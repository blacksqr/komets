#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ D�finition of the functionnal core __________________________________________________
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
		  
		  this new_UPNP_message msg
		 } else {break}
  }
}

#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_FC_intelbased new_UPNP_message {msg_name} {
 upvar $msg_name msg
 # puts "\tnew_UPNP_message"
 set UDN_val [lassign $msg cmd UDN]
 switch $cmd {
	Device_added   {puts "\tAdd $UDN"
					this prim_set_item_of_dict_devices $UDN $UDN_val
				   }
	Device_removed {this prim_remove_item_of_dict_devices $UDN}
	         ERROR {puts "ERROR :\n$msg"}
	}
}

#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_FC_intelbased get_soap_proxy {UDN service action} {
 set id ${UDN},${service},${action}
 if {![info exists this($id)]} {
    set baseURL       [this get_item_of_dict_devices "$UDN baseURL"]
	set controlURL    [this get_item_of_dict_devices "$UDN ServiceList $service controlURL"]
	set URL $baseURL
		if {[string index $URL end] != "/" && [string index $controlURL 0] != "/"} {append URL "/"}
		append URL $controlURL
	set prefix_action [this get_item_of_dict_devices "$UDN ServiceList $service serviceType"]
	set L_params [list]
	foreach p [this get_children_attributes "$UDN ServiceList $service actions $action"] {
		 if {[this get_item_of_dict_devices "$UDN ServiceList $service actions $action $p direction"] == "in"} {lappend L_params $p ""}
		}
	set this($id) ${objName}_SOAP_proxy_$id
	::SOAP::create $this($id) -name $action -params $L_params -proxy $URL -action ${prefix_action}#$action
	}
	
 return $this($id) 
}

#___________________________________________________________________________________________________________________________________________
Inject_code CometUPNP_PM_FC_intelbased soap_call {} {
 this get_soap_proxy $UDN $service $action
 set id ${UDN},${service},${action}
 if {[info exists this($id)]} {
	set cmd [concat [list $this($id)] $L_params]
	if {[catch {set UPNP_res [eval $cmd]} err]} {
	     puts "error $err"
		 this soap_error_reply [::SOAP::dump -reply $this($id)] $CB
		} else {this soap_reply [::SOAP::dump -reply $this($id)] $CB}
	}
}
#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_FC_intelbased soap_error_reply {xml CB} {
 set doc [dom parse $xml]
	set UPNP_res [list]
	set root [$doc documentElement]; set ns_root [$root namespace]; puts "$root $ns_root"
	foreach res [$root selectNodes -namespace [list ns $ns_root] "//ns:Body/ns:Fault/detail/*"] {
		 set UPNP_res [list ERROR [$res asText]]
		 eval $CB
		}
 #$doc delete
}

#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_FC_intelbased soap_reply {xml CB} {
	# puts $xml
	
 set doc [dom parse $xml]
	set UPNP_res [list]
	set root [$doc documentElement]; set ns_root [$root namespace]
	foreach res [$root selectNodes -namespace [list ns $ns_root] "//ns:Body/*"] {
		 set ns_response [$res namespace]
		 foreach node [$res selectNodes -namespace [list ns $ns_response] "./*"] {lappend UPNP_res [$node nodeName] [$node text]}
		}
 $doc delete
 
 eval $CB
}
