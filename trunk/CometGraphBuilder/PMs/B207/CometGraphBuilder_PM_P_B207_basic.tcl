source [get_B207_files_root]B_Spline.tcl
source [get_B207_files_root]B_canvas.tcl

#_________________________________________________________________________________________________________
inherit CometGraphBuilder_PM_P_B207_basic PM_BIGre

#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CometGraphBuilder_PM_P_B207_basic

# Attributes
 set this(IN)  ""
 set this(OUT) ""
 
# Scenegraph
 set this(canvas) [B_polygone]

 set contour_ext [ProcOvale 0 0 15 15 60]
 set contour_int [ProcOvale 0 0 10 10 60]
   set this(rel,IN)      [B_polygone]; $this(rel,IN)  Mode_ligne
   set this(rel,OUT)     [B_polygone]; $this(rel,OUT) Mode_ligne
   set this(poly_IN)     [B_polygone]; B_configure $this(poly_IN)      -Ajouter_contour $contour_int \
                                                                       -Couleur 0 0 0 1 \
																	   -Ajouter_MetaData_T CometGraphBuilder_PM_P_B207_basic $objName \
																	   -Ajouter_MetaData_T CometGraphBuilder_PM_P_B207_basic___arg mother
   set this(poly_OUT_pt) [B_polygone]; B_configure $this(poly_OUT_pt)  -Ajouter_contour $contour_int \
                                                                       -Couleur 0 0 0 1 \
																	   -Gerer_contacts 0 
   set this(poly_OUT)    [B_polygone]; B_configure $this(poly_OUT)     -Ajouter_contour $contour_ext \
                                                                       -Couleur 1 1 1 1 \
																	   -Ajouter_fils $this(poly_OUT_pt) \
																	   -Ajouter_MetaData_T CometGraphBuilder_PM_P_B207_basic $objName \
																	   -Ajouter_MetaData_T CometGraphBuilder_PM_P_B207_basic___arg daughter
 Detruire $contour_ext
 Detruire $contour_int

 B_contact ctc_IN_$objName  "$this(poly_IN)  1"
 B_contact ctc_OUT_$objName "$this(poly_OUT) 1"
 
 set this(rap_change_IN_OUT) [B_rappel [Interp_TCL] "$objName Update_display_IN_OUT"]
   ctc_IN_$objName  abonner $this(rap_change_IN_OUT)
   ctc_OUT_$objName abonner $this(rap_change_IN_OUT)
 
 B_configure $this(canvas) -Ajouter_fils $this(poly_IN)  \
                           -Ajouter_fils $this(poly_OUT) \
						   -Ajouter_fils $this(rel,IN)   \
						   -Ajouter_fils $this(rel,OUT)
 
# Liste de < noeud zone de drop
#          , condition à évaluer sur l'élément dropé identifié par $n
#          , action à déclancher qui sera succédé par $zone et $info
#          , onEnter rappel
#          , onLeave rappel
#          >
 Drop_zones CometPM   [list [list $this(canvas) "$objName Is_a_CometPM   \$n" "$objName Add_a_node " "$objName Enter_for_node " "$objName Exit_for_node "] ]
 Drop_zones CometType [list [list $this(canvas) "$objName Is_a_CometType \$n" "$objName Add_a_type " "$objName Enter_for_node " "$objName Exit_for_node "] ]
                     
 
 this set_prim_handle        $this(canvas)
 this set_root_for_daughters $this(canvas)
 
 set this(L_Pool_presentation_for_node) [list ]
 set this(L_presentation_for_node)      [list ]
 
 set this(L_Pool_poly_line) [list ]
 set this(L_poly_line)      [list ]
 
 this Resize_canvas 0 0 400 300
 
 eval "$objName configure $args"
 return $objName
}

method CometGraphBuilder_PM_P_B207_basic pipo {} {
 B_configure $this(canvas) -Ajouter_fils $this(rel,IN)   \
						   -Ajouter_fils $this(rel,OUT)
}

#_________________________________________________________________________________________________________
Methodes_set_LC CometGraphBuilder_PM_P_B207_basic [P_L_methodes_set_CometGraphBuilder] {}          {}
Methodes_get_LC CometGraphBuilder_PM_P_B207_basic [P_L_methodes_get_CometGraphBuilder] {$this(FC)}

