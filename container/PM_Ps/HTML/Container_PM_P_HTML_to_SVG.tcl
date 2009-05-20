#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Container_PM_P_HTML_to_SVG PM_HTML
#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HTML_to_SVG constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id FUI_Container_PM_P_HTML_to_SVG
   [[this get_cou] get_ptf] maj Ptf_HTML_to_SVG

   this set_root_for_daughters $objName
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
	this Render_daughters strm "$dec  "	 
	append strm $dec "<div style=\"display:none\" id=\"${objName}_pipo\">\n"
	append strm $dec "</div>\n"
 append strm $dec "</div>\n"
 
 this cont_svg
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HTML_to_SVG cont_svg {} {
 set root    [this get_L_roots] 
 set methode "contsvg"
 set cmd     "\$('#$objName').svg();"
 append cmd  "\$('#${objName}_pipo').svg();"

 if {[lsearch [gmlObject info classes $root] PhysicalHTML_root] != -1} {
	$root Concat_update $objName $methode $cmd
 }
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HTML_to_SVG add_pipo_element {strsvg} {
 set root    [this get_L_roots] 
 set methode "addpipoelement"
 set strm    {}
 set strm    [$strsvg Encode_param_for_JS $strm]
 set cmd     "var svg = $('#${objName}_pipo').svg('get');"
 append cmd  "svg.add($strm);"

 if {[lsearch [gmlObject info classes $root] PhysicalHTML_root] != -1} {
	$root Concat_update $objName $methode $cmd
 }
}