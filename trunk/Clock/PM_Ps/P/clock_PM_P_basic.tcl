inherit CometClock_PM_P_basic_TK PM_TK

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometClock_PM_P_basic_TK constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Clock_CUI_standard_numeric_TK
   set this(clock_TK_root) {}
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometClock_PM_P_basic_TK dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
method CometClock_PM_P_basic_TK get_or_create_prims {root} {
 set this(clock_TK_root) "$root.tk_${objName}_labclock"
 if {[winfo exists $this(clock_TK_root)]} {} else {
   label $this(clock_TK_root)
  }
 this set_root_for_daughters $root
 
 this set_time [this get_time]

 return [this set_prim_handle $this(clock_TK_root)]
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometClock_PM_P_basic_TK [L_methodes_set_Clock] {$this(FC)} {}
Methodes_get_LC CometClock_PM_P_basic_TK [L_methodes_get_Clock] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometClock_PM_P_basic_TK set_time {t} {
 if {[winfo exists $this(clock_TK_root)]} {
   $this(clock_TK_root) configure -text [clock format $t -format %H:%M:%S]
  }
}
