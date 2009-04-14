#_________________________________________________________________________________________________________
inherit CometToolBox_GDD_PM_P_B207_basic PM_BIGre

#_________________________________________________________________________________________________________
method CometToolBox_GDD_PM_P_B207_basic constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CometToolBox_GDD_PM_P_B207_basic

   set this(root) [B_noeud]
   set this(B207_L_nodes) [B_noeud]; $this(root) Ajouter_fils $this(B207_L_nodes)
   
   set this(L_actives_text_nodes) [list]
   set this(L_Pool_text_nodes)    [list]
   
   this set_prim_handle        $this(root)
   this set_root_for_daughters $this(root)
 
 eval "$objName configure $args"
 return $objName
}


#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometToolBox_GDD_PM_P_B207_basic [P_L_methodes_set_CometToolBox_GDD] {} {$this(L_actives_PM)}
Methodes_get_LC CometToolBox_GDD_PM_P_B207_basic [P_L_methodes_get_CometToolBox_GDD] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters CometToolBox_GDD_PM_P_B207_basic [P_L_methodes_set_CometToolBox_GDD_COMET_RE]

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometToolBox_GDD_PM_P_B207_basic get_a_text_node {indent txt} {
 set rep [lindex $this(L_Pool_text_nodes) 0]
 if {$rep == ""} {
   set rep [B_texte 15 $txt]
  } else {set this(L_Pool_text_nodes) [lrange $this(L_Pool_text_nodes) 1 end]
         }
 $rep TEXTE $indent$txt; $rep Optimiser_dimensions; $rep Ajouter_MetaData_T CometType $txt; Drag_nodes $rep 1 "" ""
 
 $this(B207_L_nodes) Ajouter_fils_au_debut $rep
 
 Add_list this(L_actives_text_nodes) $rep
 
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method CometToolBox_GDD_PM_P_B207_basic Release_text_nodes {L} {
 foreach n $L {
   Sub_list this(L_actives_text_nodes) $n
   Add_list this(L_Pool_text_nodes)    $n
   $n Vider_Peres
  }
}

#___________________________________________________________________________________________________________________________________________
method CometToolBox_GDD_PM_P_B207_basic Update_layout {} {
 set y 0
 foreach n [Lister_fils_de $this(B207_L_nodes)] {
   set box [$n Boite_noeud_et_fils]
   $n Origine 0 $y
   set y [expr $y + [$box Ty]]
  }
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometToolBox_GDD_PM_P_B207_basic Update_nodes {} {
 puts "In $objName Update_nodes:"
 this Release_text_nodes $this(L_actives_text_nodes)
 foreach top_level_task [this get_L_nodes] {
   puts "  - toplevel task : [lindex $top_level_task 0]"
   this get_a_text_node "" [lindex $top_level_task 0]
   foreach t [lindex $top_level_task 1] {
	 puts "    ~ T : [lindex $t 0]"
	 this get_a_text_node "    " [lindex $t 0]
	 foreach a [lindex $t 1] {
	   puts "      * AUI : [lindex $a 0]"
	   this get_a_text_node "        " [lindex $a 0]
	   foreach c [lindex $a 1] {
         puts "        ¤ CUI : $c"
		  this get_a_text_node "            " $c
		}
	  }
	}
  }
  
 this Update_layout
}
