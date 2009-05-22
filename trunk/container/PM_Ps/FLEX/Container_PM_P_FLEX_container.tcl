#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Container_PM_P_FLEX_Vbox PM_FLEX

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_FLEX_Vbox constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Container_CUI_frame_FLEX

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_FLEX_Vbox Render {strm_name {dec {}}} {
 upvar $strm_name strm

 #set this(container_text) [this get_text]
 append strm $dec " var $objName:Vbox = new Vbox(); \n"
 append strm $dec " $objName.minHeight=20; \n"
 append strm $dec " $objName.minWidth=150; \n"
 append strm $dec " Dyna_context.$objName = $objName;\n"
 
 this set_prim_handle        $objName
 this set_root_for_daughters $objName
 this Render_daughters strm "$dec "

 return [this get_prim_handle]
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_FLEX_Vbox Resize {x y} {}