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
      set this(socket_server) [socket -server "$objName Global_page" $this(port)]
	  fconfigure $this(socket_server) -buffersize 1024
    }
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method Comet_root_PM_P_FLEX Render {strm_name {dec {}}} {
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
 append strm " public function connexion():void {\n"
 append strm " 		if ((client==null)||(client.etat=\"deconnecte\")) { \n"
 append strm "	    	client = new SimpleClient(\" $class(local_IP) \", 12000); \n"
 append strm "	    	boutonConnexion.label=\"connexion effectué...\";} \n"
 append strm {	    else } "\n"
 append strm "	    	boutonConnexion.label=\"déjà connecté\"; } \n"
 append strm " public function envoyer():void { \n"
 append strm "    	client.ecrire(zoneText.text); \n"
 append strm "   	zoneText.text=null;} \n"
 append strm " public function recevoir():String{ \n"
 append strm {    	msg=client.lire();} "\n"
 append strm { 		zoneText.text=msg;} "\n"
 append strm " return msg;} \n"
 append strm { ]]>} "\n"
 append strm { </mx:Script>} "\n"
 append strm { <mx:TextArea id="zoneText" x="455" y="194" width="145" height="23"/>} "\n"
 append strm { <mx:Button id="boutonConnexion" x="455" y="164" label="Connexion client" width="145" height="22" click="connexion()"/>} "\n\n\n"
 append strm { <mx:Button id="boutonEnvoyer" x="455" y="164" label="envoyer" width="145" height="22" click="envoyer()"/>} "\n\n\n"
 append strm { <mx:Button id="boutonRecevoir" x="455" y="164" label="recevoir" width="145" height="22" click="recevoir()"/>} "\n\n\n"
    this Render_daughters strm "$dec  "

 append strm {</mx:Application>} "\n"
 
 set f [open "${objName}.mxml" w]; fconfigure $f -encoding utf-8; puts $f $strm; close $f
 #exec "mxmlc ${objName}.mxml"
}

#___________________________________________________________________________________________________________________________________________
method PhysicalFLEX_root Global_page {chan ad num} {
 puts "Demande de renseignement global de $ad;$num sur $chan"
 fconfigure $chan -blocking 0
 if {![this get_direct_connection]} 
 {
   fileevent $chan readable "$objName Send_global_info $chan"
  } 
  else {if {[this get_One_root_per_IP]} {
            set new_root "Root_for_[string map [list . _] $ad]"
			if {![gmlObject info exists object $new_root]} {
			    CometRoot $new_root "Root for IP $ad" "Generated in $objName"
			    PhysicalFLEX_root ${new_root}_PM_P_FLEX "FLEX Root for IP $ad" "Generated in $objName"
				${new_root}_LM_LP configure -Add_PM ${new_root}_PM_P_FLEX -set_PM_active ${new_root}_PM_P_FLEX
			  foreach cmd [this get_L_cmd_to_eval_when_plug_under_new_roots] {
			    set obj_LC $new_root
				set obj_PM ${new_root}_PM_P_FLEX 
				eval $cmd
			   }
			 }
			this set_next_root ${new_root}_PM_P_FLEX
			this New_connexion $chan $ad $num
           } 
		else {puts "$objName New_connexion $chan $ad $num"
		           this New_connexion $chan $ad $num}
        }
 }
#___________________________________________________________________________________________________________________________________________
method PhysicalFLEX_root get_server_port {} {return $this(server_port)}

#___________________________________________________________________________________________________________________________________________
method PhysicalFLEX_root set_server_port {port} {
 if {[string length $this(s)]} {close $this(s)}
 set cmd "set this(s) \[socket -server \"$objName New_connexion\" $port\]"
 if {[catch $cmd res]} {
   puts "Echec de création de socket serveur sur $objName au port $port\n$res"
   set this(s) {}
   return
  }

 set pos [lsearch $class(L_server_ports) "$this(server_port) $objName"]
 if {$pos>=0} {
   lset class(L_server_ports) $pos "$port $objName"
  } else {lappend class(L_server_ports) "$port $objName"}

 set this(server_port) $port
}
#___________________________________________________________________________________________________________________________________________
method PhysicalFLEX_root New_connexion {chan ad num} {
 fconfigure $chan -blocking 0
   set this(msg) ""
   set this(msg_attended_length) -1
 fileevent $chan readable "$objName Read_from_FLEX $chan"
 lappend this(clients) $chan
}
#___________________________________________________________________________________________________________________________________________
method PhysicalFLEX_root Read_from_FLEX {chan} {
 append this(msg) [read $chan]
 
 if {[string first " " $this(msg)] > 0} {
   set this(msg_attended_length) [lindex $this(msg) 0]
   set deb [expr [string length $this(msg_attended_length)] + 1]
   set this(msg) [string range $this(msg) $deb end]
  }
  
 if {$this(msg_attended_length)  > 0 && [string length $this(msg)] >= $this(msg_attended_length)} {
   puts "Il faut exécuter le message FLEX suivant:\n$this(msg)"
  }
}









