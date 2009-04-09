inherit PM_P_scale_TK PM_P_ChoiceN_TK

#___________________________________________________________________________________________________________________________________________
method PM_P_scale_TK constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id N_Choice_AUI_basic_CUI_slider_line_TK
 this set_root_for_daughters NULL
 this set_nb_max_daughters 0
 set this(all_currents) ""
 set this(scale_val_varname) "${objName}_var"
 global $this(scale_val_varname)
   set $this(scale_val_varname) 0
 set this(scale_name)        ""
 
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method PM_P_scale_TK dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
method PM_P_scale_TK get_or_create_prims {root} {
 global $this(scale_val_varname)

 set common_FC  [this get_Common_FC]
 set CometLabel [this get_comet_label]

 set this(scale_name) "$root.tk_${objName}_scale"
 if {[winfo exists $this(scale_name)]} {} else {
   #set min [$common_FC get_b_inf]
   #set max [$common_FC get_b_sup]
   scale $this(scale_name) -orient horizontal
  }
 this maj_choices

# Bindings
 set L [list $this(scale_name)]
 this set_prim_handle $L

# this set_currents [$common_FC get_currents]
 this maj_choices

 return [this set_prim_handle $L]
}
#___________________________________________________________________________________________________________________________________________
method PM_P_scale_TK maj_choices        {}   {
 global $this(scale_val_varname)

 set scale_name $this(scale_name)
 if {[winfo exists $scale_name]} {
   set $this(scale_val_varname) [this get_val]
   $scale_name configure -from [this get_b_inf] -to [this get_b_sup] \
                         -resolution [this get_step] \
                         -variable $this(scale_val_varname) \
                         -command "global $this(scale_val_varname); $objName prim_set_val $$this(scale_val_varname); $this(FC) set_val "
  }
}

#___________________________________________________________________________________________________________________________________________
#method PM_P_scale_TK set_comet_label {c} {set this(comet_label) $c}

#___________________________________________________________________________________________________________________________________________
method PM_P_scale_TK set_b_inf {v} {
 this inherited $v
 this maj_choices
}
#___________________________________________________________________________________________________________________________________________
method PM_P_scale_TK set_b_sup {v} {
 this inherited $v
 this maj_choices
}
#___________________________________________________________________________________________________________________________________________
method PM_P_scale_TK set_step  {v} {
 this inherited $v
 this maj_choices
}
#___________________________________________________________________________________________________________________________________________
method PM_P_scale_TK set_val  {v} {
 this inherited $v
 this maj_choices
}


