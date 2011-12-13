#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Pipo_UPNP_TemperatureDisplay UPNP_device
method Pipo_UPNP_TemperatureDisplay constructor {L_tag_value t metadata canvas x y} {
	this inherited $t
	set this(metadata)    $metadata
	set this(temperature) 12
	
	set this(canvas)     $canvas
		$this(canvas) create rect $x $y $x $y -fill white -tags [list $objName rect_$objName]
		$this(canvas) create text $x $y -anchor nw -font "Arial 26" -justify left -text $this(temperature) -tags [list $objName text_$objName Pipo_UPNP_TemperatureDisplay TemperatureDisplay]
	# Part related to the UPNP device
	 set str_srv [this Generate_control_description_for_service $objName]
	 set f [open $::env(ROOT_COMETS)/Comets/UPNP/__control_${objName}_TemperatureDisplay.php w]
		fconfigure $f -encoding utf-8
		puts $f $str_srv
		close $f
	 set f [open $::env(ROOT_COMETS)/Comets/UPNP/__control_${objName}_Metadata.php w]
		fconfigure $f -encoding utf-8
		puts $f $str_srv
		close $f
		
	# Events...
	 set str_srv [this Generate_event_description_for_service urn:upnp-org:serviceId:TemperatureDisplay]
	 set f [open $::env(ROOT_COMETS)/Comets/UPNP/__event_${objName}_TemperatureDisplay.php w]
		fconfigure $f -encoding utf-8
		puts $f $str_srv
		close $f
	
	 this Generate_device_description_from_xml_file $::env(ROOT_COMETS)/Comets/UPNP/__device__TemperatureDisplay.xml [list \
																							  controlURL_TemperatureDisplay     __control_${objName}_TemperatureDisplay.php \
																							  controlURL_MetaData  __control_${objName}_Metadata.php \
																					 ]	[list eventURL_TemperatureDisplay       __event_${objName}_TemperatureDisplay.php \
																						] $L_tag_value
																						

	# Terminate, now publish the device on the network
	this update_presentation
	after 100 [list $objName send_heartbeat]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_TemperatureDisplay Read_Event_Subscription_from_socket {sock} {
	set service_subscribed [this inherited $sock]
	switch $service_subscribed {
		 urn:upnp-org:serviceId:TemperatureDisplay {this Emit_event $service_subscribed [list Value $this(temperature)]}
		 default {puts "In $objName. Subscription to unknown service : $service_subscribed"}
		}  
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_TemperatureDisplay Process_result {mtd ns_res L_res} {
	return [this Process_L_result $mtd $ns_res $L_res]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_TemperatureDisplay GetMetadata {args} {
	return [list _ReturnValue $this(metadata)]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_TemperatureDisplay GetValue {args} {
	return [list Value $this(temperature)]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_TemperatureDisplay SetValue {args} {
	set this(temperature) $args
	this Emit_event urn:upnp-org:serviceId:TemperatureDisplay [list Value $this(temperature)]
	this update_presentation
	return [list]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_TemperatureDisplay update_presentation {} {
	$this(canvas) itemconfigure text_$objName -text $this(temperature)
	lassign [$this(canvas) bbox text_$objName] x1 y1 x2 y2
	$this(canvas) coords rect_$objName [expr $x1 - 2] [expr $y1 - 2] [expr $x2 + 2] [expr $y2 + 2]
}
