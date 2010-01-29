#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometGraphBuilder_PM_P_TK_CANVAS_basic PM_TK_CANVAS

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_TK_CANVAS_basic constructor {name descr args} {
 this inherited $name $descr

   this set_GDD_id FUI_CometGraphBuilder_PM_P_TK_CANVAS_basic
   
   set this(dim_edit_zone)        [list 1000 1000]
   
   set this(L_TK_comet_preso)     [list]
   set this(L_TK_connexions)      [list]
   set this(current_building_rel) ""
   
 eval "$objName configure $args"
 return $objName
}

#_________________________________________________________________________________________________________
Methodes_set_LC CometGraphBuilder_PM_P_TK_CANVAS_basic [P_L_methodes_set_CometGraphBuilder] {}          {}
Methodes_get_LC CometGraphBuilder_PM_P_TK_CANVAS_basic [P_L_methodes_get_CometGraphBuilder] {$this(FC)}

#_________________________________________________________________________________________________________
Generate_PM_setters CometGraphBuilder_PM_P_TK_CANVAS_basic [P_L_methodes_set_CometGraphBuilder_COMET_RE]

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_TK_CANVAS_basic get_or_create_prims {C_canvas} {
 set this(C_canvas) $C_canvas
 if {$C_canvas == "" || $C_canvas == "NULL"} {return [this inherited $C_canvas]}
 
 this inherited $C_canvas
 
# Define the handle
 set canvas [$C_canvas get_canvas]
 this set_canvas $canvas
 
 this Add_MetaData PRIM_STYLE_CLASS [list $objName "COMPO COMPONENT" \
                                    ]

# Create TK items
 this set_root_for_daughters $C_canvas
 this Reset_comet_graph
 								
 return [this set_prim_handle $C_canvas]
}

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_TK_CANVAS_basic Reset_comet_graph {} {
# Get the canvas
 set C_canvas [this get_root_for_daughters]
 set c [this get_canvas]
 $c delete $objName

# Create the edition zone
 lassign $this(dim_edit_zone) tx ty
 $c create rectangle 0 0 $tx $ty -fill green -tags [list $objName dim_edit_zone_$objName]

# Create the presentation handles for root and daughters
 CometGraphBuilder_PM_P_TK_CANVAS_basic___GRAPH_ROOT ${objName}_ROOT $C_canvas $objName; ${objName}_ROOT Translate 190 0
 CometGraphBuilder_PM_P_TK_CANVAS_basic___GRAPH_EXIT ${objName}_EXIT $C_canvas $objName; ${objName}_EXIT Translate 190 240
 
# Destroy previous comet representation
 foreach TK_comet $this(L_TK_comet_preso) {$TK_comet dispose}
 set this(L_TK_comet_preso) [list]
 
# Create Comets representations

# Update interaction
 this Update_interaction
}

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_TK_CANVAS_basic Update_interaction {} {
 set canvas   [this get_canvas]

# Bindings for START and EXIT points
 ${objName}_ROOT Subscribe_to_Translate $objName "$objName Update_connexions_related_to \[$objName get_TK_node_with_id \[$objName get_handle_root\]     \]"      UNIQUE
 ${objName}_EXIT Subscribe_to_Translate $objName "$objName Update_connexions_related_to \[$objName get_TK_node_with_id \[$objName get_handle_daughters\]\]" UNIQUE

# Bindings for drag 
 $canvas bind dim_edit_zone_$objName <ButtonPress>   "$objName Button_press   %b %x %y"
 $canvas bind dim_edit_zone_$objName <ButtonRelease> "$objName Button_release %b %x %y"
 
# Bindings for zoom
 set this(zoom_factor) 1
 bind [winfo toplevel $canvas] <MouseWheel> "+ $objName trigger %W %X %Y %D"
 bind $canvas <<Wheel>> "$objName Zoom %x %y \[$objName get_delta\]"

 bind $canvas <Motion> "+ $objName Motion %x %y" 
}

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_TK_CANVAS_basic get_delta {} {return $this(delta)}

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_TK_CANVAS_basic Motion {x y} {
 if {$this(current_building_rel) != ""} {
   lassign [$this(canvas) coords $this(current_building_rel)] sx sy
   $this(canvas) coords $this(current_building_rel) $sx $sy $x $y
  }
}

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_TK_CANVAS_basic trigger {W X Y D} {
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
method CometGraphBuilder_PM_P_TK_CANVAS_basic Button_press {b x y} {
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
method CometGraphBuilder_PM_P_TK_CANVAS_basic Button_release {b x y} {
 set C_canvas [this get_root_for_daughters]
 set factor 1.1
 switch $b {
   1 {$C_canvas set_current_element {} 0 0}
   4 {$objName Zoom %x %y $factor}
   5 {$objName Zoom %x %y [expr 1.0/$factor]}
  }
}

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_TK_CANVAS_basic Zoom {x y factor} {
 set C_canvas [this get_root_for_daughters]
 set canvas   [this get_canvas]
 set this(zoom_factor)   [expr $this(zoom_factor) * $factor]
 $C_canvas Zoom $objName [expr 1.0/$factor] $x $y
 $canvas itemconfigure TEXT_$objName -font "Times [expr int(12.0 / $this(zoom_factor))] normal"
}

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_TK_CANVAS_basic Display_drop_down_menu {obj x y} {
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

#___________________________________________________________________________________________________________________________________________
Inject_code CometGraphBuilder_PM_P_TK_CANVAS_basic set_handle_root      {} {
 set D [this get_TK_node_with_id $v]
 set M ${objName}_ROOT
 set this(L_TK_connexions) [lremove $this(L_TK_connexions) [$this(canvas) find withtag ${objName}_CONNEXION_START]]
 $this(canvas) delete ${objName}_CONNEXION_START
 if {$v != ""} {
   set connexion [eval "$this(canvas) create line [$M get_daughters_connection_point] [$D get_mothers_connection_point] -tags \[list $objName ${objName}_CONNEXION ${objName}_CONNEXION_START ${objName}_E_$v ${objName}_CONNEXION_M_$M ${objName}_CONNEXION_D_$D\]"]
   lappend this(L_TK_connexions) $connexion
  }
}

#___________________________________________________________________________________________________________________________________________
Inject_code CometGraphBuilder_PM_P_TK_CANVAS_basic set_handle_daughters {} {
 set D ${objName}_EXIT
 set M [this get_TK_node_with_id $v]
 set this(L_TK_connexions) [lremove $this(L_TK_connexions) [$this(canvas) find withtag ${objName}_CONNEXION_EXIT]]
 $this(canvas) delete ${objName}_CONNEXION_EXIT
 if {$v != ""} {
   set connexion [eval "$this(canvas) create line [$M get_daughters_connection_point] [$D get_mothers_connection_point] -tags \[list $objName ${objName}_CONNEXION ${objName}_CONNEXION_EXIT ${objName}_E_$v ${objName}_CONNEXION_M_$M ${objName}_CONNEXION_D_$D\]"]
   lappend this(L_TK_connexions) $connexion
  }
}

#___________________________________________________________________________________________________________________________________________
Inject_code CometGraphBuilder_PM_P_TK_CANVAS_basic Add_node_type {} {
 # PARAM : id name
 set C_canvas [this get_root_for_daughters]
 
 set new_preso [CPool get_a_unique_name]
 TK_comet_preso $new_preso $id $name $C_canvas [list $id $objName] $objName
 
 $new_preso Subscribe_to_Press_on_poly_mothers     $objName "$objName INTERACT_Start_rel \[list {} $new_preso\]"             UNIQUE
 $new_preso Subscribe_to_Release_on_poly_mothers   $objName "$objName INTERACT_End_rel   \[list {} $new_preso\] \$b \$x \$y" UNIQUE
 $new_preso Subscribe_to_Press_on_poly_daugthers   $objName "$objName INTERACT_Start_rel \[list $new_preso {}\]"             UNIQUE
 $new_preso Subscribe_to_Release_on_poly_daugthers $objName "$objName INTERACT_End_rel   \[list $new_preso {}\] \$b \$x \$y" UNIQUE
 $new_preso Subscribe_to_Translate                 $objName "$objName Update_connexions_related_to $new_preso"               UNIQUE
 $new_preso Subscribe_to_Ask_destroy               $objName "$objName prim_Sub_node $id"                                     UNIQUE
 
 lappend this(L_TK_comet_preso) $new_preso
 
 this Update_connexions_related_to $new_preso
}

#___________________________________________________________________________________________________________________________________________
Inject_code CometGraphBuilder_PM_P_TK_CANVAS_basic Add_node_instance {} {
 
}

#___________________________________________________________________________________________________________________________________________
Inject_code CometGraphBuilder_PM_P_TK_CANVAS_basic Sub_node {} {
 set pos 0
 foreach P $this(L_TK_comet_preso) {
   if {[$P get_id_comet_represented] == $id} {
     $P dispose
	 set this(L_TK_comet_preso) [lreplace $this(L_TK_comet_preso) $pos $pos]
	 break
    }
   incr pos
  }
  
# Destroy related connexions
 set new_L [list]
 foreach connexion $this(L_TK_connexions) {
   if {[lsearch [$this(canvas) gettags $connexion] ${objName}_E_$id] >= 0} {
     $this(canvas) delete $connexion
    } else {lappend new_L $connexion}
  }
 set this(L_TK_connexions) $new_L
}

#___________________________________________________________________________________________________________________________________________
proc compare_TK_node_abscisse {T1 T2} {
 set x1 [lindex [$T1 get_daughters_connection_point] 0]
 set x2 [lindex [$T2 get_daughters_connection_point] 0]
 
 return [expr $x1 > $x2]
}

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_TK_CANVAS_basic Update_connexions_related_to {TK_preso} {
 if {$TK_preso == ""} {return}
 
# get the related CFC node
 set id [$TK_preso get_id_comet_represented]
 set CFC_node [this get_node_with_id $id]

# Update connexions where TK_preso is the daughter 
 foreach mother [$CFC_node get_mothers] {
   set id_m       [$mother get_id]
   set TK_preso_M [this get_TK_node_with_id $id_m]
   eval "$this(canvas) coords ${objName}_CONNEXION_${id_m}_${id} [$TK_preso_M get_daughters_connection_point] [$TK_preso get_mothers_connection_point]"
  }
  
# Update connexions where TK_preso is the mother
 foreach daughter [$CFC_node get_daughters] {
   set id_d       [$daughter get_id]
   set TK_preso_D [this get_TK_node_with_id $id_d]
   eval "$this(canvas) coords ${objName}_CONNEXION_${id}_${id_d} [$TK_preso get_daughters_connection_point] [$TK_preso_D get_mothers_connection_point]"
  }

# Update connexions related to START and EXIT points if necessary
 if {$id == [this get_handle_root]} {
   set TK_preso_M ${objName}_ROOT
   eval "$this(canvas) coords ${objName}_CONNEXION_START [$TK_preso_M get_daughters_connection_point] [$TK_preso get_mothers_connection_point]"
  }
 if {$id == [this get_handle_daughters]} {
   set TK_preso_D ${objName}_EXIT
   eval "$this(canvas) coords ${objName}_CONNEXION_EXIT [$TK_preso get_daughters_connection_point] [$TK_preso_D get_mothers_connection_point]"
  }
  
# Re-order, if necessary, the position of the node in its mothers list with respect to the spatial position
 foreach mother [$CFC_node get_mothers] {
   set L_TK_d [list]; foreach d [$mother get_daughters] {lappend L_TK_d [this get_TK_node_with_id [$d get_id]]}
   set L_TK_d [lsort -command compare_TK_node_abscisse $L_TK_d]
   set L_d [list]   ; foreach tk_d $L_TK_d              {lappend L_d    [this get_node_with_id [$tk_d get_id_comet_represented]]}
    
   $mother set_daughters $L_d
  }
}

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_TK_CANVAS_basic get_TK_node_with_id {id} {
 foreach node $this(L_TK_comet_preso) {
   if {$id == [$node get_id_comet_represented]} {return $node}
  }
 
 return ""
}

#___________________________________________________________________________________________________________________________________________
Inject_code CometGraphBuilder_PM_P_TK_CANVAS_basic Add_rel {} {
 set D [this get_TK_node_with_id $id_d]
 set M [this get_TK_node_with_id $id_m]
 set connexion [eval "$this(canvas) create line [$M get_daughters_connection_point] [$D get_mothers_connection_point] -tags \[list $objName ${objName}_CONNEXION ${objName}_CONNEXION_${id_m}_${id_d} ${objName}_E_$id_m ${objName}_E_$id_d ${objName}_CONNEXION_M_$M ${objName}_CONNEXION_D_$D\]"]
 lappend this(L_TK_connexions) $connexion
 
 this Update_connexions_related_to $D
}

Trace CometGraphBuilder_PM_P_TK_CANVAS_basic Add_rel

#___________________________________________________________________________________________________________________________________________
Inject_code CometGraphBuilder_PM_P_TK_CANVAS_basic Sub_rel {} {
 $this(canvas) delete ${objName}_CONNEXION_${id_m}_${id_d}
 set this(L_TK_connexions) [lremove $this(L_TK_connexions) ${objName}_CONNEXION_${id_m}_${id_d}]
}
Trace CometGraphBuilder_PM_P_TK_CANVAS_basic Sub_rel

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_TK_CANVAS_basic INTERACT_Start_rel {R} {
 if {$this(current_building_rel) != ""} {return}
 set this(current_building_rel) $R
 if {[lindex $R 0] != ""} {
   set obj [lindex $R 0]
   set pt [$obj get_daughters_connection_point]
  } else {set obj [lindex $R 1]
          set pt [$obj get_mothers_connection_point]
		 }
		 
# Create the pending connexion
 set this(current_building_rel) [$this(canvas) create line 0 0 0 0 -tags [list $objName pending_connexion_$objName]]

 eval "$this(canvas) coords $this(current_building_rel) $pt $pt"
}

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_TK_CANVAS_basic INTERACT_End_rel {R b x y} {
 if {$this(current_building_rel) == ""} {return}
 
 if {[lindex $R 0] == ""} {set mother   ""} else {set mother   [lindex $R 0]}
 if {[lindex $R 1] == ""} {set daughter ""} else {set daughter [lindex $R 1]}
  
# What is beneath the pointer?
 set C_canvas [this get_root_for_daughters]
 set canvas   [$C_canvas get_canvas]
 set item [lindex [$canvas find overlapping $x $y $x $y] end-1]
 set L_tags [$canvas gettags $item]
 puts "  Release on item $item with tags {$L_tags}"
 foreach t $L_tags {
   if {[string equal -length 8 "MOTHERS_" $t]} {set daughter [string range $t 8 end]
    } else {if {[string equal -length 10 "DAUGTHERS_" $t]} {set mother [string range $t 10 end]
	         } else {if {[string equal -length 15 $t "TK_comet_preso_"]} {
			           if {$mother   == ""} {set mother   [string range $t 15 end]}
					   if {$daughter == ""} {set daughter [string range $t 15 end]}
					  }
			        }
	       }
  }
 
 
 if {$mother != "" && $daughter != ""} {
   set CFC_M [this get_node_with_id [$mother   get_id_comet_represented]]
   set CFC_D [this get_node_with_id [$daughter get_id_comet_represented]]
   if {[$CFC_M Contains_daughters $CFC_D]} {
     this prim_Sub_rel [$mother get_id_comet_represented] [$daughter get_id_comet_represented]
    } else {this prim_Add_rel [$mother get_id_comet_represented] [$daughter get_id_comet_represented]}
  } else {
          # It may have been release on the START or EXIT point
		  if {[lsearch $L_tags ${objName}_ROOT] >= 0 && $daughter != ""} {this prim_set_handle_root      [$daughter get_id_comet_represented]}
		  if {[lsearch $L_tags ${objName}_EXIT] >= 0 && $mother   != ""} {this prim_set_handle_daughters [$mother   get_id_comet_represented]}
         }
  
# Destroy th pending connexion
 $this(canvas) delete $this(current_building_rel) 
 set this(current_building_rel) ""
}





#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_TK_CANVAS_basic___GRAPH_ROOT constructor {C_canvas tags} {
 set canvas [$C_canvas get_canvas]; set this(canvas) $canvas
 $canvas create oval 0 0 20 20 -fill black -tags [concat $tags [list $objName]]
 
 $canvas bind $objName <ButtonPress>   [list $C_canvas set_current_element $objName %x %y]
 $canvas bind $objName <ButtonRelease> [list $C_canvas set_current_element {} %x %y]

 set this(x) 10; set this(y) 0
 
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_TK_CANVAS_basic___GRAPH_ROOT Translate {x y} {
 set x [expr int($x)]; set y [expr int($y)]
 incr this(x) $x; incr this(y) $y
 $this(canvas) move $objName $x $y
}

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_TK_CANVAS_basic___GRAPH_ROOT get_daughters_connection_point {} {
 lassign [$this(canvas) bbox $objName] x1 y1 x2 y2
 
 return [list [expr ($x1+$x2)/2.0] [expr ($y1+$y2)/2.0]]
}

#___________________________________________________________________________________________________________________________________________
Manage_CallbackList CometGraphBuilder_PM_P_TK_CANVAS_basic___GRAPH_ROOT [list Translate] end

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_TK_CANVAS_basic___GRAPH_EXIT constructor {C_canvas tags} {
 set canvas [$C_canvas get_canvas]; set this(canvas) $canvas
 $canvas create oval 0 0 20 20 -fill white -tags [concat $tags [list $objName]]
 $canvas create oval 4 4 16 16 -fill black -tags [concat $tags [list $objName]]

 $canvas bind $objName <ButtonPress>   [list $C_canvas set_current_element $objName %x %y]
 $canvas bind $objName <ButtonRelease> [list $C_canvas set_current_element {} %x %y]

 set this(x) 10; set this(y) 0
 
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_TK_CANVAS_basic___GRAPH_EXIT Translate {x y} {
 set x [expr int($x)]; set y [expr int($y)]
 incr this(x) $x; incr this(y) $y
 $this(canvas) move $objName $x $y
}

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_PM_P_TK_CANVAS_basic___GRAPH_EXIT get_mothers_connection_point {} {
 lassign [$this(canvas) bbox $objName] x1 y1 x2 y2
 
 return [list [expr ($x1+$x2)/2.0] [expr ($y1+$y2)/2.0]]
}

#___________________________________________________________________________________________________________________________________________
Manage_CallbackList CometGraphBuilder_PM_P_TK_CANVAS_basic___GRAPH_EXIT [list Translate] end