#_________________________________________________________________________________________________________
Generate_PM_setters CometGraphBuilder_PM_P_B207_basic [P_L_methodes_set_CometGraphBuilder_COMET_RE]
                                                       
#_________________________________________________________________________________________________________
Generate_accessors CometGraphBuilder_PM_P_B207_basic [list canvas IN OUT]

#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic set_IN  {e} {
 this prim_set_handle_root [$e Val_MetaData u_id]
}

#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic set_handle_root {id} {
 set this(IN) $this(preso,$id)
 if {$this(IN) != ""} {
   set txt [[$this(IN) Val_MetaData rap_change] Texte]
   [$this(IN) Val_MetaData rap_change] Texte [string map [list "; $objName Update_display_IN_OUT" ""] $txt]
  }
  
 #puts "$objName : IN point is $this(IN)"
 set txt [[$this(IN) Val_MetaData rap_change] Texte]; 
   set txt [string map [list "; $objName Update_display_IN_OUT" ""] $txt]
   [$this(IN) Val_MetaData rap_change] Texte "$txt; $objName Update_display_IN_OUT"; 
   [$this(IN) get_B_contact] abonner [$this(IN) Val_MetaData rap_change]
   
 this Update_display_IN_OUT
}

#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic set_OUT {e} {
 this prim_set_handle_daughters [$e Val_MetaData u_id]
}

#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic set_handle_daughters {id} {
 set this(OUT) $this(preso,$id)
 if {$this(OUT) != ""} {
   set txt [[$this(OUT) Val_MetaData rap_change] Texte]
   [$this(OUT) Val_MetaData rap_change] Texte [string map [list "; $objName Update_display_IN_OUT" ""] $txt]
  }
  
 #puts "$objName : OUT point is $this(OUT)"
 set txt [[$this(OUT) Val_MetaData rap_change] Texte]; 
   set txt [string map [list "; $objName Update_display_IN_OUT" ""] $txt]
   [$this(OUT) Val_MetaData rap_change] Texte "$txt; $objName Update_display_IN_OUT"; [$this(OUT) get_B_contact] abonner [$this(OUT) Val_MetaData rap_change]
   
 this Update_display_IN_OUT
}

#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic Is_a_CometPM {n} {
 if {[$n Val_MetaData CometType] == "" && [$n Val_MetaData CometPM] != ""} {return 1} else {return 0}
}

#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic Is_a_CometType {n} {
 if {[$n Val_MetaData CometType] != ""} {return 1} else {return 0}
}

#_________________________________________________________________________________________________________
#_________________________________________________________________________________________________________
#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic Resize_canvas {x1 y1 x2 y2} {
 set contour [ProcRect $x1 $y1 $x2 $y2]
   $this(canvas) Vider
   $this(canvas) Ajouter_contour $contour
 Detruire $contour
 
 $this(poly_IN)  Origine [expr $x1+($x2-$x1)/2.0] [expr $y2 - 30]
 $this(poly_OUT) Origine [expr $x1+($x2-$x1)/2.0] [expr $y1 + 30]
}

#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic Enter_for_node {args} {
 $this(canvas) Couleur 0 1 0 1
}

#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic Exit_for_node {args} {
 $this(canvas) Couleur 1 1 1 1
}

#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic Add_a_type {n_zone infos} {
 set n_drop [$infos NOEUD]
 set ptr    [$infos Ptr]
 set n_drag [$ptr Val_MetaData Noeud_placement_drag]
 
 set x [$infos X_au_contact]; set y [$infos Y_au_contact]
 
 set n_dragged [$ptr Val_MetaData Dragging] 
 set TYPE [$n_dragged Val_MetaData CometType]
 
 this Add_a_presentation_for_node TYPE $TYPE $x $y
}

#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic Add_a_node {n_zone infos} {
 set n_drop [$infos NOEUD]
 set ptr    [$infos Ptr]
 set n_drag [$ptr Val_MetaData Noeud_placement_drag]
 
 set x [$infos X_au_contact]; set y [$infos Y_au_contact]
 
 set n_dragged [$ptr Val_MetaData Dragging] 
 set PM [$n_dragged Val_MetaData CometPM ]
 set LC [$PM get_LC]
 
 this Add_a_presentation_for_node LC $LC $x $y
}

