#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Container_PM_P_Flotant_HTML PM_HTML
#___________________________________________________________________________________________________________________________________________
method Container_PM_P_Flotant_HTML constructor {name {descr {}}} {
 this inherited $name $descr

 eval "$objName configure $args"
 return $objName
}
#___________________________________________________________________________________________________________________________________________
method Container_PM_P_Flotant_HTML Render {strm_name {dec {}}} {
 upvar $strm_name strm
 append strm $dec <div [this Style_class] {id=" } [eval [this get_LC] get_name] {" style="position:absolute; " onMouseDown="javascript:testClick(id)"  style="cursor:move"> }
  this Render_daughters strm "$dec  "
   append strm  $dec</div></br> "\n"
}



