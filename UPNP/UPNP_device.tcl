if {[catch {package require uuid} err]} {
	exec teacup install uuid 
	package require uuid
}
if {[catch {package require  udp} err]} {
	exec teacup install  udp 
	package require  udp
}
package require tdom

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method UPNP_device constructor {timeout} {
	set this(timeout)      $timeout
	set this(uuid)         [::uuid::uuid generate]
	set this(D_events)     [dict create]	
	
	if {![info exists class(ip)]} {set class(ip) [this get_IP]}
	
	set this(udp_sock)     [udp_open]
	fconfigure $this(udp_sock) -buffering none -blocking 0
	fconfigure $this(udp_sock) -mcastadd "239.255.255.250" -remote [list "239.255.255.250" 1900]
	fconfigure $this(udp_sock) -encoding utf-8 -translation {lf crlf}
	# fconfigure $this(udp_sock) -encoding utf-8
	
	# Open TCP server for SOAP actions management
	set this(tcp_server)      [socket -server "$objName New_connection " 0]
	set this(tcp_server_port) [lindex [fconfigure $this(tcp_server) -sockname] end]

	# Open TCP server for EVENT management
	set this(Event_tcp_server)      [socket -server "$objName New_Event_connection " 0]
	set this(Event_tcp_server_port) [lindex [fconfigure $this(Event_tcp_server) -sockname] end]


	set this(C_UPNP)          [CPool get_singleton CometUPNP]
	$this(C_UPNP) Subscribe_to_M-SEARCH $objName [list $objName Received_M-SEARCH]
	
	set this(description_ready) 0
	
}

#___________________________________________________________________________________________________________________________________________
method UPNP_device get_IP {} {
	set rep "127.0.0.1"
	foreach str [split [exec ipconfig] "\n"] {
		 if {[regexp {IPv4.*: (.*)$} $str reco IP]} {return $IP}
		 if {[regexp {IP.*: (.*)$}   $str reco IP]} {set rep $IP}
		}
	return $rep
}

#___________________________________________________________________________________________________________________________________________
method UPNP_device dispose {} {
	# Send byebye SSDP messages
	foreach {NT USN} [list  upnp:rootdevice  uuid:$this(uuid)::upnp:rootdevice \
							uuid:$this(uuid) uuid:$this(uuid) \
							urn:schemas-upnp-org:device:Sample:1 uuid:$this(uuid)::urn:schemas-upnp-org:device:Sample:1
					 ] {
		 set msg	"NOTIFY * HTTP/1.1
HOST: 239.255.255.250:1900
NTS: ssdp:byebye
USN: $USN
NT: $NT
Content-Length: 0\n\n"
		 puts -nonewline $this(udp_sock) $msg
		 flush $this(udp_sock)
		}

	# Unsubscribe from Comet UPNP
	$this(C_UPNP) UnSubscribe_to_M-SEARCH $objName
	
	# Close sockets
	if {[catch {close $this(tcp_server); close $this(udp_sock)} err]} {
		 puts "Error while disposing $objName:\n$err"
		}
	
	this inherited
}

#___________________________________________________________________________________________________________________________________________
method UPNP_device Received_M-SEARCH {} {
	this send_heartbeat 0
}
# Trace UPNP_device Received_M-SEARCH

