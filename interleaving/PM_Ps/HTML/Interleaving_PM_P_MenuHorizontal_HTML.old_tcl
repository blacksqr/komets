#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Interleaving_PM_P_MenuHorizontal_HTML PM_HTML

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_MenuHorizontal_HTML constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id ScrollableMonospaceInterleaving_HTML
   this set_mark 0
   set this(current_menu) {}
 eval "$objName configure $args"
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_MenuHorizontal_HTML get_mark {}  {return $class(mark)}
method Interleaving_PM_P_MenuHorizontal_HTML set_mark {m} {set class(mark) $m}

#___________________________________________________________________________________________________________________________________________
Generate_accessors Interleaving_PM_P_MenuHorizontal_HTML current_menu

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_MenuHorizontal_HTML get_current_menu {} {
 set c [string range $this(current_menu) 6 end]
 set L [[this get_nesting_CORE_LC] get_out_daughters]
 if {[lsearch $L == -1} {
   set this(current_menu) categ_[lindex $L 0]
  }
 return $this(current_menu)
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_MenuHorizontal_HTML get_current_menu {} {
 if {[regexp {^categ_(.*)$} $this(current_menu) reco elem]} {
   set L_d [[this get_nesting_CORE_LC] get_out_daughters]
   if {[lsearch $L_d $elem] == -1} {
     set this(current_menu) ""
    }
  }
 if {[string equal $this(current_menu) {}]} {
   set L [[this get_nesting_CORE_LC] get_out_daughters]
   set this(current_menu) categ_[lindex $L 0]
  }
 return $this(current_menu)
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_MenuHorizontal_HTML AJAX_set_current_menu {v} {
 puts "$objName AJAX_set_current_menu $v"
 [this get_L_roots] set_AJAX_root NOTHING
 this set_current_menu $v
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_MenuHorizontal_HTML set_current_menu {v} {
 set this(current_menu) $v
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_MenuHorizontal_HTML get_AJAX_POST_tab_name {} {return ${objName}_AJAX_tab}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_MenuHorizontal_HTML Render_JS {strm_name mark {dec {}}} {
 upvar $strm_name strm
 if {$mark != [this get_mark]} {
   append strm $dec {function go_to_categ(b, c) } "\{\n"
   append strm $dec {  document.getElementById("Categ_manager_" + b).className=c;} "\n"
   append strm $dec {  document.getElementById(b + "__XXX__set_current_menu").value = c;} "\n"
     set AJAX_tab [this get_AJAX_POST_tab_name]
     append strm $dec "  ${AJAX_tab} = new Array()\;"
     append strm $dec {  } $AJAX_tab {["Comet_port"] = } [[this get_L_roots] get_server_port] "\;\n"
     append strm $dec {  } $AJAX_tab {["} ${objName}__XXX__AJAX_set_current_menu {"]  = c} "\;\n"
     append strm $dec {  Ajax.get("set", "#", "} $objName {", } $AJAX_tab {, false)} "\;\n"
   append strm $dec " \}\;\n"
  }
 this Render_daughters_JS strm $mark $dec
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_MenuHorizontal_HTML Render {strm_name {dec {}}} {
 upvar $strm_name strm

 append strm $dec {<style media="all" type="text/css"><!--} "\n"
 append strm $dec "  ul#${objName}_tab_menu      {font: bold 11px verdana, arial, sans-serif; list-style-type: none; padding-bottom: 24px; border-bottom: 1px solid #6c6; margin: 0;}" "\n"
 append strm $dec "  ul#${objName}_tab_menu > li {float: left; height: 21px; background-color: #cfc; margin: 2px 2px 0 2px; border: 1px solid #6c6;}" "\n"
 append strm $dec "  ul#${objName}_tab_menu > li.active {border-bottom: 1px solid #fff; background-color: #fff;}" "\n"
 append strm $dec "  ul#${objName}_tab_menu a {float: left; display: block; color: #666; text-decoration: none; padding: 4px;}" "\n"
 append strm $dec "  ul#${objName}_tab_menu a:over {color: #fff;}" "\n"
 append strm $dec {--></style>} "\n"

 append strm $dec "<input type=\"hidden\" id=\"${objName}__XXX__set_current_menu\" name=\"${objName}__XXX__set_current_menu\" value=\"[this get_current_menu]\" />\n"
 append strm $dec {<div } [this Style_class] ">\n"
  append strm $dec { <div class="menu_heading">} "\n"
   # Génération des rubriques
   append strm $dec " <ul id=\"${objName}_tab_menu\">\n"
   foreach c [[this get_nesting_CORE_LC] get_out_daughters] {
     append strm $dec "  " {<li class="} menu_$c {">} "\n"
     append strm $dec "    " {<a href="javascript:go_to_categ('} "$objName', 'categ_$c" {')">} [$c get_name] {</a>} "\n"
     append strm $dec "  " {</li>} "\n"
    }
   append strm $dec " </ul>\n"
  append strm $dec { </div>} "\n"
  append strm $dec " " {<div id="} Categ_manager_$objName {" class="} [this get_current_menu] {">} "\n"
   this Render_daughters strm "$dec    "
  append strm $dec " " {</div>} "\n"
 append strm $dec {</div>} "\n"
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_MenuHorizontal_HTML maj_interleaved_daughters {} {}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_MenuHorizontal_HTML Render_daughters {strm_name {dec {}}} {
 upvar $strm_name strm

 set L [[this get_nesting_CORE_LC] get_out_daughters]

 append strm $dec {<style media="all" type="text/css">} "\n"
 append strm $dec {<!--} "\n"
   #append strm $dec ".$objName > .menu_body > * \{display : none\}\n"
   append strm $dec .just_here_for_generation
   set pos 0
   foreach c $L {
     set L2 [lreplace $L $pos $pos]
     foreach c2 $L2 {
       append strm ", .categ_$c .categ_$c2"
      }
     incr pos
     append strm ", .menu_body .$c"
    }
   append strm " \{display:none;\}\n"
 append strm $dec {-->} "\n"
 append strm $dec {</style>} "\n"

 set pos 0
 foreach c [this get_daughters] {
   append strm $dec {<div class="} categ_[lindex $L $pos] {">} "\n"
     $c Render_all strm "$dec  "
   append strm $dec {</div>} "\n"
   incr pos
  }

}
