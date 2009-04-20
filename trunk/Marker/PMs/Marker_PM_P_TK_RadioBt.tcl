#___________________________________________________________________________________________________________________________________________
inherit Marker_PM_P_TK_RadioBt PM_TK
#___________________________________________________________________________________________________________________________________________
method Marker_PM_P_TK_RadioBt constructor {name descr args} {
 set this(var_name) "${objName}_var_rb"
 this inherited $name $descr
   this set_GDD_id Marker_simple_RadioBt_TK   
 eval "$objName configure $args"
}
#___________________________________________________________________________________________________________________________________________
method Marker_PM_P_TK_RadioBt get_context {} {}
#___________________________________________________________________________________________________________________________________________
method Marker_PM_P_TK_RadioBt get_or_create_prims {root} {
# Define the handle
 set rb $root.tk_${objName}_rb
 if {[winfo exists $rb]} {
  } else {set CFC [this get_Common_FC]
          set cmd "set new_val \[expr 1-\[$CFC get_mark\]\];\
                   $CFC set_mark \$new_val;\
                   [this get_LC] set_mark \$new_val"
          radiobutton $rb -variable $this(var_name) -value 1 -command $cmd
         }

 this set_root_for_daughters $root
# DEBUG
 [this get_mothers] set_cmd_placement {pack $p -side left -expand 0}
#XXXXX

 return [this set_prim_handle $rb]
}

#___________________________________________________________________________________________________________________________________________
method Marker_PM_P_TK_RadioBt get_mark {}  {
 set CFC [this get_Common_FC]
 return [$CFC get_mark]
}
#___________________________________________________________________________________________________________________________________________
method Marker_PM_P_TK_RadioBt set_mark {m} {
 global $this(var_name)
 set $this(var_name) $m
}
#___________________________________________________________________________________________________________________________________________


