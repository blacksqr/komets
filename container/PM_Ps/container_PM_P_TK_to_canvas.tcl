#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Container_PM_P_TK_to_canvas PM_TK

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_TK_to_canvas constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Container_FUI_bridge_TK_to_CANVAS_frame
   [[this get_cou] get_ptf] maj Ptf_TK_to_CANVAS
   set this(canvas) ""
   set this(current_element) ""
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_TK_to_canvas get_context {} {}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_TK_to_canvas get_or_create_prims {root} {
# Define the handle
 set f $root.tk_${objName}_canvas
 if {![winfo exists $f]} {canvas $f}
 
 set this(canvas) $f
 bind $this(canvas) <Motion>      "+ $objName Move %x %y"
 this Add_MetaData PRIM_STYLE_CLASS [list $f "ROOT CANVAS FRAME" \
                                    ]

 this set_root_for_daughters $objName
 return [this set_prim_handle $f]
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_TK_to_canvas get_root_for_daughters {{index -1}} {
 if {[winfo exists $this(canvas)]} {
   return $objName
  } else {return NULL}
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_TK_to_canvas get_canvas {} {return $this(canvas)}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_TK_to_canvas get_tk_canvas {} {return $this(canvas)}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_TK_to_canvas set_current_element {e x y} {
 set this(current_element) $e
 set this(last_x) $x
 set this(last_y) $y
 if {$e != ""} {$this(canvas) raise $e}
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_TK_to_canvas Move {x y} {
 if {$this(current_element) != ""} {
   $this(current_element) Translate [expr $x - $this(last_x)] [expr $y - $this(last_y)]
   set this(last_x) $x
   set this(last_y) $y
  }
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_TK_to_canvas Zoom {e factor x y} {
 $this(canvas) scale $e $x $y $factor $factor
}

#___________________________________________________________________________________________________________________________________________
#Trace Container_PM_P_TK_to_canvas set_current_element
#Trace Container_PM_P_TK_to_canvas Move
