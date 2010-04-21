#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Container_PM_P_HideShow_HTML PM_HTML
#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HideShow_HTML constructor {name descr args} {
 this inherited $name $descr
 set this(header_place) "top"
 set this(title)        "&nbsp;"
 
 this set_html_style "" ${objName}_header
 this set_html_style "" ${objName}_content
 
 this set_root_for_daughters ${objName}_content
 
 set this(drag)         0
 set this(resizable)    0
 
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
 
 this Render_post_JS cmd $this(marker)
 
 if {[lsearch [gmlObject info classes $root] PhysicalHTML_root] != -1} {
	$root Concat_update $objName $methode $cmd
 }
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HideShow_HTML set_LM {LM} {
 set rep [this inherited $LM]
 if {$LM != ""} {set this(title) [[this get_LC] get_name]}
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
method Container_PM_P_HideShow_HTML Resizable {v {id {}}} {
 set this(resizable) $v

 if {$v == 1} {set cmd "\$( '#${objName}_content').resizable( {alsoResize: '#$objName'} );"
               this Subscribe_to_Render_post_JS ${objName}_Container_PM_P_HideShow_HTML::Resizable [this Translate_JS_for_subscribe cmd] UNIQUE
 } else {set cmd "\$( '#${objName}_content').resizable().resizable('destroy');"
         this UnSubscribe_to_Render_post_JS ${objName}_Container_PM_P_HideShow_HTML::Resizable
		}
 
 
 this send_jquery_message Resize_$objName $cmd 
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HideShow_HTML Draggable {v} {
 set this(drag) $v
 
 if {$v == 1} {set cmd "\$(\"#${objName}\").draggable({handle : '#${objName}_header'});"
               this Subscribe_to_Render_post_JS ${objName}_Container_PM_P_HideShow_HTML::Draggable [this Translate_JS_for_subscribe cmd] UNIQUE
 } else {set cmd "\$(\"#${objName}\").draggable().draggable('destroy');"
         this UnSubscribe_to_Render_post_JS ${objName}_Container_PM_P_HideShow_HTML::Draggable
		}
 
 this send_jquery_message Drag_$objName $cmd
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HideShow_HTML Render_post_JS {strm_name {dec {}}} {
 upvar $strm_name strm

 ### jquery pour tous les containers
 if {[this get_header_place] == "left" || [this get_header_place] == "right"} { set ouvert "w"; set ferme "e"} else { set ouvert "n"; set ferme "s" }
 
 append strm $dec "     \$(\"#${objName}_icon\").remove();\n"
 append strm $dec "     \$(\"#${objName}\").addClass(\"ui-widget ui-widget-content ui-helper-clearfix ui-corner-all\")" "\n"
 append strm $dec "	            .find(\"#${objName}_header\")" "\n"
 append strm $dec "				.prepend('<span id=\"${objName}_icon\" style=\"float: right;\" class=\"ui-icon ui-icon-circle-arrow-" $ouvert "\"></span>')" "\n"
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

 
 this inherited strm $dec
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HideShow_HTML Render {strm_name {dec {}}} {
 upvar $strm_name strm
 
 append strm $dec <div  [this Style_class] > "\n"
   append strm $dec "<div id=\"${objName}_header\" style=\"[this get_html_style_in_text ${objName}_header]\"><span id=\"${objName}_title\" style=\"\">$this(title)</span></div>"
   append strm $dec "<div id=\"${objName}_content\" style=\"[this get_html_style_in_text ${objName}_content]\">"
      this Render_daughters strm "$dec  "
   append strm $dec "</div>"
 append strm $dec </div> "\n"
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_HideShow_HTML Float_daughters {position} {
	this add_html_style [list "overflow" "auto"] ${objName}_content
	foreach daugther [this get_out_daughters] {
		$daugther Float $position
	}
}
