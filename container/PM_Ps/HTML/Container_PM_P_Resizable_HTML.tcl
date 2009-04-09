#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Container_PM_P_Resizable_HTML PM_HTML
#___________________________________________________________________________________________________________________________________________
method Container_PM_P_Resizable_HTML constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Container_CUI_frame_HTML
 eval "$objName configure $args"
 return $objName
}
#___________________________________________________________________________________________________________________________________________
method Container_PM_P_Resizable_HTML Render_JS {strm_name mark {dec {}}} {
 upvar $strm_name strm

 append strm $dec "\$(function() {" "\n"
 append strm $dec "	\$(\"#${objName}\").resizable({ " 
 append strm $dec "	});" "\n"
 append strm $dec "});" "\n"

 this set_mark $mark
 this Render_daughters_JS strm $mark $dec  
}
#___________________________________________________________________________________________________________________________________________
method Container_PM_P_Resizable_HTML Render {strm_name {dec {}}} {
 upvar $strm_name strm
 
 append strm $dec "<div style=\"border:1px solid grey;\" " [this Style_class] ">" "\n"
   this Render_daughters strm "$dec  "
 append strm $dec </div> "\n"
}



