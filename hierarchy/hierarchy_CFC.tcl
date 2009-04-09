##Hierarchy_CFC

inherit Hierarchy_CFC CommonFC
#________________________________________________________________________________________________________________________________________
proc L_methodes_get_hierarchy {} {return [list {get_currents {}}   {get_element_root {}}  {get_ll_cmd {}}]}
proc L_methodes_set_hierarchy {} {return [list {set_currents {lc}} {set_element_root {r}} ]               }

method Hierarchy_CFC constructor { {element_root {}} ll_cmd } {

	set this(element_root) 	$element_root
	set this(currents)		[list]
	
	## ll_cmd liste de commandes à appliquer sur tous les éléments
	
#	## ll_cmd liste de liste d'éléments <function-level, name, cmd>
#	#   ex = <0, nested, get_daughters>
#	#		 <{expr $depth == 3}, {}, get_sisters> -> pour niveau 3
#	#		 <{expr $depth % 2  == 1}>, nested, get_daughters> -> pour niveau impair
#	#        <{},nested, get_daughters > ou alors
	set this(ll_cmd)		$ll_cmd

	
	


}

################################################################################
method Hierarchy_CFC get_currents       {}   {return $this(currents)}
method Hierarchy_CFC set_currents       {lc} {set this(currents) $lc}


################################################################################
method Hierarchy_CFC get_element_root { } {return $this(element_root)}
method Hierarchy_CFC set_element_root {r} {set this(element_root) $r}

################################################################################
method Hierarchy_CFC get_ll_cmd {} {
	return $this(ll_cmd)
}


################################################################################
method Hierarchy_CFC get_cmd { depth } {

return [list {} {} get_daughters]
	
	foreach l $this(ll_cmd) {
		if { [lindex $l 0] == {} } {
			return $l
		}
		
		#if { eval [lindex $l 0] } {
		#	return $l		
		#}
	}
	
	return [lindex $this(ll_cmd) end]

}

################################################################################
if {[info exists nb_Hierarchy_CFC]} {} else {set nb_Hierarchy_CFC 0}

proc New_Hierarchy_CFC {root ll_name_cmd} {
 global nb_Hierarchy_CFC
 set name "Hierarchy_CFC_$nb_Hierarchy_CFC"
 Hierarchy_CFC $name $root $ll_name_cmd
 incr nb_Hierarchy_CFC
 return $name
}