#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic Update_display_IN_OUT {} {
 if {$this(IN) != ""} {
   set m_root $this(poly_IN)
   set d_root [$this(IN) get_root]
   set m_root_X [$m_root Px]; set m_root_Y [$m_root Py]
   set d_root_X [$d_root Px]; set d_root_Y [$d_root Py]
   set contour [ProcTabDouble "[expr $m_root_X + 1] $m_root_Y $m_root_X $m_root_Y $d_root_X [expr $d_root_Y + 31] $d_root_X [expr $d_root_Y + 30]"]
     $this(rel,IN) Vider
	 $this(rel,IN) Ajouter_contour $contour
   Detruire $contour
  }

 if {$this(OUT) != ""} {
   set m_root [$this(OUT) get_root]
   set d_root $this(poly_OUT)
   set m_root_X [$m_root Px]; set m_root_Y [$m_root Py]
   set d_root_X [$d_root Px]; set d_root_Y [$d_root Py]
   set contour [ProcTabDouble "[expr $m_root_X + 1] [expr $m_root_Y-30] $m_root_X [expr $m_root_Y - 30] $d_root_X [expr $d_root_Y + 1] $d_root_X $d_root_Y"]
     $this(rel,OUT) Vider
	 $this(rel,OUT) Ajouter_contour $contour
   Detruire $contour
  }
}

#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic Update_display {m d} {
 set m_root [$m get_root]
 set d_root [$d get_root]
 set m_root_X [$m_root Px]; set m_root_Y [$m_root Py]
 set d_root_X [$d_root Px]; set d_root_Y [$d_root Py]
 set contour [ProcTabDouble "[expr $m_root_X + 1] [expr $m_root_Y - 30] $m_root_X [expr $m_root_Y - 30] $d_root_X [expr $d_root_Y + 31] $d_root_X [expr $d_root_Y + 30]"]
   $this(rel,$m,$d) Vider
   $this(rel,$m,$d) Ajouter_contour $contour
 Detruire $contour
}

#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic release_a_poly_line {} {
 $e Vider_peres
 Sub_list this(L_poly_line)      $e
 Add_list this(L_Pool_poly_line) $e
 
 return $e
}

#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic get_a_poly_line {} {
 set e [lindex $this(L_Pool_poly_line) 0]
 if {$e == ""} {
   set e [B_polygone]
   $e Mode_ligne
  }
 
 $this(canvas) Ajouter_fils_au_debut $e
 
 Add_list this(L_poly_line)      $e
 Sub_list this(L_Pool_poly_line) $e
 
 return $e
}

#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic New_rel {m d} {
 puts "___$objName New_rel $m $d"
 this prim_Add_rel [$m Val_MetaData u_id] [$d Val_MetaData u_id]
}

#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic Add_rel {id_m id_d} {
 puts "$objName Add_rel $id_m $id_d"
 set m $this(preso,$id_m)
 set d $this(preso,$id_d)
 
 #puts "$objName detect the establishment of a new relationship from $m to $d"
 if {![info exists this(rel,$m,$d)]} {
   set poly_line       [this get_a_poly_line]
   set this(rel,$m,$d) $poly_line
  }
 set txt [[$m Val_MetaData rap_change] Texte]; 
   set txt [string map [list "; $objName Update_display $m $d" ""] $txt]
   [$m Val_MetaData rap_change] Texte "$txt; $objName Update_display $m $d"; [$m get_B_contact] abonner [$m Val_MetaData rap_change]
 set txt [[$d Val_MetaData rap_change] Texte]; 
   set txt [string map [list "; $objName Update_display $m $d" ""] $txt]
   [$d Val_MetaData rap_change] Texte "$txt; $objName Update_display $m $d"; [$d get_B_contact] abonner [$d Val_MetaData rap_change]
   
 this Update_display $m $d
}

