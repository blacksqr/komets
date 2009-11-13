#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometInterleaving_PM_P_menu_B207 PM_BIGre

#___________________________________________________________________________________________________________________________________________
method CometInterleaving_PM_P_menu_B207 constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Interleaving_FUI_Menu_B207
 
# L_menu_and_associated_comets contient une liste de triplet de la forme :
#   <Nom du menu, liste de sélecteurs associées, noeud B207 racine de ce menu>
 set this(L_menu_and_associated_comets) [list]
 
 set this(font_size) 40

 set this(L_inner_menus) [list]
 set this(id_menu)       0

 set this(root) [B_noeud]
  set this(B207_local_menu)            [B_noeud] 
  set this(B207_daughters)             [B_noeud]
  set this(B207_pipo_handle_daughters) [B_noeud]
  
 B_configure $this(root) -Position_des_fils_changeable 0 \
                         -Nom_IU $objName \
						 -Ajouter_fils $this(B207_local_menu) \
						 -Ajouter_fils $this(B207_daughters)

 this set_prim_handle        $this(root)
 this set_root_for_daughters $this(B207_pipo_handle_daughters)

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors CometInterleaving_PM_P_menu_B207 [list font_size L_menu_and_associated_comets B207_local_menu B207_daughters B207_pipo_handle_daughters]

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometInterleaving_PM_P_menu_B207 [P_L_methodes_set_CometInterleaving] {}  {}
Methodes_get_LC CometInterleaving_PM_P_menu_B207 [P_L_methodes_get_CometInterleaving] {}

#___________________________________________________________________________________________________________________________________________
method CometInterleaving_PM_P_menu_B207 set_L_menu_and_associated_comets {L_menu_sel} {
# Sub
 foreach e $this(L_menu_and_associated_comets) {
   this Sub_L_menu_and_associated_comets [list "[lindex $e 0] [lindex $e 1]"]
  }
  
# Add
 this Add_L_menu_and_associated_comets $L_menu_sel
}

#___________________________________________________________________________________________________________________________________________
method CometInterleaving_PM_P_menu_B207 Add_L_menu_and_associated_comets {L_menu_sel} {
 set nL ""
# Look for the menus in L_menu_and_associated_comets that are also in L_menu_sel
 foreach m $this(L_menu_and_associated_comets) {
   set found 0
   foreach e $L_menu_sel {
     if {[lindex $e 0] == [lindex $m 0]} {
	   set found 1
	   set L [lindex $m 1]; Add_list L [lindex $e 1]; lappend nL [list [lindex $m 0] $L [lindex $m 2]]
	   break
	  }
    }
   
   if {!$found} {
     lappend nL $m
    }
  }

# Add menus of L_menu_sel that are not in L_menu_and_associated_comets
 foreach e $L_menu_sel {
   set found 0
   foreach m $this(L_menu_and_associated_comets) {
     if {[lindex $e 0] == [lindex $m 0]} {
	   set found 1
	   break
	  }
    }
   if {!$found} {
     lappend nL $e
	}
  }

# Update the local list of menus
 set this(L_menu_and_associated_comets) $nL 
 
 this Update_menu_titles
}

#___________________________________________________________________________________________________________________________________________
method CometInterleaving_PM_P_menu_B207 Sub_L_menu_and_associated_comets {L_menu_sel} {
 set nL ""
 foreach m $this(L_menu_and_associated_comets) {
   set found 0
   foreach e $L_menu_sel {
     if {[lindex $e 0] == [lindex $m 0]} {
	   set L [lindex $m 1]
	   set L_keep $L; Sub_list L_keep [lindex $e 1]
	   set L_sub  $L; Sub_list L_sub  $L_keep
	  # Update primitive level
	   #XXX
	  # Update logical level
	   if {$L_keep != ""} {lappend nL [list [lindex $m 0] $L_keep [lindex $m 2]]}
	   set found 1
	   break
	  }
    }
	
   if {!$found} {
     lappend nL $m
    }
  }
 
 set this(L_menu_and_associated_comets) $nL
 
 this Update_menu_titles
}

