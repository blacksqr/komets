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
  set this(Update_interval) 2000
    set this(L_cmd_to_eval_when_plug_under_new_roots) ""

  set this(clients)        [list]
  set this(PHP_page)       "#"
  set this(CSS) {}
  this set_style_class BODY
  set this(style) ""
  
  set this(marker) 0
  
  set this(L_js_files_link) [list]
  
  # Pour ne pas générer les appels types COMETS
  set this(html_compatibility_strict_mode) 0
  
  # ________Envoi de changement avec le serveur le php________#
  set this(update_send) 0
  set this(version_server) 0
  set this(version_client) {}
  set this(update_cmd) ""
  set this(L_PM_to_sub) [list]
  set this(L_PM_to_add) [list]
  set this(L_PM_really_add) [list]
  set this(L_PM_really_sub) [list]
  
  set this(concat_send,0) ""
  # ___________________________________________________________#
  this set_PM_root $objName
  
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC PhysicalHTML_root [L_methodes_set_CometRoot] {} {}

#___________________________________________________________________________________________________________________________________________
Generate_accessors     PhysicalHTML_root [list direct_connection next_root AJAX_root marker One_root_per_IP Update_interval extra_css_style html_compatibility_strict_mode]
Generate_List_accessor PhysicalHTML_root L_cmd_to_eval_when_plug_under_new_roots L_cmd_to_eval_when_plug_under_new_roots
Generate_List_accessor PhysicalHTML_root L_js_files_link                         L_js_files_link

#___________________________________________________________________________________________________________________________________________
Inject_code PhysicalHTML_root set_L_js_files_link {} {
 set this(L_js_files_link) [Liste_to_set] $this(L_js_files_link)
}

#___________________________________________________________________________________________________________________________________________
Inject_code PhysicalHTML_root Add_L_js_files_link {} {
 set this(L_js_files_link) [Liste_to_set] $this(L_js_files_link)
}