#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic Add_node_instance {id name} {
 if {[info exists this(preso,$id)]} {
   set preso $this(preso,$id)
   #puts "In $objName : Adding an instance node created locally:\n  -   id : $id\n  - preso : $preso"
   [$preso get_root] Vider_peres
   $this(canvas) Ajouter_fils_au_debut [$preso get_root]
  } else {
          #puts "In $objName : Adding an instance node created externally:\n  -    e : $e"
          set preso [this get_a_presentation_for_node LC $e]
          $preso set_position_center 50 50
          $preso Subscribe_to_Establish_rel $objName "$objName New_rel \$mother \$daughter"
		  set this(preso,$id) $preso
         }
}

#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic Add_a_presentation_for_node {mark node x y} {
 set u_id [this get_a_local_unique_id]
 
 set preso [this get_a_presentation_for_node $mark $node]
 $preso set_position_center $x $y
 $preso Subscribe_to_Establish_rel $objName "$objName New_rel \$mother \$daughter"
 $preso Add_MetaData u_id $u_id

 set this(preso,$u_id) $preso
 
 puts "$objName Add_a_presentation_for_node $mark $node $x $y" 
 [$preso get_root] Vider_peres
 set this(instance_to_plug,$node) $preso
 puts "$objName prim_Add_node_instance {$node}"
 
 if {$mark == "LC"} {
   this prim_Add_node_instance $u_id $node
  } else {this prim_Add_node_type $u_id $node}
}

#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic get_a_presentation_for_node {mark node} {
 set e [lindex $this(L_Pool_presentation_for_node) 0]
 if {$e == ""} {
   set e [CPool get_a_comet CometGraphBuilder_PM_P_B207_basic___presentation_for_node]
   set rap_change [B_rappel [Interp_TCL]]
   $e Add_MetaData rap_change $rap_change
  }
 
 $this(canvas) Ajouter_fils_au_debut [$e get_root]

 $e Add_MetaData CometGraphBuilder_PM_P_B207_basic::Is_a $mark
 $e set_represented_element $node
 
 Sub_list this(L_Pool_presentation_for_node) $e
 Add_list this(L_presentation_for_node)      $e
 
 return $e
}

#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic release_a_presentation_for_node {e} {
 [$e get_root] Vider_peres
 
 Add_list this(L_Pool_presentation_for_node) $e
 Sub_list this(L_presentation_for_node)      $e
}
#_________________________________________________________________________________________________________
#_________________________________________________________________________________________________________
#_________________________________________________________________________________________________________







#_________________________________________________________________________________________________________
#_________________________________________________________________________________________________________
#_________________________________________________________________________________________________________
inherit CometGraphBuilder_PM_P_B207_basic___presentation_for_node Physical_model

#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic___presentation_for_node constructor {name descr args} {
 set this(represented_element) ""
 
# B207 scenegraph
 set this(root)     [B_noeud]
 set this(poly_txt) [B_polygone]
 set this(b_txt)    [B_texte 20 ""]
 
 set this(poly_for_mothers)   [B_polygone]
 set this(poly_for_daughters) [B_polygone]
 
 B_configure $this(root) -Ajouter_fils_au_debut $this(poly_for_mothers)   \
                         -Ajouter_fils_au_debut $this(poly_for_daughters) \
						 -Ajouter_fils_au_debut $this(poly_txt) \
						 -Position_des_fils_changeable 0
 
 B_configure $this(poly_txt) -Ajouter_fils_au_debut $this(b_txt)
 B_configure $this(b_txt)    -Gerer_contacts        0 -Couleur_texte 0 0 0 1

 set contour [ProcRect -15 0 15 30]
   B_configure $this(poly_for_mothers)   -Ajouter_contour $contour
   B_configure $this(poly_for_daughters) -Ajouter_contour $contour \
                                         -Origine 0 -30
 Detruire $contour
  
# Adding metadatas
 B_configure $this(poly_for_mothers)   -Ajouter_MetaData_T CometGraphBuilder_PM_P_B207_basic___arg daughter \
                                       -Ajouter_MetaData_T CometGraphBuilder_PM_P_B207_basic $objName
 B_configure $this(poly_for_daughters) -Ajouter_MetaData_T CometGraphBuilder_PM_P_B207_basic___arg mother \
                                       -Ajouter_MetaData_T CometGraphBuilder_PM_P_B207_basic $objName

