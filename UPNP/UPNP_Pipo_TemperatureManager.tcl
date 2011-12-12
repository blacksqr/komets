#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Pipo_UPNP_TemperatureManager UPNP_device 
method Pipo_UPNP_TemperatureManager constructor {L_tag_value t metadata {dt_temperature_change 1000}} {
	this inherited $t
	set this(metadata)   $metadata
	set this(CurTemp)    12
	set this(TargetTemp) 12
	set this(dt_temperature_change) $dt_temperature_change
	set this(is_going_to_update)    0
			
	# Part related to the UPNP device
	 set str_srv [this Generate_control_description_for_service $objName]
	 set f [open $::env(ROOT_COMETS)/Comets/UPNP/__control_${objName}_TemperatureManager.php w]
		fconfigure $f -encoding utf-8
		puts $f $str_srv
		close $f
	 set f [open $::env(ROOT_COMETS)/Comets/UPNP/__control_${objName}_Metadata.php w]
		fconfigure $f -encoding utf-8
		puts $f $str_srv
		close $f
		
	# Events...
	 set str_srv [this Generate_event_description_for_service urn:upnp-org:serviceId:TempManagerService]
	 set f [open $::env(ROOT_COMETS)/Comets/UPNP/__event_${objName}_TemperatureManager.php w]
		fconfigure $f -encoding utf-8
		puts $f $str_srv
		close $f
	
	 this Generate_device_description_from_xml_file $::env(ROOT_COMETS)/Comets/UPNP/__device__TemperatureManager.xml [list \
																							  controlURL_TemperatureManagement  __control_${objName}_TemperatureManager.php \
																							  controlURL_MetaData               __control_${objName}_Metadata.php \
																					 ]	[list eventURL_TemperatureManagement    __event_${objName}_TemperatureManager.php \
																						] $L_tag_value
																						

	# Terminate, now publish the device on the network
	after 100 [list $objName send_heartbeat]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_TemperatureManager Read_Event_Subscription_from_socket {sock} {
	set service_subscribed [this inherited $sock]
	switch $service_subscribed {
		 urn:upnp-org:serviceId:TempManagerService {this Emit_event $service_subscribed [list CurTemp    $this(CurTemp)]
												    # this Emit_event $service_subscribed [list TargetTemp $this(TargetTemp)]
												   }
		 default {puts "In $objName. Subscription to unknown service : $service_subscribed"}
		}  
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_TemperatureManager Process_result {mtd ns_res L_res} {
	return [this Process_L_result $mtd $ns_res $L_res]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_TemperatureManager GetMetadata {args} {
	return [list _ReturnValue $this(metadata)]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_TemperatureManager GetCurTemp  {args} {
	return [list CurTemp $this(CurTemp)]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_TemperatureManager GetTargetTemp  {args} {
	return [list TargetTemp $this(TargetTemp)]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_TemperatureManager SetTargetTemp {args} {
	set this(TargetTemp) $args
	# this Emit_event urn:upnp-org:serviceId:TempManagerService [list TargetTemp $this(TargetTemp)]
	if {!$this(is_going_to_update)} {this update_temperature}
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_TemperatureManager update_temperature {} {
	set this(is_going_to_update) 1
	set t $this(CurTemp)
	if {$this(CurTemp) < $this(TargetTemp)} {incr this(CurTemp)}
	if {$this(CurTemp) > $this(TargetTemp)} {incr this(CurTemp) -1}
	if {$t != $this(CurTemp)} {
		 this Emit_event urn:upnp-org:serviceId:TempManagerService [list CurTemp $this(CurTemp)]
		 after $this(dt_temperature_change) "$objName update_temperature"
		} else {set this(is_going_to_update) 0}
}
