inherit CometToolBox_GDD_CFC CommonFC

#___________________________________________________________________________________________________________________________________________
method CometToolBox_GDD_CFC constructor {} {
 set this(gdd_proxy) {}
 set this(L_nodes)   [list]
}
#___________________________________________________________________________________________________________________________________________
Generate_accessors CometToolBox_GDD_CFC [list L_nodes gdd_proxy]

#___________________________________________________________________________________________________________________________________________
method CometToolBox_GDD_CFC Select_node {n} {}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_get_CometToolBox_GDD {} {return [list {get_L_nodes { }} {get_gdd_proxy { }} ]}
proc P_L_methodes_set_CometToolBox_GDD {} {return [list {set_L_nodes {L}} {set_gdd_proxy {v}} {Select_node {n}} {Update_nodes {}} ]}

#___________________________________________________________________________________________________________________________________________
method CometToolBox_GDD_CFC Update_nodes {} {
 set this(L_nodes) [this GDD_get_L_nodes_for_builder]
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometToolBox_GDD_CFC GDD_get_L_nodes_for_builder {} {
 set L_rep [list ]
 
 foreach top_level_task [this GDD_get_toplevel_tasks] {
   #puts "top_level_task : $top_level_task"
   set L_spec_task [list ]
   foreach t [this GDD_get_level_closest_from_sublevel_of $top_level_task] {
     #puts "  task : $t"
	 set L_aui [list ]
	 foreach a [this GDD_get_level_closest_from_sublevel_of [this GDD_get_concretizations_of $t]] {
	   #puts "    AUI : $a"
	   set L_cui [list ]
	   foreach c [this GDD_get_level_closest_from_sublevel_of [this GDD_get_concretizations_of $a]] {
	     #puts "      CUI : $c"
		 lappend L_cui $c
	    }
	   if {[llength $L_cui] > 0} {lappend L_aui [list $a $L_cui]}
	  }
	 if {[llength $L_aui] > 0} {lappend L_spec_task [list $t $L_aui]}
    }
   if {[llength $L_spec_task] > 0} {lappend L_rep [list $top_level_task $L_spec_task]}
  }
  
 return $L_rep
}
 
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometToolBox_GDD_CFC GDD_get_toplevel_tasks {} {
 set req {?T : IS_root : NODE()<-REL(type==GDD_restriction)<-$T()}
 $this(gdd_proxy) QUERY $req
 set rep [lindex [$this(gdd_proxy) get_Result] 0]
 return [lindex $rep 1]
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometToolBox_GDD_CFC GDD_get_level_closest_from_sublevel_of {L_nodes} {
 set L [list ]
 foreach node $L_nodes {
   set req "?T : $node : NODE()<-REL(type~=GDD_inheritance && type!=GDD_concretization)*<-\$T()<-REL(type~=GDD_concretization)<-NODE()"
   $this(gdd_proxy) QUERY $req
   set rep [lindex [$this(gdd_proxy) get_Result] 0]
 
   set req2 "?T : $node : \$T()<-REL(type~=GDD_concretization)<-NODE()"
   $this(gdd_proxy) QUERY $req2
   set rep2 [lindex [$this(gdd_proxy) get_Result] 0]
   
   set L [concat $L [lindex $rep2 1] [lindex $rep 1]]
  }
 
 return $L
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometToolBox_GDD_CFC GDD_get_concretizations_of {L_nodes} {
 set L [list ]
 foreach node $L_nodes {
   set req "?T : $node : NODE()<-REL(type~=GDD_concretization)<-\$T()"
   $this(gdd_proxy) QUERY $req
   set rep [lindex [$this(gdd_proxy) get_Result] 0]
   set L [concat $L [lindex $rep 1]]
  }
  
 return $L
}
