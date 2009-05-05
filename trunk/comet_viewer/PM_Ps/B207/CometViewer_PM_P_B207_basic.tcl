source [get_B207_files_root]B_Spline.tcl
source [get_B207_files_root]B_canvas.tcl

#_________________________________________________________________________________________________________
inherit CometViewer_PM_P_B207_basic PM_BIGre

#_________________________________________________________________________________________________________
method CometViewer_PM_P_B207_basic constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CometViewer_PM_P_B207_basic

 set this(animation_time) 600
 set this(tkdot_port) 10010
 set this(B_canvas)   ${objName}_BC; BIGre_canvas $this(B_canvas)

 this set_prim_handle        [$this(B_canvas) get_root]
 this set_root_for_daughters [$this(B_canvas) get_root]
 
 eval "$objName configure $args"
 return $objName
}

#______________________________________________________ Adding the viewer functions _______________________________________________________
Methodes_set_LC CometViewer_PM_P_B207_basic [L_methodes_set_CometViewer] {}          {}
Methodes_get_LC CometViewer_PM_P_B207_basic [L_methodes_get_CometViewer] {$this(FC)}

#_________________________________________________________________________________________________________
Generate_PM_setters CometViewer_PM_P_B207_basic [P_L_methodes_PM_set_CometViewer_COMET_RE]

#_________________________________________________________________________________________________________
Generate_accessors CometViewer_PM_P_B207_basic [list B_canvas animation_time tkdot_port]

#_________________________________________________________________________________________________________
method CometViewer_PM_P_B207_basic Start_Anim_Enlight {} {
 set fond [$this(B_canvas) get_fond]; 
 if {$fond != ""} {
   $fond Calculer_boites
   set box  [$fond Boite_noeud]; set X [$box BG_X]; set Y [$box BG_Y]; set Ex [$box Tx]; set Ey [$box Ty]
   foreach n [$this(B_canvas) get_highlighters] {
     $n Ajouter_MetaData_T params_transfo "$X $Y $Ex $Ey 0 [$n Px] [$n Py] [$n Ex] [$n Ey] [$n Couleur 3]"
     $n maj $X $Y 0 $Ex $Ey
    }
  }
}

#_________________________________________________________________________________________________________
method CometViewer_PM_P_B207_basic Anim_Enlight {v} {
 foreach n [$this(B_canvas) get_highlighters] {
   #puts "$n : v = $v"
   set params [$n Val_MetaData params_transfo]
   set X1 [lindex $params 0]; set Y1 [lindex $params 1]; set Ex1 [lindex $params 2]; set Ey1 [lindex $params 3]; set A1 [lindex $params 4]
   set X2 [lindex $params 5]; set Y2 [lindex $params 6]; set Ex2 [lindex $params 7]; set Ey2 [lindex $params 8]; set A2 [lindex $params 9]
   set dv [expr 1-$v]
   $n Couleur 3 [expr $A1*$dv + $A2*$v]
   $n maj [expr $X1*$dv + $X2*$v] \
          [expr $Y1*$dv + $Y2*$v] \
		  0 \
		  [expr $Ex1*$dv + $Ex2*$v] \
		  [expr $Ey1*$dv + $Ey2*$v]
  }
}

#_________________________________________________________________________________________________________
method CometViewer_PM_P_B207_basic Enlight_with_CSS {CSS_expr} {
 set L_nodes  [CSS++ [this get_L_roots] $CSS_expr]
 this Enlight $L_nodes
}

#_________________________________________________________________________________________________________
method CometViewer_PM_P_B207_basic Enlight {L_nodes} {
 $this(B_canvas) Stop_Enlight
 
 set L_L_elmt [list]
 foreach n $L_nodes {
   lappend L_L_elmt [$this(B_canvas) get_nodes_representing $n]
  }
 
 #puts "L_L_elmt = $L_L_elmt"
 $this(B_canvas) Enlight $L_L_elmt
 
 this Start_Anim_Enlight
 B_transfo_rap $this(animation_time) "if {\[catch \"$objName Anim_Enlight \$v\" err\]} {puts \"Error Anim_Enlight \$v:\n\$err\"}"
}

#_________________________________________________________________________________________________________
method CometViewer_PM_P_B207_basic get_nodes_representing {e} {
 return [$this(B_canvas) get_nodes_representing $e]
}

#_________________________________________________________________________________________________________
method CometViewer_PM_P_B207_basic set_dot_description {v} {
 set this(tk_str) ""
 
 if {[catch {
   set s [socket 127.0.0.1 $this(tkdot_port)]
   fconfigure $s -blocking 0 
   fileevent  $s readable [list $objName Read_tk_data_from $s]
 
   puts $s $v
   flush $s
  } err]} {puts "Error in $objName :: set_dot_description\n  - err : $err"
          }
}

#_________________________________________________________________________________________________________
method CometViewer_PM_P_B207_basic Read_tk_data_from {s} {
 append this(tk_str) [read $s]
 #puts "__________\nReceived__________\n$s"
 if {[eof $s]} {
   #puts "in CometViewer_PM_P_B207_basic::$objName\n  - Server answered :\n$this(tk_str)"
   set c $this(B_canvas)
   set __tkgen_smooth_type ""
   set this(tk_str) [string range $this(tk_str) [string first {$c} $this(tk_str)] end]
   $this(B_canvas) Vider
   if {[catch $this(tk_str) err]} {
     puts "!!!!"
	 puts "______________________________________________________________________\nERROR in CometViewer_PM_P_B207_basic::${objName}\n______________________________________________________________________\n$err\nProgram was\n$this(tk_str)"
    } else {$this(B_canvas) Gestion_ctc
            $this(B_canvas) Link_contacts_and_co
            $this(B_canvas) Maj_MetaData_Markers CometPM
			foreach n [$this(B_canvas) get_L_nodes] {
			  if {[string range $n 12 end] == "alx_noeud_zone_texte_sdl_opengl"} {
			    Drag_nodes $n 1 "" ""
			   }
			 }
           }
   close $s
  }
}
