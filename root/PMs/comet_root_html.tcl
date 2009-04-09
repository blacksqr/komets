inherit PhysicalHTML_root PM_HTML

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CT_Comet_Root_FUI_HTML
 set this(nb_max_mothers)    1

  set this(s)             {}
    if {[info exists class(L_server_ports)]} {} else {
      set class(next_port) 9100
      set class(L_server_ports) [list "9100 $objName"]
      set this(socket_server) [socket -server "$objName Global_page" 9000]
	  fconfigure $this(socket_server) -buffersize 10
     }
  set this(server_port) $class(next_port)
  this set_server_port  $this(server_port)
  incr class(next_port) 10

  set this(direct_connection) 0
  set this(next_root) {}
  set this(AJAX_root) {}
  set this(One_root_per_IP) 0
    set this(L_cmd_to_eval_when_plug_under_new_roots) ""

  set this(clients)        [list]
  set this(PHP_page)       "#"
  set this(CSS) {}
  this set_style_class BODY
  set this(style) ""

  set this(marker) 0
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC PhysicalHTML_root [L_methodes_set_CometRoot] {} {}

#___________________________________________________________________________________________________________________________________________
Generate_accessors     PhysicalHTML_root [list direct_connection next_root AJAX_root marker One_root_per_IP]
Generate_List_accessor PhysicalHTML_root L_cmd_to_eval_when_plug_under_new_roots L_cmd_to_eval_when_plug_under_new_roots
#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root CB_plug_under_new_roots {r} {}

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root Render_JS {strm_name mark {dec {}}} {
 upvar $strm_name strm
 append strm $dec "<script language=\"JavaScript\" type=\"text/javascript\" src=\"./src_js/xml2dom_1.0.0.js\"></script>\n"
 append strm $dec "<script language=\"JavaScript\" type=\"text/javascript\" src=\"./src_js/core.js\"></script>\n"
 append strm $dec "<script language=\"JavaScript\" type=\"text/javascript\" src=\"./src_js/events.js\"></script>\n"
 append strm $dec "<script language=\"JavaScript\" type=\"text/javascript\" src=\"./src_js/css.js\"></script>\n"
 append strm $dec "<script language=\"JavaScript\" type=\"text/javascript\" src=\"./src_js/coordinates.js\"></script>\n"
 append strm $dec "<script language=\"JavaScript\" type=\"text/javascript\" src=\"./src_js/drag.js\"></script>\n"
 append strm $dec "<script language=\"JavaScript\" type=\"text/javascript\" src=\"./src_js/dragsort.js\"></script>\n"
 append strm $dec "<script language=\"JavaScript\" type=\"text/javascript\" src=\"./src_js/ajax.js\"></script>\n"
 append strm $dec {<script language="JavaScript" type="text/javascript" src="./src_js/dynamiclayout.js"></script>} "\n"

 append strm $dec "<script language=\"JavaScript\" type=\"text/javascript\">\n"
 append strm $dec "<!--\n"
 append strm $dec "  FuncOL = new Array();\n"
 append strm $dec "  function StkFunc(Obj) \{\n"
 append strm $dec "    FuncOL\[FuncOL.length\] = Obj;\n"
 append strm $dec "  \}\n"
 append strm $dec "  window.onload = function() \{\n"
 append strm $dec "    for(i=0 ; i<FuncOL.length ; i++) \{\n"
 append strm $dec "      FuncOL\[i\]();\n"
 append strm $dec "    \}\n"
 append strm $dec "  \}\n"
 
   this Render_daughters_JS strm $mark $dec
 append strm $dec "-->\n"
 append strm $dec "</script>\n"
}
#___________________________________________________________________________________________________________________________________________
Generate_accessors PhysicalHTML_root [list CSS PHP_page]

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root Global_page {chan ad num} {
 puts "Demande de renseignement global de $ad;$num sur $chan"
 fconfigure $chan -blocking 0
 if {![this get_direct_connection]} {
   fileevent $chan readable "$objName Send_global_info $chan"
   #this New_connexion $chan $ad $num
   ##fileevent $chan readable "$objName Read_from_PHP $chan"
  } else {if {[this get_One_root_per_IP]} {
            set new_root "Root_for_[string map [list . _] $ad]"
			if {![gmlObject info exists object $new_root]} {
			  CometRoot $new_root "Root for IP $ad" "Generated in $objName"
			    PhysicalHTML_root ${new_root}_PM_P_HTML "HTML Root for IP $ad" "Generated in $objName"
				${new_root}_LM_LP configure -Add_PM ${new_root}_PM_P_HTML -set_PM_active ${new_root}_PM_P_HTML
			  foreach cmd [this get_L_cmd_to_eval_when_plug_under_new_roots] {
			    set obj_LC $new_root
				set obj_PM ${new_root}_PM_P_HTML 
				eval $cmd
			   }
			 }
			this set_next_root ${new_root}_PM_P_HTML
			this New_connexion $chan $ad $num
           } else {puts "$objName New_connexion $chan $ad $num"
		           this New_connexion $chan $ad $num
				  }
         }
 }

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root Send_global_info {chan} {
 if { [eof $chan] } {
   puts STOP
   close $chan
   return
  }

 set txt [read $chan]

 set    rep "\n"
 append rep {<html>} "\n"
 append rep "  " {<head>} "\n"
 append rep "  " "  " {<title>} [this get_name] {</title>} "\n"
 append rep "  " "  " {<style type="text/css">} "\n"
 append rep "  " "  " "  " "*.title   {border: solid black; background-color: #963; border-width: 3px; text-align: center;}" "\n"
 append rep "  " "  " "  " "*.content {border: solid green; background-color: #486; border-width: 1px; text-align: left;}" "\n"
 append rep "  " "  " {</style>} "\n"
 append rep "  " {</head>}	"\n"
 append rep "  " {<body>}	"\n"
 append rep "  " "  " <form [this Style_class] { name="root" method="post" action="} [this get_PHP_page] {">} "\n"
   append rep "      " {<div class="title">Availables comets systems</div>} "\n"
   append rep "      " {<div class="content">} "\n"
   foreach i $class(L_server_ports) {
     set port [lindex $i 0]
     set PM   [lindex $i 1]
     set LC   [$PM get_LC]
     append rep "        " {<input type="radio" name="Comet_port" value="} $port {" />} "[$LC get_name] : [$LC get_descr]" <br> "\n"
    }
   append rep "      " {</div>} "\n"
   append rep "      " {<br><input type="submit" VALUE="GO !" />} "\n"
 append rep "  " "  " {</form>} "\n"
 append rep "  " {</body>} "\n"
 append rep </html> "\n"


 puts $chan $rep
 puts $rep
# flush $chan
 close $chan
}

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root get_server_port {} {return $this(server_port)}

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root set_server_port {port} {
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
method PhysicalHTML_root set_CSS_from_file {file_name} {
 set f [open $file_name]
   this set_CSS [read $f]
 close $f
}

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root dispose {} {
 close $this(s)
 set pos [lsearch $class(L_server_ports) $this(server_port)]
 set class(L_server_ports) [lreplace $class(L_server_ports) $pos $pos]
 this inherited
}

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root New_connexion {chan ad num} {
 fconfigure $chan -blocking 0
   set this(msg) ""
   set this(msg_attended_length) -1
 fileevent $chan readable "$objName Read_from_PHP $chan"
 #puts "$objName : Connection de la part de $ad;$num sur $chan"
 lappend this(clients) $chan
}

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root Close_clients {} {
 foreach c $this(clients) {
   close $c
  }
}

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root List_clients {} {
 foreach c $this(clients) {
   puts $c
  }
}

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root Read_from_PHP {chan} {
 #puts "Sur $chan on reçoit un message"
  
  if { [eof $chan] } {
    close $chan
    set nc [list]
    foreach e $this(clients) {if {[string equal $e $chan]} {} else {lappend nc $e}}
    set this(clients) $nc
    puts "$objName : Déconnection de $chan, reçut [string length $this(msg)] octets"
    return} else {append this(msg) [read $chan]
				  if {$this(msg_attended_length) == -1} {
					set pos [string first " " $this(msg)]
				    set this(msg_attended_length) [string range $this(msg) 0 [expr $pos - 1]]
					set this(msg)                 [string range $this(msg) [expr $pos + 1] end]
				   }
	              set recept [string length $this(msg)]
				  #puts " Chargement intermédiaire : $recept octets / $this(msg_attended_length)"
				  if {$recept >= $this(msg_attended_length)} {
					if {[catch {$objName Analyse_message $chan this(msg)} err]} {
					  #
					  #set rep ""; this Render_all rep
	                  puts $chan "<html><body>ERROR in COMETs:<br>$err</body></html>"
					 } 
					close $chan
				    #puts "Done!"; 
				   }
				 }
  return
  
  
  set txt [read $chan]
    set prev $txt
    if {[catch {$objName Analyse_message $chan txt} err]} {
	  set rep ""; this Render_all rep
	  puts $chan $rep
	  puts $prev
	  puts "________ERROR in analysing message from browser :  err : $err"
	 } else {puts "  Reçut [string length $prev] octets"}
  close $chan
  set nc [list]
  foreach e $this(clients) {if {[string equal $e $chan]} {} else {lappend nc $e}}
  set this(clients) $nc
}

#___________________________________________________________________________________________________________________________________________
proc pipo_button {c} {
 #puts "pipo :\n$c"
 if {[regexp {^(.*)__XXX__(.*)$} $c reco comet m]} {
   if {[catch {eval "$comet $m"} res]} {
     puts "Paramètre de post invalid pour les comets :\n  $res"
    }
  }
}

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root Analyse_message {chan txt_name} {
 upvar $txt_name txt

 #puts "  Annalyse : $txt"
 set t [clock clicks -millisecond]; set t0 $t
 set L_post_cmd {}
 set L_cmd      {}
# Découpage
 set pos 0
 set prev 0
 set t [string length $txt]
 while {$pos < $t-1} {
  # Variable
  set next [string first { } $txt $pos]; if {$next <= $pos} {puts "POST foireux, trop d'espaces..."; break}
     set t_var [string range $txt $pos [expr $next-1]]
	 #puts "  t_var : $t_var"
   set pos [expr $next+1]
     set var [string range $txt $pos [expr $pos+$t_var-1]]
	 #puts "  var : $var"
   set pos [expr $pos+$t_var+1]
  # Valeur
   set next [string first { } $txt $pos]
     set t_val [string range $txt $pos [expr $next-1]]
	 #puts "  t_val : $t_val"
   set pos [expr $next+1]
     set val [string range $txt $pos [expr $pos+$t_val-1]]
 	 #puts "  val : $val"
   set pos [expr $pos+$t_val+1]

   lappend L_cmd "$var $val"
  }

# Analyse des commandes
 #puts "Analyse des commandes"
 foreach cmd $L_cmd {
   set c_size [string first { } $cmd]
     incr c_size -1; set c [string range $cmd 0       $c_size]
     incr c_size  2; set v [string range $cmd $c_size end]
   #regsub -all {\"} $v {"} v
   #DEBUG set v [string map [list {\"} {"}] $v]

   if {[regexp {^(.*)__XXX__(.*)$} $c reco comet m]} {
     #puts "Eval of: \"$comet $m $v\""
     if {[string length $v] == 0} {
       set    msg {}
       append msg $comet { } $m " \{\}"
       if {[catch {eval $msg} res]} {puts $res}
      } else {set    msg {}
              append msg $comet { } $m " \$v"
              if {[catch {eval $msg} res]} {puts $res}
             }
    } else {
        if {[string length $c] > 1} {lappend L_post_cmd "$c \{$v\}"}
       }
  }

 foreach cmd $L_post_cmd {
   if {[catch {eval $cmd} res]} {
     puts "Paramètre de post invalid pour les comets :\n  $res"
    }
  }

 #puts "Time to render..."
 set rep {}
 if {[string equal [this get_next_root] {}]} {
   this set_marker [clock clicks]
   this Render_all rep
  } else {set r [this get_next_root]
          puts "CSS++ $r \"#${r}->PMs\[soft_type==PHP_HTML\]\""
          set r [CSS++ $r "#${r}->PMs\[soft_type==PHP_HTML\]"]
          $r set_marker [clock clicks]
          $r Render_all rep
          this set_next_root {}
         }
 puts $chan $rep
 set dt [expr [clock clicks -millisecond] - $t0];

 #puts "Generated in $dt ms."
 flush $chan
}

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root Render {strm_name {dec {}}} {
 upvar $strm_name rep

 #puts "$objName Render $strm_name"
 set AJAX_root [this get_AJAX_root]
 if {[string equal $AJAX_root {}]} {} else {
   #puts "  AJAX_root : $AJAX_root"
   set rep {}
   if {[string equal NOTHING $AJAX_root]} {} else {
     incr this(marker)
     #this Render_JS rep $this(marker)
     eval "$AJAX_root rep"
    }
   this set_AJAX_root {}
   return
  }

 #puts "  Render classic"
 set    rep "\n"
 append rep {<?xml version="1.0" encoding="UTF-8"?>} "\n"
 append rep {<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">}
 append rep {<html>} "\n"
 append rep "  " {<head>} "\n"

 #append rep {<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />} "\n"
 append rep {<meta http-equiv="Content-Type" content="application/x-www-form-urlencoded; charset=UTF-8; Accept-Language: en,fr;" />} "\n"

 append rep "  " "  " {<title>} [this get_name] {</title>} "\n"
 append rep "  " "  " {<style type="text/css">} "\n"
 append rep "  " "  " "  " [this Apply_style] "\n"
 append rep "  " "  " {</style>} "\n"
# append rep "  " "  " {<script type="text/javascript" src="script.js">		document.captureEvents(Event.MOUSEMOVE);document.onmousemove = get_mouse;</script>} "\n"
   set this(marker) [clock clicks]
   #puts "  $objName Render_JS rep $this(marker)"
   this Render_JS rep $this(marker) "    "
   #puts "  / END OF / $objName Render_JS rep $this(marker)"
 append rep "  " {</head>}	"\n"
# append rep "  " {<body onMouseUp="javascript:testClick2()">} "\n"

 append rep "  " {<body>}	"\n"
 append rep "  " "  " <form [this Style_class] {name="root" method="post" action="} [this get_PHP_page] {">} "\n"
 #append rep "  " "  " "  " {<input type="submit" value="soumettre" />} "\n"
 #append rep "  " "  " "  " {<input type="reset"  value="Annuler" />} "\n"
 append rep "  " "  " "  " {<input type="hidden" value="} $this(server_port) {" id="Comet_port" name="Comet_port" />} "\n"
   #puts "  this Render_daughters rep"
   this Render_daughters rep "$dec  "
   #puts "  / END OF / this Render_daughters rep"
 append rep "  " "  " "  " {<input type="hidden" value="" name="pipo_button" />} "\n"
 append rep "  " "  " {</form>} "\n"
 append rep "  " {</body>} "\n"
 append rep </html> "\n"
}

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root get_style { } {return $this(style)}
method PhysicalHTML_root set_style {v} {set this(style) $v}

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root get_styler {} {
 return [[this get_LC] get_styler]
}

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root Apply_style {} {
 set res {}
 set styler [this get_styler]
 if {[string equal $styler ""]} {
   set styler [lindex [gmlObject info objects Style] 0]
   this set_styler $styler
   if {[string equal $styler ""]} {
     puts "$objName Apply_style: NO STYLER FOUND !!!"
    }
  }

 foreach r [this get_style] {
   #puts "Considering rule :\n$r"
   set str   [lindex $r 0]
   set L_rep {}
   #DEBUG $styler DSL_SELECTOR str L_rep [lindex $r 1] 1
     set L_rep [$styler Interprets_and_parse str [lindex $r 1]]
   #/DEBUG
   set ext {}
     regexp {^.*(:.*)$} $str reco ext
   set nL {}
     foreach rep $L_rep {
	   if {[lsearch [gmlObject info classes $rep] Physical_model] != -1} {
	     if {[string equal [${rep}_cou_ptf get_soft_type] PHP_HTML]} {
		   lappend nL $rep
		  }
		} else {set nL [concat $nL [CSS++ $rep "#${rep}->PMs\[soft_type == PHP_HTML\]"]]} 
	  }
   set L_rep $nL	  
   set nL {}	  
   if {[llength $L_rep]>0} {
	 foreach rep $L_rep {lappend nL "#$rep$ext"}
     set nL [join $nL {, }]
     append res $nL " \{\n" [lindex $r 2] "\n\}\n"
	} 
  }
 
 return $res
}