# Model of contact
 B_contact ctc_$objName "$this(root) 0" -add "$this(poly_txt) 1"

# Callbacks for pointers events 
 set this(rap_press_on_mothers)   [B_rappel [Interp_TCL]]; $this(rap_press_on_mothers)   Texte "$objName Press_on_mothers   $this(rap_press_on_mothers)  "
 set this(rap_press_on_daughters) [B_rappel [Interp_TCL]]; $this(rap_press_on_daughters) Texte "$objName Press_on_daugthers $this(rap_press_on_daughters)"
 set this(rap_create_rel)         [B_rappel [Interp_TCL]]; $this(rap_create_rel)         Texte "if {\[catch {$objName Create_rel $this(rap_create_rel)} err\]} {puts \"ERROR in $objName Create_rel:\n\$err\"}"
 
 $this(poly_for_mothers)   abonner_a_detection_pointeur [$this(rap_press_on_mothers)   Rappel] [ALX_pointeur_enfonce]
 $this(poly_for_daughters) abonner_a_detection_pointeur [$this(rap_press_on_daughters) Rappel] [ALX_pointeur_enfonce]

# End
 return $objName
}

#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic___presentation_for_node dispose {} {
 ctc_$objName dispose
 Detruire $this(b_txt)
 Detruire $this(poly_txt)
 Detruire $this(poly_for_daughters)
 Detruire $this(poly_for_mothers)
 Detruire $this(root)
 
 this inherited
}

#_________________________________________________________________________________________________________
Generate_accessors CometGraphBuilder_PM_P_B207_basic___presentation_for_node [list represented_element root poly_for_daughters poly_for_mothers poly_txt b_txt rap_create_rel rap_press_on_mothers rap_press_on_daughters]

#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic___presentation_for_node get_B_contact {} {return ctc_$objName}

#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic___presentation_for_node set_represented_element   {element} {
 #puts "$objName set_represented_element $element"

 set this(represented_element) $element
 
 if {[catch {$this(b_txt) TEXTE [$element get_name]} err]} {
   $this(b_txt) TEXTE $element
   $this(b_txt) Gerer_contacts 1
   $this(b_txt) Editable 1
  }
  
 this Update_presentation
}

#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic___presentation_for_node Update_presentation {} {
   $this(b_txt) Optimiser_dimensions; $this(b_txt) Calculer_boites
   set box [$this(b_txt) Boite_noeud]
   set w [$box Tx]
   set h [$box Ty]
   $this(b_txt) Origine [expr -[$box BG_X] - $w/2.0] \
                        [expr -[$box BG_Y] - $h/2.0]
 set contour [ProcOvale 0 0 [expr 1.2 * $w / 2.0] [expr 1.2 * $h / 2.0] 60]
   $this(poly_txt) Ajouter_contour $contour
 Detruire $contour
}

#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic___presentation_for_node Press_on_mothers   {rap} {
 set infos [Void_vers_info [$rap Param]]
 set ptr   [$infos Ptr]

 #puts "$objName Press_on_mothers with ptr $ptr"
 
 if {[$ptr Val_MetaData CometGraphBuilder_PM_P_B207_basic___presentation_for_node] == ""} {
   $ptr Add_MetaData CometGraphBuilder_PM_P_B207_basic___presentation_for_node $objName
   $ptr Add_MetaData CometGraphBuilder_PM_P_B207_basic___presentation_for_node___daughter $objName
   $ptr abonner_a_changement [$this(rap_create_rel) Rappel]
  }
}

#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic___presentation_for_node Press_on_daugthers {rap} {
 set infos [Void_vers_info [$rap Param]]
 set ptr   [$infos Ptr]

 #puts "$objName Press_on_daugthers with ptr $ptr"
 
 if {[$ptr Val_MetaData CometGraphBuilder_PM_P_B207_basic___presentation_for_node] == ""} {
   $ptr Add_MetaData CometGraphBuilder_PM_P_B207_basic___presentation_for_node $objName
   $ptr Add_MetaData CometGraphBuilder_PM_P_B207_basic___presentation_for_node___mother $objName
   $ptr abonner_a_changement [$this(rap_create_rel) Rappel]
  }
}

