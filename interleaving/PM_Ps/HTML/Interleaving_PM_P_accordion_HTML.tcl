#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Interleaving_PM_P_accordion_HTML PM_HTML

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_accordion_HTML constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id FUI_Interleaving_HTML_accordion
   this set_mark 0
    
	this set_html_style    "" ${objName}_tabs
	this set_html_style    "" ${objName}_selected
    set this(current_menu) ""
    
 eval "$objName configure $args"
}

#__________________________________________________
Methodes_set_LC Interleaving_PM_P_accordion_HTML [P_L_methodes_set_CometInterleaving] {}  {}
Methodes_get_LC Interleaving_PM_P_accordion_HTML [P_L_methodes_get_CometInterleaving] {}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_accordion_HTML get_mark {}  {return $class(mark)}
method Interleaving_PM_P_accordion_HTML set_mark {m} {set class(mark) $m}

#___________________________________________________________________________________________________________________________________________
Generate_accessors Interleaving_PM_P_accordion_HTML current_menu

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_accordion_HTML get_current_menu {} {
 if {[regexp {^categ_(.*)$} $this(current_menu) reco elem]} {
   set L_d [[this get_nesting_CORE_LC] get_out_daughters]
   if {[lsearch $L_d $elem] == -1} {
     set this(current_menu) ""
    }
  }
 if {$this(current_menu) == ""} {
   set L [[this get_nesting_CORE_LC] get_out_daughters]
   set this(current_menu) categ_${objName}_[lindex $L 0]
  }
 return $this(current_menu)
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_accordion_HTML AJAX_set_current_menu {v} {
 #puts "$objName AJAX_set_current_menu $v"
 [this get_L_roots] set_AJAX_root NOTHING
 this set_current_menu $v
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_accordion_HTML set_current_menu {v} {
 set this(current_menu) $v
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_accordion_HTML Render_post_JS {strm_name {dec {}}} {
 upvar $strm_name strm

   append strm $dec "\$(\"#${objName}\").accordion();" "\n"

 this inherited strm $dec
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_accordion_HTML get_tabs_css_style {strm_name {dec {}}} {
 upvar $strm_name strm
   append strm $dec ".${objName}_tabs.ui-state-default { \n"
   append strm $dec "[this get_html_style_in_text ${objName}_tabs]\n}\n"
   append strm $dec ".${objName}_tabs.ui-tabs-selected { \n"
   append strm $dec "[this get_html_style_in_text ${objName}_selected]\n}\n"
   append strm $dec ".${objName}_tabs.ui-tabs-nav{ \n"
   append strm $dec "[this get_html_style_in_text ${objName}_header]\n}\n"
	
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_accordion_HTML get_ordered_LC_daughters {} {
 set L [list]
 foreach LC [CSS++ $objName "(#$objName > *->LC, #$objName > * > *->LC) ; (#[this get_LC] > *)"] {
   lappend L $LC
  }
 return $L
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_accordion_HTML Render {strm_name {dec {}}} {
 upvar $strm_name strm

 append strm $dec " <style id=\"${objName}_tabs_style\" type=\"text/css\">\n"
   this get_tabs_css_style strm $dec
 append strm $dec "</style>\n"
 append strm $dec {<div } [this Style_class] ">\n"
   foreach c [this get_ordered_LC_daughters] {
     set PM [CSS++ $objName "#$objName $c $c"]
     append strm $dec "  <h3 class=\"${objName}_tabs\"><a href=\"#\">[$c get_name]</a></h3>\n"
     append strm $dec "  <div class=\"${objName}_content ${objName}_$c\">\n"
	   $PM Render strm "$dec  "
	 append strm $dec "  </div>\n"
    }
 append strm $dec {</div>} "\n"
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_accordion_HTML add_html_style {L_var_val {id {}}} {
    this inherited $L_var_val $id
	if {[lsearch [list ${objName}_tabs ${objName}_selected ${objName}_header] $id] >= 0} {
		set msg "\$(\"#${objName}_tabs_style\").text("
		set tmp "" 
		this get_tabs_css_style tmp
		append  msg [this Encode_param_for_JS $tmp]
		append  msg ");" 
		#puts "$objName send_jquery_message Tabs_css_style $msg"
		this send_jquery_message Tabs_css_style $msg 
	 }
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_accordion_HTML set_html_style {lstyles {id {}}} {
    this inherited $lstyles $id
	if {[lsearch [list ${objName}_tabs ${objName}_selected ${objName}_header] $id] >= 0} {
		set msg "\$(\"${objName}_tabs_style\").text("
		set tmp "" 
		this get_tabs_css_style tmp
		append  msg [this Encode_param_for_JS $tmp]
		append  msg ");" 
		this send_jquery_message Tabs_css_style $msg 
	}
}

