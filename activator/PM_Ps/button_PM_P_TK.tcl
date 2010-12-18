#_______________________________________________ D�finition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________

inherit Activator_PM_P_button_TK PM_TK


#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_button_TK constructor {name descr args} {
 set this(b) ""
 this inherited $name $descr
 this set_GDD_id CT_Activator_AUI_basic_CUI_button_TK
 eval "$objName configure $args"
 return $objName
}
#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_button_TK dispose {} {
 this inherited
}


#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Activator_PM_P_button_TK $L_methodes_set_Activator {} {}
Methodes_get_LC Activator_PM_P_button_TK $L_methodes_get_Activator {$this(FC)}
Generate_PM_setters Activator_PM_P_button_TK [list {activate {{type {}}}}]
  Manage_CallbackList Activator_PM_P_button_TK prim_activate begin

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_button_TK Trigger_prim_activate {} {
 set cmd ""
 foreach {var val} [this get_Params] {append cmd " " $var " $val"}
 this prim_activate $cmd
}

#___________________________________________________________________________________________________________________________________________
Manage_CallbackList Activator_PM_P_button_TK Trigger_prim_activate begin

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_button_TK get_or_create_prims {root} {
 set this(b) "$root.tk_${objName}_button"
 if {![winfo exists $this(b)]} {
   button $this(b) -text [this get_text]
  }
 this set_root_for_daughters $root
 
 $this(b) configure -command "$objName Trigger_prim_activate"

 return [this set_prim_handle $this(b)]
}

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_button_TK set_text {t} {
 if {[winfo exists $this(b)]} {
  $this(b) configure -text $t}
}

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_button_TK get_text {} {
 if {[winfo exists $this(b)]} {
   return [$this(b) cget -text]
  }
 return [eval [this get_Common_FC] get_text]
}
