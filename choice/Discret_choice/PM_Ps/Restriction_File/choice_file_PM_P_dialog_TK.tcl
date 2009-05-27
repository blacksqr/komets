inherit Choice_file_PM_P_dialog_TK PM_TK

#___________________________________________________________________________________________________________________________________________
method Choice_file_PM_P_dialog_TK constructor {name descr args} {
 this inherited $name $descr
 this set_root_for_daughters NULL
   this set_GDD_id ChoiceFiles_CUI_standard_system_TK
   this set_nb_max_daughters 0
   set this(direct_plug) 0
   set this(root_of_prim) ""
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method Choice_file_PM_P_dialog_TK dispose {} {this inherited}

#______________________________________________________ Adding the choices functions _______________________________________________________
Methodes_set_LC Choice_file_PM_P_dialog_TK $L_methodes_set_choices {}          {}
Methodes_get_LC Choice_file_PM_P_dialog_TK $L_methodes_get_choices {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters Choice_file_PM_P_dialog_TK [P_L_methodes_set_choice_N_COMET_RE]

#___________________________________________________________________________________________________________________________________________
Generate_accessors Choice_file_PM_P_dialog_TK [list direct_plug]

#___________________________________________________________________________________________________________________________________________
method Choice_file_PM_P_dialog_TK get_or_create_prims {root} {
 set this(root_of_prim) $root
 set mult [expr [this get_nb_max_choices] > 1]
 set LC  [this get_LC]
 set txt [$LC get_name]
 if {$this(direct_plug)} {
   this prim_set_currents [tk_getOpenFile -multiple $mult -title [$LC get_name] -parent $root]
   return
  }

 set this(b) $root.tk_${objName}_bt
 if {[winfo exists $this(b)]} {} else {
   button $this(b)
  }
 $this(b) configure -text $txt -command "$LC set_currents \[tk_getOpenFile -title \{$txt\} -multiple \[expr \[$objName get_nb_max_choices\] > 1\] -parent $root\]"

# Bindings
 set L [list $this(b)]
 this set_prim_handle $L

 return [this set_prim_handle $L]
}

#___________________________________________________________________________________________________________________________________________
method Choice_file_PM_P_dialog_TK maj_choices        {}   {}

#___________________________________________________________________________________________________________________________________________
method Choice_file_PM_P_dialog_TK activate {} {
 if {![winfo exists $this(root_of_prim)]} {return}
 set mult [expr [this get_nb_max_choices] > 1]
 set LC  [this get_LC]
 set txt [$LC get_name]
 $LC set_currents [tk_getOpenFile -title $txt -multiple $mult -parent $this(root_of_prim)]
}
