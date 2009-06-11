#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit PM_SVG PM_HTML
#___________________________________________________________________________________________________________________________________________
method PM_SVG constructor {name descr args} {
 this inherited $name $descr
 [[this get_cou] get_ptf] maj Ptf_SVG
 set this(drag_function) ""
}

#_________________________________________________________________________________________________________
Generate_accessors PM_SVG [list drag_function]

#_________________________________________________________________________________________________________
method PM_SVG set_drag_function {fct} {
 set this(drag_function) $fct
 this Draggable
}

#_________________________________________________________________________________________________________
method PM_SVG get_HTML_to_SVG_bridge {} {
 set m [this get_mothers]
 if {$m != ""} {
  return [$m get_HTML_to_SVG_bridge]
 } else {return ""
		}
}

#_________________________________________________________________________________________________________
method PM_SVG Add_JS {e} {
 set cmd ""
 set bridge [this get_HTML_to_SVG_bridge]
 if {$bridge != ""} { 
     set marker [clock clicks]
	 $e Render_JS      cmd $marker
 
     set pipo_svg [$bridge get_pipo_svg]
	 set strm ""; $e Render strm
     set strm    [$e Encode_param_for_JS $strm]
     append cmd  "var svg = \$('#$pipo_svg').svg('get');"
     append cmd  "svg.add($strm);" 
	 
	 set pos       [lsearch [$objName get_daughters] $e]
	 set tailletot [llength [$objName get_daughters]]
	 set e_root    [$e get_prim_handle]
	 append cmd    "var ref = \$(\"#$e_root\").get(0);"
	 append cmd    "ref.parentNode.removeChild(ref);"

	 if { $tailletot-1 > $pos} {
		set objAfter [lindex [$objName get_daughters] [expr $pos+1]]
		set objAfter [$objAfter get_prim_handle]
		set root_for_daughters [this get_root_for_daughters]
		append cmd "\$('#$root_for_daughters').get(0).insertBefore(ref, \$('#$objAfter').get(0));"
	  } else {set root_for_daughters [this get_root_for_daughters]
			  append cmd "\$('#$root_for_daughters').get(0).appendChild(ref);"
			 }

   
    $e Render_post_JS cmd 
  }
 return $cmd
}

#___________________________________________________________________________________________________________________________________________
method PM_SVG Sub_JS {e} {
 set cmd "\$('#$e').remove();"
 return $cmd
}

#___________________________________________________________________________________________________________________________________________
method PM_SVG SVG_Origine {coords} {
 set x [lindex $coords 0]
 set y [lindex $coords 1]
}

#___________________________________________________________________________________________________________________________________________
Manage_CallbackList PM_SVG SVG_Origine end
Trace PM_SVG SVG_Origine

#___________________________________________________________________________________________________________________________________________
method PM_SVG Draggable {} {
 set cmd "\$('#$objName').draggable({drag : function(event, ui){"
 append cmd [this get_drag_function]
 append cmd " addOutputSVG(\"${objName}__XXX__SVG_Origine\", string(event.pageX) + ' ' + string(event.pageY));"
 append cmd "}});"
 
 this send_jquery_message "Draggable" $cmd 
}