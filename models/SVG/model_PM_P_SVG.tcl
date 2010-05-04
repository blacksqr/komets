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
 set this(L_draggable) [list ]

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
     $e Render_JS      cmd [$bridge get_last_marker]
 
     set pipo_svg [$bridge get_pipo_svg]
	 set strm ""; $e Render_all strm
     set strm    [$e Encode_param_for_JS $strm]
     append cmd  "var svg = \$('#$pipo_svg').svg('get');\n"
     append cmd  "svg.add($strm);\n" 
	 
	 set pos       [lsearch [$objName get_daughters] $e]
	 set tailletot [llength [$objName get_daughters]]
	 set e_root    [$e get_prim_handle]
	 append cmd    "var ref = \$(\"#$e_root\").get(0);\n"
	 append cmd    "ref.parentNode.removeChild(ref);\n"

	 if { $tailletot-1 > $pos} {
		set objAfter [lindex [$objName get_daughters] [expr $pos+1]]
		set objAfter [$objAfter get_prim_handle]
		set root_for_daughters [this get_root_for_daughters]
		append cmd "\$('#$root_for_daughters').get(0).insertBefore(ref, \$('#$objAfter').get(0));\n"
	  } else {set root_for_daughters [this get_root_for_daughters]
			  append cmd "\$('#$root_for_daughters').get(0).appendChild(ref);\n"
			 }

   
    $e Render_post_JS cmd 
  }
 return $cmd
}

Trace PM_SVG Add_JS
#___________________________________________________________________________________________________________________________________________
method PM_SVG Sub_JS {e} {
 set cmd "\$('#$e').remove();\n"
 return $cmd
}

#___________________________________________________________________________________________________________________________________________
method PM_SVG SVG_Origine {coords} {
}

#___________________________________________________________________________________________________________________________________________
Manage_CallbackList PM_SVG SVG_Origine end

#___________________________________________________________________________________________________________________________________________
method PM_SVG Draggable {SVG_group L_drag_element {direct_mode 1}} {
 if {$direct_mode == 1  &&  $L_drag_element == $this(L_draggable)} {return ""}
 
 set cmd ""
 foreach n $this(L_draggable) {
	append cmd "\$('#$n').draggable('destroy');\n"
 }
 
 set this(L_draggable) $L_drag_element 
 foreach n $this(L_draggable) {
 	 append cmd "var ${n}_dx = 0;\n"
	 append cmd "var ${n}_dy = 0;\n"
	 append cmd "var ${n}_str_dCTM = '';\n"
	 append cmd "\$('#$n').draggable({start : function(event, ui){\n"
	   append cmd "   var drag_obj = \$(\"#${SVG_group}\").get(0);\n"
	   append cmd "   var coord = convert_coord_from_page_to_node(event.pageX,event.pageY,drag_obj.parentNode);\n"
	   append cmd "   ${n}_dx = coord\['x'\];\n"
	   append cmd "   ${n}_dy = coord\['y'\];\n"
	   #append cmd "   alert('click on ' + ${n}_dx +' , '+ ${n}_dy);"
	   append cmd "   var ma_matrice = drag_obj.getCTM();\n"
	   append cmd "   var dCTM = drag_obj.parentNode.getCTM().inverse().mMultiply(ma_matrice);\n"
	   append cmd {   } ${n}_ {str_dCTM = "matrix("+dCTM.a+","+dCTM.b+","+dCTM.c+","+dCTM.d+","+dCTM.e+","+dCTM.f+")";} "\n"
	   append cmd "   drag_obj.setAttribute(\"transform\", ${n}_str_dCTM);\n"
	 append cmd "},drag : function(event, ui){\n"
	   append cmd "   var drag_obj = \$(\"#${SVG_group}\").get(0);\n"
	   append cmd "   var coord = convert_coord_from_page_to_node(event.pageX,event.pageY,drag_obj.parentNode);\n"
	   append cmd "   var tx = coord\['x'\] - ${n}_dx;\n"
	   append cmd "   var ty = coord\['y'\] - ${n}_dy;\n"
	   append cmd {   drag_obj.setAttribute("transform", } ${n}_ {str_dCTM + ' translate(' + tx + ', ' + ty +')');} "\n"
	 append cmd "},stop : function(event, ui){\n"
	   append cmd "   var drag_obj = \$(\"#${SVG_group}\").get(0);\n"
	   append cmd "   var ma_matrice = drag_obj.getCTM();\n"
	   append cmd "   var ma_matrice = drag_obj.parentNode.getCTM().inverse().mMultiply(ma_matrice);\n"
	   append cmd "   addOutput_proc_val(\"${objName}__XXX__SVG_Origine\", ma_matrice.e + ' ' + ma_matrice.f,true);\n"
	 append cmd "}});\n"
 }
 
 if {$direct_mode == 1} {
	this send_jquery_message "Draggable" $cmd 
  }
  
 return $cmd
}

