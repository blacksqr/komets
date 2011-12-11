#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Pipo_UPNP_PresenceZones UPNP_device
method Pipo_UPNP_PresenceZones constructor {t canvas coords metadata {mode_simulation Wizard}} {
	this inherited $t
	set this(metadata)       $metadata
	set this(OccupancyState) Indeterminate
	# Part related to the UPNP device
	 set str_srv [this Generate_control_description_for_service $objName]
	 set f [open $::env(ROOT_COMETS)/Comets/UPNP/__control_${objName}_HouseStatus.php w]
		fconfigure $f -encoding utf-8
		puts $f $str_srv
		close $f
	 set f [open $::env(ROOT_COMETS)/Comets/UPNP/__control_${objName}_Metadata.php w]
		fconfigure $f -encoding utf-8
		puts $f $str_srv
		close $f
	# Events...
	 set str_srv [this Generate_event_description_for_service urn:upnp-org:serviceId:HouseStatus]
	 set f [open $::env(ROOT_COMETS)/Comets/UPNP/__event_${objName}_HouseStatus.php w]
		fconfigure $f -encoding utf-8
		puts $f $str_srv
		close $f
	
	 this Generate_device_description_from_xml_file $::env(ROOT_COMETS)/Comets/UPNP/__scpd_PresenceZone.xml [list \
																							  /upnp/fb9e473a-f276-4930-b511-376d61dd0a3e    __control_${objName}_HouseStatus.php \
																						      /upnp/fb9e473a-f276-4930-b511-376d61dd0a3e    __control_${objName}_Metadata.php \
																					 ]	[list /upnp/Event/fb9e473a-f276-4930-b511-376d61dd0a3e:HouseStatus    __event_${objName}_HouseStatus.php \
																						]
																						
	# Graphic part polygons in the canvas
	set this(canvas) $canvas
	eval "set this(poly_id) \[$canvas create polygon $coords -fill grey\]"
	set this(mode_simulation) $mode_simulation
	switch $mode_simulation {
		 Wizard 	{$canvas bind $this(poly_id) <ButtonPress> "$objName Switch_OccupancyState"
					}
		 Simulation {
					}
		}
	
	
	after 100 [list $objName send_heartbeat]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_PresenceZones Read_Event_Subscription_from_socket {sock} {
	set service_subscribed [this inherited $sock]
	switch $service_subscribed {
		 urn:upnp-org:serviceId:HouseStatus {this Emit_event $service_subscribed [list OccupancyState $this(OccupancyState)]}
		}
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_PresenceZones Process_result {mtd ns_res L_res} {
	return [this Process_L_result $mtd $ns_res $L_res]
}


#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_PresenceZones set_Occupied {b} {
	set L [list Unoccupied Occupied]
	set C [list red green]
	if {$this(OccupancyState) != [lindex $L $b]} {
		 set this(OccupancyState) [lindex $L $b]
		 $this(canvas) itemconfigure $this(poly_id) -fill [lindex $C $b]
		 this Emit_event urn:upnp-org:serviceId:HouseStatus [list OccupancyState $this(OccupancyState)]
		}
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_PresenceZones Simulation_OccupancyState_at {x y} {
	if {$this(mode_simulation) != "Simulation"} {return}
	if {[lsearch [$this(canvas) find overlapping $x $y $x $y] $this(poly_id)] >= 0} {
		 set b 1
		} else {set b 0}

	this set_Occupied $b
}
# Trace Pipo_UPNP_PresenceZones Simulation_OccupancyState_at

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_PresenceZones Switch_OccupancyState {} {
	if {$this(OccupancyState) == "Unoccupied"} {
		 set this(OccupancyState) "Occupied"
		 $this(canvas) itemconfigure $this(poly_id) -fill green
		} else {set this(OccupancyState) "Unoccupied"
			    $this(canvas) itemconfigure $this(poly_id) -fill red
			   }

   # Emit an event
	this Emit_event urn:upnp-org:serviceId:HouseStatus [list OccupancyState $this(OccupancyState)]
}
# Trace Pipo_UPNP_PresenceZones Switch_OccupancyState

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_PresenceZones GetMetadata {args} {
	return [list _ReturnValue $this(metadata)]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_PresenceZones GetOccupancyState {args} {
	return [list CurrentOccupancyState $this(OccupancyState)]
}

