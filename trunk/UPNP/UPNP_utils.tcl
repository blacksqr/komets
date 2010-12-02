package require http
package require tdom
package require Thread

set PATH [pwd]
# cd {C:\These\Projet Interface\COMETS\devCOMETS\Comets\UPNP\Intel_UPNP_TCL\Debug}
# load Intel_UPNP_TCL.dll
# cd {C:\These\Bibliotheques\UPNP_TCL\Debug}
# load UPNP_TCL.dll
cd $PATH

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method UPNP_server constructor {} {
 set this(L_devices)      [list]
 set this(L_threads)      [list]
 
 set this(var_synchro) ""
 
 set this(UPNP_thread) ""
 set this(mutex)       [::thread::mutex create]
 

 set f [open "$::env(ROOT_COMETS)/Comets/UPNP/pg_thread_UPNP.threaded_tcl" r]; set this(pg_thread_UPNP) [read $f]; close $f
 append this(pg_thread_UPNP) [list INTEL_UPNP_listener_start_sync "upnp:rootdevice" "Device_added $this(mutex) " "Device_removed $this(mutex) " ""]
 
 # this Observer 1000
 puts ""
}

#___________________________________________________________________________________________________________________________________________
method UPNP_server dispose {} {
 this inherited
}

#___________________________________________________________________________________________________________________________________________
method UPNP_server Observer {{t 0}} {
 puts "$objName Observer"
 if {$this(UPNP_thread) != ""} {
	 # ::thread::mutex lock $this(mutex)
	 # puts "\tLock"
	 lassign [::thread::send $this(UPNP_thread) get_L_added_and_removed] L_added L_removed
	 puts "Current UPNP state : \n\tAdded : $L_added\n\tRemoved : $L_removed"
	 # ::thread::mutex unlock $this(mutex)
	}
	
 if {$t > 0} {after $t [list $objName Observer $t]}
}

#___________________________________________________________________________________________________________________________________________
method UPNP_server Reset_infos {} {
 set this(L_devices) [list]
}

#___________________________________________________________________________________________________________________________________________
method UPNP_server get_L_devices {} {return $this(L_devices)}
#___________________________________________________________________________________________________________________________________________
method UPNP_server get_infos {} {
 # puts [list multi_cast_ip $this(multi_cast_ip) multicast_port $this(multicast_port) port [fconfigure $this(socket_server_udp_multicast) -myport]]
 # puts "UDP socket :"
 # puts [fconfigure $this(socket_server_udp_multicast)]
 
 set L_devices $this(L_devices)
 dict for {UDN UDN_val} $L_devices {
   puts "UDN : $UDN"
   if {![dict exists $UDN_val xml_description]} {
	 if {[dict exists $UDN_val LocationURL]} {
	   if {[dict exists $UDN_val http_token]} {
	     set token [dict get $UDN_val http_token]
	     if {[llength $token]==1 && [::http::status $token] != ""} {
		   puts "Error with token $token :\n\tstatus : [::http::status $token]\n\terror : [::http::error $token]"
		   dict set UDN_val http_token [list $token [::http::status $token]]
		   dict set this(L_devices) $UDN $UDN_val
		   ::http::cleanup $token
		  }
		}
	   
	   if {![info exists token]} {
	     set url [dict get $UDN_val LocationURL]
	     puts "________getting xml description $url"
        if {[catch {set token [::http::geturl $url -command [list $objName set_xml_description $UDN] -timeout 5000]} err]} {
		   dict set UDN_val http_token [list ERROR getting url $url]
		   dict set this(L_devices) $UDN $UDN_val
		  } else {puts "\t$objName set_xml_description $UDN $token"
				  dict set UDN_val http_token $token
				  dict set this(L_devices) $UDN $UDN_val
				  unset token
				 }
		}
	  }
    }

   dict for {var val} $UDN_val {
     puts "\t$var : $val"
    }
  }
}

