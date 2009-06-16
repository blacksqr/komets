#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometSWL_Missile_PM_P_SVG_basic PM_SVG

#___________________________________________________________________________________________________________________________________________
method CometSWL_Missile_PM_P_SVG_basic constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id FUI_CometSWL_Missile_PM_P_SVG_basic
 
 this Add_MetaData PRIM_STYLE_CLASS [list $objName "MISSILE PARAM RESULT IN OUT"]
  
 set this(svg_x) ""
 set this(svg_y) ""
 
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometSWL_Missile_PM_P_SVG_basic [P_L_methodes_set_CometSWL_Missile] {} {}
Methodes_get_LC CometSWL_Missile_PM_P_SVG_basic [P_L_methodes_get_CometSWL_Missile] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters CometSWL_Missile_PM_P_SVG_basic [P_L_methodes_set_CometSWL_Missile_COMET_RE]

#___________________________________________________________________________________________________________________________________________
Inject_code CometSWL_Missile_PM_P_SVG_basic prim_set_X \
  "set this(svg_x) \$v" \
  ""

#___________________________________________________________________________________________________________________________________________
Inject_code CometSWL_Missile_PM_P_SVG_basic prim_set_Y \
  "set this(svg_y) \$v" \
  ""
  
#___________________________________________________________________________________________________________________________________________
method CometSWL_Missile_PM_P_SVG_basic SVG_Origine {coords} {
 set x [lindex $coords 0]
 set y [lindex $coords 1]
 
 this prim_set_X $x
 this prim_set_Y $y
 
 this inherited $coords
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Missile_PM_P_SVG_basic set_X       {v}  {
 if {$v != $this(svg_x)} {
   this send_jquery_message "SVG_Origine" "\$('#$objName').each(function(i) {this.setAttribute('cx',$v)});" 
  }
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Missile_PM_P_SVG_basic set_Y       {v}  {
 if {$v != $this(svg_y)} {
   this send_jquery_message "SVG_Origine" "\$('#$objName').each(function(i) {this.setAttribute('cy',$v)});"
  }
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Missile_PM_P_SVG_basic Render {strm_name {dec {}}} {
 upvar $strm_name strm
 
 append strm "<circle id=\"${objName}\" cx=\"[this get_X]\" cy=\"[this get_Y]\" r=\"5\" fill=\"yellow\" stroke=\"black\" stroke-width=\"3\" />\n"
 
 this Render_daughters strm "$dec  "
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Missile_PM_P_SVG_basic Render_post_JS {strm_name {dec ""}} {
 upvar $strm_name strm
 this inherited strm
 
 this Render_daughters_post_JS strm $dec
}