#___________________________________________________________________________________________________________________________________________
method CometInterleaving_PM_P_menu_B207 Add_daughter {m {index -1}} {
 set rep [this inherited $m $index]
 #puts "  rep = $rep"
 if {$rep == 1} {
	 set plugged 0
	 
	 foreach menu_and_sel $this(L_menu_and_associated_comets) {
	   set menu_name   [lindex $menu_and_sel 0]
	   set L_selectors [lindex $menu_and_sel 1]
	   set L_PM [CSS++ $objName "#$objName $L_selectors"]
	   if {[lsearch $L_PM $m] != -1} {
		 set plugged 1
		 # Add to the corresponding menu
		 set menu_root [lindex $menu_and_sel 2]
		 if {[catch "$menu_root Retirer_fils [$m get_prim_handle]" err]} {puts "ERROR in 1 : \"$objName Add_daughter $m $index\"\n  command $menu_root Retirer_fils \[$m get_prim_handle\]\n  $m get_prim_handle = [$m get_prim_handle]\n  err : $err"}
		 if {[catch "$menu_root Ajouter_fils [$m get_prim_handle]" err]} {puts "ERROR in 1 : \"$objName Add_daughter $m $index\"\n  command $menu_root Ajouter_fils \[$m get_prim_handle\]\n  $m get_prim_handle = [$m get_prim_handle]\n  err : $err"}
		}
	  }
	  
	 if {!$plugged} {
	   if {[catch "$this(B207_daughters) Retirer_fils [$m get_prim_handle]" err]} {puts "ERROR in 2 : \"$objName Add_daughter $m $index\"\n  command $this(B207_daughters) Retirer_fils \[$m get_prim_handle\]\n  $m get_prim_handle = [$m get_prim_handle]\n  err : $err"}
	   if {[catch "$this(B207_daughters) Ajouter_fils [$m get_prim_handle]" err]} {puts "ERROR in 2 : \"$objName Add_daughter $m $index\"\n  command $this(B207_daughters) Ajouter_fils \[$m get_prim_handle\]\n  $m get_prim_handle = [$m get_prim_handle]\n  err : $err"}
	  }
  }
  
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method CometInterleaving_PM_P_menu_B207 Sub_daughter {m} {
 [$m get_prim_handle] Vider_peres
 return [this inherited $m]
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometInterleaving_PM_P_menu_B207 Update_menu_titles {} {
# Is there any new menu ?
# A new menu is characterized by the abscence of a B207 node
 set nL ""
 set dx 0
 foreach m $this(L_menu_and_associated_comets) {
   if {[lindex $m 2] == ""} {
     # A new menu entry must be added
	 set node [this Add_a_new_menu_entry [lindex $m 0]]
	 lappend nL [list [lindex $m 0] [lindex $m 1] $node]
    } else {lappend nL $m
	        set node [lindex $m 2]
		   }
   set poly [$node get_poly_node]; set box_poly [$poly Boite_noeud_et_fils]
   $poly Origine $dx 0
   set dx [expr $dx + [$box_poly Tx]]
  }
 
 set this(L_menu_and_associated_comets) $nL
 
# Unplugg presentation that are now part of a menu
 #puts "Unplugg presentation that are now part of a menu"
 set L_nodes ""
 foreach m $this(L_menu_and_associated_comets) {
   #puts "Do menu [lindex $m 0] with selector [lindex $m 1]"
   set sel [lindex $m 1]
   set LC  [CSS++ $objName "#$objName $sel"]
   foreach C $LC {
     #puts "$this(B207_daughters) Retirer_fils [$C get_prim_handle]"
     $this(B207_daughters) Retirer_fils [$C get_prim_handle]
	 Add_list L_nodes [$C get_prim_handle]
	}
  }
# Plug the presentations that are not part of a menu
 #puts "Plug the presentations that are not part of a menu"
 #set L [Lister_fils_de $this(B207_pipo_handle_daughters)]
 set L ""; foreach C [this get_out_daughters] {lappend L [$C get_prim_handle]}
 #puts "      L : {$L}"
 Sub_list L $L_nodes
 #puts "  new L : {$L}"
 $this(B207_daughters) Vider_fils
 foreach n $L {
   #puts "$this(B207_daughters) Ajouter_fils_au_debut $n\n_________"
   #puts "  n à [$n Nb_Peres] peres"
   $this(B207_daughters) Ajouter_fils_au_debut $n
  }
}

#___________________________________________________________________________________________________________________________________________
method CometInterleaving_PM_P_menu_B207 Add_a_new_menu_entry {name} {
 set m [this get_a_inner_menu $name]
   $this(B207_local_menu) Ajouter_fils_au_debut [$m get_poly_node]
   $m Subscribe_to_Deploy   $objName "$objName   Deploy_menu $m" UNIQUE
   $m Subscribe_to_UnDeploy $objName "$objName UnDeploy_menu $m" UNIQUE
 lappend this(L_inner_menus) $m
 
 return $m
}

#___________________________________________________________________________________________________________________________________________
method CometInterleaving_PM_P_menu_B207   Deploy_menu {menu} {
 #puts "$objName Deploy_menu $menu"
 set m_name [$menu get_name]
 set L_nodes ""
 foreach m $this(L_menu_and_associated_comets) {
   set name [lindex $m 0]
   if {$m_name == $name} {
     set sel  [lindex $m 1]
     set LC   [CSS++ $objName "#$objName $sel"]
     foreach C $LC {lappend L_nodes [$C get_prim_handle]}
	 break
    }
  }
# Place nodes 
 set poly_for_daughters [$menu get_poly_for_daughters] 
 $poly_for_daughters Vider_fils
 set dy 0; set dx 0
 foreach node $L_nodes {
   $node Origine 0 0
   $node Maj_boites_recursif; $node Afficher; $node Maj_boites_recursif;
   set box_node [$node Boite_noeud_et_fils_glob]
   set dy [expr $dy - [$box_node Ty]]
   set tx [$box_node Tx]; if {$tx > $dx} {set dx $tx}
   $node Origine [expr -[$box_node BG_X]] [expr $dy - [$box_node BG_Y]]
   $poly_for_daughters Ajouter_fils $node
  }

# Resize menu box and make the menu box appear
 #puts "$menu Resize_poly_for_daughters $dx $dy"
 $menu Resize_poly_for_daughters $dx $dy
 B_configure [$menu get_poly_for_daughters] -Origine 0 0 \
                                            -Afficher_noeud 1 \
										    -Gerer_contacts 1

}

#___________________________________________________________________________________________________________________________________________
method CometInterleaving_PM_P_menu_B207 UnDeploy_menu {menu} {
 #puts "$objName UnDeploy_menu $menu"
 B_Fire_Forget_after_simulations "B_configure [$menu get_poly_for_daughters] -Afficher_noeud 0 -Gerer_contacts 0"
}

#___________________________________________________________________________________________________________________________________________
method CometInterleaving_PM_P_menu_B207 get_a_inner_menu {txt} {
 incr this(id_menu)
 set name ${objName}_inner_menu_$this(id_menu)
 CometInterleaving_PM_P_menu_B207_inner_class_menu $name $this(font_size) $txt
 return $name
}

#___________________________________________________________________________________________________________________________________________
method CometInterleaving_PM_P_menu_B207 release_a_inner_menu {m} {
 $m dispose
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#Trace CometInterleaving_PM_P_menu_B207 Add_L_menu_and_associated_comets
#Trace CometInterleaving_PM_P_menu_B207 Sub_L_menu_and_associated_comets
#Trace CometInterleaving_PM_P_menu_B207 Add_daughter
#Trace CometInterleaving_PM_P_menu_B207 Sub_daughter
#Trace CometInterleaving_PM_P_menu_B207 Update_menu_titles
#Trace CometInterleaving_PM_P_menu_B207 Add_a_new_menu_entry

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometInterleaving_PM_P_menu_B207_inner_class_menu constructor {font_size name} {
 set this(switch_state) 0
 set this(switch_set)   [list UnDeploy Deploy]
 
 set this(name) $name
 set this(poly_node) [B_polygone]; $this(poly_node) Ajouter_MetaData_T gml_class $objName; $this(poly_node) Couleur 0.3 0.3 0.3 1
 set this(poly_for_daughters) [B_polygone]; $this(poly_for_daughters) Couleur 0.3 0.3 0.3 1
 set this(txt_node)  [B_texte $font_size $name]
   B_configure $this(poly_node) -Ajouter_fils $this(txt_node) \
                                -Ajouter_fils $this(poly_for_daughters)
 
 
 set txt_box   [$this(txt_node) Boite_noeud]
 set contour   [ProcRect 0 0 [$txt_box Tx] [$txt_box Ty]]
   $this(poly_node) Ajouter_contour $contour
 Detruire $contour
 
 $this(txt_node) Origine [expr -[$txt_box BG_X]] [expr -[$txt_box BG_Y]]
 
 set this(bt_perso) ${objName}_bt_perso
 B_bouton_perso $this(bt_perso) $this(poly_node) "$this(txt_node) Couleur_texte 0 1 0 1" \
                                                 "$this(txt_node) Couleur_texte 1 1 1 1" \
												 "$this(poly_node) Couleur 0 1 0 1      ; $this(txt_node) Couleur_texte 0.3 0.3 0.3 1" \
												 "$this(poly_node) Couleur 0.3 0.3 0.3 1; $this(txt_node) Couleur_texte 0 1 0 1" \
												 "$objName Switch_deploy"

 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometInterleaving_PM_P_menu_B207_inner_class_menu dispose {} {
 #Detruire $this(poly_node)
 #Detruire $this(txt_node)
 this inherited
}

#___________________________________________________________________________________________________________________________________________
method CometInterleaving_PM_P_menu_B207_inner_class_menu Switch_deploy {} {
 set this(switch_state) [expr 1 - $this(switch_state)]
 set mtd [lindex $this(switch_set) $this(switch_state)]
 this $mtd
}

#___________________________________________________________________________________________________________________________________________
method CometInterleaving_PM_P_menu_B207_inner_class_menu Resize_poly_for_daughters {x y} {
 set contour [ProcRect 0 0 $x $y]
   $this(poly_for_daughters) Vider
   $this(poly_for_daughters) Ajouter_contour $contour
 Detruire $contour
}

#___________________________________________________________________________________________________________________________________________
method CometInterleaving_PM_P_menu_B207_inner_class_menu   Deploy {} {}

#___________________________________________________________________________________________________________________________________________
method CometInterleaving_PM_P_menu_B207_inner_class_menu UnDeploy {} {}

#___________________________________________________________________________________________________________________________________________
Generate_accessors CometInterleaving_PM_P_menu_B207_inner_class_menu [list name poly_for_daughters bt_perso poly_node txt_node]

#___________________________________________________________________________________________________________________________________________
Manage_CallbackList CometInterleaving_PM_P_menu_B207_inner_class_menu [list Deploy UnDeploy] end
