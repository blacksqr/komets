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

 # Set up the TCP server
 set this(socket_server) [socket -server [list $objName New_connection] 0]
 set this(port_server)   [[fconfigure $this(socket_server) -sockname] end]
      
 # Create a new thread and load a UPNP_server inside it
 # XXX
 
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
 fconfigure $chan -blocking 0
   set this(${chan},msg) ""
   set this(${chan},msg_attended_length) -1
 fileevent $chan readable "$objName Read_data $chan"

 lappend this(clients) $chan
}

#___________________________________________________________________________________________________________________________________________
method CometUPNP_PM_FC_intelbased Read_data {chan} {
 append this(sock_data) [read $sock]
 
 while {1} {
	 if {$this(${chan},msg_attended_length) == -1} {
		   set pos [string first " " $this(sock_data)]
		   if {$pos > 0} {
			 set this(${chan},msg_attended_length) [string range $this(sock_data) 0 [expr $pos - 1]]
			 set this(${chan},msg)                 [string range $this(sock_data) [expr $pos + 1] end]
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

}

