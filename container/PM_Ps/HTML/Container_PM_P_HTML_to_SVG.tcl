#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Container_PM_P_HTML_to_SVG PM_HTML
#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HTML_to_SVG constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Container_FUI_bridge_HTML_to_SVG_frame
   [[this get_cou] get_ptf] maj Ptf_HTML_to_SVG

   this set_root_for_daughters ${objName}_root_group
   this set_prim_handle        $objName
   this Add_MetaData PRIM_STYLE_CLASS [list $objName "ROOT FRAME" \
                                      ]
   set this(canevas_width) ""
   set this(canevas_height) 400  
   set class(last_marker) "100%"
	
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HTML_to_SVG get_last_marker {} {return $class(last_marker)}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HTML_to_SVG Render {strm_name {dec {}}} {
 upvar $strm_name strm
 
 append strm $dec "<div [this Style_class] oncontextmenu=\"return false;\">\n"
    # append strm $dec "<script language=\"JavaScript\" type=\"text/javascript\" src=\"./Comets/models/HTML/jquery/svg/jquery.svg.min.js\"></script>\n"
	append strm $dec "<script language=\"JavaScript\" type=\"text/javascript\" src=\"./src_js/geometry2Dbasics.js\"></script>\n"
	append strm $dec "<script language=\"JavaScript\" type=\"text/javascript\" src=\"./src_js/COMET_SVG_utilities.js\"></script>\n"
	# viewBox=\"0 0 640 480\" preserveAspectRatio=\"xMidYMid slice\" style=\"border: solid black; width: 100%; height: 100%;\"
	append strm $dec "<svg id=\"${objName}_canvas\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" version=\"1.1\" width=\"800px\" height=\"600px\" style=\"width: 100%;\">\n"
	append strm $dec "<g id=\"${objName}_canvas_g_root\" transform=\"\">\n"	
		this Render_daughters strm "$dec  "
	append strm $dec "</g>\n"
	append strm $dec "</svg>\n"
 append strm $dec "</div>\n"
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HTML_to_SVG Render_post_JS {strm_name {dec {}}} {
 upvar $strm_name strm
 
 append strm "init_draggable();\n"
 this Render_daughters_post_JS strm $dec
}

#_________________________________________________________________________________________________________
method Container_PM_P_HTML_to_SVG get_HTML_to_SVG_bridge {} {
 return $objName
}

#_________________________________________________________________________________________________________
method Container_PM_P_HTML_to_SVG get_svg_canvas_id {} {return ${objName}_canvas}

#_________________________________________________________________________________________________________
method Container_PM_P_HTML_to_SVG Add_JS {e} [gmlObject info body PM_SVG Add_JS]

# _________________________________________________________________________________________________________
method Container_PM_P_HTML_to_SVG set_canevas_width {v} {
 set this(canevas_width) $v
 set cmd "document.getElementById('${objName}_canvas').setAttribute('width', '${v}');"
 
 this send_jquery_message "set_canevas_width" $cmd 
}

# _________________________________________________________________________________________________________
method Container_PM_P_HTML_to_SVG get_canevas_width {} {return $this(canevas_width)}

# _________________________________________________________________________________________________________
method Container_PM_P_HTML_to_SVG set_canevas_height {v} {
 set this(canevas_height) $v
 set cmd "document.getElementById('${objName}_canvas').setAttribute('width', '${v}');"
 
 this send_jquery_message "set_canevas_height" $cmd 
}

# _________________________________________________________________________________________________________
method Container_PM_P_HTML_to_SVG get_canevas_height {} {return $this(canevas_height)}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HTML_to_SVG Render_JS {strm_name marker {dec {}}} {
 upvar $strm_name strm
 
 this Render_daughters_JS strm $marker $dec
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HTML_to_SVG Draggable {} {
	this inherited ${objName}_canvas_g_root [list ${objName}_canvas_g_root]
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HTML_to_SVG RotoZoomable {} {
	this inherited ${objName}_canvas_g_root [list ${objName}_canvas_g_root]
}
