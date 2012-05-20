#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit PM_SVG PM_HTML
#___________________________________________________________________________________________________________________________________________
method PM_SVG constructor {name descr args} {
 this inherited $name $descr
 [[this get_cou] get_ptf] maj Ptf_SVG
 set this(drag_function)  ""
 set this(L_draggable)    [list ]
 set this(L_rotozoomable) [list ]
}

#_________________________________________________________________________________________________________
Generate_accessors PM_SVG [list drag_function]

#_________________________________________________________________________________________________________
method PM_SVG set_drag_function {fct} {
 set this(drag_function) $fct
 this Draggable
}

#_________________________________________________________________________________________________________
method PM_SVG get_HTML_to_SVG_bridge {} {
 set m [this get_mothers]
 if {$m != ""} {
  return [$m get_HTML_to_SVG_bridge]
 } else {return ""
		}
}

#_________________________________________________________________________________________________________
method PM_SVG Add_JS {e} {
 set cmd ""
 set bridge [this get_HTML_to_SVG_bridge]
 if {$bridge != ""} { 
     $e Render_JS      cmd [$bridge get_last_marker]
 
     set pipo_svg [$bridge get_pipo_svg]
	 set strm ""; $e Render_all strm
     set strm    [$e Encode_param_for_JS $strm]
     append cmd  "var svg = \$('#$pipo_svg').svg('get');\n"
     append cmd  "svg.add($strm);\n" 
	 
	 set pos       [lsearch [$objName get_daughters] $e]
	 set tailletot [llength [$objName get_daughters]]
	 set e_root    [$e get_prim_handle]
	 append cmd    "var ref = \$(\"#$e_root\").get(0);\n"
	 append cmd    "ref.parentNode.removeChild(ref);\n"

	 if { $tailletot-1 > $pos} {
		set objAfter [lindex [$objName get_daughters] [expr $pos+1]]
		set objAfter [$objAfter get_prim_handle]
		set root_for_daughters [this get_root_for_daughters]
		append cmd "\$('#$root_for_daughters').get(0).insertBefore(ref, \$('#$objAfter').get(0));\n"
	  } else {set root_for_daughters [this get_root_for_daughters]
			  append cmd "\$('#$root_for_daughters').get(0).appendChild(ref);\n"
			 }

   
    $e Render_post_JS cmd 
  }
 return $cmd
}

Trace PM_SVG Add_JS
#___________________________________________________________________________________________________________________________________________
method PM_SVG Sub_JS {e} {
 set cmd "\$('#$e').remove();\n"
 return $cmd
}

#___________________________________________________________________________________________________________________________________________
method PM_SVG SVG_Origine {coords} {
}

#___________________________________________________________________________________________________________________________________________
Manage_CallbackList PM_SVG SVG_Origine end

#___________________________________________________________________________________________________________________________________________
method PM_SVG Generate_windows_descr {id x y width height border_width str_svg_name str_js_name} {
	upvar $str_svg_name str_svg
	upvar $str_js_name  str_js
	
	append str_svg "<g id=\"${id}\">"
	append str_svg   "<clipPath id=\"Clip_$id\"><rect id=\"Clip_rect_$id\" x=\"0\" y=\"0\" width=\"$width\" height=\"$height\" /></clipPath>"
	append str_svg   "<g id=\"BG_root_$id\">"
	append str_svg     "<rect id=\"BG_border_$id\" fill=\"green\" x=\"-$border_width\" y=\"-$border_width\" rx=\"$border_width\" ry=\"$border_width\" width=\"[expr $width + 2*$border_width]\" height=\"[expr $height + 2*$border_width]\" />"
	append str_svg     "<rect id=\"BG_rect_$id\"   fill=\"yellow\" x=\"0\" y=\"0\" width=\"$width\" height=\"$height\" />"
	append str_svg   "</g>"
	append str_svg   "<g id=\"root_for_daughters_${id}\" clip-path=\"url(#Clip_${id})\"></g>"
	append str_svg "</g>"
	
	append str_js  "Draggable('${id}', \['BG_border_${id}'\], null, null, null);"
	append str_js  "Register_node_id_SVG_zoom_onwheel('${id}');"
	
	return [dict create id $id clipPath Clip_$id Clip_rect Clip_rect_$id BG_border BG_border_$id BG_rect BG_rect_$id root_for_daughters root_for_daughters_${id}]
}

#___________________________________________________________________________________________________________________________________________
method PM_SVG Draggable {SVG_group L_drag_element {fct_start null} {fct_drag null} {fct_stop null}} {
 if {$L_drag_element == $this(L_draggable)} {return ""}
 set this(L_draggable) $L_drag_element
 
 set cmd "Draggable('${SVG_group}', \['[join $L_drag_element {, }]'\], ${fct_start}, ${fct_drag}, ${fct_stop});\n"
 this set_after_render_js  Draggable $cmd
 this send_jquery_message "Draggable$objName" $cmd 
  
 return $cmd
}

#___________________________________________________________________________________________________________________________________________
method PM_SVG RotoZoomable {SVG_group L_rotozoomable_elements} {
 if {$L_rotozoomable_elements == $this(L_rotozoomable)} {return ""}
 set this(L_rotozoomable) $L_rotozoomable_elements
 
 set cmd "RotoZoomable('${SVG_group}', \['[join $L_rotozoomable_elements {, }]'\], null, null, null, null, null, null);\n"
 this set_after_render_js  RotoZoomable $cmd
 this send_jquery_message "RotoZoomable$objName" $cmd 
  
 return $cmd
}
