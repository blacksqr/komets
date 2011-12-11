#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Pipo_UPNP_Button UPNP_device
method Pipo_UPNP_Button constructor {t metadata canvas x y {r 15}} {
	this inherited $t
	set this(metadata)     $metadata
	set this(state_button) 0
	
	set this(canvas)     $canvas
		$this(canvas) create rect [expr $x - $r] [expr $y - $r] [expr $x + $r] [expr $y + $r] -fill #777 -tags [list $objName Pipo_UPNP_Button Button]
		incr r -2
		$this(canvas) create oval [expr $x - $r] [expr $y - $r] [expr $x + $r] [expr $y + $r] -fill #9F9 -tags [list $objName Pressoir_$objName Pipo_UPNP_Button Button]
		
		$this(canvas) bind $objName <ButtonPress> "$objName PressButton"
		
	# Part related to the UPNP device
	 set str_srv [this Generate_control_description_for_service $objName]
	 set f [open $::env(ROOT_COMETS)/Comets/UPNP/__control_${objName}_Button.php w]
		fconfigure $f -encoding utf-8
		puts $f $str_srv
		close $f
	 set f [open $::env(ROOT_COMETS)/Comets/UPNP/__control_${objName}_Metadata.php w]
		fconfigure $f -encoding utf-8
		puts $f $str_srv
		close $f
		
	# Events...
	 set str_srv [this Generate_event_description_for_service urn:upnp-org:serviceId:Button]
	 set f [open $::env(ROOT_COMETS)/Comets/UPNP/__event_${objName}_Button.php w]
		fconfigure $f -encoding utf-8
		puts $f $str_srv
		close $f
	
	 this Generate_device_description_from_xml_file $::env(ROOT_COMETS)/Comets/UPNP/__device__Button.xml [list \
																							  controlURL_Button    __control_${objName}_Button.php \
																							  controlURL_MetaData  __control_${objName}_Metadata.php \
																					 ]	[list eventURL_Button      __event_${objName}_Button.php \
																						]
																						

	# Terminate, now publish the device on the network
	after 100 [list $objName send_heartbeat]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_Button Read_Event_Subscription_from_socket {sock} {
	set service_subscribed [this inherited $sock]
	switch $service_subscribed {
		 urn:upnp-org:serviceId:Button {this Emit_event $service_subscribed [list Value $this(state_button)]}
		}  
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_Button Process_result {mtd ns_res L_res} {
	return [this Process_L_result $mtd $ns_res $L_res]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_Button GetMetadata {args} {
	return [list _ReturnValue $this(metadata)]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_Button GetValue {args} {
	return [list RetValue $this(state_button)]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_Button PressButton {} {
	set this(state_button) [expr 1 - $this(state_button)]
	this Emit_event urn:upnp-org:serviceId:Button [list Value $this(state_button)]
}
# Trace Pipo_UPNP_Button PressButton