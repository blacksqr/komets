#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Proxy_UPNP_Sonos UPNP_device
method Proxy_UPNP_Sonos constructor {t UDN_of_the_target metadata} {
	this inherited $t
	set this(metadata)          $metadata
	set this(UDN_of_the_target) $UDN_of_the_target

	# Part related to the UPNP device
	 set str_srv [this Generate_control_description_for_service $objName]
	 set f [open $::env(ROOT_COMETS)/Comets/UPNP/__control_${objName}_proxySonos.php w]
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
																					 ]	[list eventURL_access    __event_${objName}_proxySonos.php \
																						]
																						

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
method Proxy_UPNP_Sonos GetOccupancyState {args} {
	return [list CurrentOccupancyState $this(OccupancyState)]
}

      # <name>GetMute</name>
      # <argumentList>
        # <argument>
          # <name>InstanceID</name>
          # <direction>in</direction>
          # <relatedStateVariable>
          # A_ARG_TYPE_InstanceID</relatedStateVariable>
        # </argument>
        # <argument>
          # <name>Channel</name>
          # <direction>in</direction>
          # <relatedStateVariable>
          # A_ARG_TYPE_MuteChannel</relatedStateVariable>
        # </argument>
        # <argument>
          # <name>CurrentMute</name>
          # <direction>out</direction>
          # <relatedStateVariable>Mute</relatedStateVariable>
        # </argument>
      # </argumentList>
    # </action>
    # <action>
      # <name>SetMute</name>
      # <argumentList>
        # <argument>
          # <name>InstanceID</name>
          # <direction>in</direction>
          # <relatedStateVariable>
          # A_ARG_TYPE_InstanceID</relatedStateVariable>
        # </argument>
        # <argument>
          # <name>Channel</name>
          # <direction>in</direction>
          # <relatedStateVariable>
          # A_ARG_TYPE_MuteChannel</relatedStateVariable>
        # </argument>
        # <argument>
          # <name>DesiredMute</name>
          # <direction>in</direction>
          # <relatedStateVariable>Mute</relatedStateVariable>
        # </argument>
      # </argumentList>
    # </action>
    # <action>
      # <name>GetVolume</name>
      # <argumentList>
        # <argument>
          # <name>InstanceID</name>
          # <direction>in</direction>
          # <relatedStateVariable>
          # A_ARG_TYPE_InstanceID</relatedStateVariable>
        # </argument>
        # <argument>
          # <name>Channel</name>
          # <direction>in</direction>
          # <relatedStateVariable>
          # A_ARG_TYPE_Channel</relatedStateVariable>
        # </argument>
        # <argument>
          # <name>CurrentVolume</name>
          # <direction>out</direction>
          # <relatedStateVariable>Volume</relatedStateVariable>
        # </argument>
      # </argumentList>
    # </action>
    # <action>
      # <name>SetVolume</name>
      # <argumentList>
        # <argument>
          # <name>InstanceID</name>
          # <direction>in</direction>
          # <relatedStateVariable>
          # A_ARG_TYPE_InstanceID</relatedStateVariable>
        # </argument>
        # <argument>
          # <name>Channel</name>
          # <direction>in</direction>
          # <relatedStateVariable>
          # A_ARG_TYPE_Channel</relatedStateVariable>
        # </argument>
        # <argument>
          # <name>DesiredVolume</name>
          # <direction>in</direction>
          # <relatedStateVariable>Volume</relatedStateVariable>
        # </argument>
      # </argumentList>
    # </action>
