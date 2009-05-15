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
method Container_PM_P_HTML Render {strm_name {dec {}}} {
 upvar $strm_name strm
 
 append strm $dec <svg  [this Style_class] " xmlns=\"http://www.w3.org/2000/svg\">\n"
   this Render_daughters strm "$dec  "
 append strm $dec </svg> "\n"
}



