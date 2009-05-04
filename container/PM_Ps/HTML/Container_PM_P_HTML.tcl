#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Container_PM_P_HTML PM_HTML
#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HTML constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Container_CUI_frame_HTML

   this set_root_for_daughters $objName
   this set_prim_handle        $objName
   this Add_MetaData PRIM_STYLE_CLASS [list $objName "ROOT FRAME" \
                                      ]
 eval "$objName configure $args"
 return $objName
}
#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HTML Render {strm_name {dec {}}} {
 upvar $strm_name strm
 
 append strm $dec <div [this Style_class] > "\n"
   this Render_daughters strm "$dec  "
 append strm $dec </div> "\n"
}



