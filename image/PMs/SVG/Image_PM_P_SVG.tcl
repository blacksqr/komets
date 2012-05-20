#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Image_PM_P_SVG PM_SVG
#___________________________________________________________________________________________________________________________________________
method Image_PM_P_SVG constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CT_Image_FUI_basic_SVG
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Image_PM_P_SVG [P_L_methodes_set_Image] {} {}
Methodes_get_LC Image_PM_P_SVG [P_L_methodes_get_Image] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method Image_PM_P_SVG get_img_file_name {} {
 set img_path [[this get_Common_FC] get_img_file_name]
 set comet_path [Comet_files_root]
 set length [string length $comet_path]
 if {[string equal -length $length $comet_path $img_path]} {
   return [string range $img_path $length end]
  } else {return $img_path}
}

#___________________________________________________________________________________________________________________________________________
method Image_PM_P_SVG load_img {v} {
 set root    [this get_L_roots] 
 set methode "attr"
 set cmd     "\$('#$objName').attr('src','$v');\n"

 if {[lsearch [gmlObject info classes $root] PhysicalHTML_root] != -1} {
	$root Concat_update $objName $methode $cmd
 }
}

#___________________________________________________________________________________________________________________________________________
method Image_PM_P_SVG Render {strm_name {dec {}}} {
 upvar $strm_name strm
 
 set img_path   [this get_img_file_name]
 set comet_path [Comet_files_root]
 set length [string length $comet_path]
 if {[string equal -nocase -length $length $comet_path $img_path]} {
   set img_path [string range $img_path $length end]
  }
 
 append strm $dec "<g [this Style_class] ><image id=\"core_$objName\" x=\"0\" y=\"0\" width=\"320px\" height=\"200px\" xlink:href=\"" $img_path "\" />\n"
 this Render_daughters strm "$dec  "
 append strm $dec "</g>"
 
}

#___________________________________________________________________________________________________________________________________________
method Image_PM_P_SVG Draggable {} {
	this inherited $objName [list core_$objName]
}

#___________________________________________________________________________________________________________________________________________
method Image_PM_P_SVG RotoZoomable {} {
	this inherited $objName [list core_$objName]
}
