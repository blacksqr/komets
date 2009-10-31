
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit PM_TK_CANVAS Physical_model
#___________________________________________________________________________________________________________________________________________
method PM_TK_CANVAS constructor {name {descr {}}} {          
 this inherited $name $descr
 set this(root)          {}
 set this(cmd_deconnect) {}
 set this(L_prim_undisplayed) ""

# Let's define a command that can overload the connection specified in the mother
 set this(cmd_connect_to_mother) ""
 
 set ptf [$this(cou) get_ptf]
 $ptf maj Ptf_TK_CANVAS

 this set_cmd_placement {}
 
 set this(canvas) ""
 set this(L_canvas_tags) [list]
 
 set this(x) 0
 set this(y) 0
 
 
 set this(cmd_placement_daughters) ""
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors     PM_TK_CANVAS [list L_prim_undisplayed cmd_connect_to_mother cmd_placement_daughters canvas]

#___________________________________________________________________________________________________________________________________________
Generate_List_accessor PM_TK_CANVAS L_canvas_tags L_canvas_tags

#___________________________________________________________________________________________________________________________________________
method PM_TK_CANVAS dispose {} {foreach PMM $this(L_mothers) {$PMM Sub_prim_daughter $objName [$objName get_prim_handle]}
                                catch {$this(canvas) delete $objName}
								this inherited
                               }

#___________________________________________________________________________________________________________________________________________
method PM_TK_CANVAS Substitute_by {PM} {
 this inherited $PM
 set LM [this get_LM]
 if {$LM != ""} {$LM Connect_PM_descendants $PM {}}
}

#___________________________________________________________________________________________________________________________________________
method PM_TK_CANVAS Add_daughter {m {index -1}} {
 set rep [this inherited $m $index]
 if {$index != -1} {
   $m set_canvas [this get_canvas]
   foreach PM [this get_daughters] {this Reconnect $PM}
  }
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method PM_TK_CANVAS set_cmd_connect_to_mother {args} {
 set this(cmd_connect_to_mother) $args
 set p [this get_mothers] 
 if {$p != ""} {
   set L [$p get_daughters]
   [$p get_LM] Connect_PM_descendants
  }
 return $args
}

#___________________________________________________________________________________________________________________________________________
method PM_TK_CANVAS Show_elements_prims {b L_prims} {
 #puts "$objName PM_TK_CANVAS::Show_elements_prims $b"
 if {$b} {
   Sub_list this(L_prim_undisplayed) $L_prims
  } else {set this(L_prim_undisplayed) [Liste_Union $this(L_prim_undisplayed) $L_prims]
         }
#puts "Undisplay list : {$this(L_prim_undisplayed)}"
 [this get_mothers] Reconnect $objName
}

#___________________________________________________________________________________________________________________________________________
method PM_TK_CANVAS Add_prim_mother {c L_prims {index -1}} {
 set rep [this inherited $c $L_prims $index]
 this set_canvas [$c get_canvas]
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method PM_TK_CANVAS Reconnect {{PMD {}}} {
 if {[string equal $PMD {}]} {set PMD [this get_out_daughters]}
 foreach PM $PMD {
   foreach p [$PM get_prim_handle] {
     eval [this get_cmd_deconnect]
    }
   this Add_prim_daughter $PM      [$PM get_prim_handle]
   $PM  Add_prim_mother   $objName [this get_root_for_daughters]
  }
}

#___________________________________________________________________________________________________________________________________________
method PM_TK_CANVAS Add_prim_daughter {c Lprims {index -1}} {
  global debug
  set rep [this inherited $c $Lprims $index]

  return $rep
}

#___________________________________________________________________________________________________________________________________________
method PM_TK_CANVAS get_prim_handle {{index -1}}  {
 return $objName
}
#___________________________________________________________________________________________________________________________________________
method PM_TK_CANVAS Sub_prim_daughter {c Lprims {index -1}} {
 catch {foreach p $Lprims {$this(canvas) delete $p}}
}

#___________________________________________________________________________________________________________________________________________
method PM_TK_CANVAS get_root_for_daughters {{index -1}} {
 return [this inherited]
}

#___________________________________________________________________________________________________________________________________________
method PM_TK_CANVAS Do_prims_still_exist {} {
 if {$this(canvas) != ""} {
   if {[winfo exists $this(canvas)]} {
     return [expr ![string equal [$this(canvas) coords $objName] ""]]
	}
  }
 return 0
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method PM_TK_CANVAS Translate {x y} {
 set x [expr int($x)]; set y [expr int($y)]
 incr this(x) $x; incr this(y) $y
 $this(canvas) move $objName $x $y
}

#___________________________________________________________________________________________________________________________________________
method PM_TK_CANVAS Move_to {x y} {
 set x [expr int($x)]; set y [expr int($y)]
 $this(canvas) move $objName [expr $x - $this(x)] [expr $y - $this(y)]
 set this(x) $x; set this(y) $y
}

#___________________________________________________________________________________________________________________________________________
Manage_CallbackList PM_TK_CANVAS [list Translate Move_to] end
