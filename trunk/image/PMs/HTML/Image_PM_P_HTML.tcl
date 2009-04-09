#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Image_PM_P_HTML PM_HTML
#___________________________________________________________________________________________________________________________________________
method Image_PM_P_HTML constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CT_Image_AUI_CUI_basic_HTML
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Image_PM_P_HTML [P_L_methodes_set_Image] {} {}
Methodes_get_LC Image_PM_P_HTML [P_L_methodes_get_Image] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method Image_PM_P_HTML get_img_file_name {} {
 set img_path [[this get_Common_FC] get_img_file_name]
 set comet_path [Comet_files_root]
 set length [string length $comet_path]
 if {[string equal -length $length $comet_path $img_path]} {
   return [string range $img_path $length end]
  } else {return $img_path}
}

#___________________________________________________________________________________________________________________________________________
method Image_PM_P_HTML Render {strm_name {dec {}}} {
 upvar $strm_name strm
 
 set img_path   [this get_img_file_name]
 set comet_path [Comet_files_root]
 set length [string length $comet_path]
 if {[string equal -length $length $comet_path $img_path]} {
   set img_path [string range $img_path $length end]
  }
 
 append strm "$dec" <img [this Style_class] { src="} [this get_img_file_name] {" alt="} [this get_name] {" />} "\n"

 this Render_daughters strm "$dec  "

}