#___________________________________________________________________________________________________________________________________________
method UPNP_server get_infos {} {
 set L_devices $this(L_devices)
 dict for {UDN UDN_val} $L_devices {
   puts "UDN : $UDN"
   dict for {var val} $UDN_val {
     puts "\t$var : $val"
    }
  }
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method UPNP_server release_a_thread {tid} {
  if {[lsearch $this(L_threads) $tid] == -1} {
    lappend this(L_threads) $tid
   }
}

#___________________________________________________________________________________________________________________________________________
method UPNP_server get_a_thread {} {
  if {[llength $this(L_threads)]} {
    set this(L_threads) [lassign $this(L_threads) rep]
   } else {set rep [::thread::create]}
  
  return $rep
}

#___________________________________________________________________________________________________________________________________________
method UPNP_server Thread_loaded {UDN tid args} {
 global last_info;

 set last_info "$objName Thread_loaded :: begin"
 dict set this(L_devices) $UDN Thread_id $tid
 set last_info "$objName Thread_loaded :: end"
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method UPNP_server Device_added {L} {
 ::thread::mutex lock $this(mutex)
 set UDN [dict get $L UDN]
 regexp {^uuid:(.*)$} $UDN reco UDN
 if {[dict exists $L LocationURL]} {set new_location 1} else {set new_location 0}
 
 if {$new_location && [dict exists $this(L_devices) $UDN]} {
   set UDN_val [dict get $this(L_devices) $UDN]
   if {[dict exists $UDN_val LocationURL]} {
	 if {[dict get $UDN_val LocationURL] == [dict get $L LocationURL]} {set new_location 0}
	}
   set UDN_val [dict merge $UDN_val $L]
  } else {set UDN_val $L}

 # Update the list  
 dict set this(L_devices) $UDN $UDN_val

 # Thread the loading of the related XML document
 if {$new_location} {
   # Create or get a thread to ask for a 
   set tid [this get_a_thread]
   ::thread::send $tid $this(pg_load_xml) V
   dict set this(L_devices) $UDN Thread_id $tid
   
   lappend this(var_synchro) $UDN $tid
  }
  
 ::thread::mutex unlock $this(mutex)
}

#___________________________________________________________________________________________________________________________________________
method UPNP_server set_description_from_thread {UDN v_name args} {
 ::thread::mutex lock $this(mutex)
 puts "$objName set_description_from_thread $UDN $v_name"
 global $v_name
 if {[catch {set doc [dom parse [subst $$v_name]]} err]} {
   puts "Error parsing xml from $UDN : \n$err"
   ::thread::mutex unlock $this(mutex)
   return
  }
  
 set root [$doc documentElement]
 set ns   [$root namespaceURI]
 
 set UDN_val [dict replace [dict get $this(L_devices) $UDN] dom_doc $doc]
 set this(L_devices) [dict replace $this(L_devices) $UDN $UDN_val]

 foreach node_device [$root selectNodes -namespaces [list ns $ns] "//ns:device"] {
   # puts "\t$objName Add_device_from_dom $UDN $ns $node_device"
   if {[catch {this Add_device_from_dom $UDN $ns $node_device} err]} {
     puts "\t\tERROR $err"
    }
  } 
  
 ::thread::mutex unlock $this(mutex)
}
 
#___________________________________________________________________________________________________________________________________________
method UPNP_server Add_device_from_dom {parent_UDN ns node_device} {
 set node_UDN [$node_device selectNodes -namespaces [list ns $ns] "ns:UDN"]
 if {[llength $node_UDN] == 1} {set UDN [$node_UDN asText]} else {puts "ERROR"; error "Pas d'UDN trouvé dans le noeud $node_device !!!"; return}

 regexp {^uuid:(.*)$} $UDN reco UDN
 
 if {[dict exists $this(L_devices) $UDN]} {set UDN_val [dict get $this(L_devices) $UDN]} else {set UDN_val [dict create]}

 dict set UDN_val xml_description 1
 dict set UDN_val parent_UDN $parent_UDN
 
 foreach att [list deviceType friendlyName modelDescription modelName modelURL URLBase presentationURL] {
   set node [$node_device selectNodes -namespaces [list ns $ns] "ns:$att"]
   if {[llength $node] == 1} {set UDN_val [dict replace $UDN_val $att [$node asText]]}
  }
 set node [lindex [$node_device selectNodes -namespaces [list ns $ns] "ns:serviceList"]]
	if {[llength $node] == 1} {set UDN_val [dict replace $UDN_val tcl_dom_serviceList $node]}
 
 set this(L_devices) [dict replace $this(L_devices) $UDN $UDN_val]
 
 return $UDN_val
}

#___________________________________________________________________________________________________________________________________________
method UPNP_server Device_removed {L} {
 set UDN [dict get $L UDN]
 regexp {^uuid:(.*)$} $UDN reco UDN
 set UDN_val [dict get $this(L_devices) $UDN]
 if {[dict exists $UDN_val dom_doc]} {
   set dom_doc [dict get $UDN_val dom_doc]
   # DEBUG? : Appelé par un autre thread, la destruction du doc pourrait être problématique car http pas multithread...
   $dom_doc delete
  }
 set this(L_devices) [dict remove $this(L_devices) $UDN]
}

#___________________________________________________________________________________________________________________________________________
method UPNP_server End_search {} {
}

#___________________________________________________________________________________________________________________________________________
method UPNP_server Send_msg_discovery {} {
 # set urn "upnp:rootdevice"
 # set urn "ssdp:all"

 if {$this(UPNP_thread) == ""} {
   set this(UPNP_thread) [::thread::create]
   ::thread::send -async $this(UPNP_thread) $this(pg_thread_UPNP) V
   puts "\tUPNP client started in thread $this(UPNP_thread)"
  } else {puts "\tUPNP client has already been started"}
}


