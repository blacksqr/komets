#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the functionnal core __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometUPNP_PM_FC_intelbased Physical_model

proc CometUPNP_PM_FC_intelbased__Thread_error {id err} {
	puts "Error in thread $id :\n$err"
}

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
 ::thread::errorproc $this(UPNP_thread)
 set cmd "source \$::env(ROOT_COMETS)/Comets/CometUPNP/PMs/FC/IntelBased/pg_thread_UPNP.threaded_tcl;\n UPNP_server $this(port_server)\n"
 ::thread::send $this(UPNP_thread) $cmd
 
 # Server port will be send by the thread once runned
 set this(UPNP_server_port) 0
 
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
method CometUPNP_PM_FC_intelbased Do_a_SSDP_M-SEARCH {} {
	# ::thread::send $this(UPNP_thread) "MSEARCH\n"
	if {$this(UPNP_server_port) != 0} {
		 set s [socket 127.0.0.1 $this(UPNP_server_port)]
		 fconfigure $s -encoding utf-8
		 set msg "CALL MSEARCH"
		 puts $s "[string length $msg] $msg"
		 close $s
		}
}

#___________________________________________________________________________________________________________________________________________
#__________________________________________________________ UPNP eventing __________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_FC_intelbased New_UPNP_eventing_connection {chan ip port} {
	fconfigure $chan -blocking 0 -encoding utf-8
	set this(upnp_eventing_msg_from_$chan) ""
	fileevent  $chan readable [list $objName Eventing_msg $chan 1]
}
# Trace CometUPNP_PM_FC_intelbased New_UPNP_eventing_connection
#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_FC_intelbased Eventing_msg {chan read_chan} {
	if {[eof $chan]} {
		 unset this(upnp_eventing_msg_from_$chan)
		 catch {close $chan}
		} else  {if {$read_chan} {append this(upnp_eventing_msg_from_$chan) [read $chan]}
				 set msg $this(upnp_eventing_msg_from_$chan)
				 # puts "UPNP event:\n$msg\n_______________________________"
				 set pos_entete [string first "\n\n" $msg]
				 if {$pos_entete < 0} {return}
				 set entete [string range $msg 0 $pos_entete]
				 set xml    [string range $msg $pos_entete end]
				 
				 set dict_rep [dict create]
				 foreach line [split $entete "\n"] {
					 set pos [string first " " $line]
					 if {$pos >= 0} {
						 set var [string toupper [string trim [string range $line 0 [expr $pos - 1]]]]
						 set val [string trim [string range $line [expr $pos + 1] end]]
						 dict set dict_rep $var $val
						}
					}
				 # Is there a message Content-Length?
				 if {[dict exists $dict_rep "CONTENT-LENGTH:"]} {
					 # If the xml message does not contain enough byte, cancel...
					 if {[string bytelength $xml] < ([dict get $dict_rep "CONTENT-LENGTH:"]-3)} {
						 puts stderr "not enough bytes in the UPNP message ([dict get $dict_rep CONTENT-LENGTH:] needed), we have [string bytelength $xml] bytes :\n$xml"
						 return
						} 
					} 
				 
				 puts "CometUPNP_PM_FC_intelbased::Eventing_msg"
				 if {[dict exists $dict_rep "SID:"]} {
					 set UUID [dict get $dict_rep "SID:"]
					 if {[info exists this(index_of_UUID,$UUID)] && [info exists this($this(index_of_UUID,$UUID))]} {
						 # puts "dict : [dict get $this($this(index_of_UUID,$UUID)) CB]"
						 foreach {id CB} [dict get $this($this(index_of_UUID,$UUID)) CB] {
							 # puts $CB
							 set CB "$CB [list $xml]"
							 eval $CB
							}
						} else {puts stderr "Variable do not exist for $UUID, let's retry just after we get the SID?"
							    after idle "$objName Eventing_msg $chan 1"
							   }
					} else {puts stderr "No SID in the UPNP eventing message???:\n\tmsg : $msg"}
				 catch {close $chan}
				}
}
# Trace CometUPNP_PM_FC_intelbased Eventing_msg 
#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_FC_intelbased get_eventing_CB {UDN service_id} {
	return [dict get $this(UPNP_eventing_CB,${UDN},${service_id}) CB]
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
method CometUPNP_PM_FC_intelbased UnSubscribe_to_UPNP_events {UDN service_id ID_subscribe} {
	if {[regexp {^http://(.*):(.*)$} [this get_item_of_dict_devices [list $UDN IP_port]] reco IP PORT]} {
		 this Remove_eventing_CB $UDN $service_id $ID_subscribe
		 if {![info exists this(UPNP_eventing_CB,${UDN},${service_id})]} {
			 set event_ad [this get_item_of_dict_devices [list $UDN ServiceList $service_id eventSubURL]]
			 if {[string index $event_ad 0] != "/"} {set event_ad "/$event_ad"}
			 
			 set msg "UNSUBSCRIBE $event_ad HTTP/1.1
HOST: ${IP}:$PORT
SID: [dict get $this(UPNP_eventing_CB,${UDN},${service_id}) UUID]
Content-Length: 0
"
			 set S [socket -async $IP $PORT]
			 fconfigure $S -blocking 0
			 fileevent $S writable "puts $S [list $msg]; close $S;"
			}
		}
}

#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_FC_intelbased Subscribe_to_UPNP_events {UDN service_id ID_subscribe CB} {
	if {![regexp {^http://(.*):(.*)$} [this get_item_of_dict_devices [list $UDN IP_port]] reco IP PORT]} {
		 if {![regexp {^http://(.*)$} [this get_item_of_dict_devices [list $UDN IP_port]] reco IP]} {puts stderr "No port specified in $objName Subscribe_to_UPNP_events $UDN"; return;}
		 set PORT 80
		}
	if {[info exists PORT]} {
		 if {![info exists this(UPNP_eventing_CB,${UDN},${service_id})]} {
			 set event_ad [this get_item_of_dict_devices [list $UDN ServiceList $service_id eventSubURL]]
			 if {![catch {set baseURL [this get_item_of_dict_devices [list $UDN baseURL]]}]} {
				 set pos [string first "/" $baseURL 7]
				 if {$pos >= 0} {
					 if {[string index $baseURL end] != "/" && [string index $event_ad 0] != "/"} {set event_ad "/$event_ad"}
					 if {[string first [string range $baseURL [expr $pos + 1] end] $event_ad] >= 0} {
						 set event_ad $event_ad
						} else {set event_ad [string range $baseURL $pos end]$event_ad}
					} else {if {[string index $event_ad 0] != "/"} {set event_ad "/$event_ad"}}
				} else {if {[string index $event_ad 0] != "/"} {set event_ad "/$event_ad"}
					   }
			 
			 set msg "SUBSCRIBE $event_ad HTTP/1.1
TIMEOUT: Second-10000
HOST: ${IP}:$PORT
CALLBACK: <http://$this(IP):$this(eventing_server_port)>
NT: upnp:event
Content-Length: 0
"
			 # puts "Subscribe message to $IP $PORT:\n$msg"
			 set S [socket -async $IP $PORT]
			 fconfigure $S -blocking 0
			 fileevent $S writable "puts $S [list $msg]; flush $S; fileevent $S writable {}; fileevent $S readable \[list $objName Read_UPNP_subscribe_to_eventing_response $S $UDN $service_id\];"
			}
			
		 this Add_eventing_CB $UDN $service_id $ID_subscribe $CB
		}
}
# Trace CometUPNP_PM_FC_intelbased Subscribe_to_UPNP_events

#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_FC_intelbased Read_UPNP_subscribe_to_eventing_response {S UDN service_id} {
	 set str [read $S]; close $S
	 # puts "_____________________\n$str"
	 set dict_rep [dict create]
	 foreach line [split $str "\n"] {
		 set pos [string first " " $line]
		 if {$pos >= 0} {
			 set var [string toupper [string range $line 0 [expr $pos - 1]]]
			 set val [string range $line [expr $pos + 1] end]
			 dict set dict_rep $var $val
			}
		}
	
	 if {![dict exists $dict_rep "SID:"]} {
		 puts stderr "No SID given by the device for the subscription...\n$str\n"
		 return
		}
	 set UUID [dict get $dict_rep "SID:"]
	 set this(index_of_UUID,$UUID) UPNP_eventing_CB,${UDN},${service_id}
	 dict set this(UPNP_eventing_CB,${UDN},${service_id}) UUID    $UUID
	 if {![dict exists $dict_rep "TIMEOUT:"]} {dict set dict_rep "TIMEOUT:" 1800}
	 set TIMEOUT [dict get $dict_rep "TIMEOUT:"]
		regexp {^Second-(.*)$} $TIMEOUT reco TIMEOUT
	 dict set this(UPNP_eventing_CB,${UDN},${service_id}) TIMEOUT $TIMEOUT
	 
	 # Launch a timer to subscribe again...
	 after [expr [dict get $this(UPNP_eventing_CB,${UDN},${service_id}) TIMEOUT]*1000 - 10000] [list puts "RESUBSCRIBE IS NEEDED FOR $UDN $service_id"]
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
 fileevent $chan readable "if {\[catch {$objName Read_data $chan} err\]} {puts \"Error reading from socket in $objName :\n\$err\"}"
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
		  
		  if {[catch {this new_UPNP_message msg} err]} {puts stderr "ERROR while receiving new message :\n\tmsg : $msg\n\terr : $err\n______stack:\n$::errorInfo"}
		 } else {break}
  }
}

#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_FC_intelbased new_UPNP_message {msg_name} {
 upvar $msg_name msg
 # puts "\tnew_UPNP_message : $msg"; return
 set UDN_val [lassign $msg cmd UDN]
 switch $cmd {
	Device_added     {
					  this prim_set_item_of_dict_devices $UDN $UDN_val
				     }
	Device_removed   {
				      if {[catch {this prim_remove_item_of_dict_devices $UDN} err]} {}
				     }
    M-SEARCH         {
					  this prim_M-SEARCH $UDN
				     }
    UPNP_server_port {set this(UPNP_server_port) $UDN; puts "\n____________________________________________________________________\nUPNP_server_port : $this(UPNP_server_port)"}
	         ERROR   {puts stderr "ERROR from UPNP :\n$msg"}
			 INFOS	 {puts "UPNP $msg"}
	}
}

#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_FC_intelbased get_soap_proxy {UDN service action} {
 set id ${UDN},${service},${action}
 
 # Get the closest service for this UDN
 dict for {s s_val} [this get_item_of_dict_devices "$UDN ServiceList"] {
	 if {[string first $service $s] == 0} {
		 # puts "Service renamed from $service to $s"
		 set service $s
		 break;
		}
	}

 if {![info exists this($id)]} {
	set this(isSOAP_Available_${UDN}_${service}_$action) 1
	set this($id) ${objName}_SOAP_proxy_$id
	set controlURL    [this get_item_of_dict_devices "$UDN ServiceList $service controlURL"]
	if {[string index $controlURL 0] != "/"} {
		 set URL [this get_item_of_dict_devices "$UDN baseURL"]
		} else {set URL [this get_item_of_dict_devices "$UDN IP_port"]
			   }
	if {[string index $URL end] != "/" && [string index $controlURL 0] != "/"} {append URL "/"}
	append URL $controlURL

	set prefix_action [this get_item_of_dict_devices "$UDN ServiceList $service serviceType"]
	set L_params [list]; set this(L_out_params_$this($id)) [list]
	foreach p [this get_children_attributes "$UDN ServiceList $service actions $action"] {
		 if {[this get_item_of_dict_devices "$UDN ServiceList $service actions $action $p direction"] == "in"} {lappend L_params $p ""} else {lappend this(L_out_params_$this($id)) $p}
		}
	# puts "::SOAP::create ${objName}_SOAP_proxy_$id -name $action -params {$L_params} -proxy $URL -uri $prefix_action -action ${prefix_action}#$action"
	::SOAP::create ${objName}_SOAP_proxy_$id -name $action -params $L_params -proxy $URL -uri $prefix_action -action ${prefix_action}#$action -command [list $objName soap_asynchronous_reply $this($id)]
	}
	
 return $this($id) 
}

#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_FC_intelbased soap_asynchronous_reply {soap_proxy_id data} {
	set obj $objName; regexp {^\:\:(.*)$} $obj reco obj
	if {[catch {set soap_rep [::SOAP::dump -reply $soap_proxy_id]} err]} {puts stderr "Error reading SOAP answer"} else {
		 # puts [list $obj soap_reply]
		 if {[catch [list $obj soap_reply $soap_rep $this(CB_for_$soap_proxy_id)] err]} {puts stderr "Error with $obj soap_reply \[::SOAP::dump -reply $soap_proxy_id\] [list $this(CB_for_$soap_proxy_id)]\n\terr : $err"}
		}
	unset this(CB_for_$soap_proxy_id)
	if {$this(next_call_for_$soap_proxy_id) != ""} {
		 # puts "Post call in $obj of $this(next_call_for_$soap_proxy_id)"
		 set cmd [concat $obj soap_call $this(next_call_for_$soap_proxy_id)]
		 if {[catch $cmd err]} {puts "Error while recalling soap action:\n\tcmd : $cmd:\n\terr : $err"}
		}
}
# Trace CometUPNP_PM_FC_intelbased soap_asynchronous_reply

