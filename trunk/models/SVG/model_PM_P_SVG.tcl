#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit PM_SVG PM_HTML
#___________________________________________________________________________________________________________________________________________
method PM_SVG constructor {name descr args} {
 this inherited $name $descr
 [[this get_cou] get_ptf] maj Ptf_SVG
}

#_________________________________________________________________________________________________________
method PM_SVG Add_JS {e} {
 if {[gmlObject info exists object $e]} {
	 set pos       [lsearch [$objName get_daughters] $e]
	 set tailletot [llength [$objName get_daughters]]
	 set cmd       "var ref = \$(\"#${e}\").get(0);"
	 append cmd    "ref.parentNode.removeChild(ref);"

	 if { $tailletot-1 > $pos} {
		set objAfter [lindex [$objName get_daughters] [expr $pos+1]]
		append cmd "\$('#$objName').get(0).insertBefore(ref,$('#$objAfter').get(0));"
	  } else {
			  append cmd "\$('#$objName').get(0).appendChild(ref);"
			 }

	 set this(marker) [clock clicks]
	 $e Render_JS cmd $this(marker)
  } else {set cmd [[$e get_mothers] Sub_JS $e]}
  
 return $cmd
}

#___________________________________________________________________________________________________________________________________________
method PM_SVG Sub_JS {e} {
 set cmd "\$('#$e').remove();"
 return $cmd
}