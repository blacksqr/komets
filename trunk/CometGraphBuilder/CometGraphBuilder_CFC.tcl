inherit CometGraphBuilder_CFC CommonFC

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_CFC constructor {} {
 set this(handle_root)      {}
 set this(handle_daughters) {}
 set this(node_id) 0
 set this(id)      0
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors CometGraphBuilder_CFC [list handle_root handle_daughters]

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_CFC get_a_local_unique_id {} {
 incr this(id)
 return ${objName}_U_ID_$this(id)
}

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_CFC get_a_unique_node_name {}   {
 incr this(node_id)
 return ${objName}_NODE_$this(node_id)
}

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_CFC Add_node_type     {id name}   {
 set node_name [this get_a_unique_node_name]
 CometGraphBuilder_CFC___NODE $node_name CLASS $name $id
 set this(id,$node_name) $id
 set this(node_name,$id) $node_name
}

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_CFC get_node_with_id {id} {
 if {[info exists this(node_name,$id)]} {return $this(node_name,$id)} else {return ""}
}

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_CFC Add_node_instance {id name}   {
 set node_name [this get_a_unique_node_name]
 CometGraphBuilder_CFC___NODE $node_name INSTANCE $name $id
 set this(id,$node_name) $id
 set this(node_name,$id) $node_name
}

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_CFC Sub_node          {id}   {
 if {[info exists this(node_name,$id)]} {
   $this(node_name,$id) dispose
  }
}

 #___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_CFC Add_rel           {id_m id_d} {
 if { [info exists this(node_name,$id_m)] \
    &&[info exists this(node_name,$id_d)]} {
   this Sub_rel $id_m $id_d
   $this(node_name,$id_m) Add_daughters $this(node_name,$id_d)
   $this(node_name,$id_d) Add_mothers   $this(node_name,$id_m)
  }
}

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_CFC Sub_rel           {id_m id_d} {
 if { [info exists this(node_name,$id_m)] \
    &&[info exists this(node_name,$id_d)]} {
   $this(node_name,$id_m) Sub_daughters $this(node_name,$id_d)
   $this(node_name,$id_d) Sub_mothers   $this(node_name,$id_m)
  }
}

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_CFC Has_for_descendant {id_m id_d} {
 set rep [$this(node_name,$id_m) Has_for_descendant $this(node_name,$id_d)]
 puts "$objName Has_for_descendant $id_m $id_d"
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_CFC get_marks_for {id} {
 return [$this(node_name,$id) get_marks]
}

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_CFC set_marks_for {id L_marks} {
 $this(node_name,$id) set_marks $L_marks
}

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_CFC get_graph_description {{root {}}} {
 if {$this(handle_daughters) == ""} {return ""}
 
 set str "[$this(node_name,$this(handle_daughters)) get_name] "
 if {$this(handle_root) != ""} {
   set rep [$this(node_name,$this(handle_root)) Serialize str $root]
   puts $rep
  }
 return $str
}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_get_CometGraphBuilder {} {return [list {get_handle_root { }} {get_handle_daughters { }} \
                                                         {get_a_local_unique_id {}} \
														 {get_marks_for {id}} \
														 {get_graph_description {{{root {}}}}} \
														 {Has_for_descendant {id_m id_d}} \
														 {get_node_with_id {id}} \
												   ]}
proc P_L_methodes_set_CometGraphBuilder {} {return [list {set_handle_root {v}} {set_handle_daughters {v}} \
                                                         {Add_node_type {id name}} {Add_node_instance {id name}} \
														 {Sub_node {id}} {Add_rel {id_m id_d}} {Sub_rel {id_m id_d}} \
														 {set_marks_for {id L_marks}} \
	 											   ]}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_CFC___NODE constructor {type name id} {
 set this(id)        $id
 set this(type)      $type
 set this(name)      $name

 set this(marks)     [list]
 set this(daughters) [list]
 set this(mothers)   [list]
}

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_CFC___NODE dispose {} {
 foreach m $this(mothers)   {$m Sub_daughters $objName}
 foreach d $this(daughters) {$d Sub_mothers   $objName}
 
 this inherited
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors     CometGraphBuilder_CFC___NODE [list type name id]
Generate_List_accessor CometGraphBuilder_CFC___NODE daughters daughters
Generate_List_accessor CometGraphBuilder_CFC___NODE mothers   mothers
Generate_List_accessor CometGraphBuilder_CFC___NODE marks     marks

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_CFC___NODE Has_for_descendant {e} {
 if {[lsearch $this(daughters) $e] >= 0} {return 1}
 foreach d $this(daughters) {
   if {[$d Has_for_descendant $e]} {return 1}
  }
 return 0
}

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_CFC___NODE get_path_to_ancestor_from {n root rep_name} {
 #puts "get_path_to_ancestor_from $n $root"
 upvar $rep_name rep
 
 set nb 0
 if {$n == $root} {
   #set rep {}
  } else {set m [$n get_mothers]
          if {$m != ""} {
            set m [lindex $m 0]
			set nb [this get_path_to_ancestor_from $m $root rep]
            if { [lsearch [$m get_out_daughters] $n] == -1} {
			  if {$m != $root} {
                set L_classes [lindex [gmlObject info classes [$m get_LC]] 0]
                set L_classes [concat $L_classes [$m get_style_class]]
                set obj_marks [join $L_classes .]
			   } else {set obj_marks {$obj}}
			  append rep $obj_marks "\\("
			  incr nb
			 }
           } else {set m [lindex [$n get_nesting_element] 0]
		           if {$m != ""} {
				     set m [$m get_LC]
                     if {$m != $root} {
					   set L_classes [lindex [gmlObject info classes [$m get_LC]] 0]
                       set L_classes [concat $L_classes [$m get_style_class]]
                       set obj_marks [join $L_classes .]
					  } else {set obj_marks {$obj}}
			           append rep $obj_marks "\\("
			           incr nb
				    }
		          }
		 }
		 
 return $nb
}

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_CFC___NODE Serialize {str_name root} {
 #puts "$objName Serialize"
 upvar $str_name str
 
 set is_a_comet 0
 if {[gmlObject info exists object $this(name)]} {
   if {[lsearch [gmlObject info classes $this(name)] Comet_element] >= 0} {set is_a_comet 1}
  }
  
 set rep ""
 if {$is_a_comet} {
   #puts "$this(name) is a comet"
   set L_classes [lindex [gmlObject info classes [$this(name) get_LC]] 0]
   set L_classes [concat $L_classes [$this(name) get_style_class]]
   set obj_marks [join $L_classes .]
   append rep "set C_$this(name)" { [CSS++ $obj "}  
     set nb_close_parenthesis [this get_path_to_ancestor_from $this(name) $root rep]
	 append rep $obj_marks
	 for {set i 0} {$i < $nb_close_parenthesis} {incr i} {append rep ")"}
#	 puts "Nb close parenthesis $nb_close_parenthesis"
   append rep {"]} ";\n"
   append str {$} C_$this(name) {\(}
  } else {
          #puts "$this(name) is not a comet"
          append str $this(name) {(}
		 }
  
   
  
   # serialize the markers, if any
   if {[llength $this(marks)] > 0} {
     append str {-Add_style_class "} $this(marks) {"}
	}
	
   # serialize the daughters, if any
   foreach d $this(daughters) {
     append str { ,}; 
	 append rep [$d Serialize str $root]
    }
 append str {)}
 
 return $rep
}

