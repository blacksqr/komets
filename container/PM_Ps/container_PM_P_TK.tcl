#___________________________________________________________________________________________________________________________________________
inherit PhysicalContainer_TK_frame PM_TK
#___________________________________________________________________________________________________________________________________________
method PhysicalContainer_TK_frame constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Container_CUI_frame_TK
 eval "$objName configure $args"
 return $objName
}
#___________________________________________________________________________________________________________________________________________
method PhysicalContainer_TK_frame get_context {} {}
#___________________________________________________________________________________________________________________________________________
method PhysicalContainer_TK_frame get_or_create_prims {root} {
# Define the handle
 set f $root.tk_${objName}_frame
 if {![winfo exists $f]} {frame $f -bd 0 -relief raised}

 this Add_MetaData PRIM_STYLE_CLASS [list $f      "ROOT FRAME"                           \
                                    ]

 this set_root_for_daughters $f
 return [this set_prim_handle $f]
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit PhysicalContainer_TK_window PM_TK
#___________________________________________________________________________________________________________________________________________
method PhysicalContainer_TK_window constructor {name descr args} {
 set this(primitives_handle) "."
 this inherited $name $descr
   this set_GDD_id Container_CUI_window_TK
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method PhysicalContainer_TK_window dispose {} {
 set w [this get_prim_handle]
 if {[winfo exists $w]} {destroy $w}
 
 this inherited
}

#___________________________________________________________________________________________________________________________________________
method PhysicalContainer_TK_window get_context {} {}

#___________________________________________________________________________________________________________________________________________
method PhysicalContainer_TK_window get_or_create_prims {root} {
# Define the handle
 set w $root.tk_${objName}_win
 if {![winfo exists $w]} {toplevel $w}
 wm title $w [[this get_LC] get_name]
 this set_root_for_daughters $w

 return [this set_prim_handle $w]
}

#___________________________________________________________________________________________________________________________________________
method PhysicalContainer_TK_window Resize {x y} {
 set w [this get_prim_handle]
 if {[winfo exists $w]} {
   wm geometry $w "${x}x${y}"
  }
}

