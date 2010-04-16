#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Interleaving_PM_P_MenuHorizontal_HTML PM_HTML

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_MenuHorizontal_HTML constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id ScrollableMonospaceInterleaving_HTML
   this set_mark 0
    
	this set_html_style "" ${objName}_tabs
	this set_html_style "" ${objName}_selected
	this set_html_style "" ${objName}_header
	this set_html_style "" ${objName}_content
	
    set this(current_menu) {}
	
 eval "$objName configure $args"
}

#__________________________________________________
Methodes_set_LC Interleaving_PM_P_MenuHorizontal_HTML [P_L_methodes_set_CometInterleaving] {}  {}
Methodes_get_LC Interleaving_PM_P_MenuHorizontal_HTML [P_L_methodes_get_CometInterleaving] {}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_MenuHorizontal_HTML get_mark {}  {return $class(mark)}
method Interleaving_PM_P_MenuHorizontal_HTML set_mark {m} {set class(mark) $m}

#___________________________________________________________________________________________________________________________________________
Generate_accessors Interleaving_PM_P_MenuHorizontal_HTML current_menu

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_MenuHorizontal_HTML get_current_menu {} {
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
method Interleaving_PM_P_MenuHorizontal_HTML AJAX_set_current_menu {v} {
 #puts "$objName AJAX_set_current_menu $v"
 [this get_L_roots] set_AJAX_root NOTHING
 this set_current_menu $v
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_MenuHorizontal_HTML set_current_menu {v} {
 set this(current_menu) $v
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_MenuHorizontal_HTML Render_post_JS {strm_name {dec {}}} {
 upvar $strm_name strm

   append strm $dec "\$(\"#${objName}\").tabs();" "\n"

 this inherited strm $dec
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_MenuHorizontal_HTML get_tabs_css_style {strm_name {dec {}}} {
 upvar $strm_name strm
	append strm $dec ".${objName}_tabs.ui-state-default a {	background-color:transparent !important; }"
   append strm $dec ".${objName}_tabs.ui-state-default a, .${objName}_tabs li.ui-state-default{ \n"
   append strm $dec "[this get_html_style_in_text ${objName}_tabs]\n}\n"
   append strm $dec ".${objName}_tabs.ui-tabs-selected a, .${objName}_tabs li.ui-tabs-selected{ \n"
   append strm $dec "[this get_html_style_in_text ${objName}_selected]\n}\n"
   append strm $dec ".${objName}_tabs.ui-tabs-nav { \n"
   append strm $dec "[this get_html_style_in_text ${objName}_header]\n}\n"
	
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_MenuHorizontal_HTML get_ordered_LC_daughters {} {
 set L [list]
 foreach LC [CSS++ $objName "(#$objName > *->LC, #$objName > * > *->LC) ; (#[this get_LC] > *)"] {
   lappend L $LC
  }
 return $L
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_MenuHorizontal_HTML Render {strm_name {dec {}}} {

 upvar $strm_name strm

 append strm $dec "<input type=\"hidden\" id=\"${objName}__XXX__set_current_menu\" name=\"${objName}__XXX__set_current_menu\" value=\"[this get_current_menu]\" />\n"
 append strm $dec {<div } [this Style_class] ">\n"
   # Génération des rubriques
   append strm $dec " <style id=\"${objName}_tabs_style\" type=\"text/css\">\n"
   this get_tabs_css_style strm $dec
   append strm $dec "</style>\n"
   append strm $dec " <ul class=\"${objName}_tabs\">\n"
   foreach c [this get_ordered_LC_daughters] {
     append strm $dec "  " "<li class=\"${objName}_tabs\" style=\"padding-bottom:3px\">" "\n"
     append strm $dec "    " {<a href="#} categ_${objName}_$c {" style="background-color: transparent !important ; border : none !important">} [[$c get_LC] get_name] {</a>} "\n"
     append strm $dec "  " {</li>} "\n"
    }
   append strm $dec " </ul>\n"

   this Render_daughters strm "$dec    "

 append strm $dec {</div>} "\n"
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_MenuHorizontal_HTML add_html_style {L_var_val {id {}}} {
    this inherited $L_var_val $id
		set msg ""
		if {[lsearch [list ${objName}_tabs ${objName}_selected ${objName}_header ${objName}_content] $id] >= 0} {
		if {$id != "${objName}_content"} {
			set msg "\$(\"${objName}_tabs_style\").text("
			set tmp "" 
			this get_tabs_css_style tmp
			append  msg [this Encode_param_for_JS $tmp]
			append  msg ");" 
			
		} else {			
			set L ""
			if {[catch {set L [ [this get_LC] get_out_daughters]} {err}]} {puts stderr "Pas bon : $err" ; puts $objName ;}

			set pos 0
			foreach c $L {
				set id_style "categ_${objName}_$c"
				
				set    cmd  "\$(\"#${id_style}\").removeAttr(\"style\");\n"
				append cmd  "\$(\"#${id_style}\").css({" 
				
				foreach {var val} [this get_html_style $id] {
					append cmd \' $var \' " : \'" $val "\',"
				}
				if {[string index $cmd end] == ","} {set cmd [string range $cmd 0 end-1]}
				append cmd "});" "\n"
				
						
				
				append msg $cmd 
				incr pos
			}
		}
		
		this send_jquery_message Tabs_css_style $msg 
	}
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_MenuHorizontal_HTML set_html_style {lstyles {id {}}} {
    this inherited $lstyles $id
}



#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_MenuHorizontal_HTML Render_daughters {strm_name {dec {}}} {
 upvar $strm_name strm

 set L [this get_ordered_LC_daughters]
 
 set pos 0
 foreach c [this get_out_daughters] {
   append strm $dec {<div id="} categ_${objName}_[lindex $L $pos] {" style="} [this get_html_style_in_text ${objName}_content] {">} "\n"
     $c Render_all strm "$dec  "
   append strm $dec {</div>} "\n"
   incr pos
  }

}

method Interleaving_PM_P_MenuHorizontal_HTML Float_daughters {position} {
	this add_html_style [list "overflow" "auto"] ${objName}_content
	foreach daugther [this get_out_daughters] {
		$daugther Float $position
	}
}

method Interleaving_PM_P_MenuHorizontal_HTML Border {width style color {radius {}}  {target {}}} {	if {$target == "core" || $target == ""} {set id {}} else { set id ${objName}_$target ; }
	lassign $color r g b a 
	this add_html_style [list "border" "${width}px $style rgba([expr int(256 * $r)],[expr int(256 * $g)],[expr int(256 * $b)],$a) !important"] $id ; 
	if {$radius != {}} {
		this add_html_style [list "-moz-border-radius" "${radius}px"] $id ;
		this add_html_style [list "-webkit-border-radius" "${radius}px"] $id ;
		this add_html_style [list "border-radius" "${radius}px"] $id ;
	}
}