#___________________________________________________________________________________________________________________________________________
Generate_List_accessor PhysicalHTML_root L_PM_to_sub L_PM_to_sub
Generate_List_accessor PhysicalHTML_root L_PM_to_add L_PM_to_add

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root Add_L_PM_to_sub {L_PM} {
 incr this(version_server)
 lappend this(L_PM_to_sub) [list $this(version_server) $L_PM]
 set this(concat_send,$this(version_server)) [list $L_PM ""]
}

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root Add_L_PM_to_add {L_PM} {
 incr this(version_server)
 lappend this(L_PM_to_add) [list $this(version_server) $L_PM]
 set this(concat_send,$this(version_server)) [list $L_PM ""]
}

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root CB_plug_under_new_roots {r} {}

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root Render_JS {strm_name mark {dec {}}} {
 if {[this get_html_compatibility_strict_mode]} {return}
 
 upvar $strm_name strm
 
 append strm $dec {<link type="text/css" href="./Comets/models/HTML/jquery/css/cupertino/jquery-ui-1.8.custom.css" rel="stylesheet" />} "\n"
 append strm $dec "<style type=\"text/css\"> body{ font: 80% \"Trebuchet MS\", sans-serif;} </style>\n"
 append strm $dec "<script language=\"JavaScript\" type=\"text/javascript\" src=\"./Comets/models/HTML/jquery/js/jquery-1.4.2.min.js\"></script>\n"
 append strm $dec "<script language=\"JavaScript\" type=\"text/javascript\" src=\"./Comets/models/HTML/jquery/js/jquery-ui-1.8.custom.min.js\"></script>\n"
 #append strm $dec "<script language=\"JavaScript\" type=\"text/javascript\" src=\"./Comets/models/HTML/jquery/jquery.svg.min.js\"></script>\n"
 append strm $dec "<script language=\"JavaScript\" type=\"text/javascript\" src=\"./Comets/models/HTML/refreshClientServer.js\"></script>\n"
 #append strm $dec "<script language=\"JavaScript\" type=\"text/javascript\" src=\"./Comets/models/HTML/jquery/jquery.multi-ddm.pack.js\"></script>\n"
 
 
 foreach js_file_link [this get_L_js_files_link] {
   append strm $dec "<script language=\"JavaScript\" type=\"text/javascript\" src=\"$js_file_link\"></script>\n"
  }
 
 #append strm $dec "<link type=\"text/css\" href=\"./Comets/models/HTML/jquery/css/smoothness/jquery-ui-1.7.1.custom.css\" rel=\"stylesheet\" />\n"
 
 append strm $dec "<script language=\"JavaScript\" type=\"text/javascript\">\n"
   this Render_daughters_JS strm $mark $dec
   append strm $dec "\$(document).ready(function() {\n"
     this Render_post_JS strm "$dec    "
   append strm $dec "  });"
 append strm $dec "</script>\n"
}
#___________________________________________________________________________________________________________________________________________
Generate_accessors PhysicalHTML_root [list CSS PHP_page]

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root Global_page {chan ad num} {
 #puts "Demande de renseignement global de $ad;$num sur $chan"
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
   
   set new_L [list]
   foreach i $class(L_server_ports) {
     set port [lindex $i 0]
	 set PM   [lindex $i 1]
     if {[gmlObject info exists object $PM]} {
       set LC   [$PM get_LC]
       append rep "        " {<input type="radio" name="Comet_port" value="} $port {" />} "[$LC get_name] : [$LC get_descr]" <br> "\n"
	   lappend new_L $i
	  }
    }
   set class(L_server_ports) $new_L

   append rep "      " {</div>} "\n"
   append rep "      " {<br><input type="submit" VALUE="GO !" />} "\n"
 append rep "  " "  " {</form>} "\n"
 append rep "  " {</body>} "\n"
 append rep </html> "\n"


 puts $chan $rep
 #puts $rep
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
method PhysicalHTML_root set_CSS {v} {
 set this(CSS) $v
 set    cmd "\$( '#CSS_${objName}' ).remove(); \$( 'head' ).append( \""
 append cmd "<style id=\\\"CSS_$objName\\\" type=\\\"text/css\\\">"
 append cmd [string map [list "\"" "\\\"" "\n" "\\n"] $this(CSS)]
 append cmd "</style> \");"
 this Concat_update $objName set_CSS $cmd
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
 fconfigure $chan -encoding utf-8
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
    return
  } else {append this(msg) [read $chan]
				  if {$this(msg_attended_length) == -1} {
					set pos [string first " " $this(msg)]
				    set this(msg_attended_length) [string range $this(msg) 0 [expr $pos - 1]]
					set this(msg)                 [string range $this(msg) [expr $pos + 1] end]
					#puts " Premier paquet :\n  lg : $this(msg_attended_length)\n  txt : $this(msg)"
				   }
	              set recept [string length $this(msg)]
				  #puts "  -   % : $recept / $this(msg_attended_length)"
				  if {$recept >= $this(msg_attended_length)} {
				    set original_msg $this(msg)
					if {[catch {$objName Analyse_message $chan this(msg)} err]} {
					  puts $err					  
					  #
					  #set rep ""; this Render_all rep
					  set err_txt "ERROR in COMETs:<br/>message was :<br/>$original_msg<br/>ERROR was<br/>$err"
	                  puts $chan $err_txt
					 }
					set this(msg_attended_length) -1
					set this(msg)                 ""
					close $chan
				    #puts "Done!"; 
				   }
		}
  return
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

 #puts "  Annalyse :\n$txt"
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

   set pos_XXX [string first __XXX__ $c]
   
   if {$pos_XXX >= 0} {
	 set m     [string range $c [expr $pos_XXX + 7] end]
	 set comet [string range $c 0 [expr $pos_XXX - 1]]
     #puts "Eval of: \"$comet $m $v\""
     if {[string length $v] == 0} {
       set    msg {}
       append msg $comet { } $m " \{\}"
       if {[catch {eval $msg} res]} {
	     if {[catch "eval $comet $m" res]} {puts "ERROR:\n$res"}
		}
      } else {set    msg {}
              append msg $comet { } $m " \$v"
              if {[catch {eval $msg} res]} {puts "ERROR2:\n  exe : $msg\n    v : $v\n  err : $res"}
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
		 
 # envoi de la page complete ou juste d'un update partiel
 if {$this(update_send) == 0} {
	set rep {}
	  this set_marker [clock clicks]
	  this Render_all rep
	puts $chan $rep
	set this(L_PM_to_add) [list]
	set this(L_PM_to_sub) [list]
 } else {
    if {$this(update_cmd) != ""} {
	  #puts "$objName => Send update : $this(update_cmd)"
	 }
	puts -nonewline $chan $this(update_cmd) 
	set this(update_send) 0
	set this(update_cmd) ""
 }
 set dt [expr [clock clicks -millisecond] - $t0];

 #puts "Generated in $dt ms."
 flush $chan
}

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root Mouse_hover {L} {
 foreach e $L {
   if {[gmlObject info exists object $e]} {
     if {[lsearch [gmlObject info classes $e] Physical_model] >= 0} {
	   this HTML_element_selected $e
	   break
	  }
    }
  }
}

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root HTML_element_selected {v} {}

Manage_CallbackList PhysicalHTML_root [list HTML_element_selected] end
Trace PhysicalHTML_root HTML_element_selected

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root Do_Mouse_hover {v} {
 if {$v} {
   this Concat_update ${objName} Do_Mouse_hover {$('body').attr('onMouseDown', 'javascript:mouseEventHandler(event);');}
  } else {this Concat_update ${objName} Do_Mouse_hover {$('body').attr('onMouseDown', '');}}
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
 append rep "  " "  " {<style id="} CSS_$objName {" type="text/css">} "\n"
 append rep "  " "  " "  " [this Apply_style] "\n"
 append rep "  " "  " "  " [this get_CSS] "\n"
 append rep "  " "  " {</style>} "\n"
   set this(marker) [clock clicks]
   this Render_JS rep $this(marker) "    "
 append rep "  " {</head>}	"\n"

 append rep "  " {<body onMouseDown="">}	"\n"
 this Render_daughters rep "$dec  "
 
 if {![this get_html_compatibility_strict_mode]} {
	 append rep "  " "  " {<p id="p_debug" style="display:none;"></p>}
	 append rep "  " "  " {<textarea id="Ajax_Raw" style="display:none; width:100%; height:100px;"></textarea>}
	 append rep "  " "  " <form [this Style_class] {name="root" method="post" action="} [this get_PHP_page] {">} "\n"
	 #append rep "  " "  " "  " {<input type="submit" value="soumettre" />} "\n"
	 #append rep "  " "  " "  " {<input type="reset"  value="Annuler" />} "\n"
	 append rep "  " "  " "  " {<input type="hidden" value="} $this(server_port) {" id="Comet_port" name="Comet_port" />} "\n"
	 append rep "  " "  " "  " {<input type="hidden" value="" id="IP_client" name="IP_client" />} "\n"
	 append rep "  " "  " "  " {<input type="hidden" value="} $this(version_server) {" id="Version_value" name="} $objName {__XXX__Is_update" />} "\n"
	 append rep "  " "  " "  " {<input type="hidden" value="} [this get_Update_interval] {" id="Update_interval" />} "\n"
  }

 if {![this get_html_compatibility_strict_mode]} {
	 append rep "  " "  " "  " {<input type="hidden" value="" name="pipo_button" />} "\n"
	 append rep "  " "  " {</form>} "\n"
  }
 append rep "  " {</body>} "\n"
 append rep </html> "\n"
}

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root set_Update_interval {v} {
 set this(Update_interval) $v
 this Concat_update ${objName} "set_update_interval" "\$(\"#Update_interval\").val($v);\n"
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
 set styler [this get_DSL_CSSpp]
 if {$styler == ""} {
   set styler [lindex [gmlObject info objects Style] 0]
   this set_styler $styler
   if {$styler == ""} {puts "$objName Apply_style: NO STYLER FOUND !!!"}
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


#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#______________________________ Automatic Dynamic update via AJAX __________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root Concat_update {objN methode cmd} {
 # suppression dans le concat toute les versions qui sont obsoléte
 this Concat_update_supp

 # Avant d'incrémenter la version, on vérifie que objN et method ne sont pas dans les nouvelles mises à jour.
 # +1 pour la nouvelle version
 set v_current $this(version_server)
 set vmax      [this get_vclient_max]
 if {$vmax == -1} {return}
 set trouve    0
 
 set id [list $objN $methode]
 while {$v_current > $vmax} {
   if {[lrange $this(concat_send,$v_current) 0 1] == $id} {set trouve 1;  break} else {incr v_current -1}
  }
 if {!$trouve} {incr this(version_server)
                set  v_current $this(version_server)
			   }
  
 # enregistrement de la commande avec sa version
 set this(concat_send,$v_current) [list $objN $methode $cmd]
 
 return ""
}

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root Concat_update_supp {} {
 set mini [this get_vclient_min]
 if {$mini == -1} {return}
 
 if {$mini != -1} {
	 foreach {vconcat cmd} [array get this concat_send,*] {
		if {$vconcat <= $mini} {
			unset this(concat_send,$vconcat)
		}
	 }
	 
  # Update the list of elements to sub
  set nL [list]
    foreach e [this get_L_PM_to_sub] {
	  if {[lindex $e 0] > $mini} {lappend nL $e}
	 }
  this set_L_PM_to_sub $nL

  # Update the list of elements to add
  set nL [list ]; 
    foreach e [this get_L_PM_to_add] {
	  if {[lindex $e 0] > $mini} {lappend nL $e}
	 }
  this set_L_PM_to_add $nL
 }
}

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root get_vclient_max {} {
 # renvoi la version la plus grande de tous les clients
 set max -1

	 foreach {i v} [array get this version_client,*] {
	   if {$v > $max} {set max $v}
	  }

 return $max
}

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root get_vclient_min {} {
 # renvoi la version la plus grande de tous les clients
 set min -1

	 foreach {i v} [array get this version_client,*] {
	   if {$min == -1 || $v < $min} {set min $v}
	  }

 return $min
}

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root get_vclient_min___OLD___ {} {
 # renvoi la version la plus petite de tous les clients
 set mini -1
 if {[array size this(version_client)]} {
	 set i 0
	 foreach p [array names this version_client] {
		if {$this(version_client,$p) < $mini || $i == 0} {
			set mini $this(version_client,$p)		
		}
		incr i 1
	 }
 }
 return $mini
}

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root Verif_L_add_exist_version {vencours} {
 set trouve 0 
 foreach e [this get_L_PM_to_add] {
	if {[lindex $e 0] == $vencours} { set trouve 1; break }
 } 
 return $trouve
}

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root Verif_L_sub_exist_version {vencours} {
 set trouve 0 
 foreach e [this get_L_PM_to_sub] {
	if {[lindex $e 0] == $vencours} { set trouve 1; break }
 } 
 return $trouve
}

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root Verif_obj_parents_in_L_add_sub {vclient obj} {
 if {[gmlObject info exists object $obj]} {
   set L [list]; $obj get_L_ancestors L
  } else {set L [list $obj]}
  
 set trouve 0
 #puts "verif if     =>    Verif_obj_parents_in_L_add_sub   => $obj"
 
 foreach e $L {
	#puts "    ->   $e"	
	set pos [lsearch [this get_L_PM_to_add] $e ]
	if {$pos > -1 && [lindex [lindex [this get_L_PM_to_add] $pos] 0] > $vclient} { set trouve 1; break }
	
	set pos [lsearch [this get_L_PM_to_sub] $e ]
	if {$pos > -1 && [lindex [lindex [this get_L_PM_to_sub] $pos] 0] > $vclient} { set trouve 1; break }
 }

 return $trouve
}

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root Verif_obj_parents_in_L_really_add_sub {obj} {
 if {[gmlObject info exists object $obj]} {
   #set L [CSS++ $objName "#$obj, #$obj <--< *"]
   set L [list]; $obj get_L_ancestors L
  } else {set L [list $obj]}
 
 set trouve 0
 foreach e $L {
	if {[lsearch $this(L_PM_really_add) $e ] > -1} { set trouve 1; break }
	if {[lsearch $this(L_PM_really_sub) $e ] > -1} { set trouve 1; break }
 }

 return $trouve
}
#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root Clear_L_PM_really_sub_add {obj} {
 if {[gmlObject info exists object $obj]} {
   #set daughts [CSS++ $obj "#$obj *"]
   set L [list]; $obj get_L_out_descendants L
   set daughts [lrange $L 0 end-1]
  } else {set daughts [list $obj]}
  
 foreach e $daughts {
	set pos [lsearch $this(L_PM_really_add) $e]
	if {$pos!=-1} {
		set this(L_PM_really_add) [lreplace $this(L_PM_really_add) $pos $pos]
	}
	
	set pos [lsearch $this(L_PM_really_sub) $e]
	if {$pos!=-1} {
		set this(L_PM_really_sub) [lreplace $this(L_PM_really_sub) $pos $pos]
	}
 }
}

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root Minimize_L_add_sub {L_PM_name} {
 upvar $L_PM_name L_PM
 
 set L_all_descendants [list]
 foreach PM $L_PM {
   set L_tmp [list]; 
   if {[gmlObject info exists object $PM]} {$PM get_L_out_descendants L_tmp;}
   Add_list L_all_descendants [lrange $L_tmp 1 end]
  }
 
 set nL [list]
 foreach PM $L_PM {
   if {[lsearch $L_all_descendants $PM] == -1} {lappend nL $PM} else {
     #puts "  On vire $PM"
	}
  }
  
 set L_PM $nL
}

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root Cmd_vserver_to_vclient {vclient strm_name} {
 upvar $strm_name strm
 set this(L_PM_really_sub) [list]
 set this(L_PM_really_add) [list]
 set listcmd               [list]
 
 
 # XXX GROS PROBLEME car BCP de version sont générés lors d'un drag...
 #     => Optimiser l'ajout de versions
 for {set ver $this(version_server)} {$ver > $vclient} {incr ver -1} {
 
	set objN [lindex $this(concat_send,$ver) 0]
	set met  [lindex $this(concat_send,$ver) 1]
	set cmd  [lindex $this(concat_send,$ver) 2] 
	#puts "version        :   $ver    $cmd"
	
	if {![this Verif_obj_parents_in_L_add_sub $vclient $objN] && $cmd != ""} {
	# [lindex [lindex [this get_L_PM_to_add] $pos] 0]
		if {[lsearch $listcmd "$objN $met"] == -1} {
			lappend listcmd "$objN $met"
			append strm $cmd "\n"
			#puts "je suis dans le if        :   $strm"
		}		
	} elseif {![this Verif_obj_parents_in_L_really_add_sub $objN]} {
		this Clear_L_PM_really_sub_add $objN
		#puts "je suis dans le elseif    :    $objN "
		
		if {[this Verif_L_add_exist_version $ver]} {
			lappend this(L_PM_really_add) $objN
			#puts "       - L_PM_really_add     :    $objN " 
		} elseif {[this Verif_L_sub_exist_version $ver]} {
			lappend this(L_PM_really_sub) $objN
			#puts "       - dans L_PM_really_sub    :    $objN "
		}
	} 
 }
 
 this Minimize_L_add_sub this(L_PM_really_sub); 
 this Minimize_L_add_sub this(L_PM_really_add); 
 
 
 foreach e $this(L_PM_really_sub) {
	append strm [this Sub_JS $e] "\n"
	#puts "\nMa boucle L_PM_really_sub    :   $strm" 
 } 
 
 foreach e $this(L_PM_really_add) {
	#append strm [$e Sub_JS] "\n"
	if {[gmlObject info exists object $e]} {
	  if {[$e get_mothers] != ""} {
	    append strm [[$e get_mothers] Add_JS $e] "\n"
		$e Render_post_JS strm
	   } else {puts "In $objName Cmd_vserver_to_vclient {$vclient} $strm_name\n  $e n'a pas de père"}
	 } else {append strm [this Sub_JS $e] "\n"}
	#puts "\nMa boucle L_PM_really_add    :   $strm"
 }
 set this(L_PM_really_sub) [list]
 set this(L_PM_really_add) [list]
}

#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root Is_update {clientversion} {
 #puts "Is_update $clientversion"
 
 set this(update_send) 1
 set this(update_cmd) ""
 
 # Découpage de la chaine reçu pour connaitre  id du client et sa version | rangement dans un tableau de clients
 # Chaine séparer par un espace => "ipclient vclient" => "192.168.0.10 20"
 set pos [string first { } $clientversion]
   set ipclient [string range $clientversion 0 [expr $pos - 1]]
   set vclient  [string range $clientversion [expr $pos + 1] end]
 
 # J'enregistre la version du client dans le tableau
 set this(version_client,$ipclient) $vclient

 # Vérif si la version du client et la même que celle du serveur
 # Si diff => Appliquer toutes les modifs depuis la version du client jusqu'à celle du serveur
 if {$vclient != $this(version_server)} {
	# j'envoie le numéro de version du serveur
	this Cmd_vserver_to_vclient $vclient this(update_cmd)
	# j'enregistre le numéro de version du serveur à envoyer
	append this(update_cmd) "\$(\"#Version_value\").val($this(version_server));\n"
	#puts "___________________________________________________"
	#puts $this(update_cmd)
 }
 
 # J'enregistre la version du serveur dans le client
 set this(version_client,$ipclient) $this(version_server)
}


#___________________________________________________________________________________________________________________________________________
method PhysicalHTML_root Enlight {L_nodes} {
 set cmd ""

# Destruction of previous enlighters
  append cmd {$('div.}  $objName {_Enlighter').remove();} "\n"
  
# Creation of new enlighters
 foreach n $L_nodes {
   # Création d'une frame(?) sous la racine
   append cmd "\$('body').append(\"<div id=\\\"${objName}_Enlighter_for_$n\\\" class=\\\"${objName}_Enlighter\\\"></div>\")\;\n"
   # Get coordinates of the targeted element n
   append cmd "var Enlight_tx = \$('#${n}').width()\;\n"
   append cmd "var Enlight_ty = \$('#${n}').height()\;\n"
   append cmd "var Enlight_x  = \$('#${n}').offset().left\;\n"
   append cmd "var Enlight_y  = \$('#${n}').offset().top\;\n"
   # Placement
   append cmd "\$('#${objName}_Enlighter_for_${n}').css({'position' : 'absolute', 'top' : Enlight_y + 'px', 'left' : Enlight_x + 'px', 'width' : Enlight_tx + 'px', 'height' : Enlight_ty + 'px'})\;\n"
   append cmd "\$('#${objName}_Enlighter_for_${n}').show('pulsate', {}, 500)\;\n"
   append cmd "\$('#${objName}_Enlighter_for_${n}').hover(function(){\$(this).text('${n}')}, function(){\$(this).text('')})\;\n"
  }
 
 # Coloration of all enlighters
 append cmd "\$('div.${objName}_Enlighter').css('background-color', 'rgba(255, 255, 0, 0.5)')\;\n"
 
 # Send the update
 this Concat_update $objName Enlight $cmd
 
 puts $cmd
}

