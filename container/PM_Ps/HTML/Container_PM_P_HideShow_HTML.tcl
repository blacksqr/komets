#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Container_PM_P_HideShow_HTML PM_HTML
#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HideShow_HTML constructor {name descr args} {
 this inherited $name $descr
 set this(header_place) "top"
 set this(title)        "&nbsp;"
 set this(html_title_style)  "" 
 set this(drag)         0
   this set_GDD_id Container_Maskable_HTML
 eval "$objName configure $args"
 return $objName
}
#___________________________________________________________________________________________________________________________________________
Generate_accessors Container_PM_P_HideShow_HTML [list header_place title drag]

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HideShow_HTML set_header_place {hp} {
 set this(header_place) $hp
 
 set root         [this get_L_roots]
 set this(marker) [clock clicks]
 set cmd          ""
 set methode      "header_place"
 
 append cmd "\$(function() {" "\n" 
 append cmd "     \$(\"#${objName}_icon\").remove();" "\n"
 append cmd "     \$(\"#${objName}\").removeAttr(\"style\");" "\n"
 append cmd "     \$(\"#${objName}_header\").removeAttr(\"style\").removeAttr(\"class\");" "\n"
 append cmd "     \$(\"#${objName}_title\").removeAttr(\"style\").removeAttr(\"class\");" "\n"
 append cmd "     \$(\"#${objName}_content\").removeAttr(\"style\").removeAttr(\"class\");" "\n"
 append cmd "     \$(\"#${objName}_header\").insertBefore(\"#${objName}_content\");"
 append cmd "});" "\n"
 
 this Render_JS cmd $this(marker)
 
 if {[lsearch [gmlObject info classes $root] PhysicalHTML_root] != -1} {
	$root Concat_update $objName $methode $cmd
 }
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HideShow_HTML set_LM {LM} {
 set rep [this inherited $LM]
 set this(title) [[this get_LC] get_name]
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HideShow_HTML Resize {x y} {}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HideShow_HTML set_title {v} {
 set this(title) $v
 
 set root         [this get_L_roots]
 set this(marker) [clock clicks]
 set methode      "title"
 set title [this Encode_param_for_JS [this get_title]]
 set cmd          "\$(\"#${objName}_title\").html($title);"
 
 if {[lsearch [gmlObject info classes $root] PhysicalHTML_root] != -1} {
	$root Concat_update $objName $methode $cmd
 }
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HideShow_HTML set_drag {v} {
 set this(drag) $v
 
 set root         [this get_L_roots]
 set methode      "drag"
 if {$v == 1} { set cmd          "\$(\"#${objName}\").draggable({handle : '#${objName}_header'});"
 } else { set cmd          "\$(\"#${objName}\").draggable('destroy');" }
 
 if {[lsearch [gmlObject info classes $root] PhysicalHTML_root] != -1} {
	$root Concat_update $objName $methode $cmd
 }
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HideShow_HTML Render_post_JS {strm_name {dec {}}} {
 upvar $strm_name strm

 #append strm $dec "\$(function() {" "\n" 

 ### jquery pour tous les containers
 if {[this get_header_place] == "left" || [this get_header_place] == "right"} { set ouvert "w"; set ferme "e"} else { set ouvert "n"; set ferme "s" }
 
 append strm $dec "     \$(\"#${objName}_icon\").remove();\n"
 append strm $dec "     \$(\"#${objName}\").addClass(\"ui-widget ui-widget-content ui-helper-clearfix ui-corner-all\")" "\n"
 append strm $dec "	            .find(\"#${objName}_header\")" "\n"
 append strm $dec "				.prepend('<span id=\"${objName}_icon\" class=\"ui-icon ui-icon-circle-arrow-" $ouvert "\"></span>')" "\n"
 append strm $dec "				.end()" "\n"
 append strm $dec "			.find(\"#${objName}_content\").attr({class : \"portlet-content\"});" "\n"
 
 set title [this Encode_param_for_JS [this get_title]]
 append strm $dec "		\$(\"#${objName}_title\").html(" $title ");" "\n"

 if {[this get_header_place] == "top" || [this get_header_place] == "bottom"} {
		append strm $dec "		\$(\"#${objName}_header\").attr({class : \"portlet-header ui-widget-header\"});"
		append strm $dec "		\$(\"#${objName}_icon\").click(function() {" "\n"
		append strm $dec "         if(\$(this).hasClass(\"ui-icon-circle-arrow-" $ouvert "\")) { \$(this).attr(\"class\",\"ui-icon ui-icon-circle-arrow-" $ferme "\"); \$(\"#${objName}_content\").hide(\"blind\"); }" "\n"
		append strm $dec "			else { \$(this).attr(\"class\",\"ui-icon ui-icon-circle-arrow-" $ouvert "\"); \$(\"#${objName}_content\").show(\"blind\"); }" "\n"
		append strm $dec "	      });" "\n"
		
		if {[this get_header_place] == "bottom"} { append strm $dec "     \$(\"#${objName}_header\").insertAfter(\"#${objName}_content\");" "\n" }

	} elseif {[this get_header_place] == "left" || [this get_header_place] == "right"} {
				append strm $dec "		\$(\"#${objName}_header\").attr({class : \"portlet-header ui-widget-header2\"});"
				append strm $dec "		var options = {};"
				append strm $dec "		options = {direction : \"" [this get_header_place] "\"};"
				
				# if {[this get_header_place] == "left"} { set ouvert "w"; set ferme "e"
				   # } else { set ouvert "e"; set ferme "w" }
				 set ouvert "w"
				 set ferme "e"
				   
				append strm $dec "		\$(\"#${objName}_icon\").click(function() {" "\n"
				append strm $dec "         if(\$(this).hasClass(\"ui-icon-circle-arrow-" $ouvert "\")) { \$(this).attr(\"class\",\"ui-icon ui-icon-circle-arrow-" $ferme "\"); \$(\"#${objName}_content\").hide(\"slide\",options); save = \$(\"#${objName}\").width(); \$(\"#${objName}\").effect(\"size\",{to: {width: (\$(\"#${objName}_header\").width()+12)}},500);   }" "\n"
				append strm $dec "		   else { \$(this).attr(\"class\",\"ui-icon ui-icon-circle-arrow-" $ouvert "\"); \$(\"#${objName}\").effect(\"size\",{to: {width: save}});  \$(\"#${objName}_content\").show(\"slide\",options); }" "\n"
				append strm $dec "	     });" "\n"
				
				if {[this get_header_place] == "left"} {
					 append strm $dec "     \$(\"#${objName}_header\").attr({style : \"float:left;\"});" "\n"
				     append strm $dec "     \$(\"#${objName}_content\").attr({style : \"float:left;\"});" "\n"
				   } else {
				            append strm $dec "     \$(\"#${objName}_header\").attr({style : \"float:right;\"});" "\n"
				            append strm $dec "     \$(\"#${objName}_content\").attr({style : \"float:left;\"});" "\n"
						  }

				append strm $dec "     var save = 0;" "\n"
				append strm $dec "     \$(\"#${objName}_title\").html(\$(\"#${objName}_title\").text().replace(/(.)/g,\"\$1<br />\"));" "\n"
				append strm $dec "     \$(\"#${objName}_header\").height(\$(\"#${objName}_title\").height()+20);" "\n"
				append strm $dec "     var heightT = (\$(\"#${objName}_header\").height() - \$(\"#${objName}_title\").height());	" "\n"
				append strm $dec "     \$(\"#${objName}_title\").attr({style : \"padding-top:\"+heightT+\"px;text-align:center;\"});" "\n"
			 }

 #append strm $dec "});" "\n"

 #this set_mark $mark
 this Render_daughters_post_JS strm $dec  
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HideShow_HTML Render {strm_name {dec {}}} {
 upvar $strm_name strm
 
 append strm $dec <div  [this Style_class] > "\n"
   append strm $dec "<div id=\"${objName}_header\" style=\"[this get_html_title_style_in_text]\"><div id=\"${objName}_title\">$this(title)</div></div>"
   append strm $dec "<div id=\"${objName}_content\">"
      this Render_daughters strm "$dec  "
   append strm $dec "</div>"
 append strm $dec </div> "\n"
}

#title style----------------------------------------------------------


# method Container_PM_P_HideShow_HTML get_html_title_style_in_text {} {
 # set rep ""
 # foreach {var val} [this get_html_title_style] {
	# append rep $var ": " $val ";"
  # }  
 # return $rep
# }
# method Container_PM_P_HideShow_HTML sub_html_title_style {L_vars} {
 # foreach var $L_vars {
	# unset this(html_title_style,$var)
  # }
 # this Send_updated_html_title_style
# }

# #_________________________________________________________________________________________________________
# method Container_PM_P_HideShow_HTML set_html_title_style {lstyles} {
 # set Lsub [list ]
 # foreach {var val} [this get_html_title_style] {
   # lappend Lsub $var
  # }
 # this sub_html_title_style $Lsub
 # this add_html_title_style $lstyles 
# }

# #_________________________________________________________________________________________________________
# method Container_PM_P_HideShow_HTML get_html_title_style {} {
 # set L [list]
 # foreach {var val} [array get this html_title_style,*] {lappend L [string range $var 11 end] $val; }
 # return $L
# }

# #_________________________________________________________________________________________________________
# method Container_PM_P_HideShow_HTML add_html_title_style {L_var_val} {
 # foreach {var val} $L_var_val {
   # set this(html_title_style,$var) $val
  # }
 # this Send_updated_html_title_style
# }
# method Container_PM_P_HideShow_HTML Send_updated_html_title_style {} {

 # #set root [this get_L_roots] 
 # set root $this(PM_root)
 # set class(enable_AJAX_UPDATE) 1
 # if {$class(enable_AJAX_UPDATE) && $root != ""} {
   # set    cmd  "\$(\"#${objName}_header\").removeAttr(\"style\");\n"
   # append cmd  "\$(\"#${objName}_header\").css({"
   # foreach {var val} [this get_html_title_style] {
	 # append cmd \' $var \' " : \'" $val "\',"
	# }
   # set cmd [string range $cmd 0 end-1]	
   # append cmd "});" "\n"
# puts "send Update  $cmd" 
   # $root Concat_update $objName htmlstyle $cmd
  # } 
# }














method Container_PM_P_HideShow_HTML Bg_gradient_bar {color1 color2 angle} {
puts "Bg Gradient Bar"

	lassign $color1 r g b a 
	lassign $color2 r1 g1 b1 a1 
	this add_html_style [list "background" "-moz-linear-gradient(${angle}deg,rgba([expr int(255 * $r)],[expr int(255 * $g)],[expr int(255 * $b)],$a), rgba([expr int(255 * $r1)],[expr int(255 * $g1)],[expr int(255 * $b1)],$a1))" ]
	#this add_html_style [list "background" "-webkit-gradient(linear,0 0, 0% 100%, from(rgba([expr int(256 * $r)],[expr int(256 * $g)],[expr int(256 * $b)],$a)), to(rgba([expr int(256 * $r1)],[expr int(256 * $g1)],[expr int(256 * $b1)],$a1)))" ]
}

method Container_PM_P_HideShow_HTML Bg_bar {color} {
	puts "Bg Gradient Bar"
	lassign $color r g b a  
	this add_html_style [list "background" "rgba([expr int(255 * $r)],[expr int(255 * $g)],[expr int(255 * $b)],$a)"];
}

