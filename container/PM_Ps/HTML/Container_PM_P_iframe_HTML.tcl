#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Container_PM_P_iframe_HTML PM_U_Container
#___________________________________________________________________________________________________________________________________________
method Container_PM_P_iframe_HTML constructor {name descr args} {
 this inherited $name $descr
   this set_nb_max_mothers   1
   this set_GDD_id GDD_Container_PM_P_iframe_HTML
   
   [[this get_cou] get_ptf] maj Ptf_HTML

   set this(width)  "100%"
   set this(height) "600px"
   
   set this(C_root) [CPool get_a_comet CometRoot]
     set this(C_root_PM) [CPool get_a_comet PhysicalHTML_root]
     $this(C_root)_LM_LP Add_PM $this(C_root_PM); $this(C_root)_LM_LP set_PM_active $this(C_root_PM)
	 $this(C_root_PM) set_html_compatibility_strict_mode 1
	 
   set this(cont_pipo) [CPool get_a_comet CometContainer]

   this set_L_nested_handle_LM    $this(cont_pipo)_LM_LP
   this set_L_nested_daughters_LM $this(C_root)_LM_LP
   
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_iframe_HTML dispose {} {
  $this(C_root) dispose
  this inherited
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors Container_PM_P_iframe_HTML [list width height C_root C_root_PM cont_pipo]

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_iframe_HTML Render {strm_name {dec {}}} {
 upvar $strm_name strm

 append strm $dec "<iframe [this Style_class] width=\"$this(width)\" height=\"$this(height)\" src=\"http://localhost?Comet_port=[$this(C_root_PM) get_server_port]\">\n"
   append strm $dec "  iframe are not supported by your browser ... Should display COMET $this(C_root_PM)"
 append strm $dec </iframe> "\n"
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_iframe_HTML Render_post_JS {strm_name {dec {}}} {}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_iframe_HTML Render_JS {strm_name mark {dec {}}} {}
