#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Video_PM_P_HTML PM_HTML
#___________________________________________________________________________________________________________________________________________
method Video_PM_P_HTML constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Container_CUI_frame_HTML

   this set_root_for_daughters $objName
   this set_prim_handle        $objName
   this Add_MetaData PRIM_STYLE_CLASS [list $objName "ROOT FRAME" \
                                      ]
									  
	set this(url) ""
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Video_PM_P_HTML [P_L_methodes_set_Video] {} {}
Methodes_get_LC Video_PM_P_HTML [P_L_methodes_get_Video] {$this(FC)}

#_________________________________________________________________________________________________________________________________
Generate_accessors Video_PM_P_HTML [list url]

#___________________________________________________________________________________________________________________________________________
method Video_PM_P_HTML set_url {v} {
 set root    [this get_L_roots] 
 set methode "url"
 set this(url) $v

 set param [this Encode_param_for_JS $v]
 set cmd   "\$('#${objName}').attr(\"src\",$param);"

 if {[lsearch [gmlObject info classes $root] PhysicalHTML_root] != -1} {
	$root Concat_update $objName $methode $cmd
 }
}
#___________________________________________________________________________________________________________________________________________
method Video_PM_P_HTML Render {strm_name {dec {}}} {
 upvar $strm_name strm
 
 append strm $dec "<embed src=\"[this get_url]\" [this Style_class] pluginspage=\"http://www.macromedia.com/shockwave/download/\" type=\"application/x-shockwave-flash\" quality=\"high\" width=\"300\" height=\"300\" />" "\n"
 this Render_daughters strm "$dec  "
}
