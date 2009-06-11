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
 eval "$objName configure $args"
 return $objName
}

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
