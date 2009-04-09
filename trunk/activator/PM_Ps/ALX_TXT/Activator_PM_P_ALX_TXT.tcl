#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Activator_PM_P_ALX_TXT PM_ALX_TXT

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_ALX_TXT constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CT_Activator_AUI_basic_CUI_button_S207
   this set_nb_max_mothers 1
   set this(internal_log) {}
   this set_name $name
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Activator_PM_P_ALX_TXT $L_methodes_set_Activator {$this(FC)} {}
Methodes_get_LC Activator_PM_P_ALX_TXT $L_methodes_get_Activator {$this(FC)}
Generate_PM_setters Activator_PM_P_ALX_TXT [list {activate {{type {}}}}]
  Manage_CallbackList Activator_PM_P_ALX_TXT prim_activate begin

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_ALX_TXT Add_Params {L_var_val} {
 foreach {var val} $L_var_val {
   set this(PARAMS,$var) $val
  }
}

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_ALX_TXT Sub_Params {L_var_val} {
 foreach {var val} $L_var_val {
   unset this(PARAMS,$var)
  }
}

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_ALX_TXT Has_Params {L_var} {
 foreach {var val} [array get this PARAMS,*] {
   set var [string range $var 7 end]
   foreach v $L_var {if {$v == $var} {return 1}}
  }
 return 0
}

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_ALX_TXT Val_Param {v} {
 return $this(PARAMS,$v)
}

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_ALX_TXT Trigger_prim_activate {} {
 set cmd ""
 foreach {var val} [array get this PARAMS,*] {append cmd " " [string range $var 7 end] " $val"}
 this prim_activate $cmd
}

#___________________________________________________________________________________________________________________________________________
Manage_CallbackList Activator_PM_P_ALX_TXT Trigger_prim_activate begin

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_ALX_TXT Analyse {str_name} {
 upvar $str_name  str
 set LC [this get_LC]
 this set_reg_exp "regexp -nocase \" *(action|activate|trigger)? *(${objName}|[this get_text]|[$LC get_name]) *(.*)\$\" \$str reco activate name apres"

 this inherited str
}

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_ALX_TXT Process_TXT {e} {
 this Trigger_prim_activate
}
