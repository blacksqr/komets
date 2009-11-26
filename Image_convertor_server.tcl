source 
#___________________________________________________________________________________________________________________________________________
method ImageConvertorServer constructor {port} {
 set this(socket_server) [socket -server "$objName ClientConnection" $port]
 fconfigure $this(socket_server) -buffersize 65536
 
 set this(last_rep) {}
}

#___________________________________________________________________________________________________________________________________________
method ImageConvertorServer get_last_rep {} {return $this(last_rep)}

#___________________________________________________________________________________________________________________________________________
method ImageConvertorServer dispose {} {
 close $this(socket_server) 
 this inherited
}

#___________________________________________________________________________________________________________________________________________
method ImageConvertorServer get_server_port { } {return [lindex [fconfigure $this(socket_server) -sockname] 2]}
method ImageConvertorServer set_server_port {port} {
 catch "close $this(socket_server)"
 set this(socket_server) [socket -server "$objName ClientConnection" $port]
 fconfigure $this(socket_server) -buffersize 65536
}

#___________________________________________________________________________________________________________________________________________
method ImageConvertorServer ClientConnection {chan ad num} {
 fconfigure $chan -blocking 0 -buffersize 65536
 fileevent $chan readable "$objName Read_L_img $chan"
 puts "Connection de $ad;$num sur $chan"
 set this($chan,val) ""
}

#___________________________________________________________________________________________________________________________________________
method ImageConvertorServer Data_in {chan} {return $this($chan,val)}

#___________________________________________________________________________________________________________________________________________
method ImageConvertorServer Read_L_img {chan} {
 puts "$objName Read_L_img $chan"
 if { [eof $chan] } {puts "___ EOF on $chan"; close $chan; return}
 append this($chan,val) [read $chan]
#puts "  * Received something : $this($chan,val)"
 if {![string equal "END\n" [string range $this($chan,val) end-4 end]]} {return}
   if {[catch {set rep [$objName Convert_img_list this($chan,val)]} err]} {
     puts "ERROR : $err\nEND_ERROR"
	 puts $chan 0
	 close $chan
	 return
	}
   set this(last_rep) $rep
   puts $chan $rep
   #puts $rep
 close $chan
 puts "__ close $chan"
}

#___________________________________________________________________________________________________________________________________________
method ImageConvertorServer Convert_img_list {txt_name} {
 upvar $txt_name txt
 puts "$objName Convert_img_list $txt"
 
 foreach {port img_name size} $txt {
   puts "  exec capture_and_convert.bat \"http://localhost?Comet_port?$port\" \"$img_name\" $size"
   if {[catch "eval exec capture_and_convert.bat \"http://localhost?Comet_port?$port\" \"$img_name\" $size" err]} {
     puts "  Error exec capture_and_convert.bat \"http://localhost?Comet_port?$port\" \"$img_name\" $size"
    }
  } 

 return 1
}

