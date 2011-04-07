inherit CometChoice_PM_P_UPNP_AV_tree PM_TK

#___________________________________________________________________________________________________________________________________________
method CometChoice_PM_P_UPNP_AV_tree constructor {name descr args} {
 this inherited $name $descr
 this set_root_for_daughters NULL
   this set_GDD_id FUI_CometChoice_PM_P_UPNP_AV_tree
   this set_nb_max_daughters 0
   set this(comet_UPNP) [CPool get_singleton CometUPNP]
   
   package require tdom
   set this(L_media_servers) [list]
   set this(img_device)      [image create photo -file $::env(ROOT_COMETS)/Comets/CometUPNP/PMs/icon_device2.png]
   
   $this(comet_UPNP) Subscribe_to_set_item_of_dict_devices    $objName "$objName Add_new_UPNP_device \$keys \$val"
   $this(comet_UPNP) Subscribe_to_remove_item_of_dict_devices $objName "$objName Remove_UPNP_device \$UDN"
   
   set this(current_tree_id) ""
   
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometChoice_PM_P_UPNP_AV_tree dispose {} {this inherited}

#______________________________________________________ Adding the choices functions _______________________________________________________
Methodes_set_LC CometChoice_PM_P_UPNP_AV_tree $L_methodes_set_choices {}          {}
Methodes_get_LC CometChoice_PM_P_UPNP_AV_tree $L_methodes_get_choices {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters CometChoice_PM_P_UPNP_AV_tree [P_L_methodes_set_choice_N_COMET_RE]

#___________________________________________________________________________________________________________________________________________
method CometChoice_PM_P_UPNP_AV_tree get_or_create_prims {root} {
 set this(tk_root) $root.tk_root_${objName}
 
 if {![winfo exists $this(tk_root)]} {
	 set this(frame_root) [frame $this(tk_root)]
	 set this(frame_top) [frame $this(frame_root).f_top]; pack $this(frame_top) -side top -expand 0 -fill x
		set this(lab_search) [label $this(frame_top).lab -text "Search : "]; pack $this(lab_search) -side left
		set this(entry_search) [entry $this(frame_top).e]; pack $this(entry_search) -side left -expand 1 -fill x
		set cmd "$objName Search \[$this(entry_search) get\]"
		bind $this(entry_search) <Return> $cmd
		set this(bt_search)    [button $this(frame_top).bt -text "SEARCH" -command $cmd]; pack $this(bt_search) -side left
	 set this(frame_bottom) [frame $this(frame_root).f_bottom]; pack $this(frame_bottom) -side top -expand 1 -fill both
	 set this(paned_for_tree) [ttk::panedwindow $this(frame_bottom).pan -orient horizontal]; pack $this(paned_for_tree) -expand 1 -fill both
	 
	 set this(frame_tree) [frame $this(paned_for_tree).f_tree]; pack $this(frame_tree) -expand 0 -fill y
	 set this(tree)    [ttk::treeview $this(frame_tree).tree   ]; pack $this(tree)    -side left -fill both -expand 1
	 set this(sb_tree) [scrollbar     $this(frame_tree).sb -orient vert]; pack $this(sb_tree) -fill y -expand 1
		$this(tree)    configure -yscrollcommand "$this(sb_tree) set"
		$this(sb_tree) configure -command "$this(tree) yview"
	
	 $this(paned_for_tree) add $this(frame_tree); pack $this(paned_for_tree) -expand 1 -fill both
	 
	 # List of items
	 set this(frame_L_items) [frame $this(paned_for_tree).f_L_items]
	 $this(paned_for_tree) add $this(frame_L_items)
	 set this(tk_L_items) [listbox $this(frame_L_items).tk_L_items]; pack $this(tk_L_items) -expand 1 -fill both -side left
	 set this(sb_items) [scrollbar     $this(frame_L_items).sb -orient vert]; pack $this(sb_items) -fill y -expand 0 -side left
		$this(tk_L_items) configure -yscrollcommand "$this(sb_items) set"
		$this(sb_items)   configure -command "$this(tk_L_items) yview"
		bind $this(tk_L_items) <<ListboxSelect>> "$objName Display_item_info \[$this(tk_L_items) curselection\]"
		bind $this(tk_L_items) <Double-ButtonPress-1> "$objName Choose_item \[$this(tk_L_items) curselection\]"
	 
	 # Description of item
	 set this(frame_item_descr) [frame $this(paned_for_tree).f_item_descr]
	 $this(paned_for_tree) add $this(frame_item_descr)
	 set this(text_item_descr) [text $this(frame_item_descr).text_descr -state disabled]; pack $this(text_item_descr) -expand 1 -fill both
	 
	 # MetaDatas
	 this Add_MetaData PRIM_STYLE_CLASS [list $this(tree) "NAVIGATION TREE INFORMATION" $this(tk_L_items) "PARAM IN ACTION"]
	 after 100 "$objName Update_tree"
	}
	
 this set_root_for_daughters $this(tk_root)
 return [this set_prim_handle $this(tk_root)]
}

#___________________________________________________________________________________________________________________________________________
method CometChoice_PM_P_UPNP_AV_tree maj_choices {}   {}

#___________________________________________________________________________________________________________________________________________
method CometChoice_PM_P_UPNP_AV_tree Add_new_UPNP_device {keys val} {
	if {[llength $keys] == 1  &&  [winfo exists $this(tk_root)]} {
		 this Update_tree [list $keys $val]
		}
}
# Trace CometChoice_PM_P_UPNP_AV_tree Add_new_UPNP_device
#___________________________________________________________________________________________________________________________________________
method CometChoice_PM_P_UPNP_AV_tree Remove_UPNP_device {UDN} {
	if {[winfo exists $this(tk_root)]} {
		 if {[info exists this(tree_id_of,$UDN)]} {
			 $this(tree) delete $this(tree_id_of,$UDN)
			 $this(tk_L_items) delete 0 end
			 $this(text_item_descr) configure -state normal
			 $this(text_item_descr) delete 0.0 end
			 $this(text_item_descr) configure -state disabled
			 unset this(tree_id_of,$UDN)
			 
			 foreach {i v} [array get this items,${UDN}_] {
				 unset this($i)
				}
			}
		}
}

#___________________________________________________________________________________________________________________________________________
method CometChoice_PM_P_UPNP_AV_tree Search {str} {
	set tree_id "Search"; set this(items,$tree_id) [list]

	set L_search [list]
	foreach s [split $str ","] {
		 lappend L_search [string trim $s]
		}
	
	set Result [list]
	foreach {i val} [array get this "items,*"] {
		 foreach item $val {
			 foreach s $L_search {
				 # puts $item
				 if {[catch {set title [dict get $item title]} err]} {puts "Error with item:\n$item"; set title ""} 
				 if {[string match $s $title]} {Add_list Result [list $item]; break}
				}
			}
		}
		
	# puts $search_result
	set this(items,$tree_id) $Result
	
	this Update_items_with $tree_id
}

#___________________________________________________________________________________________________________________________________________
method CometChoice_PM_P_UPNP_AV_tree is_a_media_server {UDN} {
	if {[string first {urn:schemas-upnp-org:device:MediaServer} [$this(comet_UPNP) get_item_of_dict_devices [list $UDN deviceType]]] >= 0} {set rep 1} else {set rep 0}
	return $rep
}

#___________________________________________________________________________________________________________________________________________
method CometChoice_PM_P_UPNP_AV_tree get_service_name_containing {UDN service_name} {
	set rep ""
	foreach {service descr} [$this(comet_UPNP) get_item_of_dict_devices [list $UDN ServiceList]] {
		 if {[string first $service_name $service] >= 0} {set rep $service; break}
		}
	return $rep
}

#___________________________________________________________________________________________________________________________________________
method CometChoice_PM_P_UPNP_AV_tree Update_service_description {UDN ContentDirectory_service num_update} {
	# puts "\t$objName Update_service_description $num_update / $this(last_SystemUpdateID)"
	if {$num_update == $this(last_SystemUpdateID)} {
		 puts "\t=> update !"
		 set this(last_SystemUpdateID) 0
		 set this(update_${UDN}_${ContentDirectory_service}) $num_update
		 catch {unset this(items,Search)}
		 foreach {i v} [array get this items,${UDN}_*] {
			 unset this($i)
			}
		 if {[string first $UDN $this(current_tree_id)] == 0  ||  $this(current_tree_id) == "Search"} {
			 $this(tk_L_items) delete 0 end
			 $this(text_item_descr) configure -state normal
			 $this(text_item_descr) delete 0.0 end
			 $this(text_item_descr) configure -state disabled
			}
		 this Update_tree [list $UDN [$this(comet_UPNP) get_item_of_dict_devices $UDN]]
		} else {if {$this(last_SystemUpdateID) != 0} {after 2500 [list $objName Update_service_description $UDN $ContentDirectory_service $this(update_${UDN}_${ContentDirectory_service})]}}
}

#___________________________________________________________________________________________________________________________________________
method CometChoice_PM_P_UPNP_AV_tree Update_service {UDN ContentDirectory_service xml} {
	# puts "$objName Update_service $UDN"
	if {[regexp {<SystemUpdateID>(.*)</SystemUpdateID>} $xml reco SystemUpdateID]} {
		if {![info exists this(update_${UDN}_${ContentDirectory_service})]} {
			 set this(update_${UDN}_${ContentDirectory_service}) $SystemUpdateID
			} else {if {$this(update_${UDN}_${ContentDirectory_service}) < $SystemUpdateID} {
						 after 2500 [list $objName Update_service_description $UDN $ContentDirectory_service $SystemUpdateID]
						 set this(last_SystemUpdateID) $SystemUpdateID
						}
				   }
		}
}
# Trace CometChoice_PM_P_UPNP_AV_tree Update_service

#___________________________________________________________________________________________________________________________________________
method CometChoice_PM_P_UPNP_AV_tree Update_tree {{L_devices {}}} {
	if {[llength $L_devices] == 0} {set L_devices [$this(comet_UPNP) get_dict_devices]}
	foreach {UDN UDN_val} $L_devices {
		 # Is it a media server?
		 if {[this is_a_media_server $UDN]} {
			Add_list this(L_media_servers) $UDN

			# If yes, add audio/videos items
			 set ContentDirectory_service [this get_service_name_containing $UDN "ContentDirectory"]
			 if {$ContentDirectory_service != ""} {
				 # Can we browse ?
				 if {[lsearch [$this(comet_UPNP) get_children_attributes [list $UDN ServiceList $ContentDirectory_service actions]] "Browse"] >= 0} {
					 $this(comet_UPNP) Subscribe_to_UPNP_events $UDN $ContentDirectory_service $objName [list $objName Update_service $UDN $ContentDirectory_service]
					 this Browse_recursively_from $UDN $ContentDirectory_service "" 0 [$this(comet_UPNP) get_item_of_dict_devices [list $UDN friendlyName]]
					}
				}
			}
		}
}

#___________________________________________________________________________________________________________________________________________
method CometChoice_PM_P_UPNP_AV_tree Browse_recursively_from {UDN service parent_tree_id object_id title} {
	# Create an item in the tree
	set tree_id ${UDN}_$object_id
	if {![$this(tree) exists $tree_id]} {
		 $this(tree) insert $parent_tree_id end -id $tree_id -tags $tree_id -text $title
		} else  {$this(tree) delete [$this(tree) children $tree_id]
				}
	if {$parent_tree_id == ""} {set this(tree_id_of,$UDN) $tree_id}
	$this(tree) tag bind $tree_id <ButtonPress-1> [list $objName Update_items_with [string map [list "%" "%%"] $tree_id]]
	
	$this(comet_UPNP) soap_call $UDN $service Browse [list $object_id "BrowseDirectChildren" res 0 0 ""] "$objName Update_item $UDN $service $object_id \$UPNP_res"
}
Trace CometChoice_PM_P_UPNP_AV_tree Browse_recursively_from
#___________________________________________________________________________________________________________________________________________
method CometChoice_PM_P_UPNP_AV_tree Update_item {UDN service object_id rep} {
	if {[dict exists $rep Result]} {
		set xml [string map [list "&" "&amp;"] [dict get $rep Result]]
		if {[catch {set doc [dom parse $xml]} err]} {
			 puts "Error in $objName CometChoice_PM_P_UPNP_AV_tree::Update_item $UDN $object_id\n$err\n________________________________________\n$xml"
			} else  {set root [$doc documentElement]; set ns_root [$root namespace]
					 # Explore sub containers
					 foreach n [$root selectNodes -namespace [list ns $ns_root] "//ns:container"] {
						 set id    [$n getAttribute id]
						 set title [[$n selectNodes -namespace [list ns $ns_root] "./dc:title"] asText]
						 # Recursive call
						 this Browse_recursively_from $UDN $service ${UDN}_$object_id $id $title
						}
					 # Explore contained items
					 set L_items [list]
					 foreach n [$root selectNodes -namespace [list ns $ns_root] "//ns:item"] {
						 lappend L_items [dict create title [[$n selectNodes -namespace [list ns $ns_root] "./dc:title"] asText] res [[$n selectNodes -namespace [list ns $ns_root] "./ns:res\[last()\]"] asText]]
						}
					 set this(items,${UDN}_$object_id) $L_items
					 # puts "Update_item => $object_id : [llength $L_items] items\n"
					 $doc delete
					}
		}
}
# Trace CometChoice_PM_P_UPNP_AV_tree Update_item
#___________________________________________________________________________________________________________________________________________
method CometChoice_PM_P_UPNP_AV_tree Update_items_with {tree_id} {
	set this(current_tree_id) $tree_id
	$this(tk_L_items) delete 0 end
	if {[info exists this(items,$tree_id)]} {
		 foreach item $this(items,$tree_id) {
			 $this(tk_L_items) insert end [dict get $item title]
			}
		}
}

#___________________________________________________________________________________________________________________________________________
method CometChoice_PM_P_UPNP_AV_tree Display_item_info {i} {
	$this(text_item_descr) configure -state normal
	$this(text_item_descr) delete 0.0 end
	if {[catch {set item [lindex $this(items,$this(current_tree_id)) $i]}]} {set item ""}
	foreach {att val} $item {
		 $this(text_item_descr) insert end "_____________________\n$att :\n"
		 $this(text_item_descr) insert end "$val\n"
		}
	$this(text_item_descr) configure -state disabled
	# catch {this prim_set_currents [dict get $item res]}
}

#___________________________________________________________________________________________________________________________________________
method CometChoice_PM_P_UPNP_AV_tree Choose_item {i} {
	if {![catch {set item [lindex $this(items,$this(current_tree_id)) $i]}]} {
		 this prim_set_currents [dict get $item res]
		}
}