#___________________________________________________________________________________________________________________________________________
method UPNP_device Emit_event {service L_var_val} {
	if {[dict exists $this(D_events) $service]} {
		 dict for {uuid D_CB} [dict get $this(D_events) $service] {
			 if {![dict exists $D_CB CALLBACK]} {continue}
			 set CALLBACK [lindex [dict get $D_CB CALLBACK] 0]
			 if {$CALLBACK == ""} {continue}
			 
			 set    content ""
			 append content {<?xml version="1.0" encoding="utf-8"?>} "\n"
			 append content {<e:propertyset xmlns:e="urn:schemas-upnp-org:event-1-0">} "\n"
			 foreach {var val} $L_var_val {
				 append content {<e:property>} "\n"
				 append content "<${var}>" {<![CDATA[} $val {]]>} "</${var}>\n"
				 append content {</e:property>} "\n"
				}
			 append content  {</e:propertyset>} "\n"
			 
			 set    entete "NOTIFY $CALLBACK HTTP/1.1\n"
			 append entete "NTS:  upnp:propchange\n"
			 append entete "NT:  upnp:event\n"
			 append entete "CONNECTION:  close\n"
			 append entete "SEQ:  [dict get $D_CB SEQ]\n"
			 append entete "CONTENT-TYPE:  text/xml\n"
			 append entete "SID:  $uuid\n"
			 append entete "HOST:  [dict get $D_CB IP]:[dict get $D_CB PORT]\n"
			 append entete "Content-Length: [string bytelength $content]\n\n"
			 
			 if {[catch {set sock [socket [dict get $D_CB IP] [dict get $D_CB PORT]]} err]} {
				 puts stderr "Error with socket connection [list socket [dict get $D_CB IP] [dict get $D_CB PORT]]"
				} else {fconfigure $sock -encoding utf-8
						# puts "Send event : $entete$content"
						puts -nonewline $sock $entete$content
						close $sock
					   }
			 
			 # update SEQ
			 dict set this(D_events) $service $uuid SEQ [expr 1+[dict get $D_CB SEQ]]
			}
		}
}
# Trace UPNP_device Emit_event

#___________________________________________________________________________________________________________________________________________
method UPNP_device New_Event_connection {sock ad port} {
	global reading_sock_$sock 
	set this(data_$sock) ""; set this(size_$sock) -1
	fconfigure $sock -blocking 0 -encoding utf-8 -translation {lf crlf}
	fileevent  $sock readable [list $objName Read_Event_Subscription_from_socket $sock]
}

