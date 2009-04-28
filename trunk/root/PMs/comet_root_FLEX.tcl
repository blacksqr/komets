#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Comet_root_PM_P_FLEX PM_FLEX

#___________________________________________________________________________________________________________________________________________
method Comet_root_PM_P_FLEX constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Comet_root_PM_P_FLEX
 
   if {![info exists class(local_IP)]} {
     set class(local_IP) [regexp -inline {\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}} [exec ipconfig] ]
    }
	
 set this(s)             {}
 if {[info exists class(L_server_ports)]} {
    set this(port) $class(next_port)
	incr class(next_port)
	lappend class(L_server_ports) [list "$this(port) $objName"]
	set this(socket_server) [socket -server "$objName New_connection" $this(port)]
	fconfigure $this(socket_server) -buffersize 1024
   } else {
      set this(port) 12000
      set class(next_port) 12001
      set class(L_server_ports) [list "12000 $objName"]
      set this(socket_server) [socket -server "$objName New_connection" $this(port)]
	  fconfigure $this(socket_server) -buffersize 1024
    }
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors Comet_root_PM_P_FLEX [list socket_server port]

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method Comet_root_PM_P_FLEX generate_FLEX_stub {strm_name {dec {}}} {
 upvar $strm_name strm

 append strm {<?xml version="1.0" encoding="utf-8"?>} "\n"
 append strm {<mx:Application xmlns:mx="http://www.adobe.com/2006/mxml" layout="vertical" cornerRadius="0" alpha="1.0" 
 backgroundGradientAlphas="[1.0, 1.0]" backgroundGradientColors="[#1BA01B, #C2E6E5]" color="#22B21B" borderColor="#202FC1">} "\n"
 append strm { <mx:Script>} "\n"
 append strm { <![CDATA[ } "\n"
 #set f [open "[Comet_files_root]Comets/root/PMs/gestion_sockets.action_script" r]; append strm [read $f]; close $f
 append strm { import SimpleClient; } "\n"
 append strm { public var client:SimpleClient;} "\n"
 append strm { public var msg:String;} "\n"
 #append strm " zoneText.text = \"IP = $class(local_IP)\";"
 append strm " public function connexion():void {\n"
 append strm " 		if ((client==null)||(client.etat=\"deconnecte\")) { \n"
 append strm "	    	client = new SimpleClient(\"$class(local_IP)\",12000,Application.application); \n"
 append strm "	    	boutonConnexion.label=\"connexion effectué...\";\n"
 append strm "		} \n"
 append strm "	    else  \n"
 append strm "	    	boutonConnexion.label=\"déjà connecté\";\n"
 append strm " } \n"
 append strm " public function FLEX_to_TCL(str_obj:String, str_mtd:String, str_val:String):void {\n" 
 append strm {   client.ecrire(String (str_obj.length)+ " " + str_obj + " " + String (str_mtd.length)+ " " + str_mtd + " " + String (str_val.length)+ " " + str_val + "|");} "\n"
 append strm "  }\n"
   this set_prim_handle        "Application.application"
   this set_root_for_daughters "Application.application"
   this Render_daughters strm "$dec  "
 append strm { ]]>} "\n"
 append strm { </mx:Script>} "\n"
 append strm { <mx:Button id="boutonConnexion" label="Connexion client" width="155" height="22" click="connexion()"/>} "\n"
    

 append strm {</mx:Application>} "\n"
 
 set f [open "${objName}.mxml" w]; fconfigure $f -encoding utf-8; puts $f $strm; close $f
 #exec "mxmlc ${objName}.mxml"
}
 
#___________________________________________________________________________________________________________________________________________
method Comet_root_PM_P_FLEX New_connection {chan ad num} {
 puts "$objName New_connection $chan $ad $num" 
 fconfigure $chan -blocking 0
 fconfigure $chan -encoding utf-8
 # attention cela exige qu'il n'y ait qu'un seul client, sinon il faut créer un array
  set this(chan_for_client) $chan
  
   set this(msg) ""
   set this(msg_attended_length) -1
 fileevent $chan readable "$objName Read_from_FLEX $chan"
 lappend this(clients) $chan
}
#___________________________________________________________________________________________________________________________________________
method Comet_root_PM_P_FLEX Read_from_FLEX {chan} {
 append this(msg) [read $chan]
 #permet de sauter la taille indiquée en début de 
 if {$this(msg_attended_length) == -1 && [string first " " $this(msg)] > 0} {
   set this(msg_attended_length) [lindex $this(msg) 0]
   set deb [expr [string length $this(msg_attended_length)] + 1]
   set this(msg) [string range $this(msg) $deb end]
  }
 
 puts "Received [string length $this(msg)] / $this(msg_attended_length)"
 puts "  msg : $this(msg)"
 
 if {$this(msg_attended_length) > 0 && [string length $this(msg)] >= $this(msg_attended_length)} {
   set length [string length $this(msg)]
   while { $length == [string length $this(msg)] \
         &&[this Analyse_message this(msg)]} {set length [string length $this(msg)]
		                                     }
   set this(msg_attended_length) -1
   set this(msg)                 ""
  }
  
 if {[eof $chan]} {puts "Socket $chan closed by client!"; close $chan}
}

#_ne sers à rien____________________________________________________________________________________________________________________________
method Comet_root_PM_P_FLEX pipo {} {
 set this(msg_attended_length) -1
 set this(msg)                 ""
}

#___________________________________________________________________________________________________________________________________________
method Comet_root_PM_P_FLEX Analyse_message {str_name} {
 set still_to_be_done 0
 # simplifie l'accès à la variable de Analyse_message
 upvar $str_name str
 
 set str_length [string length $str]
 set pos        0
 while {$pos < $str_length} {
   if {[string index $str $pos] == "|"} {
     set str [string range $str [expr $pos+1] end]
	 # il faut sauter la taille précédant les messages concaténés
	 set taille_msg [string length $str]
	 set debut [expr [string length taille_msg] + 1]
	 set str [string range str $debut end]
   
	 # fin modif.
	 set still_to_be_done 1
	 break
    }
   foreach e [list var mtd val] {
     set pos_space [string first " " $str $pos]
     set size [string range $str $pos [expr $pos_space-1]]
     set pos [expr $pos_space+1]
	 set $e [string range $str $pos [expr $pos+$size-1]]
	 set pos [expr $pos+$size+1]
    }
   if {[catch {$var $mtd $val} err]} {
     puts "Error d'évaluation de la commande:\n  - var $var\n  - mtd $mtd\n  - val $val"
    }
  }
  
 return $still_to_be_done
}
#___________________________________________________________________________________________________________________________________________
method Comet_root_PM_P_FLEX send_to_FLEX {obj} {

 puts " msg \"[string length $obj] $obj;|\" envoyé sur le channel $this(chan_for_client)"
 puts -nonewline $this(chan_for_client) "[expr [string length $obj]+1] $obj;|"
 flush $this(chan_for_client)

}




















