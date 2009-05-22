#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Image_PM_P_FLEX PM_FLEX
#___________________________________________________________________________________________________________________________________________
method Image_PM_P_FLEX constructor {name descr args} {
 this inherited $name $descr

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Image_PM_P_FLEX [P_L_methodes_set_Image] {} 		{}
Methodes_get_LC Image_PM_P_FLEX [P_L_methodes_get_Image] {$this(FC)}

proc P_L_methodes_get_Image {} {return [list {get_img_file_name {}}]}
proc P_L_methodes_set_Image {} {return [list {load_img {f}}]}
#___________________________________________________________________________________________________________________________________________
method Image_PM_P_FLEX get_img_file_name {} {
 set img_path [[this get_Common_FC] get_img_file_name]
 set comet_path [Comet_files_root]
 set length [string length $comet_path]
 if {[string equal -length $length $comet_path $img_path]} {
   return [string range $img_path $length end]
  } else {return $img_path}
}

#___________________________________________________________________________________________________________________________________________
method Image_PM_P_FLEX load_img {v} {
 set root    [this get_L_roots] 
 set cmd     "$objName.source=\"$v\";\n"
 
 if {[lsearch [gmlObject info classes $root] Comet_root_PM_P_FLEX] != -1} {
	$root send_to_FLEX $cmd
	puts "commande : $cmd"
 }
}

#___________________________________________________________________________________________________________________________________________
method Image_PM_P_FLEX Render {strm_name {dec {}}} {
 upvar $strm_name strm
 
 append strm $dec " var $objName:Image = new Image(); \n"
 append strm $dec " $objName.source=\"[this get_img_file_name]\"; \n"
 append strm $dec " $objName.addEventListener(FlexEvent.DATA_CHANGE,${objName}_fct); \n"
 append strm $dec " function ${objName}_fct(${objName}_evt:FlexEvent):void { \n"
 append strm $dec "		FLEX_to_TCL(\"$objName\", \"prim_load_img\", \"\") } \n"
 append strm $dec " Dyna_context.$objName = $objName; \n"
 
 this set_prim_handle        $objName
 this set_root_for_daughters $objName
}

