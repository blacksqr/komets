
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometSWL_Ship_PM_P_B207_basic PM_BIGre

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_B207_basic constructor {name descr args} {
 set this(mode) edition
 this inherited $name $descr
   set this(current_player) ""
   
   this set_GDD_id CometSWL_Ship_PM_P_B207_basic
   set this(root) [B_noeud]
   set this(rap_root_change) [B_rappel [Interp_TCL] "if {\[$this(root) A_changer\]} {$objName Update_datas}"]
   $this(root) abonner_a_LR_parcours [$this(root) LR_Av_aff] [$this(rap_root_change) Rappel]
   
 this set_prim_handle        $this(root)
 this set_root_for_daughters $this(root)

 set x 0; set y 0; set r 10; set couleur "1 1 1 1"; set this(R) $r
 set this(poly_edition) [B_polygone]
   set this(poly_jeu) [B_polygone] 
   B_configure $this(root) -Ajouter_fils $this(poly_edition) \
                           -Etirement 1 1 \
						   -Origine $x $y \
                           -Ajouter_fils_au_debut $this(poly_jeu) \
                           -Position_des_fils_changeable 0
   
   set contour [ProcOvale 0 0 $r $r 60]
     B_configure $this(poly_edition) -Ajouter_contour $contour \
	                                 -Origine 0 0
     B_configure $this(poly_jeu)     -Ajouter_contour $contour \
	                                 -Origine 0 0
     set this(arrow) [B_polygone]; 
	 B_configure $this(poly_jeu) -Ajouter_fils $this(arrow) \
	                             -Noeud_puis_fils 0
						   
	 set this(rap_move_arrow) [B_rappel [Interp_TCL]]
	   $this(rap_move_arrow) Texte "$objName Press_arrow $this(rap_move_arrow)"
	 $this(arrow) abonner_a_detection_pointeur [$this(rap_move_arrow) Rappel] [ALX_pointeur_enfonce]
	 
	 set this(b_ctc_arrow) ${objName}_ctc_arrow
	 B_contact $this(b_ctc_arrow) "$this(arrow) [Capa_R]"
	 
	 set this(ptr_resizing_arrow) ""
	 set this(pt_tmp)                 [B_point]
	 set this(rap_ptr_resizing_arrow) [B_rappel [Interp_TCL]]
	 set this(L_reperes_for_arrow)    [Liste_alx_repere2D]
	 
   Detruire $contour
   eval "$this(poly_edition) Couleur $couleur"
   eval "$this(poly_jeu)     Couleur $couleur"

   B_contact ${objName}_ctc "$this(root) 0" -add "$this(poly_edition) 1"

    
 this Add_MetaData PRIM_STYLE_CLASS [list $this(root) "ROOT RESULT"]
 
 this set_angle 0
 this set_power 0
 
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometSWL_Ship_PM_P_B207_basic [P_L_methodes_set_CometSWL_Ship] {} {$this(L_actives_PM)}
Methodes_get_LC CometSWL_Ship_PM_P_B207_basic [P_L_methodes_get_CometSWL_Ship] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters CometSWL_Ship_PM_P_B207_basic [P_L_methodes_set_CometSWL_Ship_COMET_RE]

#___________________________________________________________________________________________________________________________________________
Generate_accessors CometSWL_Ship_PM_P_B207_basic [list mode]

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_B207_basic Update_datas {} {
 set v [$this(root) Px]     ; if {$v != [this get_X]} {this prim_set_X $v; this set_X [this get_X]}
 set v [$this(root) Py]     ; if {$v != [this get_Y]} {this prim_set_Y $v; this set_Y [this get_Y]}
 set v [$this(root) Ex]     ; if {$v != [this get_R]} {this prim_set_R $v; this set_R [this get_R]}
 #set v [$this(root) density]; if {$v != [this get_density]} {this prim_set_density $v}
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_B207_basic Substitute_by {PM} {
 this inherited $PM
 if {[catch "$PM set_mode [this get_mode]" err]} {
   puts "Error in \"$objName Substitute_by $PM :\n  -  exp : May be due to the non implementation of a set_mode method in $PM\n  -err : $err\""
  }
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_B207_basic set_mode    {m}  {
 if {$m == "game"} {set v 1} else {set v 0}

 B_configure $this(poly_jeu)     -Afficher_noeud $v          -Gerer_contacts $v
 B_configure $this(poly_edition) -Afficher_noeud [expr 1-$v] -Gerer_contacts [expr 1-$v]
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_B207_basic set_X       {v}  {$this(root) Px $v}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_B207_basic set_Y       {v}  {$this(root) Py $v}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_B207_basic set_angle   {v}  {
 $this(arrow) Rotation $v
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_B207_basic set_power   {v}  {
 set power $v
 set L [list 0 -$this(R) \
            [expr $this(R) + $power] -$this(R) \
			[expr $this(R) + $power] [expr -1.5*$this(R)] \
			[expr 3*$this(R) + $power] 0 \
			[expr $this(R) + $power] [expr 1.5*$this(R)] \
			[expr $this(R) + $power] $this(R) \
			0 $this(R) \
	   ]
 set contour [ProcTabDouble $L]
   $this(arrow) Vider
   $this(arrow) Ajouter_contour $contour
 Detruire $contour
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_B207_basic Update_color {} {
 set color [$this(current_player) get_player_color]
 eval "$this(poly_edition) Couleur $color"
 eval "$this(poly_jeu)     Couleur $color"
 eval "$this(arrow)        Couleur [lrange $color 0 2] 0.5"
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_B207_basic set_player  {P}  {
 if {$this(current_player) != ""} {$this(current_player) UnSubscribe_to_set_player_color $objName}
 set this(current_player) $P
 if {$P != ""} {
   $this(current_player) Subscribe_to_set_player_color $objName "$objName Update_color"
   this Update_color
  }
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_B207_basic get_or_create_prims {root} {
 set rep [this inherited $root]
 
 this set_X     [this get_X]
 this set_Y     [this get_Y]
 this set_angle [this get_angle]
 this set_power [this get_power]
 this set_mode  [this get_mode]
 
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_B207_basic Press_arrow {rap} {
 #puts "CometSWL_Ship_PM_P_B207_basic::Press_arrow $rap"
 if {$this(ptr_resizing_arrow) == ""} {
   set infos [Void_vers_info [$rap Param]]
   set ptr   [$infos Ptr]; 
 
   set x_ctc [$infos X_au_contact]; set y_ctc [$infos Y_au_contact]

   $this(L_reperes_for_arrow) maj [$infos L_REPERES]
   Ajouter_noeud_en_fin_de_liste_rep $this(L_reperes_for_arrow) $this(arrow)
   
   $this(rap_ptr_resizing_arrow) Texte "if {\[catch \"$objName Resize_arrow $x_ctc [this get_power]\" err\]} {puts \"ERROR in Resize_arrow $x_ctc [this get_power]:\n \$err\"}"

   $ptr abonner_a_changement [$this(rap_ptr_resizing_arrow) Rappel]
   set this(ptr_resizing_arrow) $ptr
  }
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_B207_basic Resize_arrow {initial_x initial_power} {
 #puts "CometSWL_Ship_PM_P_B207_basic::Resize_arrow $initial_x $initial_power"
 set ptr $this(ptr_resizing_arrow)
# $this(L_reperes_for_arrow)
 
 $this(pt_tmp) maj [$ptr X] [$ptr Y]
   Repere_transformation $this(pt_tmp) $this(L_reperes_for_arrow)
   
 set x [$this(pt_tmp) X]
 
# Compute the new power
 set power [expr $x + $initial_power - $initial_x]
 if {$power < 0}   {set power 0}
 if {$power > 100} {set power 100}

 this prim_set_power $power
 this prim_set_angle [$this(arrow) Rotation]
 
 if {[$ptr Appuie] == 0} {
   $ptr desabonner_de_changement [$this(rap_ptr_resizing_arrow) Rappel]
   set this(ptr_resizing_arrow) ""
  }
}