#___________________________________________________________________________________________________________________________________________
method UPNP_device Read_Event_Subscription_from_socket {sock} {
	if {[eof $sock]} {close $sock; return}
	append this(data_$sock) [read $sock]
	if {$this(size_$sock) == -1} {
		 set pos  [string first " " $this(data_$sock)]
		 set pos2 [string first " " $this(data_$sock) [expr $pos + 1]]
		 set pos3 [string first " " $this(data_$sock) [expr $pos2 + 1]]
		 if {$pos != -1 && $pos2 != -1 && $pos3 != -1} {
			 set size_comet_name   [string range $this(data_$sock) 0 [expr $pos - 1]]
			 set this(service_$sock) [string range $this(data_$sock) [expr $pos + 1] [expr $pos2 - 1]]
			 set this(size_$sock)  [string range $this(data_$sock) [expr $pos2 + 1] [expr $pos3 - 1]]
			 set this(data_$sock)  [string range $this(data_$sock) [expr $pos3 + 1] end]
		    }
		}
	
	set service_subscribed ""
	# puts "Event Received?________________\n$this(data_$sock)\n_______________________________________"
	
	# puts "Waiting $this(size_$sock) bytes, received [string length $this(data_$sock)] bytes.\n$this(data_$sock)"
	if {$this(size_$sock) != -1 && [string length $this(data_$sock)] >= $this(size_$sock)} {
		 # puts "$objName Read_Event_Subscription_from_socket:______________\n$this(data_$sock)\n_____________________________________________________"
		 foreach line [split $this(data_$sock) "\n"] {
			 set pos_: [string first ":" $line]
			 if {${pos_:} >= 0} {
				 set var_name [string trim [string range $line 0 [expr ${pos_:} - 1]]]
				 set val      [string trim [string range $line [expr ${pos_:} + 1] end]]
				 set [string toupper $var_name] $val
				}
			}
		 # How long is the subscription time in seconds?
		 regexp {^ *Second\-(.*)$} $TIMEOUT reco TIMEOUT
		 
		 # Get the callback, register it and send back an identifier
		 if {![info exists SID]} {set uuid [::uuid::uuid generate]} else {set uuid $SID}
		 if {[info exists CALLBACK]} {
			 # puts "\tCALLBACK: $CALLBACK"
			 regexp {^< *(.*) *>$} $CALLBACK reco CALLBACK
			 set L [list]; foreach CB [split $CALLBACK ","] {lappend L [string trim $CB]}; set CALLBACK $L
			 dict set this(D_events) $this(service_$sock) $uuid CALLBACK $CALLBACK
			 set CALLBACK [lindex $CALLBACK 0]
			 if {[regexp {^http://(.*)$} $CALLBACK reco IP_PORT]} {
				 set pos [string first $IP_PORT "/"]; if {$pos == -1} {set pos end} else {incr pos -1}
				 lassign [split [string range $IP_PORT 0 $pos] ":"] IP PORT
				 if {$PORT == ""} {set PORT 80}
				 dict set this(D_events) $this(service_$sock) $uuid IP   $IP
				 dict set this(D_events) $this(service_$sock) $uuid PORT $PORT
				 dict set this(D_events) $this(service_$sock) $uuid SEQ  0
				}
			 set service_subscribed $this(service_$sock)
			}
		 dict set this(D_events) $this(service_$sock) $uuid TIMEOUT  $TIMEOUT
		 
		 set rep "SID: $uuid
TIMEOUT: Second-$TIMEOUT"
		 puts $sock $rep
		 close $sock
		}
		
	return $service_subscribed
}

#___________________________________________________________________________________________________________________________________________
method UPNP_device New_connection {sock ad port} {
	global reading_sock_$sock 
	set this(data_$sock) ""; set this(size_$sock) -1
	fconfigure $sock -blocking 0 -encoding utf-8 -translation {lf crlf}
	fileevent  $sock readable [list $objName Read_from_socket $sock]
}

#___________________________________________________________________________________________________________________________________________
method UPNP_device Process_result {mtd ns_res res} {
	set doc [dom createDocument doc]
	set root [$doc createElementNS s Envelope]
		$root setAttribute xmlns         "http://schemas.xmlsoap.org/soap/envelope/"
		$root setAttribute encodingStyle "http://schemas.xmlsoap.org/soap/encoding/"
		set n_body [$doc createElement Body]; $root appendChild $n_body
			set n_mtd [$doc createElement $mtd]; $n_body appendChild $n_mtd
				$n_mtd setAttribute xmlns $ns_res
				set n_result [$doc createElement Result]; $n_mtd appendChild $n_result
					$n_result appendChild [$doc createTextNode $res]
	set rep [$root asXML]
	$doc delete
	
	return $rep
}


#___________________________________________________________________________________________________________________________________________
method UPNP_device Process_L_result {mtd ns_res L_res} {
	set doc [dom createDocument doc]
	set root [$doc createElementNS s Envelope]
		$root setAttribute xmlns         "http://schemas.xmlsoap.org/soap/envelope/"
		$root setAttribute encodingStyle "http://schemas.xmlsoap.org/soap/encoding/"
		set n_body [$doc createElement Body]; $root appendChild $n_body
			set n_mtd [$doc createElement $mtd]; $n_body appendChild $n_mtd
				$n_mtd setAttribute xmlns $ns_res
				if {[catch {
				foreach {res_var res_val} $L_res {
					 if {[catch {set n_result [$doc createElement $res_var]; $n_mtd appendChild $n_result
								 $n_result appendChild [$doc createTextNode $res_val]
								} err]} {puts stderr "Error during the generation of te UPNP device answer:\n\tdevice : $objName\n\tres_var : $res_var\n\tres_val : $res_val"}
					}
				} err]} {puts stderr "Error in the foreach of UPNP result arguments:\n\tL_res : $L_res"}
	set rep [$root asXML]
	$doc delete
	
	return $rep
}


#___________________________________________________________________________________________________________________________________________
method UPNP_device Read_from_socket {sock} {
	if {[eof $sock]} {close $sock; return}
	append this(data_$sock) [read $sock]
	if {$this(size_$sock) == -1} {
		 set pos  [string first " " $this(data_$sock)]
		 set pos2 [string first " " $this(data_$sock) [expr $pos + 1]]
		 set pos3 [string first " " $this(data_$sock) [expr $pos2 + 1]]
		 if {$pos != -1 && $pos2 != -1 && $pos3 != -1} {
			 set size_comet_name   [string range $this(data_$sock) 0 [expr $pos - 1]]
			 set this(comet_$sock) [string range $this(data_$sock) [expr $pos + 1] [expr $pos2 - 1]]
			 set this(size_$sock)  [string range $this(data_$sock) [expr $pos2 + 1] [expr $pos3 - 1]]
			 set this(data_$sock)  [string range $this(data_$sock) [expr $pos3 + 1] end]
		    }
		}
	
	# puts "Waiting $this(size_$sock) bytes, received [string length $this(data_$sock)] bytes.\n$this(data_$sock)"
	if {$this(size_$sock) != -1 && [string length $this(data_$sock)] >= $this(size_$sock)} {
		 # Interpret command and send back result
		 if {[catch {set doc [dom parse $this(data_$sock)]} err]} {puts stderr "Error parsing xml :\n$err\n_____\n$this(data_$sock)"} else {
			set root [$doc documentElement]; set ns_root [$root namespace]
			foreach res [$root selectNodes -namespace [list ns $ns_root] "//ns:Body/*"] {
				 set mtd [lindex [$res asList] 0]
				 set pos [string first ":" $mtd]; if {$pos >= 0} {set mtd [string range $mtd [expr $pos + 1] end]}
				 set cmd [list $this(comet_$sock) $mtd]
				 set ns_res [$res namespace]
				 foreach n_att [$res selectNodes -namespace [list ns $ns_root rns $ns_res] "//ns:Body/rns:$mtd/*"] {
					 # puts "\tatt : [$n_att asList]"
					 lappend cmd [$n_att asText]
					}
				}
			 $doc delete
			 if {[catch {set eval_res [eval $cmd]} err]} {
			     set eval_res "Error in UPNP device $objName while evaluating a SOAP action:\n\tSOAP action : $cmd\n\terr : $err"
				}
			 
			 # Send back result
			 puts $sock [this Process_result $mtd $ns_res $eval_res]
			}
		 close $sock
		}
}

#___________________________________________________________________________________________________________________________________________
method UPNP_device send_heartbeat {{again 1}} {
	if {$this(description_ready)} {
	foreach {NT USN} [list  upnp:rootdevice  uuid:$this(uuid)::upnp:rootdevice \
							uuid:$this(uuid) uuid:$this(uuid) \
							urn:schemas-upnp-org:device:Sample:1 uuid:$this(uuid)::urn:schemas-upnp-org:device:Sample:1
					 ] {
	set msg "NOTIFY * HTTP/1.1
NT: $NT
USN: $USN
HOST: 239.255.255.250:1900
NTS: ssdp:alive
SERVER: COMETs
LOCATION: http://$class(ip)/Comets/UPNP/${objName}.xml
CACHE-CONTROL: max-age=$this(timeout)
Content-Length: 0\n\n"

		puts -nonewline $this(udp_sock) $msg
		flush $this(udp_sock)
	}
	}
	
	if {$again} {after [expr 1000*$this(timeout)/3] "catch {$objName send_heartbeat}"}
}

#___________________________________________________________________________________________________________________________________________
method UPNP_device Generate_device_description_for_comets {L_Comets} {
	set str {<?xml version="1.0" encoding="utf-8"?>
<root xmlns="urn:schemas-upnp-org:device-1-0">
   <specVersion>
      <major>1</major>
      <minor>0</minor>
   </specVersion>
}
	append str "\t<URLBase>http://$class(ip)/Comets/UPNP/</URLBase>\n"
	append str "\t<device>\n"
	
	# Generate the file containing the device description
	foreach {var val} [list deviceType "urn:schemas-upnp-org:device:Sample:1" \
							friendlyName "Comet proxy" \
							manufacturer "PRIMA" \
							manufacturerURL "http://iihm.imag.fr/demeure" \
							modelDescription "Proxy used to access COMETs" \
							modelName "Automatically-Generated COMET Device" \
							modelNumber "COMET v1" \
							presentationURL "http://$class(ip)/index.php" \
							UDN uuid:$this(uuid) \
					  ] {
		 append str "\t\t<${var}>${val}</${var}>\n"
		}
	
	# Generate the files for each COMET seen as a service, complete also the device description
	append str "\t\t<serviceList>\n"
		# Public utility service
		
		# Services related to semantic API of COMETs
		foreach comet $L_Comets {
			 append str "\t\t\t<service>\n"
			 foreach {att_var att_val} [list serviceType "urn:schemas-upnp-org:service:$comet:1" \
											 serviceId   "urn:upnp-org:serviceId:$this(uuid):$comet" \
											 SCPDURL     "__scpd_${comet}.xml" \
											 controlURL  "__control_${comet}.php" \
											 eventSubURL "__event_${comet}" \
									   ] {append str "\t\t\t\t<${att_var}>${att_val}</${att_var}>\n"
										  set f [open $::env(ROOT_COMETS)/Comets/UPNP/__scpd_${comet}.xml w]
											fconfigure $f -encoding utf-8
											puts $f [this Generate_service_description_for_comet $comet]
										  close $f
										  set f [open $::env(ROOT_COMETS)/Comets/UPNP/__control_${comet}.php w]
											fconfigure $f -encoding utf-8
											puts $f [this Generate_control_description_for_comet $comet]
										  close $f
										 }
			 append str "\t\t\t</service>\n"
			}
			
	append str "\t\t</serviceList>\n"
	
	# Finish the string, close the tags
	append str {   </device>
</root>
}

	# Save description in a file?
	set f_name ${objName}.xml
	set f [open $::env(ROOT_COMETS)/Comets/UPNP/$f_name w]
		fconfigure $f -encoding utf-8
		puts $f $str
	close $f
	
	set this(description_ready) 1
	
	# Return the result string
	return $str
}


#___________________________________________________________________________________________________________________________________________
method UPNP_device Generate_service_description_for_comet {C} {
	set str {<?xml version="1.0" encoding="utf-8"?>
<scpd xmlns="urn:schemas-upnp-org:service-1-0">
  <specVersion> <!-- UPnP version 1.0 -->
    <major>1</major>
    <minor>0</minor>
  </specVersion>
  <actionList>
  }
  
  foreach mtd [concat [$C get_Semantic_API_get] [$C get_Semantic_API_set]] {
	 lassign $mtd mtd_name L_params
	 append str "\t\t<action>\n"
	 append str "\t\t\t<name>${mtd_name}</name>\n"
	 append str "\t\t\t<argumentList>\n"
	 foreach param $L_params {
		 lassign $param param_name param_default
		 append str "\t\t\t\t<argument>\n"
		 append str "\t\t\t\t\t<name>${param_name}</name>\n"
		 append str "\t\t\t\t\t<direction>in</direction>\n"
		 append str "\t\t\t\t\t<relatedStateVariable>var_str</relatedStateVariable>\n"
		 append str "\t\t\t\t</argument>\n"
		}
	 append str "\t\t\t\t<argument>\n"
	 append str "\t\t\t\t\t<name>Result</name>\n"
	 append str "\t\t\t\t\t<direction>out</direction>\n"
	 append str "\t\t\t\t\t<relatedStateVariable>var_str</relatedStateVariable>\n"
	 append str "\t\t\t\t</argument>\n"
	 append str "\t\t\t</argumentList>\n"
	 append str "\t\t</action>\n"
	}
	
	append str {	</actionList>
	<serviceStateTable>
	<stateVariable sendEvents="no">
         <name>var_str</name>
         <dataType>string</dataType>
      </stateVariable>
   </serviceStateTable>
</scpd>
}
	
	return $str
}

#___________________________________________________________________________________________________________________________________________
method UPNP_device Generate_event_description_for_service {C} {
	set str "<?php\n"
	
	# Generate a PHP page that will contact COMETs and return results for a SOAP action
	append str {$found_CALLBACK = false; $found_SID = false; $size = -1;} "\n\$entete = \"\";\n"
	append str {foreach (getallheaders() as $name => $value) } "{\n"
	append str "\tif (strtoupper(\$name) == \"CALLBACK\") {\$found_CALLBACK = true;}\n"
	append str "\tif (strtoupper(\$name) == \"SID\") {\$found_SID = true;}\n"
	append str "\t\$entete .= \$name . \" : \" . \$value . \"\\n\";\n"
	append str "}\n\n"
	append str "if (\$found_CALLBACK || \$found_SID) {\n"
	append str "\t\$data = \$entete;\n"
	append str "\tif(\$fp = fsockopen(\"$class(ip)\", $this(Event_tcp_server_port), \$errno, \$errstr, 10)) {\n"
	append str "\t\tfwrite(\$fp, \"[string length $C] $C \");\n"
	append str "\t\tfwrite(\$fp, strlen( utf8_decode(\$data))); fwrite(\$fp, \" \"); \n"
	append str "\t\tfwrite(\$fp, \$data); fflush(\$fp);\n"
	append str "\t\t\$out = \"\";\n"
	append str "\t\twhile (!feof(\$fp)) {\$out .= fread(\$fp, 8192);}\n"
	append str "\t\tforeach(explode(\"\\n\", \$out) AS  \$i => \$entt) {header(\$entt);}\n"
	append str "\t\tfclose(\$fp); flush();\n" 
	append str "\t}\n" 
	append str "} else {echo \"No event CALLBACK nor SID found in the headers\n<br/>\" . \$entete;}\n"
		
	# Finish the string
	append str "?>"
	
	return $str
}

#___________________________________________________________________________________________________________________________________________
method UPNP_device Generate_control_description_for_comet {C} {
	set str "<?php\n"
	
	# Generate a PHP page that will contact COMETs and return results for a SOAP action
	append str {$found_SOAP = false; $size = -1;} "\n\$entete = \"\";\n"
	append str {foreach (getallheaders() as $name => $value) } "{\n"
	append str "\tif (strtoupper(\$name) == \"SOAPACTION\") {\$found_SOAP = true;}\n"
	append str "\t\$entete .= \$name . \" : \" . \$value . \"\\n<br/>\";\n"
	append str "}\n\n"
	append str "if (\$found_SOAP) {\n"
	append str "\t\$data = file_get_contents(\"php://input\");\n"
	append str "\tif(\$fp = fsockopen(\"$class(ip)\", $this(tcp_server_port), \$errno, \$errstr, 10)) {\n"
	append str "\t\tfwrite(\$fp, \"[string length $C] $C \");\n"
	append str "\t\tfwrite(\$fp, strlen( utf8_decode(\$data))); fwrite(\$fp, \" \"); \n"
	append str "\t\tfwrite(\$fp, \$data); flush(); \n"
	append str "\t\t\$out = \"\";\n"
	append str "\t\twhile (!feof(\$fp)) {\$out .= fread(\$fp, 8192);}\n"
	append str "\t\techo \$out;\n"
	append str "\t\tfclose(\$fp);\n" 
	append str "\t}\n" 
	append str "} else {echo \"No SOAP action found in the headers\n<br/>\" . \$entete;}\n"
		
	# Finish the string
	append str "?>\n"
	
	return $str
}


#___________________________________________________________________________________________________________________________________________
#_________________________________________________ Generate a device based on descriptions _________________________________________________
#___________________________________________________________________________________________________________________________________________
method UPNP_device Generate_device_description_from_xml_file {f_name L_control_mappings L_event_mappings {L_tag_value {}}} {
	set f [open $f_name r]; set str_xml [read $f]; close $f
	dom parse $str_xml doc
	$doc documentElement root; set ns_root [$root namespace]
		set n [$root selectNodes -namespace [list ns $ns_root] "//ns:UDN | //UDN"]; set p [$n parentNode]; $p removeChild $n
			set n [$doc createElementNS $ns_root UDN]
			set t [$doc createTextNode uuid:$this(uuid)]; $n appendChild $t
			$p appendChild $n
		set n [$root selectNodes -namespace [list ns $ns_root] "//ns:URLBase | //URLBase"]; set p [$n parentNode]; $p removeChild $n
			set n [$doc createElementNS $ns_root URLBase]
			set t [$doc createTextNode "http://$class(ip)/Comets/UPNP/"]; $n appendChild $t
			$p appendChild $n
		# Update controls
		foreach n [$root selectNodes -namespace [list ns $ns_root] "//ns:controlURL | //controlURL"] {
			 set val [$n asText]
			 puts "controlURL : $val"
			 set pos [lsearch $L_control_mappings $val]
			 if {$pos >= 0} {
				 puts "\ton node $n"
				 [$n childNodes] nodeValue [lindex $L_control_mappings [expr $pos+1]]
				 puts "\tnow value is : [$n asText]"
				}
			}
			
		# Update events
		foreach n [$root selectNodes -namespace [list ns $ns_root] "//ns:eventSubURL | //eventSubURL"] {
			 set val [$n asText]
			 puts "eventURL : $val"
			 set pos [lsearch $L_event_mappings $val]
			 if {$pos >= 0} {
				 puts "\ton node $n"
				 [$n childNodes] nodeValue [lindex $L_event_mappings [expr $pos+1]]
				 puts "\tnow value is : [$n asText]"
				}
			}
		
		# Configure some tags
		foreach {tag value} $L_tag_value {
			 set node [$root selectNodes -namespace [list ns $ns_root] "//ns:$tag | //$tag"]
			 if {[llength $node] != 1} {puts stderr "There are [llength $node] tag $tag instead of 1 !"; continue}
			 [$node childNodes] nodeValue $value
			}
		
		# Write the new file
		set f [open $::env(ROOT_COMETS)/Comets/UPNP/${objName}.xml w]
			fconfigure $f -encoding utf-8
			puts $f {<?xml version="1.0" encoding="utf-8"?>}
			puts $f [$doc asXML]
		close $f
	$doc delete
	
	set this(description_ready) 1
}

#___________________________________________________________________________________________________________________________________________
method UPNP_device Generate_control_description_for_service {C} {
	set str "<?php\n"
	
	# Generate a PHP page that will contact COMETs and return results for a SOAP action
	append str {$found_SOAP = false; $size = -1;} "\n\$entete = \"\";\n"
	append str {foreach (getallheaders() as $name => $value) } "{\n"
	append str "\tif (strtoupper(\$name) == \"SOAPACTION\") {\$found_SOAP = true;}\n"
	append str "\t\$entete .= \$name . \" : \" . \$value . \"\\n<br/>\";\n"
	append str "}\n\n"
	append str "if (\$found_SOAP) {\n"
	append str "\t\$data = file_get_contents(\"php://input\");\n"
	append str "\tif(\$fp = fsockopen(\"$class(ip)\", $this(tcp_server_port), \$errno, \$errstr, 10)) {\n"
	append str "\t\tfwrite(\$fp, \"[string length $C] $C \");\n"
	append str "\t\tfwrite(\$fp, strlen( utf8_decode(\$data))); fwrite(\$fp, \" \"); \n"
	append str "\t\tfwrite(\$fp, \$data); flush(); \n"
	append str "\t\t\$out = \"\";\n"
	append str "\t\twhile (!feof(\$fp)) {\$out .= fread(\$fp, 8192);}\n"
	append str "\t\techo \$out;\n"
	append str "\t\tfclose(\$fp);\n"
	append str "\t}\n"
	append str "} else {echo \"No SOAP action found in the headers\n<br/>\" . \$entete;}\n"
		
	# Finish the string
	append str "?>\n"
	
	return $str
}

