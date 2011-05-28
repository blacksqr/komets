#___________________________________________________________________________________________________________________________________________
inherit CometUPNP_PM_P_tk_tree PM_TK
#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_P_tk_tree constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id FUI_CometUPNP_PM_P_tk_tree
      
   set this(img_device) [image create photo -file $::env(ROOT_COMETS)/Comets/CometUPNP/PMs/icon_device2.png]
   set this(tree_id) 0
 eval "$objName configure $args"
}

#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_P_tk_tree get_or_create_prims {root} {
# Define the handle
 set this(tk_root) $root.tk_root_${objName}
 
 if {![winfo exists $this(tk_root)]} {
	 ttk::panedwindow $this(tk_root) -orient horizontal
	 set this(frame_tree) [frame $this(tk_root).f_tree]; pack $this(frame_tree) -expand 0 -fill y
	 set this(tree)    [ttk::treeview $this(frame_tree).tree   ]; pack $this(tree)    -side left -fill both -expand 1
	 set this(sb_tree) [scrollbar     $this(frame_tree).sb -orient vert]; pack $this(sb_tree) -fill y -expand 1
		$this(tree)    configure -yscrollcommand "$this(sb_tree) set"
		$this(sb_tree) configure -command "$this(tree) yview"
	 set this(f_infos) [frame         $this(tk_root).f_infos]; pack $this(f_infos) -side top -fill both -expand 1
	 set this(f_for_widgets) [frame $this(f_infos).f]; pack $this(f_for_widgets)
	
	 $this(tk_root) add $this(frame_tree)
	 $this(tk_root) add $this(f_infos)
	 
	 this Add_MetaData PRIM_STYLE_CLASS [list $this(tree) "NAVIGATION TREE INFORMATION" $this(f_infos) "PARAM IN ACTION"]
	 foreach {UDN UDN_val} [this get_dict_devices] {
		 this set_item_of_dict_devices $UDN $UDN_val
		}

	 # Define the popup menu for UPNP devices
	 if {[winfo exists ._popupMenu_UPNP_$objName]} {destroy ._popupMenu_UPNP_$objName}
	 set this(UPNP_popupmenu) [menu ._popupMenu_UPNP_$objName]
	 $this(UPNP_popupmenu) add command -label "M-SEARCH" -command [list $objName prim_Do_a_SSDP_M-SEARCH]
	 
	 bind $this(tree) <3> "tk_popup $this(UPNP_popupmenu) %X %Y"
		
	 # Define the popup menu for selecting values in devices and services descriptions
	 global item_value_selection_in_$objName
	 if {[winfo exists ._popupMenu_item_selection_$objName]} {destroy ._popupMenu_item_selection_$objName}
	 set this(popupmenu) [menu ._popupMenu_item_selection_$objName]
	 $this(popupmenu) add command -label "Copy value to clipboard" -command "clipboard clear; clipboard append \$item_value_selection_in_$objName"
	} 
 this set_root_for_daughters $this(tk_root)
 return [this set_prim_handle $this(tk_root)]
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometUPNP_PM_P_tk_tree [P_L_methodes_set_CometUPNP] {} {}
Methodes_get_LC CometUPNP_PM_P_tk_tree [P_L_methodes_get_CometUPNP] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters CometUPNP_PM_P_tk_tree [P_L_methodes_set_CometUPNP_COMET_RE_LP]

#___________________________________________________________________________________________________________________________________________
Inject_code CometUPNP_PM_P_tk_tree set_item_of_dict_devices {} {
	if {[winfo exists $this(tk_root)]} {
		 set UDN $keys
		 set parent_UDN [this get_item_of_dict_devices [list $UDN parent_UDN]]
		 if {$parent_UDN != $UDN} {set parent_id $parent_UDN} else {set parent_id ""}
		 
		 # Search position to insert
		 set pos_insert 0; set L_UDN_name [list [list $UDN [this get_item_of_dict_devices [list $UDN friendlyName]]]]
		 foreach U [$this(tree) children ""] {
			 lappend L_UDN_name [list $U [this get_item_of_dict_devices [list $U friendlyName]]]
			}
		 
		 set L_UDN_name [lsort -index 1 -ascii $L_UDN_name]
		 set pos_insert [lsearch -index 0 $L_UDN_name $UDN]
		 
		 if {[$this(tree) exists $UDN]} {$this(tree) delete $UDN}
		 if {$parent_id != "" && ![$this(tree) exists $parent_id]} {
			 this set_item_of_dict_devices $parent_id ""
			}
		 $this(tree) insert $parent_id $pos_insert -id $UDN -tags $UDN -image $this(img_device) -text [this get_item_of_dict_devices [list $UDN friendlyName]]
		 $this(tree) tag bind $UDN <ButtonPress-1> [list $objName Display_UDN $UDN]
		 foreach {service_id service_descr} [this get_item_of_dict_devices [list $UDN ServiceList]] {
			 set s_id ${UDN}_$service_id 
			 $this(tree) insert $UDN end -id $s_id -tags $s_id -text $service_id
			 $this(tree) tag bind $s_id <ButtonPress-1> [list $objName Display_service $UDN $service_id]
			 foreach {action_id action_descr} [this get_item_of_dict_devices [list $UDN ServiceList $service_id actions]] {
				 set a_id ${UDN}_${service_id}_${action_id}
				 $this(tree) insert $s_id end -id $a_id -tags $a_id -text $action_id
				 $this(tree) tag bind $a_id <ButtonPress-1> [list $objName Display_action $UDN $service_id $action_id]
				}
			}
		}
} __TK_UPDATE__

