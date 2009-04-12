inherit CometGraphBuilder_CFC CommonFC

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_CFC constructor {} {
 set this(handle_root) {}
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
 CometGraphBuilder_CFC___NODE $node_name CLASS $name
 set this(id,$node_name) $id
 set this(node_name,$id) $node_name
}

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_CFC Add_node_instance {id name}   {
 set node_name [this get_a_unique_node_name]
 CometGraphBuilder_CFC___NODE $node_name INSTANCE $name
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
method CometGraphBuilder_CFC get_graph_description {{node {}}} {
 set str "[$this(node_name,$this(handle_daughters)) get_name] "
 if {$this(handle_root) != ""} {$this(node_name,$this(handle_root)) Serialize str}
 return $str
}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_get_CometGraphBuilder {} {return [list {get_handle_root { }} {get_handle_daughters { }} \
                                                         {get_a_local_unique_id {}} \
														 {get_graph_description {}} \
														 {Has_for_descendant {id_m id_d}} \
												   ]}
proc P_L_methodes_set_CometGraphBuilder {} {return [list {set_handle_root {v}} {set_handle_daughters {v}} \
                                                         {Add_node_type {id name}} {Add_node_instance {id name}} \
														 {Sub_node {id}} {Add_rel {id_m id_d}} {Sub_rel {id_n id_d}} ]}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_CFC___NODE constructor {type name} {
 set this(type) $type
 set this(name) $name
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
Generate_accessors     CometGraphBuilder_CFC___NODE [list type name]
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
method CometGraphBuilder_CFC___NODE Serialize {str_name} {
 upvar $str_name str
 
 append str $this(name) {(}
   # serialize the markers, if any
   if {[llength $this(marks)] > 0} {
     append str {-Add_style_class "} $this(marks) {"}
	}
	
   # serialize the daughters, if any
   foreach d $this(daughters) {
     append str { ,}; $d Serialize str
    }
 append str {)}
}

