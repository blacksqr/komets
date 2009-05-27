inherit Choice_file_PM_P_dialog_B207_with_TK PM_BIGre

#___________________________________________________________________________________________________________________________________________
method Choice_file_PM_P_dialog_B207_with_TK constructor {name descr args} {
 this inherited $name $descr
 this set_root_for_daughters NULL
   this set_GDD_id ChoiceFiles_CUI_standard_system_B207_with_TK
   this set_nb_max_daughters 0
   
   set this(B_txt) [B_texte "Load"]
   set this(bt) ${objName}_BT
   B_bouton_perso $this(bt) $this(B_txt) \
                  "$this(B_txt) Couleur_texte 0   1 0   1;" \
			      "$this(B_txt) Couleur_texte 1   1 1   1;" \
			      "$this(B_txt) Couleur_texte 0.5 1 0.5 1; $this(B_txt) Couleur_fond 0 0.7 0 1" \
				  "$this(B_txt) Couleur_texte 0   1 0   1; $this(B_txt) Couleur_fond 0 0   0 1"
   
   $this(bt) Subscribe_to_activate $objName "$objName Do_file_choose"
   
   this set_prim_handle $this(B_txt)
   
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method Choice_file_PM_P_dialog_B207_with_TK dispose {} {this inherited}

#______________________________________________________ Adding the choices functions _______________________________________________________
Methodes_set_LC Choice_file_PM_P_dialog_B207_with_TK $L_methodes_set_choices {}          {}
Methodes_get_LC Choice_file_PM_P_dialog_B207_with_TK $L_methodes_get_choices {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters Choice_file_PM_P_dialog_B207_with_TK [P_L_methodes_set_choice_N_COMET_RE]

#___________________________________________________________________________________________________________________________________________
method Choice_file_PM_P_dialog_B207_with_TK maj_choices        {}   {}

#___________________________________________________________________________________________________________________________________________
method Choice_file_PM_P_dialog_B207_with_TK Do_file_choose {} {
 set mult [expr [this get_nb_max_choices] > 1]
 set LC [this get_LC]
 this prim_set_currents [tk_getOpenFile -multiple $mult -title [$LC get_name]]
}
