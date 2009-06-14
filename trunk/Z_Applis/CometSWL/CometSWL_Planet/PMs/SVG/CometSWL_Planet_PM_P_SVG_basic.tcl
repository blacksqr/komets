#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometSWL_Planet_PM_P_SVG_basic PM_SVG

#___________________________________________________________________________________________________________________________________________
method CometSWL_Planet_PM_P_SVG_basic constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id FUI_CometSWL_Planet_PM_P_SVG_basic
 
 this Add_MetaData PRIM_STYLE_CLASS [list $objName "PLANET PARAM RESULT IN OUT"]
 
 set this(svg_x) ""
 set this(svg_y) ""
 set this(mode) edition
 
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometSWL_Planet_PM_P_SVG_basic [P_L_methodes_set_CometSWL_Planet] {} {}
Methodes_get_LC CometSWL_Planet_PM_P_SVG_basic [P_L_methodes_get_CometSWL_Planet] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters CometSWL_Planet_PM_P_SVG_basic [P_L_methodes_set_CometSWL_Planet_COMET_RE]

#___________________________________________________________________________________________________________________________________________
Generate_accessors CometSWL_Ship_PM_P_B207_basic [list mode]

#___________________________________________________________________________________________________________________________________________
Inject_code CometSWL_Planet_PM_P_SVG_basic prim_set_X \
  "set this(svg_x) \$v" \
  ""

#___________________________________________________________________________________________________________________________________________
Inject_code CometSWL_Planet_PM_P_SVG_basic prim_set_Y \
  "set this(svg_y) \$v" \
  ""


#___________________________________________________________________________________________________________________________________________
method CometSWL_Planet_PM_P_SVG_basic SVG_Origine {coords} {
 set x [lindex $coords 0]
 set y [lindex $coords 1]
 
 this prim_set_X $x
 this prim_set_Y $y
 
 this inherited $coords
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Planet_PM_P_SVG_basic Update_datas {} {}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Planet_PM_P_SVG_basic set_X       {v}  {
 if {$v != $this(svg_x)} {
   this send_jquery_message "SVG_Origine" "set_svg_origine('${objName}', $v, [this get_Y]);" 
  }
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Planet_PM_P_SVG_basic set_Y       {v}  {
 if {$v != $this(svg_y)} {
   this send_jquery_message "SVG_Origine" "set_svg_origine('${objName}', [this get_X], $v);"
  }
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Planet_PM_P_SVG_basic set_R       {v}  { 
 set cmd    "\$('#${objName}_resize').each(function(i) {this.setAttribute('r', $v);});\n"
 append cmd "\$('#${objName}_drag').each(function(i) {this.setAttribute('r', [expr 0.8*$v]);});\n"
 
 this send_jquery_message "set_R" $cmd 
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Planet_PM_P_SVG_basic set_density {v}  {}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Planet_PM_P_SVG_basic Render {strm_name {dec {}}} {
 upvar $strm_name strm
 
  append strm "<g id=\"${objName}\" transform=\"translate([this get_X],[this get_Y])\">\n"
    append strm "<circle id=\"${objName}_resize\" cx=\"0\" cy=\"0\" r=\"[this get_R]\" fill=\"lime\" stroke=\"black\" stroke-width=\"2\" />\n"
    append strm "<circle id=\"${objName}_drag\" cx=\"0\" cy=\"0\" r=\"[expr 0.8*[this get_R]]\" fill=\"red\" />\n"
  append strm "</g>\n"

 this Render_daughters strm "$dec  "
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Planet_PM_P_SVG_basic Render_post_JS {strm_name {dec ""}} {
 upvar $strm_name strm
 this inherited strm
 if {[this get_mode] == "edition"} {
   append strm [this Draggable ${objName} ${objName}_drag 0]
   append strm "var lag = 0;																				\n\
			\$('#${objName}_resize').draggable({start:function(event, ui){								\n\
				var cx = this.getAttribute('cx');														\n\
				var cy = this.getAttribute('cy');														\n\
				var coord = convert_coord_from_page_to_node(event.pageX,event.pageY,this.parentNode); 	\n\
				var nbre1 = (cx - coord\['x'\]);														\n\
				var nbre2 = (cy - coord\['y'\]);														\n\
				var d_middle_arrow = (Math.sqrt((nbre1*nbre1) + (nbre2*nbre2)));						\n\
				lag = (this.getAttribute('r') - d_middle_arrow) / this.getAttribute('r');				\n\
			},drag:function(event, ui){																	\n\
				var cx = \$(this).get(0).getAttribute('cx');											\n\
				var cy = \$(this).get(0).getAttribute('cy');											\n\
				var coord = convert_coord_from_page_to_node(event.pageX,event.pageY,this.parentNode); 	\n\
				var nbre1 = (cx - coord\['x'\]);														\n\
				var nbre2 = (cy - coord\['y'\]);														\n\
				var newR = (Math.sqrt((nbre1*nbre1) + (nbre2*nbre2)));									\n\
				newR += (newR * lag);																	\n\
				\$(this).get(0).setAttribute('r',newR);													\n\
				\$('#${objName}_drag').get(0).setAttribute('r',(newR*0.8));								\n\
			},stop : function(event, ui){																\n\
				addOutput_proc_val('${objName}__XXX__prim_set_R', this.getAttribute('r'), true); 		\n\
			}});"
  }			
 this Render_daughters_post_JS strm $dec
}
