#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometViewer_PM_P_TK_CANVAS_basic PM_TK_CANVAS

#___________________________________________________________________________________________________________________________________________
method CometViewer_PM_P_TK_CANVAS_basic constructor {name descr args} {
 this inherited $name $descr

   this set_GDD_id FUI_CometViewer_PM_P_TK_CANVAS_basic

   set this(animation_time) 600
   set this(tkdot_port) 10010
  
  set this(mark_for_dot) 0
  set this(setting_dot_description) 0
   
 eval "$objName configure $args"
 return $objName
}

#______________________________________________________ Adding the viewer functions _______________________________________________________
Methodes_set_LC CometViewer_PM_P_TK_CANVAS_basic [L_methodes_set_CometViewer] {}          {}
Methodes_get_LC CometViewer_PM_P_TK_CANVAS_basic [L_methodes_get_CometViewer] {$this(FC)}

#_________________________________________________________________________________________________________
Generate_PM_setters CometViewer_PM_P_TK_CANVAS_basic [P_L_methodes_PM_set_CometViewer_COMET_RE]

#_________________________________________________________________________________________________________
Generate_accessors CometViewer_PM_P_TK_CANVAS_basic [list animation_time tkdot_port]

#___________________________________________________________________________________________________________________________________________
method CometViewer_PM_P_TK_CANVAS_basic get_or_create_prims {C_canvas} {
 set this(C_canvas) $C_canvas
 if {$C_canvas == "" || $C_canvas == "NULL"} {return [this inherited $C_canvas]}
 
 this inherited $C_canvas
 
# Define the handle
 set canvas [$C_canvas get_canvas]; set this(canvas) $canvas
 this set_canvas $canvas
 
 this Add_MetaData PRIM_STYLE_CLASS [list $objName "COMPO COMPONENT" \
                                    ]

# Create TK items
 this set_root_for_daughters $C_canvas
 this Reset_comet_graph
 								
 return [this set_prim_handle $C_canvas]
}

#___________________________________________________________________________________________________________________________________________
method CometViewer_PM_P_TK_CANVAS_basic Reset_comet_graph {} {
# Get the canvas
 set C_canvas [this get_root_for_daughters]
 set c [this get_canvas]
 $c delete $objName

 this set_dot_description [this get_dot_description]
}

#___________________________________________________________________________________________________________________________________________
method CometViewer_PM_P_TK_CANVAS_basic Update_interaction {} {
 set canvas   [this get_canvas]

# Bindings for drag 
 $canvas bind $objName <ButtonPress>   "$objName Button_press   %b %x %y"
 $canvas bind $objName <ButtonRelease> "$objName Button_release %b %x %y"
 
# Bindings for zoom
 set this(zoom_factor) 1
 bind [winfo toplevel $canvas] <MouseWheel> "+ $objName trigger %W %X %Y %D"
 bind $canvas <<Wheel>> "$objName Zoom %x %y \[$objName get_delta\]"

 #bind $canvas <Motion> "+ $objName Motion %x %y" 
}

#___________________________________________________________________________________________________________________________________________
method CometViewer_PM_P_TK_CANVAS_basic get_delta {} {return $this(delta)}

#___________________________________________________________________________________________________________________________________________
method CometViewer_PM_P_TK_CANVAS_basic trigger {W X Y D} {
    set w [winfo containing -displayof $W $X $Y]
    if { $w == [this get_canvas] } {
	    #puts "CometGraphBuilder_PM_P_TK_CANVAS_basic : w = $w"
        set x [expr {$X-[winfo rootx $w]}]
        set y [expr {$Y-[winfo rooty $w]}]
        if {$D > 0} {
		  set D [expr $D / 100.0]
		 } else {set D [expr 100.0 / (-$D)]}
		set this(delta) $D
	event generate $w <<Wheel>> -rootx $X -rooty $Y -x $x -y $y
   }
 }

#___________________________________________________________________________________________________________________________________________
method CometViewer_PM_P_TK_CANVAS_basic Button_press {b x y} {
 set C_canvas [this get_root_for_daughters]
 
 switch $b {
   1 {$C_canvas set_current_element $objName $x $y}
  }
  
 set canvas   [this get_canvas]
 set item [lindex [$canvas find overlapping $x $y $x $y] end]
 if {$item != ""} {
   set L_tags [$canvas gettags $item]
   set obj    [lindex $L_tags 0]
   if {[gmlObject info exists object $obj]} {
	  if {[lindex [gmlObject info classes $obj] 0] == "GDD_Node"} {
		switch $b {
		        1 {this prim_set_L_selected_nodes $obj}
		  default {this Display_drop_down_menu $obj $x $y}
		 }
	   }
	 }
   }
 
}

#___________________________________________________________________________________________________________________________________________
method CometViewer_PM_P_TK_CANVAS_basic Button_release {b x y} {
 set C_canvas [this get_root_for_daughters]
 set factor 1.1
 switch $b {
   1 {$C_canvas set_current_element {} 0 0}
   4 {$objName Zoom %x %y $factor}
   5 {$objName Zoom %x %y [expr 1.0/$factor]}
  }
}

#___________________________________________________________________________________________________________________________________________
method CometViewer_PM_P_TK_CANVAS_basic Zoom {x y factor} {
 set C_canvas [this get_root_for_daughters]
 set canvas   [this get_canvas]
 set this(zoom_factor)   [expr $this(zoom_factor) * $factor]
 $C_canvas Zoom $objName [expr 1.0/$factor] $x $y
 $canvas itemconfigure TEXT_$objName -font "Times [expr int(12.0 / $this(zoom_factor))] normal"
}

