#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Proxy_UPNP_Sonos UPNP_device
method Proxy_UPNP_Sonos constructor {L_tag_value t UDN_of_the_target metadata} {
	this inherited $t
	set this(metadata)          $metadata
	set this(UDN_of_the_target) $UDN_of_the_target
	set this(CurrentMute)       1
	
	set this(CU) [CPool get_singleton CometUPNP]

	# Part related to the UPNP device
	 set str_srv [this Generate_control_description_for_service $objName]
	 set f [open $::env(ROOT_COMETS)/Comets/UPNP/__control_${objName}_proxySonos.php w]
		fconfigure $f -encoding utf-8
		puts $f $str_srv
		close $f
	 set f [open $::env(ROOT_COMETS)/Comets/UPNP/__control_${objName}_Metadata.php w]
		fconfigure $f -encoding utf-8
		puts $f $str_srv
		close $f

	# Events...
	 set str_srv [this Generate_event_description_for_service urn:upnp-org:serviceId:proxysonos]
	 set f [open $::env(ROOT_COMETS)/Comets/UPNP/__event_${objName}_proxySonos.php w]
		fconfigure $f -encoding utf-8
		puts $f $str_srv
		close $f
	
	 this Generate_device_description_from_xml_file $::env(ROOT_COMETS)/Comets/UPNP/sonosDeviceDescription.xml [list \
																							  controlURL_access  __control_${objName}_proxySonos.php \
																							  /upnp/fb9e473a-f276-4930-b511-376d61dd0a3e    __control_${objName}_Metadata.php \
																					 ]	[list eventURL_access    __event_${objName}_proxySonos.php \
																						] $L_tag_value
																						

	# Terminate, now publish the device on the network
	after 100 [list $objName send_heartbeat]
}

#___________________________________________________________________________________________________________________________________________
method Proxy_UPNP_Sonos Read_Event_Subscription_from_socket {sock} {
	set service_subscribed [this inherited $sock]
	switch $service_subscribed {
		 urn:upnp-org:serviceId:proxysonos {this Emit_event $service_subscribed [list Nada Nib]}
		}
}

#___________________________________________________________________________________________________________________________________________
method Proxy_UPNP_Sonos Process_result {mtd ns_res L_res} {
	return [this Process_L_result $mtd $ns_res $L_res]
}

#___________________________________________________________________________________________________________________________________________
method Proxy_UPNP_Sonos GetMetadata {args} {
	return [list _ReturnValue $this(metadata)]
}

#___________________________________________________________________________________________________________________________________________
method Proxy_UPNP_Sonos GetMute {args} {
	# <name>InstanceID</name>
	# <direction>in</direction>
	# <name>Channel</name>
	# <direction>in</direction>
	lassign $args InstanceID Channel
	return [list CurrentMute $this(CurrentMute)]
}
Trace Proxy_UPNP_Sonos GetMute
#___________________________________________________________________________________________________________________________________________
method Proxy_UPNP_Sonos SetMute {args} {
	# <name>InstanceID</name>
	# <direction>in</direction>
	# <name>Channel</name>
	# <direction>in</direction>
	# <name>DesiredMute</name>
	# <direction>in</direction>
	lassign $args InstanceID Channel DesiredMute
	set this(CurrentMute) $DesiredMute
	if {[$this(CU) has_item_dict_devices $this(UDN_of_the_target)]} {
		 puts "\t[list $this(CU) soap_call $this(UDN_of_the_target) urn:upnp-org:serviceId:proxysonos SetMute $args {}]"
		 $this(CU) soap_call $this(UDN_of_the_target)_MR urn:upnp-org:serviceId:RenderingControl SetMute $args ""
		}
	return [list ]
}
Trace Proxy_UPNP_Sonos SetMute

#___________________________________________________________________________________________________________________________________________
method Proxy_UPNP_Sonos GetVolume {args} {
          # <name>InstanceID</name>
          # <direction>in</direction>
          # <name>Channel</name>
          # <direction>in</direction>
          # <name>CurrentVolume</name>
          # <direction>out</direction>
		  lassign $args InstanceID Channel
		  return [list ]
}
Trace Proxy_UPNP_Sonos GetVolume

#___________________________________________________________________________________________________________________________________________
method Proxy_UPNP_Sonos SetVolume {args} {
          # <name>InstanceID</name>
          # <direction>in</direction>
          # <name>Channel</name>
          # <direction>in</direction>
          # <name>DesiredVolume</name>
          # <direction>in</direction>
		  lassign $args InstanceID Channel DesiredVolume
		  if {[$this(CU) has_item_dict_devices $this(UDN_of_the_target)]} {
			 puts "\tCalling the original SONOS...SetVolume"
			 $this(CU) soap_call $this(UDN_of_the_target)_MR urn:upnp-org:serviceId:RenderingControl SetVolume $args ""
			}
		  return [list ]
}
Trace Proxy_UPNP_Sonos SetVolume

