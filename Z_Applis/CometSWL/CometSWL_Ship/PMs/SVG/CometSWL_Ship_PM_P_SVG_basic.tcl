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
   this send_jquery_message "SVG_Origine" "set_svg_origine('${objName}', $v, [this get_Y]);" 
  }
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_SVG_basic set_Y       {v}  {
 if {$v != $this(svg_y)} {
   this send_jquery_message "SVG_Origine" "set_svg_origine('${objName}', [this get_X], $v);"
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
   append strm "<circle id=\"${objName}_drag\" cx=\"0\" cy=\"0\" r=\"10\" fill=\"#$r$g$b\" stroke=\"black\" stroke-width=\"1\" />\n"
 append strm "</g>\n"
 
 this Render_daughters strm "$dec  "
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_SVG_basic Render_post_JS {strm_name {dec ""}} {
 upvar $strm_name strm
 this inherited strm
 if {[this get_mode] == "edition"} {
     append strm [this Draggable ${objName} ${objName}_drag 0]
  }
 
 this Render_daughters_post_JS strm $dec
}
