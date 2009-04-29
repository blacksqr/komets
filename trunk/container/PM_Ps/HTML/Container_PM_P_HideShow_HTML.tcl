#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Container_PM_P_HideShow_HTML PM_HTML
#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HideShow_HTML constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Container_CUI_frame_HTML
 eval "$objName configure $args"
 return $objName
}
#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HideShow_HTML Render_JS {strm_name mark {dec {}}} {
 upvar $strm_name strm

 append strm $dec "\$(function() {" "\n" 

 append strm $dec "     \$(\"#${objName}\").addClass(\"ui-widget ui-widget-content ui-helper-clearfix ui-corner-all\")" "\n"
 append strm $dec "	            .find(\"#${objName}-header\")" "\n"
 append strm $dec "				.addClass(\"ui-widget-header\")" "\n"
 append strm $dec "				.prepend('<span id=\"${objName}-icon\" class=\"ui-icon ui-icon-circle-arrow-n\"></span>')" "\n"
 append strm $dec "				.end()" "\n"
 append strm $dec "			.find(\"#${objName}-content\");" "\n"
 
 append strm $dec "		\$(\"#${objName}\").draggable({ handle: '#${objName}-header' });" "\n"

 append strm $dec "		\$(\"#${objName}-icon\").click(function() {" "\n"
 append strm $dec "         if(\$(this).hasClass(\"ui-icon-circle-arrow-n\")) { \$(this).attr(\"class\",\"ui-icon ui-icon-circle-arrow-s\"); \$(\"#${objName}-content\").hide(\"blind\"); }" "\n"
 append strm $dec "			else { \$(this).attr(\"class\",\"ui-icon ui-icon-circle-arrow-n\"); \$(\"#${objName}-content\").show(\"blind\"); }" "\n"
 append strm $dec "	      });" "\n"
 append strm $dec "});" "\n"

 this set_mark $mark
 this Render_daughters_JS strm $mark $dec  
}
#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HideShow_HTML Render {strm_name {dec {}}} {
 upvar $strm_name strm
 
 append strm $dec <div  [this Style_class] > "\n"
   append strm $dec "<div id=\"${objName}-header\" class=\"portlet-header\">${objName}</div>"
   append strm $dec "<div id=\"${objName}-content\" class=\"portlet-content\">"
      this Render_daughters strm "$dec  "
   append strm $dec "</div>"
 append strm $dec </div> "\n"
}



