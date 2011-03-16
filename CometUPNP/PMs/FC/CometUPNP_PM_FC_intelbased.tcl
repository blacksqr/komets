#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the functionnal core __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometUPNP_PM_FC_intelbased Physical_model

#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_FC_intelbased constructor {name descr args} {
 this inherited $name $descr
    
 package require SOAP
 package require Thread
 package require tdom

 # Set up the TCP server
 set this(socket_server) [socket -server "$objName New_connection" 0]
 set this(port_server)   [lindex [fconfigure $this(socket_server) -sockname] end]
      
 # Create a new thread and load a UPNP_server inside it
 set this(UPNP_thread) [::thread::create]
 set cmd "source \$::env(ROOT_COMETS)/Comets/CometUPNP/PMs/FC/IntelBased/pg_thread_UPNP.threaded_tcl;\n UPNP_server $this(port_server)\n"
 ::thread::send $this(UPNP_thread) $cmd
 
 # TCP server for eventing
 set this(eventing_server)      [socket -server "$objName New_UPNP_eventing_connection" 0]
 set this(eventing_server_port) [lindex [fconfigure $this(eventing_server) -sockname] end]
 set this(IP) [this get_IP]
 
 # Terminate with configuration's parameters
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometUPNP_PM_FC_intelbased [P_L_methodes_set_CometUPNP] {} {}
Methodes_get_LC CometUPNP_PM_FC_intelbased [P_L_methodes_get_CometUPNP] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters CometUPNP_PM_FC_intelbased [P_L_methodes_set_CometUPNP_COMET_FC_RE]

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_FC_intelbased get_IP {} {
	foreach str [split [exec ipconfig] "\n"] {
		 if {[regexp {IP.*: (.*)$} $str reco IP]} {return $IP}
		}
	return "127.0.0.1"
}

#___________________________________________________________________________________________________________________________________________
#__________________________________________________________ UPNP eventing __________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_FC_intelbased New_UPNP_eventing_connection {chan ip port} {
	fconfigure $chan -blocking 0
	fileevent  $chan readable [list $objName Eventing_msg $chan]
}

#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_FC_intelbased Eventing_msg {chan} {
	if {[eof $chan]} {
		 close $chan
		} else  {set msg [read $chan]
				 set pos_entete [string first "\n\n" $msg]
				 set entete [string range $msg 0 $pos_entete]
				 set xml    [string range $msg $pos_entete end]
				 
				 set dict_rep [dict create]
				 foreach line [split $entete "\n"] {
					 set pos [string first " " $line]
					 if {$pos >= 0} {
						 set var [string range $line 0 [expr $pos - 1]]
						 set val [string range $line [expr $pos + 1] end]
						 dict set dict_rep $var $val
						}
					}
				 # puts "CometUPNP_PM_FC_intelbased::Eventing_msg"
				 if {[dict exists $dict_rep "SID:"]} {
					 set UUID [dict get $dict_rep "SID:"]
					 foreach {id CB} [dict get $this($this(index_of_UUID,$UUID)) CB] {
						 set CB "$CB [list $xml]"
						 # puts "From CometUPNP_PM_FC_intelbased:\n$CB"
						 eval $CB
						}
					}
				}
}

#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_FC_intelbased Add_eventing_CB {UDN service_id ID_subscribe CB} {
	dict set this(UPNP_eventing_CB,${UDN},${service_id}) CB $ID_subscribe $CB
}

#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_FC_intelbased Remove_eventing_CB {UDN service_id ID_subscribe} {
	catch {dict unset this(UPNP_eventing_CB,${UDN},${service_id}) CB $ID_subscribe}
}

#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_FC_intelbased Subscribe_to_UPNP_events {UDN service_id ID_subscribe CB} {
	if {[regexp {^http://(.*):(.*)$} [this get_item_of_dict_devices [list $UDN IP_port]] reco IP PORT]} {
		 if {![info exists this(UPNP_eventing_CB,${UDN},${service_id})]} {
			 set event_ad [this get_item_of_dict_devices [list $UDN ServiceList $service_id eventSubURL]]
			 if {[string index $event_ad 0] != "/"} {set event_ad "/$event_ad"}
			 
			 set msg "SUBSCRIBE $event_ad HTTP/1.1
TIMEOUT: Second-10000
HOST: ${IP}:$PORT
CALLBACK: <http://$this(IP):$this(eventing_server_port)>
NT: upnp:event
Content-Length: 0
"
			 set S [socket -async $IP $PORT]
			 fconfigure $S -blocking 0
			 fileevent $S writable "puts $S [list $msg]; flush $S; fileevent $S writable {}; fileevent $S readable \[list $objName Read_UPNP_subscribe_to_eventing_response $S $UDN $service_id\];"
			}
			
		 this Add_eventing_CB $UDN $service_id $ID_subscribe $CB
		}
}

#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_FC_intelbased Read_UPNP_subscribe_to_eventing_response {S UDN service_id} {
	 set str [read $S]; close $S
	 # puts "_____________________\n$str"
	 set dict_rep [dict create]
	 foreach line [split $str "\n"] {
		 set pos [string first " " $line]
		 if {$pos >= 0} {
			 set var [string range $line 0 [expr $pos - 1]]
			 set val [string range $line [expr $pos + 1] end]
			 dict set dict_rep $var $val
			}
		}
	
	 if {![dict exists $dict_rep "SID:"]} {return}
	 set UUID [dict get $dict_rep "SID:"]
	 set this(index_of_UUID,$UUID) UPNP_eventing_CB,${UDN},${service_id}
	 dict set this(UPNP_eventing_CB,${UDN},${service_id}) UUID    $UUID
	 if {![dict exists $dict_rep "TIMEOUT:"]} {dict set dict_rep "TIMEOUT:" 1800}
	 dict set this(UPNP_eventing_CB,${UDN},${service_id}) TIMEOUT [dict get $dict_rep "TIMEOUT:"]
}
# Trace CometUPNP_PM_FC_intelbased Read_UPNP_subscribe_to_eventing_response

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_FC_intelbased New_connection {chan ad num} {
 # puts "$objName New_connection $chan $ad $num"
 
 fconfigure $chan -blocking 0
   set this(${chan},msg) ""
   set this(${chan},msg_attended_length) -1
 fileevent $chan readable "$objName Read_data $chan"
 # fileevent $chan readable "P $chan"

}
 proc P {chan} {puts "$chan : [read $chan]"}

 
