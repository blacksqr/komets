#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Specifyer_PM_P_FLEX_color_base PM_FLEX

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_FLEX_color_base constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Specifyer_Color_FUI_basic_system_FLEX

 eval "$objName configure $args"
 return $objName
}

#______________________________________________________ Adding the Specifyers functions _______________________________________________________
Methodes_set_LC Specifyer_PM_P_FLEX_color_base $L_methodes_set_Specifyer {} 		{}
Methodes_get_LC Specifyer_PM_P_FLEX_color_base $L_methodes_get_Specifyer {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters Specifyer_PM_P_FLEX_color_base [P_L_methodes_set_specifyer_COMET_RE]

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_FLEX_color_base Update_color {color_rgba} {
 puts "color_rgba : $color_rgba \n"
 set root [this get_L_roots] 
 set cmd "${objName}.selectedColor = $color_rgba; \n"

 foreach c [list b g r] {
   set $c [expr ($color_rgba & 0xFF) / 255.0]
   set color_rgba [expr $color_rgba >> 8]
  }
 
 this prim_set_text "$r $g $b 1"
 puts "r g b a : $r $g $b 1"
}

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_FLEX_color_base set_text {rgba} {
 puts "rgba : $rgba"
 if {$rgba != ""} {
	 set r [format %.2x [expr int([lindex $rgba 0]*255)]]
	 set g [format %.2x [expr int([lindex $rgba 1]*255)]]
	 set b [format %.2x [expr int([lindex $rgba 2]*255)]]
	 set color [expr 0x$r$g${b}]
	 puts "color : $color"
	 
 	 set root    [this get_L_roots] 
	 set cmd "$objName.selectedColor=\"$color\"; \n"
	 if {[lsearch [gmlObject info classes $root] Comet_root_PM_P_FLEX] != -1} {
		$root send_to_FLEX $cmd
		puts "commande : $cmd"
	 }
 }
}

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_FLEX_color_base Render {strm_name {dec {}}} {
upvar $strm_name strm
 
 append strm $dec " var $objName:ColorPicker = new ColorPicker(); \n"
 append strm $dec " ${objName}.addEventListener(ColorPickerEvent.CHANGE,colorChanged_${objName}); \n"
 append strm $dec " function colorChanged_${objName}(${objName}_event:ColorPickerEvent):void{ \n"
 append strm $dec " 	var ${objName}_color:uint = ${objName}.selectedColor; \n"
 append strm $dec "		FLEX_to_TCL(\"$objName\", \"Update_color\", String(${objName}_color)) } \n"
 append strm $dec " Dyna_context.$objName = $objName; \n"
 
 this set_prim_handle        $objName
 this set_root_for_daughters $objName
}