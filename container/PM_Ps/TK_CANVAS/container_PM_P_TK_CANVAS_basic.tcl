#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Container_PM_P_TK_CANVAS_basic PM_TK_CANVAS

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_TK_CANVAS_basic constructor {name descr args} {
 this inherited $name $descr

   this set_GDD_id GDD_Container_PM_P_TK_CANVAS_basic

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_TK_CANVAS_basic get_or_create_prims {C_canvas} {
# Define the handle
 set canvas [$C_canvas get_canvas]
 this set_canvas $canvas
# $canvas create rectangle 0 0 200 100 -fill red -tags $objName
 
 this Add_MetaData PRIM_STYLE_CLASS [list $objName "CONTAINER" \
                                    ]

 this set_root_for_daughters $C_canvas
 return [this set_prim_handle $canvas]
}