#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_FC_intelbased Read_data {chan} {
 append this(${chan},msg) [read $chan]
 
 while {1} {
	 if {$this(${chan},msg_attended_length) == -1} {
		   set pos [string first " " $this(${chan},msg)]
		   if {$pos > 0} {
			 set this(${chan},msg_attended_length) [string range $this(${chan},msg) 0 [expr $pos - 1]]
			 set this(${chan},msg)                 [string range $this(${chan},msg) [expr $pos + 1] end]
			}
		 }

	 # Enough information to read the UPNP message ?
	 if {$this(${chan},msg_attended_length) >= 0 && [string length $this(${chan},msg)] >= $this(${chan},msg_attended_length)} {
		  set msg [string range $this(${chan},msg) 0 [expr $this(${chan},msg_attended_length) - 1]]
		  set this(${chan},msg) [string range $this(${chan},msg) $this(${chan},msg_attended_length) end]
		  set this(${chan},msg_attended_length) -1
		  
		  if {[catch {this new_UPNP_message msg} err]} {puts "ERROR while receiving new message :\n\tmsg : $msg\n\terr : $err"}
		 } else {break}
  }
}

#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_FC_intelbased new_UPNP_message {msg_name} {
 upvar $msg_name msg
 # puts "\tnew_UPNP_message"
 set UDN_val [lassign $msg cmd UDN]
 switch $cmd {
	Device_added   {
					this prim_set_item_of_dict_devices $UDN $UDN_val
				   }
	Device_removed {
				    if {[catch {this prim_remove_item_of_dict_devices $UDN} err]} {}
				   }
	         ERROR {puts "ERROR :\n$msg"}
	}
}

#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_FC_intelbased get_soap_proxy {UDN service action} {
 set id ${UDN},${service},${action}
 if {![info exists this($id)]} {
    set IP_port       [this get_item_of_dict_devices "$UDN IP_port"]
	set controlURL    [this get_item_of_dict_devices "$UDN ServiceList $service controlURL"]
	set URL $IP_port
		if {[string index $URL end] != "/" && [string index $controlURL 0] != "/"} {append URL "/"}
		append URL $controlURL
	set prefix_action [this get_item_of_dict_devices "$UDN ServiceList $service serviceType"]
	set L_params [list]
	foreach p [this get_children_attributes "$UDN ServiceList $service actions $action"] {
		 if {[this get_item_of_dict_devices "$UDN ServiceList $service actions $action $p direction"] == "in"} {lappend L_params $p ""}
		}
	set this($id) ${objName}_SOAP_proxy_$id
	::SOAP::create $this($id) -name $action -params $L_params -proxy $URL -uri $prefix_action -action ${prefix_action}#$action
	}
	
 return $this($id) 
}

#___________________________________________________________________________________________________________________________________________
Inject_code CometUPNP_PM_FC_intelbased soap_call {} {
 # set S [this get_soap_proxy $UDN $service $action]
 # ::SOAP::configure $S -command "puts "
 # return
 
 this get_soap_proxy $UDN $service $action
 set id ${UDN},${service},${action}
 if {[info exists this($id)]} {
	set cmd [concat [list $this($id)] $L_params]
	if {[catch {set UPNP_res [eval $cmd]} err]} {
		 this soap_error_reply [::SOAP::dump -reply $this($id)] $CB
		} else {this soap_reply [::SOAP::dump -reply $this($id)] $CB}
	}
}


#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_FC_intelbased soap_error_reply {xml CB} {
 if {[catch {set doc [dom parse $xml]} err]} {set UPNP_res [list ERROR $xml]; eval $CB;} else {
	set UPNP_res [list]
	set root [$doc documentElement]; set ns_root [$root namespace]
	foreach res [$root selectNodes -namespace [list ns $ns_root] "//ns:Body/ns:Fault/detail/*"] {
		 set UPNP_res [list ERROR [$res asText]]
		 eval $CB
		}
	$doc delete
	}
}

#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_FC_intelbased soap_reply {xml CB} {
 set doc [dom parse $xml]; 
	set UPNP_res [list]
	set root [$doc documentElement]; set ns_root [$root namespace]
	foreach res [$root selectNodes -namespace [list ns $ns_root] "//ns:Body/*"] {
		 set ns_response [$res namespace]
		 foreach node [$res selectNodes -namespace [list ns $ns_response] "./*"] {lappend UPNP_res [$node nodeName] [$node text]}
		}
 $doc delete
 
 eval $CB
}

