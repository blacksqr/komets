#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Pipo_UPNP_Volet UPNP_device
method Pipo_UPNP_Volet constructor {t metadata canvas x1 y1 x2 y2} {
	this inherited $t
	set this(metadata) $metadata
	set this(Position) Stopped
	
	set this(canvas)     $canvas
		$this(canvas) create rect $x1 $y1 $x2 $y2 -fill #777 -tags [list $objName Pipo_UPNP_Volet Volet]
		
	# Part related to the UPNP device
	 set str_srv [this Generate_control_description_for_service $objName]
	 set f [open $::env(ROOT_COMETS)/Comets/UPNP/__control_${objName}_Volet.php w]
		fconfigure $f -encoding utf-8
		puts $f $str_srv
		close $f
	 set f [open $::env(ROOT_COMETS)/Comets/UPNP/__control_${objName}_Metadata.php w]
		fconfigure $f -encoding utf-8
		puts $f $str_srv
		close $f
		
	# Events...
	 set str_srv [this Generate_event_description_for_service urn:upnp-org:serviceId:TwoWayMotionMotor]
	 set f [open $::env(ROOT_COMETS)/Comets/UPNP/__event_${objName}_Volet.php w]
		fconfigure $f -encoding utf-8
		puts $f $str_srv
		close $f
	
	 this Generate_device_description_from_xml_file $::env(ROOT_COMETS)/Comets/UPNP/__device__Volet.xml [list \
																							  controlURL_Volet     __control_${objName}_Volet.php \
																							  controlURL_MetaData  __control_${objName}_Metadata.php \
																					 ]	[list eventURL_Volet       __event_${objName}_Volet.php \
																						]
																						

	# Terminate, now publish the device on the network
	this update_presentation
	after 100 [list $objName send_heartbeat]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_Volet Read_Event_Subscription_from_socket {sock} {
	set service_subscribed [this inherited $sock]
	switch $service_subscribed {
		 urn:upnp-org:serviceId:TwoWayMotionMotor {this Emit_event $service_subscribed [list Position $this(Position)]}
		 default {puts "In $objName. Subscription to unknown service : $service_subscribed"}
		}  
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_Volet Process_result {mtd ns_res L_res} {
	return [this Process_L_result $mtd $ns_res $L_res]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_Volet GetMetadata {args} {
	return [list _ReturnValue $this(metadata)]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_Volet Open {args} {
	set this(Position) Opened
	this Emit_event urn:upnp-org:serviceId:TwoWayMotionMotor [list Position $this(Position)]
	this update_presentation
	return [list]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_Volet Close {args} {
	set this(Position) Closed
	this Emit_event urn:upnp-org:serviceId:TwoWayMotionMotor [list Position $this(Position)]
	this update_presentation
	return [list]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_Volet Stop {args} {
	set this(Position) Stopped
	this Emit_event urn:upnp-org:serviceId:TwoWayMotionMotor [list Position $this(Position)]
	this update_presentation
	return [list]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_Volet SetPosition {args} {
	set this(Position) $args
	this Emit_event urn:upnp-org:serviceId:TwoWayMotionMotor [list Position $this(Position)]
	this update_presentation
	return [list]
}
 
#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_Volet update_presentation {} {
	set D [dict create Stopped #777 Closed #000 Opened #FFF]
	$this(canvas) itemconfigure $objName -fill [dict get $D $this(Position)]
}
