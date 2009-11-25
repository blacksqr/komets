#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Specifyer_PM_P_B207_color_base PM_BIGre

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_B207_color_base constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Specifyer_Color_FUI_basic_system_B207
   
 set this(n_root) [B_noeud]; 
   $this(n_root) Position_des_fils_changeable 0
   $this(n_root) Nom_IU $objName
   set this(poly_fond) [B_polygone]
     $this(n_root) Ajouter_fils_au_debut $this(poly_fond)
	 $this(poly_fond) Ajouter_contour [ProcRect 0 0 32 32]
	 set this(rap_color) [B_rappel [Interp_TCL] "$objName Update_color \[tk_chooseColor\]"]
	 $this(poly_fond) abonner_a_detection_pointeur [$this(rap_color) Rappel] [ALX_pointeur_enfonce]
   set this(n_root_for_daughters) [B_noeud]
     $this(n_root) Ajouter_fils_au_debut $this(n_root_for_daughters)

 this set_prim_handle        $this(n_root)
 this set_root_for_daughters $this(n_root_for_daughters)

 eval "$objName configure $args"
 return $objName
}

#______________________________________________________ Adding the Specifyers functions _______________________________________________________
Methodes_set_LC Specifyer_PM_P_B207_color_base $L_methodes_set_Specifyer {} {}
Methodes_get_LC Specifyer_PM_P_B207_color_base $L_methodes_get_Specifyer {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters Specifyer_PM_P_B207_color_base [P_L_methodes_set_specifyer_COMET_RE]

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_B207_color_base Update_color {args} {
 #puts "$objName Update_color $args"
 if {[llength $args] == 4} {
   set r [lindex $args 0]
   set v [lindex $args 1]
   set b [lindex $args 2]
   set a [lindex $args 3]
  } else {if {[string index $args 0] == "\{"} {set args [string range $args 1 end-1]}
          set r [expr 0x[string range $args 1 2] / 255.0]
          set v [expr 0x[string range $args 3 4] / 255.0]
		  set b [expr 0x[string range $args 5 6] / 255.0]
		  set a 1
         }
 #puts "$objName prim_set_text \"$r $v $b $a\""
 this prim_set_text "$r $v $b $a"
}

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_B207_color_base set_text {v} {
 #puts "$objName Specifyer_PM_P_B207_color_base::set_text $v"
 if {[catch "$this(poly_fond) Couleur $v" err]} {puts "ERROR in $objName Specifyer_PM_P_B207_color_base::set_text $v\n$err\n____________________"}
}