#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic___presentation_for_node Create_rel         {rap} {
 set ptr [Void_vers_alx_pointeur [$rap Param]]

 #puts "Create_rel with ptr $ptr"
 
 if {[$ptr Appuie] == 0} {
   set daughter [$ptr Val_MetaData CometGraphBuilder_PM_P_B207_basic___presentation_for_node___daughter]
   set mother   [$ptr Val_MetaData CometGraphBuilder_PM_P_B207_basic___presentation_for_node___mother]
   #puts "On ptr $ptr:\n  - mother : $mother\n  - daughter : $daughter"
   
   set noeud [$ptr Noeud_sous_pointeur]
   #puts "___ DROP on $noeud"
   set arg   [$noeud Val_MetaData CometGraphBuilder_PM_P_B207_basic___arg]
   if {$arg != ""} {
     puts "  - set $arg [$noeud Val_MetaData CometGraphBuilder_PM_P_B207_basic]"
	 set $arg [$noeud Val_MetaData CometGraphBuilder_PM_P_B207_basic]
    }
   
   $ptr Sub_MetaData CometGraphBuilder_PM_P_B207_basic___presentation_for_node 
   $ptr Sub_MetaData CometGraphBuilder_PM_P_B207_basic___presentation_for_node___daughter
   $ptr Sub_MetaData CometGraphBuilder_PM_P_B207_basic___presentation_for_node___mother
   $ptr desabonner_de_changement [$this(rap_create_rel) Rappel]
   
   #puts "$objName Create_rel from $mother to $daughter"
   
   if {$mother != "" && $daughter != "" && $mother != $daughter} {
     if {[gmlObject info exists object $mother]} {
	   if { [lsearch [gmlObject info classes $mother]   CometGraphBuilder_PM_P_B207_basic___presentation_for_node] != -1 \
	      &&[lsearch [gmlObject info classes $daughter] CometGraphBuilder_PM_P_B207_basic___presentation_for_node] != -1} {
	     puts "  Both represent a LC"
		 set LC_mother   [$mother   get_represented_element]
	     set LC_daughter [$daughter get_represented_element]
	     #puts "    -LC_mother : $LC_mother\n    -LC_daughter : $LC_daughter"
         this Establish_rel $mother $daughter
		} else {
		        # Si c'est un CometGraphBuilder_PM_P_B207_basic, il s'agit du point d'entré ou de sortie du graphe nesté
				if { [lsearch [gmlObject info classes $mother]   CometGraphBuilder_PM_P_B207_basic]                         != -1 \
				   &&[lsearch [gmlObject info classes $daughter] CometGraphBuilder_PM_P_B207_basic___presentation_for_node] != -1 \
				   &&[$noeud Val_MetaData CometGraphBuilder_PM_P_B207_basic___arg] == "mother"} {
				  $mother set_IN $daughter
				 }
				if { [lsearch [gmlObject info classes $daughter] CometGraphBuilder_PM_P_B207_basic]                         != -1 \
				   &&[lsearch [gmlObject info classes $mother]   CometGraphBuilder_PM_P_B207_basic___presentation_for_node] != -1 \
				   &&[$noeud Val_MetaData CometGraphBuilder_PM_P_B207_basic___arg] == "daughter"} {
				  $daughter set_OUT $mother
				 }
		       }
	  }
    }
  }
}

#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic___presentation_for_node Establish_rel {mother daughter} {
 puts "$objName Establish_rel $mother -> $daughter"
}

#_________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_B207_basic___presentation_for_node set_position_center {x y} {
 set box [$this(root) Boite_noeud_et_fils]
 $this(root) Origine [expr $x - [$box BG_X] + [$box Tx]/2.0] \
                     [expr $y - [$box BG_Y] + [$box Ty]/2.0]
}

#_________________________________________________________________________________________________________
#_________________________________________________________________________________________________________
#_________________________________________________________________________________________________________
Manage_CallbackList CometGraphBuilder_PM_P_B207_basic___presentation_for_node [list Establish_rel] end