#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_P_tk_tree Display_UDN {UDN} {
	destroy $this(f_for_widgets)
	frame $this(f_for_widgets); pack $this(f_for_widgets) -expand 1 -fill both
	
	foreach e [list UDN LocationURL Timeout deviceType friendlyName modelDescription modelName modelURL presentationURL baseURL IP_port] {
		 if {[dict exists [this get_dict_devices] $UDN $e]} {
			 set value [dict get [this get_dict_devices] $UDN $e]
			 set f [frame $this(f_for_widgets).f_$e]; pack $f -fill x; 
			 set l [label ${f}._lab -anchor w  -text "$e : $value"]; pack $l -side left -expand 1 -fill x
			 # contextual menu
			 bind $l <3> "set item_value_selection_in_$objName \[list $value\]; tk_popup $this(popupmenu) %X %Y"
			}
		}
}

#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_P_tk_tree Display_service {UDN s_id} {
	destroy $this(f_for_widgets)
	frame $this(f_for_widgets); pack $this(f_for_widgets) -expand 1 -fill both

	foreach e [list serviceType serviceId SCPDURL controlURL eventSubURL] {
		 if {[dict exists [this get_dict_devices] $UDN ServiceList $s_id $e]} {
			 set value [dict get [this get_dict_devices] $UDN ServiceList $s_id $e]
			 set f [frame $this(f_for_widgets).f_$e]; pack $f -fill x; 
			 set l [label ${f}._lab -anchor w -text "$e : $value"]; pack $l -side left -expand 1 -fill x
			 # contextual menu
			 bind $l <3> "set item_value_selection_in_$objName \[list $value\]; tk_popup $this(popupmenu) %X %Y"
			}
		}
}

#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_P_tk_tree Display_action {UDN s_id a_id} {
	destroy $this(f_for_widgets)
	frame $this(f_for_widgets); pack $this(f_for_widgets) -expand 1 -fill both
	set i 0; set cmd [list $objName prim_soap_call $UDN $s_id $a_id]; append cmd " \[list "
	foreach {param val} [this get_item_of_dict_devices [list $UDN ServiceList $s_id actions $a_id]] {
		 set f [frame $this(f_for_widgets).f$i]; pack $f -fill x;
		 set l [label ${f}._l_$param -text $param]; pack $l -side left
		 set state_variable [this get_item_of_dict_devices [list $UDN ServiceList $s_id stateVariables [dict get $val relatedStateVariable]]]
		 if {[dict get $val direction] == "in"} {
			 if {[dict get $state_variable allowedValues] == ""} {
				 set e [entry ${f}._e_$param]; pack $e -side right -expand 1 -fill x
				 append cmd "\[$e get\] "
				} else {set var CometUPNP_PM_P_tk_tree_${UDN}_${s_id}_${a_id}_$param
					    eval "tk_optionMenu ${f}._e_$param $var [dict get $state_variable allowedValues]"
						global $var; set $var [lindex [dict get $state_variable allowedValues] 0]
						pack ${f}._e_$param -fill x -expand 1
						append cmd "\${$var} "
					   }
			} else {if {[dict get $state_variable dataType] == "string"} {
					  pack $f -expand 1 -fill both 
					  set e [text ${f}._t_$param -state disabled -background "#ece9d8" -height 1 -width 3]; pack $e -fill both -expand 1 -side left
					  set this(e_$param) [list text $e]
					  set sb [scrollbar ${f}.sb -orient vert]; pack $sb -fill y -expand 1
						  $e    configure -yscrollcommand "$sb set"
						  $sb configure -command "$e yview"
					 } else {set e [entry ${f}._t_$param -state disabled]; pack $e -fill x -expand 1
							 set this(e_$param) [list entry $e]
							}
				   }
		 incr i
		}
    append cmd "\] \"$objName update_outputs \\\$UPNP_res\""; 
	button $this(f_for_widgets).bt -text Trigger -command $cmd; pack $this(f_for_widgets).bt -side right
}

#___________________________________________________________________________________________________________________________________________
Inject_code CometUPNP_PM_P_tk_tree remove_item_of_dict_devices {} {
	if {[winfo exists $this(tk_root)]} {
		 $this(tree) delete $UDN
		}
} __TK_UPDATE__

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_P_tk_tree get_a_unique_tree_id {} {incr this(tree_id); return $this(tree_id)}

#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_P_tk_tree update_outputs {UPNP_res} {
	if {[lindex $UPNP_res 0] == "ERROR"} {
		 tk_messageBox -type ok -detail [lindex $UPNP_res 1] -message ERROR
		 return
		}
	foreach {var val} $UPNP_res {
		 lassign $this(e_$var) type tk_w
		 $tk_w configure -state normal
		 switch $type {
			 text  {$tk_w delete 0.0 end
				    $tk_w insert 0.0 $val
				   }
			 entry {$tk_w delete 0 end
				    $tk_w insert 0 $val
				   }
			}
		  $tk_w configure -state disabled
		}
}


