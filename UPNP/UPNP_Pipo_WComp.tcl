#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Pipo_WComp UPNP_device
method Pipo_WComp constructor {t} {
	this inherited $t
	# Part related to the UPNP device
	 set str_srv [this Generate_control_description_for_service $objName]
	 set f [open $::env(ROOT_COMETS)/Comets/UPNP/__control_${objName}_AddAA.php w]
		fconfigure $f -encoding utf-8
		puts $f $str_srv
		close $f
	 set f [open $::env(ROOT_COMETS)/Comets/UPNP/__control_${objName}_SelectAA.php w]
		fconfigure $f -encoding utf-8
		puts $f $str_srv
		close $f
	 this Generate_device_description_from_xml_file $::env(ROOT_COMETS)/Comets/UPNP/__scpd_PIPOWCOMP.xml [list _urn:upnp-org:serviceId:AddAA_control    __control_${objName}_AddAA.php \
																						   _urn:upnp-org:serviceId:SelectAA_control __control_${objName}_SelectAA.php \
																					 ]
	# Part related to the UPNP metadatas
	set this(CU) [CPool get_singleton CometUPNP]
	set this(dico_UDN_metadata) [dict create]
	$this(CU) Subscribe_to_set_item_of_dict_devices $objName "$objName New_UPNP_device \$keys \$val"
	dict for {k v} [$this(CU) get_dict_devices] {
		 if {[catch {this New_UPNP_device $k $v} err]} {puts stderr "Problem adding a device registered in the CometUPNP (UDN is $k):\n$err"}
		}
	
	# Part related to the WComp pipotronic
		# The dictionnary is indexed by rules id. A rule is composed of a condition and an action, stored in a dictionnary also
		# A condition is a set of UPNP device that have to be present
		# An action is a TCL programm
		set this(D_rules) [dict create]
		
}

#___________________________________________________________________________________________________________________________________________
method Pipo_WComp soap_call {UDN service_id action L_params CB} {
	if {[catch {$this(CU) soap_call $UDN $service_id $action $L_params $CB} err]} {
		 puts stderr "Error calling soap action inside $objName soap_call :\n\tUDN : $UDN\n\tservice_id : $service_id\n\taction : $action\n\tL_params : $L_params\n\tCB : $CB\n\terr : $err"
		}
}

#___________________________________________________________________________________________________________________________________________
method Pipo_WComp New_UPNP_device {k v} {
	if {[llength $k] == 1} {
		 set rep [$this(CU) Search_UDN_service_action [list {UDN} "\$UDN == \"$k\""] \
											 [list serviceId {$serviceId == "urn:upnp-org:serviceId:Metadata"}] \
											 [list "" {$D_name == "GetMetadata"}]	]
		 if {[llength $rep]} {
			 # Call the GetMetadata action
			 this soap_call $k "urn:upnp-org:serviceId:Metadata" "GetMetadata" [list] "$objName Add_device_and_metadata [list $k] \$UPNP_res"
			}
		}
}

#___________________________________________________________________________________________________________________________________________
method Pipo_WComp Add_device_and_metadata {UDN UPNP_res} {
	set metadata ""
	if {[dict exists $UPNP_res  ReturnValue]} {set metadata [dict get $UPNP_res  ReturnValue]}
	if {[dict exists $UPNP_res _ReturnValue]} {set metadata [dict get $UPNP_res _ReturnValue]}
	if {$metadata == ""} {return}
	set D_metadata [dict create]
	foreach varval [split $metadata "&"] {
		 lassign [split $varval "="] var val
		 dict set D_metadata [string trim $var] [string trim $val]
		}
	dict set this(dico_UDN_metadata) $UDN $D_metadata
	
	# Check wether this UDN is part of a AA rule condition or not...if yes, apply the AA rule
	dict for {rule_name rule_val} $this(D_rules) {
		 dict for {var val} [dict get $rule_val condition] {
			 set L_UDN [this get_L_UDN_having_metadata $val]
			 if {[lsearch $L_UDN $UDN] >= 0} {this Apply_rule $rule_name}
			}
		}
}

#___________________________________________________________________________________________________________________________________________
method Pipo_WComp Process_result {mtd ns_res res} {
	set doc [dom createDocument doc]
	set root [$doc createElementNS s Envelope]
		$root setAttribute xmlns         "http://schemas.xmlsoap.org/soap/envelope/"
		$root setAttribute encodingStyle "http://schemas.xmlsoap.org/soap/encoding/"
		set n_body [$doc createElement Body]; $root appendChild $n_body
			set n_mtd [$doc createElement $mtd]; $n_body appendChild $n_mtd
				$n_mtd setAttribute xmlns $ns_res
	set rep [$root asXML]
	$doc delete
	
	return $rep
}

