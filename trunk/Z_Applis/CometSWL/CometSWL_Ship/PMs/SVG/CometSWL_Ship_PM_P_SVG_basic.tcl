#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometSWL_Ship_PM_P_SVG_basic PM_SVG

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_SVG_basic constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id FUI_CometSWL_Ship_PM_P_SVG_basic
 
 this Add_MetaData PRIM_STYLE_CLASS [list $objName "SHIP PARAM RESULT IN OUT"]
 
 set this(svg_x) ""
 set this(svg_y) ""
 set this(mode) "edition"
 
 set this(current_player) ""
 
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometSWL_Ship_PM_P_SVG_basic [P_L_methodes_set_CometSWL_Ship] {} {}
Methodes_get_LC CometSWL_Ship_PM_P_SVG_basic [P_L_methodes_get_CometSWL_Ship] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters CometSWL_Ship_PM_P_SVG_basic [P_L_methodes_set_CometSWL_Ship_COMET_RE]

#___________________________________________________________________________________________________________________________________________
Generate_accessors CometSWL_Ship_PM_P_SVG_basic [list mode]

#___________________________________________________________________________________________________________________________________________
Inject_code CometSWL_Ship_PM_P_SVG_basic prim_set_X \
  "set this(svg_x) \$v" \
  ""

#___________________________________________________________________________________________________________________________________________
Inject_code CometSWL_Ship_PM_P_SVG_basic prim_set_Y \
  "set this(svg_y) \$v" \
  ""
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_SVG_basic set_player  {P}  {
 if {$this(current_player) != ""} {$this(current_player) UnSubscribe_to_set_player_color $objName}
 set this(current_player) $P
 if {$P != ""} {
   $this(current_player) Subscribe_to_set_player_color $objName "$objName Update_color"
   this Update_color
  }
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_SVG_basic Substitute_by {PM} {
 this inherited $PM
 if {[catch "$PM set_mode [this get_mode]" err]} {
   puts "Error in \"$objName Substitute_by $PM :\n  -  exp : May be due to the non implementation of a set_mode method in $PM\n  -err : $err\""
  }
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_SVG_basic Update_datas {} {}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_SVG_basic set_mode    {m}  {
 set this(mode) $m
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_SVG_basic SVG_Origine {coords} {
 set x [lindex $coords 0]
 set y [lindex $coords 1]
 
 this prim_set_X $x
 this prim_set_Y $y
 
 this inherited $coords
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_SVG_basic set_X       {v}  {
 if {$v != $this(svg_x)} {
   this send_jquery_message SVG_Origine "set_svg_origine('${objName}', $v, [this get_Y]);" 
  }
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_SVG_basic set_Y       {v}  {
 if {$v != $this(svg_y)} {
   this send_jquery_message SVG_Origine "set_svg_origine('${objName}', [this get_X], $v);"
  }
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_SVG_basic Update_color {} {
 set rgba [$this(current_player) get_player_color]
 set r [format %.2x [expr int([lindex $rgba 0]*255)]]
 set g [format %.2x [expr int([lindex $rgba 1]*255)]]
 set b [format %.2x [expr int([lindex $rgba 2]*255)]]
 set color [expr 0x$r$g${b}]
	 
 set cmd "\$('#${objName}_drag').each(function(i) {this.setAttribute('fill','#$r$g$b')});"
 
 this send_jquery_message "Update_color" $cmd
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_SVG_basic Render {strm_name {dec {}}} {
 upvar $strm_name strm
 set rgba [[this get_player] get_player_color]
 set r [format %.2x [expr int([lindex $rgba 0]*255)]]
 set g [format %.2x [expr int([lindex $rgba 1]*255)]]
 set b [format %.2x [expr int([lindex $rgba 2]*255)]]

 
 append strm "<g id=\"${objName}\" transform=\"translate([this get_X],[this get_Y])\">\n"
   if {[this get_mode] == "game"} { 
       set pi 3.1415926535897931
	   set angle [expr [this get_angle]*(180/$pi)]
       append strm "<rect id=\"${objName}_arrow_drag\" x=\"0\" y=\"-9\" width=\"[expr 20+[this get_power]]\" height=\"18\" fill-opacity=\"0.5\" transform=\"rotate($angle,0,0)\" stroke-opacity=\"0.9\" fill=\"#$r$g$b\" stroke=\"black\" stroke-width=\"1\" />\n" 
	 }
   append strm "<circle id=\"${objName}_drag\" cx=\"0\" cy=\"0\" r=\"[this get_R]\" fill=\"#$r$g$b\" stroke=\"black\" stroke-width=\"1\" />\n"
 append strm "</g>\n"
 
 this Render_daughters strm "$dec  "
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_SVG_basic set_power {v} {
 # puts "CometSWL_Ship_PM_P_SVG_basic set_power"
 set cmd "\$('#${objName}_arrow_drag').each(function(i) {this.setAttribute('width',($v+20));});\n"
 this send_jquery_message "set_power" $cmd
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_SVG_basic set_angle {v} {
 set pi 3.1415926535897931
 set angle [expr $v*(180/$pi)]
 set cmd "\$('#${objName}_arrow_drag').each(function(i) {this.setAttribute('transform','rotate($angle,0,0)'); });\n"
 this send_jquery_message "set_angle" $cmd
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_SVG_basic Render_post_JS {strm_name {dec ""}} {
 upvar $strm_name strm
 this inherited strm
 if {[this get_mode] == "edition"} {
     append strm [this Draggable ${objName} ${objName}_drag 0]
  } else {
	  # set x [$this(pt_tmp) X]
	 # Compute the new power
	 # set power [expr $x + $initial_power - $initial_x]
  
	 append strm "var ${objName}_angle_arrow = 0;\n"
	 append strm "\$('#${objName}_arrow_drag').draggable({drag : function(event, ui){\n"
	   append strm "   var coord = convert_coord_from_page_to_node(event.pageX,event.pageY,this.parentNode);\n"   
	   append strm "   var dxmouse = coord\['x'\];\n"
	   append strm "   var dymouse = coord\['y'\];\n"
	   append strm "   var puissance = Math.sqrt((dxmouse*dxmouse) + (dymouse*dymouse));"
	   append strm "   ${objName}_angle_arrow = Math.acos(dxmouse / puissance);"
	   append strm "   if(puissance > 120) { puissance = 120; } else if(puissance <= 20) { puissance = 20; }\n"
	   append strm "   if(dymouse < 0) { ${objName}_angle_arrow = (2 * Math.PI) - ${objName}_angle_arrow; }\n"
	   append strm "   ${objName}_angle_arrow = ${objName}_angle_arrow * (180 / Math.PI);\n"
	   append strm "   this.setAttribute('width', puissance); \n"
	   append strm "   this.setAttribute('transform','rotate('+${objName}_angle_arrow+',0,0)');\n"
	 append strm "},stop : function(event, ui){\n"
	   append strm "   var rad = (${objName}_angle_arrow*Math.PI)/180.0;"
	   append strm "   addOutput_proc_val('${objName}__XXX__prim_set_angle', rad, false);\n"
	   append strm "   addOutput_proc_val('${objName}__XXX__prim_set_power', (this.getAttribute('width')-20), true);\n"
	 append strm "}});\n"
  }
 
 this Render_daughters_post_JS strm $dec
}