#___________________________________________________________________________________________________________________________________________
method CometViewer_PM_P_TK_CANVAS_basic Display_drop_down_menu {obj x y} {
 set top ._toplevel_${objName}_${obj}
 if {![winfo exists $top]} {
   lassign [winfo pointerxy $this(canvas)] x y

   toplevel $top; 
   set b $top.destroy
   button $b -text "Destroy component" -command "puts BOUM!; destroy $top"
     pack $b -side top -fill x
   
   
   set    cmd "lassign \[split \[wm geometry $top\] +\] dim tmp tmp; lassign \[split \$dim x\] tx ty; "
   append cmd "wm geometry $top \$dim+\[expr $x - \$tx / 2\]+$y"
   after 10 $cmd
  }
}

 
#_________________________________________________________________________________________________________
#_________________________________________________________________________________________________________
#_________________________________________________________________________________________________________
method CometViewer_PM_P_TK_CANVAS_basic Start_Anim_Enlight {} {
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
method CometViewer_PM_P_TK_CANVAS_basic Anim_Enlight {v} {
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
method CometViewer_PM_P_TK_CANVAS_basic Enlight_with_CSS {CSS_expr} {
 set L_nodes  [CSS++ [this get_L_roots] $CSS_expr]
 this Enlight $L_nodes
}

#_________________________________________________________________________________________________________
method CometViewer_PM_P_TK_CANVAS_basic Enlight {L_nodes} {
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
method CometViewer_PM_P_TK_CANVAS_basic get_nodes_representing {e} {
 return [$this(B_canvas) get_nodes_representing $e]
}

#_________________________________________________________________________________________________________
method CometViewer_PM_P_TK_CANVAS_basic get_new_mark_for_dot {} {
 incr this(mark_for_dot)
 return $this(mark_for_dot)
}

#_________________________________________________________________________________________________________
method CometViewer_PM_P_TK_CANVAS_basic Update_dot_description {m} {
 if {$this(mark_for_dot) == $m} {
   if {$this(setting_dot_description)} {
     after 1000 "$objName Update_dot_description $m"
    } else {this set_dot_description $this(local_dot_description)}
  }
}

#_________________________________________________________________________________________________________
method CometViewer_PM_P_TK_CANVAS_basic set_dot_description {v} {
 if {$v == ""} {return}
 
 set this(tk_str) ""
 if {$this(setting_dot_description)} {
   puts "Still setting dot description...wait 1000ms."
   set this(local_dot_description) $v
   after 1000 "$objName Update_dot_description [this get_new_mark_for_dot]"
  } else {
			 if {[catch {
			   set this(setting_dot_description) 1
			   set s [socket 127.0.0.1 $this(tkdot_port)]
			   fconfigure $s -blocking 0 
			   fileevent  $s readable [list $objName Read_tk_data_from $s]
			 
			   puts $s $v
			   flush $s
			   #puts "$objName sent :\n$v"
			  } err]} {puts "Error in $objName :: set_dot_description\n  - err : $err"
					   set this(setting_dot_description) 0
					  }
         }
}

#_________________________________________________________________________________________________________
method CometViewer_PM_P_TK_CANVAS_basic Read_tk_data_from {s} {
 if {[catch "$objName catched_Read_tk_data_from $s" err]} {
   puts "Error in $objName Read_tk_data_from $s\n  -err : $err"
   catch "close $s"
   set this(setting_dot_description) 0
  }
}

#_________________________________________________________________________________________________________
method CometViewer_PM_P_TK_CANVAS_basic catched_Read_tk_data_from {s} {
 append this(tk_str) [read $s]
 #puts "__________\nReceived__________\n$s"
 if {[eof $s]} {
   #puts "in CometViewer_PM_P_TK_CANVAS_basic::$objName\n  - Server answered :\n$this(tk_str)"
   set c [this get_canvas]
   set __tkgen_smooth_type ""
   set str [string range $this(tk_str) [string first {$c} $this(tk_str)] end]
   
   
	 set this(tk_str) ""
	 foreach line [split $str "\n"] {
	   if {[regexp "^(.*) -tags \{(.*)\}.*\$" $line reco prefix tags]} {
		 lappend tags $objName
		 set tags [string map [list TEXT TEXT_$objName] $tags]
		 append this(tk_str) $prefix " -tags {$tags}\n"
		} else {append this(tk_str) $line "\n"
			   }
	  }

   
   $this(canvas) delete $objName
   
   puts "$objName CometViewer_PM_P_TK_CANVAS_basic::catched_Read_tk_data_from\n$this(tk_str)"
   if {[catch $this(tk_str) err]} {
     puts "!!!!"
	 puts "______________________________________________________________________\nERROR in CometViewer_PM_P_TK_CANVAS_basic::${objName}\n______________________________________________________________________\n$err\nProgram was\n$this(tk_str)"
    } else {this Update_interaction
			this Graph_regenerated
           }
   set this(setting_dot_description) 0
   close $s
  }
}

#_________________________________________________________________________________________________________
method CometViewer_PM_P_TK_CANVAS_basic Graph_regenerated {} {}

#_________________________________________________________________________________________________________
Manage_CallbackList CometViewer_PM_P_TK_CANVAS_basic Graph_regenerated end
