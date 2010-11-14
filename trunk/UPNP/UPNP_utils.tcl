package require udp
package require http

set PATH [pwd]
cd {C:\These\Bibliotheques\UPNP_TCL\Debug}
load UPNP_TCL.dll
cd $PATH

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method UPNP_server constructor {} {
 set this(L_devices)      [list]
}

#___________________________________________________________________________________________________________________________________________
method UPNP_server dispose {} {
 this inherited
}

#___________________________________________________________________________________________________________________________________________
method UPNP_server Reset_infos {} {
 set this(L_devices) [list]
}

#___________________________________________________________________________________________________________________________________________
method UPNP_server get_infos {} {
 # puts [list multi_cast_ip $this(multi_cast_ip) multicast_port $this(multicast_port) port [fconfigure $this(socket_server_udp_multicast) -myport]]
 # puts "UDP socket :"
 # puts [fconfigure $this(socket_server_udp_multicast)]
 
 dict for {uuid L_att} $this(L_devices) {
   puts "UUID : $uuid"
   dict for {var val} $L_att {
     puts "\t$var : $val"
    }
  }
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method UPNP_server Device_added {L} {
 puts "$objName Device_added {$L}"
 set UDN [dict get $L UDN]
 if {[dict exists $this(L_devices) $UDN]} {
   set UDN_val [dict merge [dict get $this(L_devices) $UDN] $L]
  } else {set UDN_val [dict create]}
  
 dict set this(L_devices) $UDN $UDN_val
}

#___________________________________________________________________________________________________________________________________________
method UPNP_server Device_removed {L} {
 puts "$objName Device_removed"
}

#___________________________________________________________________________________________________________________________________________
method UPNP_server End_search {} {
 puts "$objName End_search"
}

#___________________________________________________________________________________________________________________________________________
method UPNP_server Send_msg_discovery {} {
 UPNP_listener_start "ssdp:all" "$objName Device_added " "$objName Device_removed " "$objName End_search "
}

