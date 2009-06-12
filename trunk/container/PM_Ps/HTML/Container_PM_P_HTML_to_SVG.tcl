#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Container_PM_P_HTML_to_SVG PM_HTML
#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HTML_to_SVG constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id FUI_Container_PM_P_HTML_to_SVG
   [[this get_cou] get_ptf] maj Ptf_HTML_to_SVG

   this set_root_for_daughters ${objName}_root_group
   this set_prim_handle        $objName
   this Add_MetaData PRIM_STYLE_CLASS [list $objName "ROOT FRAME" \
                                      ]
									  
	set class(last_marker) ""
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HTML_to_SVG get_last_marker {} {return $class(last_marker)}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HTML_to_SVG Render {strm_name {dec {}}} {
 upvar $strm_name strm
 
 append strm $dec "<div [this Style_class]>\n"
	append strm $dec "<div style=\"display:none\" id=\"${objName}_pipo\">\n"
	append strm $dec "</div>\n"
 append strm $dec "</div>\n"
 
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HTML_to_SVG Render_post_JS {strm_name {dec {}}} {
 upvar $strm_name strm

 append strm $dec "\$('#$objName').svg();\n"
 append strm $dec "\$('#${objName}_pipo').svg();\n"
 
 append strm $dec "var svg = \$('#$objName').svg('get');\n"
 set render_daughters "<g id=\"${objName}_root_group\">"
   this Render_daughters render_daughters
 append render_daughters "</g>"
 append strm $dec "svg.add([this Encode_param_for_JS $render_daughters]);\n"
 append strm $dec "svg.configure({height: '400'}, true);\n"
 
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

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HTML_to_SVG Render_JS {strm_name marker {dec {}}} {
 upvar $strm_name strm
 
 if {![string equal $class(last_marker) $marker]} {
   puts "  class(last_marker) was equal to $class(last_marker)"
   set class(last_marker) $marker
   append strm "function convert_coord_from_page_to_node(x,y,node) {  						\n\
				var coord = new Array();													\n\
				coord\['x'\] = x;                         									\n\
				coord\['y'\] = y;                      										\n\
				var current_node = node;	                      							\n\
																							\n\
				while(current_node.nodeName != 'HTML' && current_node.nodeName != 'svg') {  \n\
					current_node = current_node.parentNode;                      			\n\
				}																			\n\
					 																		\n\
				if(current_node.nodeName == 'svg') {										\n\
					coord\['x'\] -= current_node.offsetLeft;								\n\
					coord\['y'\] -= current_node.offsetTop;									\n\
					var ma_matrice = current_node.createSVGMatrix();						\n\
						ma_matrice.e = coord\['x'\];										\n\
						ma_matrice.f = coord\['y'\];										\n\
					var matriceres = node.getCTM().inverse().mMultiply(ma_matrice);			\n\
																							\n\
					coord\['x'\] = matriceres.e;											\n\
					coord\['y'\] = matriceres.f;											\n\
				}																			\n\
																							\n\
				return coord;																\n\
				} 																			\n\
																							\n\
				function set_svg_origine(id,x,y) {											\n\
				  var node = document.getElementById(id);									\n\
				  if(node != null) {														\n\
				    var dCTM = node.getCTM();											\n\
				    dCTM.e = x;															\n\
				    dCTM.f = y;															\n\
				    node.setAttribute('transform', 'matrix('+dCTM.a+','+dCTM.b+','+dCTM.c+','+dCTM.d+','+dCTM.e+','+dCTM.f+')'); \n\
				   }																		\n\
				 }																			\n\
				"
  }
  
 this Render_daughters_JS strm $marker $dec
}
