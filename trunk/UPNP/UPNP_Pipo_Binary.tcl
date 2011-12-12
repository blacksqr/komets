#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Pipo_UPNP_Binary UPNP_device
method Pipo_UPNP_Binary constructor {t metadata L_tag_value} {
	this inherited $t
	set this(metadata)    $metadata
	set this(Status)      0
	
	set this(CU) [CPool get_singleton CometUPNP]

	# Part related to the UPNP device
	 set str_srv [this Generate_control_description_for_service $objName]
	 set f [open $::env(ROOT_COMETS)/Comets/UPNP/__control_${objName}_Binary.php w]
		fconfigure $f -encoding utf-8
		puts $f $str_srv
		close $f
	 set f [open $::env(ROOT_COMETS)/Comets/UPNP/__control_${objName}_Metadata.php w]
		fconfigure $f -encoding utf-8
		puts $f $str_srv
		close $f

	# Events...
	 set str_srv [this Generate_event_description_for_service urn:upnp-org:serviceId:SwitchPower]
	 set f [open $::env(ROOT_COMETS)/Comets/UPNP/__event_${objName}_Binary.php w]
		fconfigure $f -encoding utf-8
		puts $f $str_srv
		close $f
	
	 this Generate_device_description_from_xml_file $::env(ROOT_COMETS)/Comets/UPNP/__device__Binary.xml [list \
																							  controlURL_Binary      __control_${objName}_Binary.php \
																							  controlURL_MetaData    __control_${objName}_Metadata.php \
																					 ]	[list eventURL_access    __event_${objName}_Binary.php \
																						] $L_tag_value
																						

	# Terminate, now publish the device on the network
	after 100 [list $objName send_heartbeat]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_Binary Read_Event_Subscription_from_socket {sock} {
	set service_subscribed [this inherited $sock]
	switch $service_subscribed {
		 urn:upnp-org:serviceId:proxysonos {this Emit_event $service_subscribed [list Nada Nib]}
		}
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_Binary Process_result {mtd ns_res L_res} {
	return [this Process_L_result $mtd $ns_res $L_res]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_Binary GetMetadata {args} {
	return [list _ReturnValue $this(metadata)]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_Binary GetStatus {args} {
	return [list ResultStatus $this(Status)]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_Binary SetTarget {args} {
	set this(Status) $args
	return [list ]
}

