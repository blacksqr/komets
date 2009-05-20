#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Container_PM_P_SVG_group PM_SVG
#___________________________________________________________________________________________________________________________________________
method Container_PM_P_SVG_group constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id FUI_Container_PM_P_SVG_group

   this set_root_for_daughters $objName
   this set_prim_handle        $objName
   this Add_MetaData PRIM_STYLE_CLASS [list $objName "ROOT FRAME" \
                                      ]
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_SVG_group Render {strm_name {dec {}}} {
 upvar $strm_name strm
 
 append strm $dec <g  [this Style_class] ">\n"
   this Render_daughters strm "$dec  "
 append strm $dec </g> "\n"
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_SVG_group  {} {
 set root    [this get_L_roots] 
 set methode "addgroup"

 if {[lsearch [gmlObject info classes $root] Container_PM_P_HTML_to_SVG] != -1} {
	$root add_pipo_element $objName $methode $cmd
 }
}