#___________________________________________________________________________________________________________________________________________
Inject_code CometUPNP_PM_FC_intelbased soap_call {} {
 # set S [this get_soap_proxy $UDN $service $action]
 # ::SOAP::configure $S -command "puts "
 # return
 set id ${UDN},${service},${action}
 this get_soap_proxy $UDN $service $action

 if {[info exists this($id)]} {
	if {[info exists this(CB_for_$this($id))]} {
		 # Prepare a next call
		 set this(next_call_for_$this($id)) [list $UDN $service $action $L_params $CB]
		 return
		} else {set this(next_call_for_$this($id)) ""}
	set cmd [concat [list $this($id)] $L_params]
	set this(CB_for_$this($id)) $CB
	if {[catch {set UPNP_res [eval $cmd]} err]} {
		 unset this(CB_for_$this($id))
		 this soap_error_reply [::SOAP::dump -reply $this($id)] $CB
		} else {
				# this soap_reply [::SOAP::dump -reply $this($id)] $CB
			   }
	}
}


#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_FC_intelbased soap_error_reply {xml CB} {
 if {[catch {set doc [dom parse $xml]} err]} {set UPNP_res [list ERROR "$xml\n_____\n$err"]; eval $CB;} else {
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
 
 if {[catch {eval $CB} err]} {puts stderr "Error in the CB of the soap action:\n\t CB : $CB\n\tUPNP_res : $UPNP_res\n\txml : $xml\n\terr : $err"}
}
# Trace CometUPNP_PM_FC_intelbased soap_reply
