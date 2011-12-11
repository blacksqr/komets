#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Pipo_UPNP_Light UPNP_device
method Pipo_UPNP_Light constructor {t metadata canvas x y {r 15}} {
	this inherited $t
	set this(metadata)   $metadata
	set this(switch)     0
	set this(LoadLevel)  90
	set this(MinLevel)   0
	
	set this(canvas)     $canvas
		$this(canvas) create oval [expr $x - $r] [expr $y - $r] [expr $x + $r] [expr $y + $r] -fill black -tags [list $objName Pipo_UPNP_Light Light]
		
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
		 urn:upnp-org:serviceId:Dimming     {this Emit_event $service_subscribed [list LoadLevelStatus $this(LoadLevel)]}
		 urn:upnp-org:serviceId:SwitchPower {this Emit_event $service_subscribed [list Status          $this(switch)]}
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

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_Light GetStatus {args} {
	return [list ResultStatus $this(switch)]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_Light GetTarget {args} {
	return [list newTargetValue $this(switch)]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_Light SetTarget {args} {
	set D [dict create 1 1 true 1 0 0 false 0]
	set this(switch) [dict get $D [string tolower $args]]
	this Emit_event urn:upnp-org:serviceId:SwitchPower [list Status          $this(switch)]
	this update_presentation
	return [list]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_Light GetLoadLevelStatus {args} {
	return [list RetLoadLevelStatus $this(LoadLevel)]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_Light GetMinLevel {args} {
	return [list MinLevel $this(MinLevel)]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_Light GetLoadLevelTarget {args} {
	return [list NewLoadLevelTarget $this(LoadLevel)]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_Light SetLoadLevelTarget {args} {
	set this(LoadLevel) $args
	this Emit_event urn:upnp-org:serviceId:Dimming [list LoadLevelStatus $this(LoadLevel)]
	this update_presentation
	return [list]
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_Light update_presentation {} {
	if {$this(switch)} {
		 set i [format %X [expr int(min(99, $this(LoadLevel)) * 0.16)]]
		} else {set i 0}
	
	$this(canvas) itemconfigure $objName -fill #$i${i}0
}
Trace Pipo_UPNP_Light update_presentation