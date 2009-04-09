inherit SlideRemoteController_PM_P_BIGre_keyboard PM_BIGre

#___________________________________________________________________________________________________________________________________________
method SlideRemoteController_PM_P_BIGre_keyboard constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id N_controller_basic_BIGre_keyboard
 if {[string length [info proc B_noeud]] > 0} {} else {return $objName}

 set this(nb) 0
 set this(node_created_inside) 1
 this set_prim_handle        [B_texte 0 0 999999 [fonte_Arial] [B_sim_sds]]
   set this(rap_car) [B_rappel [Interp_TCL] "$objName Char_entered"]
   B_configure [this get_prim_handle] -Nom_IU $objName -abonner_a_caractere_tape [$this(rap_car) Rappel] -Afficher_boites 0
 this set_root_for_daughters [this get_prim_handle]

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method  SlideRemoteController_PM_P_BIGre_keyboard dispose {} {
 if {$this(node_created_inside)} {
   $this(primitives_handle) -delete
  }
 this inherited
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC SlideRemoteController_PM_P_BIGre_keyboard $L_methodes_set_choicesN {$this(FC)} {}
Methodes_get_LC SlideRemoteController_PM_P_BIGre_keyboard $L_methodes_get_choicesN {$this(FC)}
Methodes_set_LC SlideRemoteController_PM_P_BIGre_keyboard [L_methodes_set_SlideRemoteController] {$this(FC)} {}
Methodes_get_LC SlideRemoteController_PM_P_BIGre_keyboard [L_methodes_get_SlideRemoteController] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters SlideRemoteController_PM_P_BIGre_keyboard [L_methodes_set_SlideRemoteController]

#___________________________________________________________________________________________________________________________________________
method  SlideRemoteController_PM_P_BIGre_keyboard Char_entered {} {
 set c [Void_vers_int [$this(rap_car) Param]]
 puts "$objName à capter num $c :?: \'[Void_vers_char [$this(rap_car) Param]]\'"
 if {$c == [SDSK_LEFT] } {this prim_go_to_prv} else {
 if {$c == [SDSK_RIGHT]} {this prim_go_to_nxt} else {
 if {$c == [SDSK_HOME]}  {this prim_go_to_bgn} else {
 if {$c == [SDSK_END]}   {this prim_go_to_end} else {
 if {$c>=48 && $c<=57} {this Chiffre [Void_vers_char [$this(rap_car) Param]]}
   }
  }}}
}

#___________________________________________________________________________________________________________________________________________
method SlideRemoteController_PM_P_BIGre_keyboard Chiffre {c} {
 puts "$objName Chiffre $c"
 set this(nb) [expr $this(nb)*10 + $c]
 after 500 "$objName TMP_go_to_num $this(nb)"
}

#___________________________________________________________________________________________________________________________________________
method SlideRemoteController_PM_P_BIGre_keyboard TMP_go_to_num {nb} {
 if {$this(nb) == $nb} {this prim_set_current $nb
                        set this(nb) 0
                       }
}

#___________________________________________________________________________________________________________________________________________
#method SlideRemoteController_PM_P_BIGre_keyboard go_to_num {c} {[this get_LC] set_val [expr ($c>[this get_b_sup])?[this get_b_sup]:(($c<[this get_b_inf])?[this get_b_inf]:$c)]}
#method SlideRemoteController_PM_P_BIGre_keyboard go_to_bgn {}  {[this get_LC] set_val [this get_b_inf]}
#method SlideRemoteController_PM_P_BIGre_keyboard go_to_prv {}  {[this get_LC] set_val [expr ([this get_val]-1 < [this get_b_inf])?[this get_b_inf]:[this get_val]-1]}
#method SlideRemoteController_PM_P_BIGre_keyboard go_to_nxt {}  {[this get_LC] set_val [expr ([this get_val]+1 > [this get_b_sup])?[this get_b_sup]:[this get_val]+1]}
#method SlideRemoteController_PM_P_BIGre_keyboard go_to_end {}  {[this get_LC] set_val [this get_b_sup]}

