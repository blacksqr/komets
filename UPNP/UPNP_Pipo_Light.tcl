#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Pipo_UPNP_Light UPNP_device
method Pipo_UPNP_Light constructor {t metadata canvas x y} {
	this inherited $t
	set this(metadata) $metadata
	set this(switch)   0
	set this(dimming)  90
	
	# Part related to the UPNP device
	 set str_srv [this Generate_control_description_for_service $objName]
	 set f [open $::env(ROOT_COMETS)/Comets/UPNP/__control_${objName}_SwitchPower.php w]
		fconfigure $f -encoding utf-8
		puts $f $str_srv
		close $f
	 set f [open $::env(ROOT_COMETS)/Comets/UPNP/__control_${objName}_Dimming.php w]
		fconfigure $f -encoding utf-8
		puts $f $str_srv
		close $f
	 set f [open $::env(ROOT_COMETS)/Comets/UPNP/__control_${objName}_Metadata.php w]
		fconfigure $f -encoding utf-8
		puts $f $str_srv
		close $f
		
	# Events...
	 set str_srv [this Generate_event_description_for_service urn:upnp-org:serviceId:Dimming]
	 set f [open $::env(ROOT_COMETS)/Comets/UPNP/__event_${objName}_Dimming.php w]
		fconfigure $f -encoding utf-8
		puts $f $str_srv
		close $f
	 set str_srv [this Generate_event_description_for_service urn:upnp-org:serviceId:SwitchPower]
	 set f [open $::env(ROOT_COMETS)/Comets/UPNP/__event_${objName}_SwitchPower.php w]
		fconfigure $f -encoding utf-8
		puts $f $str_srv
		close $f
	
	 this Generate_device_description_from_xml_file $::env(ROOT_COMETS)/Comets/UPNP/__device__Light.xml [list \
																							  controlURL_SwitchPower  __control_${objName}_SwitchPower.php \
																							  controlURL_Dimming      __control_${objName}_Dimming.php \
																							  controlURL_MetaData     __control_${objName}_Metadata.php \
																					 ]	[list eventURL_SwitchPower    __event_${objName}_SwitchPower.php \
																							  eventURL_Dimming        __event_${objName}_Dimming.php \
																						]
																						

	# Terminate, now publish the device on the network
	after 100 [list $objName send_heartbeat]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_Light Read_Event_Subscription_from_socket {sock} {
	set service_subscribed [this inherited $sock]
	switch $service_subscribed {
		 urn:upnp-org:serviceId:proxysonos {this Emit_event $service_subscribed [list Nada Nib]}
		}
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_Light Process_result {mtd ns_res L_res} {
	return [this Process_L_result $mtd $ns_res $L_res]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_Light GetMetadata {args} {
	return [list _ReturnValue $this(metadata)]
}

XXX.../XXX