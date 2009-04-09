inherit Root_PM_P_BIGre PM_BIGre

#___________________________________________________________________________________________________________________________________________
method Root_PM_P_BIGre constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CT_Comet_Root_FUI_B207
 if {[string length [info proc B_noeud]] > 0} {} else {return $objName}

 set this(node_created_inside) 1
 this set_prim_handle        [B_noeud]
 this set_root_for_daughters [this get_prim_handle]
 
# Highlighters
 set this(L_pool_highlighters)    [list]
 set this(L_actives_highlighters) [list]
 
 set this(contour_highlighter) [ProcRect 0 0 1 1]
 set this(color_highlighter) "1 1 0 0.5"
 
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method  Root_PM_P_BIGre dispose {} {
 if {$this(node_created_inside)} {
   $this(primitives_handle) -delete
  }
 this inherited
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Root_PM_P_BIGre [L_methodes_set_CometRoot] {} {}

#___________________________________________________________________________________________________________________________________________
Generate_accessors Root_PM_P_BIGre [list color_highlighter]

#_________________________________________________________________________________________________________
method Root_PM_P_BIGre get_highlighters {} {return $this(L_actives_highlighters)}

#_________________________________________________________________________________________________________
method Root_PM_P_BIGre get_a_highlighter {} {
 if {[llength $this(L_pool_highlighters)] > 0} {
   set rep [lindex $this(L_pool_highlighters) 0]
   set this(L_pool_highlighters) [lrange $this(L_pool_highlighters) 1 end]
  } else {set rep [B_polygone]
          B_configure $rep -Ajouter_contour $this(contour_highlighter) \
		                   -Gerer_contacts 0 \
						   -Ajouter_MetaData_T B_rappel_from_$objName [B_rappel [Interp_TCL]]
         }

 eval "$rep Couleur $this(color_highlighter)"
 Add_list this(L_actives_highlighters) $rep

 return $rep
}

#_________________________________________________________________________________________________________
method Root_PM_P_BIGre release_a_highlighter {e} {
 set prim_PM [$e Val_MetaData ${objName}::prim_PM]
 set rap     [$e Val_MetaData B_rappel_from_$objName]
 $prim_PM desabonner_de_LR_parcours [$prim_PM LR_Ap_aff] [$rap Rappel]
 
 Add_list this(L_pool_highlighters)    $e
 Sub_list this(L_actives_highlighters) $e
}

#_________________________________________________________________________________________________________
method Root_PM_P_BIGre set_color_highlighters {r v b a} {
 foreach n $this(L_actives_highlighters) {
   $n Couleur $r $v $b $a
  }
}

#_________________________________________________________________________________________________________
method Root_PM_P_BIGre Stop_Enlight {} {
 set L $this(L_actives_highlighters)
 foreach n $L {this release_a_highlighter $n}
}

#_________________________________________________________________________________________________________
method Root_PM_P_BIGre Display_highlighter {prim_PM box highlighter} {
 $prim_PM Transfo_repere
   $highlighter maj [$box BG_X] [$box BG_Y] 0 [$box Tx] [$box Ty]
   $highlighter Afficher
   $prim_PM A_changer 1 
 $prim_PM Depiler_transfo_repere
}
 
#_________________________________________________________________________________________________________
method Root_PM_P_BIGre prim_Enlight {L_PM} {
 foreach PM $L_PM {
   puts -nonewline "  - $PM ... "
   set highlighter [this     get_a_highlighter]
   set rap         [$highlighter Val_MetaData B_rappel_from_$objName]
   set prim_PM     [$PM      get_prim_handle]
   
     B_configure $highlighter -Ajouter_MetaData_T ${objName}::prim_PM $prim_PM
	 $rap Texte "$objName Display_highlighter $prim_PM [$prim_PM Boite_noeud_et_fils] $highlighter"
   
   $prim_PM desabonner_de_LR_parcours [$prim_PM LR_Ap_aff] [$rap Rappel]
   $prim_PM abonner_a_LR_parcours     [$prim_PM LR_Ap_aff] [$rap Rappel]
   puts "DONE"
  }
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method Root_PM_P_BIGre set_root {n} {
 if {$this(node_created_inside)} {
   $this(primitives_handle) -delete
   set this(node_created_inside) 0
  }
 this set_prim_handle        $n
 this set_root_for_daughters $n
 this Reconnect [this get_daughters]
}

#___________________________________________________________________________________________________________________________________________
# L_nodes is a list of comet elements
# We must find from each element of the list the related PM.B207 node related to that root
# Each of these related nodes is then Enlighted
method Root_PM_P_BIGre Enlight {L_nodes} {
 set L_B207_PM [list ]
 
 foreach n $L_nodes {
   set done 0
   if {[lsearch [gmlObject info classes $n] Physical_model] != -1} {
     if {[[${n}_cou get_ptf] Accept_for_daughter Ptf_BIGre]} {set done 1} else {continue}
    }
	
   if {$done} {
     lappend L_B207_PM $n
    } else {puts "set PM \[CSS++ $objName \"#${n}->PMs \\\\<--< $objName/\"\]"
	        set PM [CSS++ $objName "#${n}->PMs \\<--< $objName/"]
	        if {$PM != ""} {set L_B207_PM [concat $L_B207_PM $PM]}
	       }
  }
  
 puts "$objName Enlight {$L_nodes}\n  - L_B207_PM = {$L_B207_PM}"
 this prim_Enlight $L_B207_PM
}
