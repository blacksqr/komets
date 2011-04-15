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
method Container_PM_P_HTML_to_SVG Render {strm_name {dec {}}} {
 upvar $strm_name strm
 
 append strm $dec "<div [this Style_class]>\n"
    # append strm $dec "<script language=\"JavaScript\" type=\"text/javascript\" src=\"./Comets/models/HTML/jquery/svg/jquery.svg.min.js\"></script>\n"
	append strm $dec "<script language=\"JavaScript\" type=\"text/javascript\" src=\"./src_js/COMET_SVG_utilities.js\"></script>\n"
	# viewBox=\"0 0 640 480\" preserveAspectRatio=\"xMidYMid slice\" style=\"border: solid black; width: 100%; height: 100%;\"
	append strm $dec "<svg id=\"${objName}_canvas\" xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\" width=\"800px\" height=\"600px\" style=\"\">\n"
	append strm $dec "<g id=\"${objName}_canvas_g_root\" transform=\"\">\n"	
		this Render_daughters strm "$dec  "
	append strm $dec "</g>\n"
	append strm $dec "<rect id=\"${objName}_debug_rect\" width=\"5\" height=\"5\"/>\n"
	append strm $dec "</svg>\n"
 append strm $dec "</div>\n"
 
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HTML_to_SVG Render_post_JS {strm_name {dec {}}} {
 upvar $strm_name strm
 
 this Render_daughters_post_JS strm $dec
}

#_________________________________________________________________________________________________________
method Container_PM_P_HTML_to_SVG get_HTML_to_SVG_bridge {} {
 return $objName
}

#_________________________________________________________________________________________________________
method Container_PM_P_HTML_to_SVG get_pipo_svg {} {return ${objName}_pipo}

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
 
 # if {![string equal $class(last_marker) $marker]} {
   # puts "  class(last_marker) was equal to $class(last_marker)"
   # set class(last_marker) $marker
   # append strm "function convert_coord_from_page_to_node(x,y,node) {  						\n\
				# var coord = new Array();													\n\
				# coord\['x'\] = x;                         									\n\
				# coord\['y'\] = y;                      										\n\
				# var current_node = node;	                      							\n\
																							# \n\
				# while(current_node.nodeName != 'HTML' && current_node.nodeName != 'svg') {  \n\
					# current_node = current_node.parentNode;                      			\n\
				# }																			\n\
					 																		# \n\
				# if(current_node.nodeName == 'svg') {										\n\
					# coord\['x'\] -= current_node.offsetLeft;								\n\
					# coord\['y'\] -= current_node.offsetTop;									\n\
					# var ma_matrice = current_node.createSVGMatrix();						\n\
						# ma_matrice.e = coord\['x'\];										\n\
						# ma_matrice.f = coord\['y'\];										\n\
					# var matriceres = node.getCTM().inverse().multiply(ma_matrice);			\n\
																							# \n\
					# coord\['x'\] = matriceres.e;											\n\
					# coord\['y'\] = matriceres.f;											\n\
				# }																			\n\
																							# \n\
				# return coord;																\n\
				# } 																			\n\
																							# \n\
				# function set_svg_origine(id,x,y) {											\n\
				  # var node = document.getElementById(id);									\n\
				  # if(node != null) {														\n\
				    # var nCTM = node.parentNode.getCTM().inverse().multiply(node.getCTM()); \n\
				    # nCTM.e = x;																\n\
				    # nCTM.f = y;																\n\
				    # node.setAttribute('transform', 'matrix('+nCTM.a+','+nCTM.b+','+nCTM.c+','+nCTM.d+','+nCTM.e+','+nCTM.f+')'); \n\
				   # }																		\n\
				 # }																			\n\
				# "
  # }
  
 this Render_daughters_JS strm $marker $dec
}