#___________________________________________________________________________________________________________________________________________
method Pipo_WComp get_L_UDN_having_metadata {metadata} {
	set D_metadata [dict create]
	foreach varval [split $metadata "&"] {
		 lassign [split $varval "="] var val
		 dict set D_metadata [string trim $var] [string trim $val]
		}
	return [this get_L_UDN_having_D_metadata $D_metadata]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_WComp get_L_UDN_having_D_metadata {D_metadata} {
	set L_rep [list]
	dict for {UDN DM} $this(dico_UDN_metadata) {
		 # Has this UDN the required metadatas?
		 set has_metadatas 1
		 dict for {var val} $D_metadata {
			 if {![dict exists $DM $var]} {set has_metadatas 0; break;}
			 if {[dict get $DM $var] != $val} {set has_metadatas 0; break;}
			}
		 if {$has_metadatas} {lappend L_rep $UDN}
		}
	return $L_rep
}

#___________________________________________________________________________________________________________________________________________
method Pipo_WComp AddAA {str} {
	lassign $str rule_name D_rule
	dict set D_rule is_selected 0
	dict set this(D_rules) $rule_name $D_rule
	this Apply_rule $rule_name
}
Trace Pipo_WComp AddAA

#___________________________________________________________________________________________________________________________________________
method Pipo_WComp Apply_rule {rule_name} {
	set D [dict get $this(D_rules) $rule_name]
	set D_vars [dict create]
	dict for {var val} [dict get $D condition] {
		 set $var [this get_L_UDN_having_metadata $val]
		 puts "\t$var : [subst $$var]"
		 dict set D_vars $var [set $var]
		}
	eval [dict get $D action]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_WComp SelectAA {str} {
	lassign $str rule_name is_selected
	if {[catch {dict set this(D_rules) $rule_name is_selected $is_selected} err]} {puts stderr "Error while selecting an AA : \n\t$objName SelectAA [list $str]\n\terr : $err"}
}
Trace Pipo_WComp SelectAA

#___________________________________________________________________________________________________________________________________________
method Pipo_WComp OnEvent {rule_name L_UDN var_name CB D_vars} {
	foreach UDN $L_UDN {
		 set service_id [$this(CU) get_service_having_variable $UDN $var_name]
		 $this(CU) Subscribe_to_UPNP_events $UDN $service_id $rule_name [list $objName Trigger_CB_after_event $rule_name $var_name $D_vars $CB]
		}
}
# Trace Pipo_WComp OnEvent
#___________________________________________________________________________________________________________________________________________
method Pipo_WComp Trigger_CB_after_event {rule_name var_name D_vars CB event} {
	set found_var_name 0
	dict for {var val} $D_vars {set $var $val}
	# Create variables packed inside the event notification
	if {[catch {set doc [dom parse [string trim $event]]} err]} {puts stderr "Error parsing the UPNP event in objName Trigger_CB_after_event:\n\trule_name : $rule_name\n\tD_vars : $D_vars\n\tCB : $CB\n\tevent : $event"} else {
		 set root [$doc documentElement]; set ns_root [$root namespace]
		 foreach p [$root selectNodes -namespace [list ns $ns_root] "//ns:property/*"] {
			 set [$p nodeName] [$p asText]
			 if {[$p nodeName] == $var_name} {set found_var_name 1}
			}
		 $doc delete	
		}
	if {$found_var_name} {
		 if {[catch {eval $CB} err]} {puts stderr "Error inside the callback of $rule_name :\n\terr : $err"}
		}
}
# Trace Pipo_WComp Trigger_CB_after_event

#___________________________________________________________________________________________________________________________________________
method Pipo_WComp OnEvents {rule_name L_UDN_var_name CB D_vars} {
	set this(MultiInput_for_$rule_name) [dict create]
	foreach {UDN var_name} $L_UDN_var_name {
		 if {$UDN == ""} {continue}
		 set service_id [$this(CU) get_service_having_variable $UDN $var_name]
		 dict set this(MultiInput_for_$rule_name) $var_name defined 0
		 dict set this(MultiInput_for_$rule_name) $var_name service $service_id
		 if {$service_id != ""} {
			 if {[catch {$this(CU) Subscribe_to_UPNP_events $UDN $service_id $rule_name [list $objName MultiInput_Trigger_CB_after_event $rule_name $var_name $D_vars $CB]} err]} {
				 puts stderr "Error during subscription in OnEvents $rule_name :\n\tUDN : $UDN\n\tservice : $service_id\n\terr : $err"
				}
			}
		}
}
# Trace Pipo_WComp OnEvents
#___________________________________________________________________________________________________________________________________________
method Pipo_WComp MultiInput_Trigger_CB_after_event {rule_name var_name D_vars CB event} {
	# Set the value upcoming inside the dictionnary
	set found_var_name 0
	dict for {var val} $D_vars {set $var $val}
	
	# Create variables packed inside the event notification
	if {[catch {set doc [dom parse [string trim $event]]} err]} {puts stderr "Error parsing the UPNP event in objName Trigger_CB_after_event:\n\trule_name : $rule_name\n\tD_vars : $D_vars\n\tCB : $CB\n\tevent : $event"} else {
		 set root [$doc documentElement]; set ns_root [$root namespace]
		 foreach p [$root selectNodes -namespace [list ns $ns_root] "//ns:property/*"] {
			 set [$p nodeName] [$p asText]
			 if {[$p nodeName] == $var_name} {
				 set found_var_name 1
				 dict set this(MultiInput_for_$rule_name) $var_name defined 1
				 dict set this(MultiInput_for_$rule_name) $var_name value [set $var_name]
				}
			}
		 $doc delete	
		}

	# If the variable is defined and all values are defined, trigger the callback
	if {$found_var_name} {
		 set CB_processable 1
		 dict for {var var_descr} $this(MultiInput_for_$rule_name) {
			 if {![dict get $var_descr defined]} {
				  puts "\tVariable $var is not defined..."
				  set CB_processable 0
				  break
				 } else {set $var [dict get $var_descr value]}
			}
		 
		 # Trigger Callback?
		 if {$CB_processable} {if {[catch {eval $CB} err]} {puts stderr "Error inside the callback of MultiInput rule $rule_name :\n\terr : $err"}}
		}
}
# Trace Pipo_WComp MultiInput_Trigger_CB_after_event