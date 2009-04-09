inherit PM_P_ChoiceN_menu_TK PM_P_ChoiceN_TK

#___________________________________________________________________________________________________________________________________________
method PM_P_ChoiceN_menu_TK constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id N_Choice_AUI_basic_CUI_menu_TK
 this set_root_for_daughters NULL
 this set_nb_max_daughters 0
 set this(all_currents) ""
 set this(menu_val_varname) "${objName}_var"
 global $this(menu_val_varname)
   set $this(menu_val_varname) 0
 set this(menu_name)        ""
 
 eval "$objName configure $args"
}

#___________________________________________________________________________________________________________________________________________
method PM_P_ChoiceN_menu_TK dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
method PM_P_ChoiceN_menu_TK get_or_create_prims {root} {
 global $this(menu_val_varname)

 set common_FC  [this get_Common_FC]
 set CometLabel [this get_comet_label]

 set this(menu_name) "$root.tk_${objName}_menu"
 if {[winfo exists $this(menu_name)]} {} else {
   tk_optionMenu $this(menu_name) "${objName}_choice" Choose
  }
 this maj_choices

# Bindings
 set L [list $this(menu_name)]
 this set_prim_handle $L

# this set_currents [$common_FC get_currents]
 this maj_choices

 return [this set_prim_handle $L]
}
#___________________________________________________________________________________________________________________________________________
method PM_P_ChoiceN_menu_TK maj_choices        {}   {
global debug

 set L_prims [this get_prim_handle]
 set racine [lindex $L_prims 0]
 if {[winfo exists $racine]} {} else {if { $debug } { puts "Racine $racine do not exists" }
				      return}
 set CFC [this get_Common_FC]
 $racine.menu delete 0 last
 set    cmd {}
   append cmd "$CFC set_state Done;"
 for {set i [$CFC get_b_inf]} {$i <= [$CFC get_b_sup]} {incr i [$CFC get_step]} {
   $racine.menu add radiobutton -label $i \
                                -command "set ${objName}_choice $i; $CFC set_val $i; $objName prim_set_val $i; $cmd"
  }

 this set_val [this get_val]
}

#___________________________________________________________________________________________________________________________________________
method PM_P_ChoiceN_menu_TK set_b_inf {v} {
 this inherited $v
 this maj_choices
}
#___________________________________________________________________________________________________________________________________________
method PM_P_ChoiceN_menu_TK set_b_sup {v} {
 this inherited $v
 this maj_choices
}
#___________________________________________________________________________________________________________________________________________
method PM_P_ChoiceN_menu_TK set_step  {v} {
 this inherited $v
 this maj_choices
}
#___________________________________________________________________________________________________________________________________________
method PM_P_ChoiceN_menu_TK set_val  {v} {
 this inherited $v
 set choice_var_name ${objName}_choice
 global $choice_var_name
 set $choice_var_name $v
 if {[winfo exists $this(menu_name)]} {
   $this(menu_name).menu activate $v
  }
}
