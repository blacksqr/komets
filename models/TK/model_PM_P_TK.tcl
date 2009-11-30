
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit PM_TK Physical_model
#___________________________________________________________________________________________________________________________________________
method PM_TK constructor {name {descr {}}} {          
 this inherited $name $descr
 set this(root)               {}
 this set_cmd_deconnect       {pack forget $p}
 set this(L_prim_undisplayed) [list]

# Let's define a command that can overload the connection specified in the mother
 set this(cmd_connect_to_mother) ""
 
 set ptf [$this(cou) get_ptf]
 $ptf maj Ptf_TK

 this set_cmd_placement {pack $p -expand 1 -fill both}
 
 set this(cmd_placement_daughters) ""
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors PM_TK [list L_prim_undisplayed cmd_connect_to_mother cmd_placement_daughters]

#___________________________________________________________________________________________________________________________________________
method PM_TK dispose {} {foreach PMM $this(L_mothers) {$PMM Sub_prim_daughter $objName [$objName get_prim_handle]}
                         this inherited
                        }

						
#___________________________________________________________________________________________________________________________________________
method PM_TK Substitute_by {PM} {
 this inherited $PM
 set LM [this get_LM]
 if {$LM != ""} {$LM Connect_PM_descendants $PM {}}
}

#___________________________________________________________________________________________________________________________________________
method PM_TK Add_daughter {m {index -1}} {
 set rep [this inherited $m $index]
 if {$index != -1 && $index + 1 != [this get_nb_daughters]} {
   foreach PM [this get_daughters] {this Reconnect $PM}
  }
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method PM_TK set_cmd_connect_to_mother {args} {
 set this(cmd_connect_to_mother) $args
 set p [this get_mothers] 
 if {$p != ""} {
   set L [$p get_daughters]
   [$p get_LM] Connect_PM_descendants
  }
 return $args
}

#___________________________________________________________________________________________________________________________________________
method PM_TK Show_elements_prims {b L_prims} {
 #puts "  $objName PM_TK::Show_elements_prims $b"
 if {$b} {
   Sub_list this(L_prim_undisplayed) $L_prims
  } else {set this(L_prim_undisplayed) [Liste_Union $this(L_prim_undisplayed) $L_prims]
         }
#puts "Undisplay list : {$this(L_prim_undisplayed)}"
 if {[catch {[this get_mothers] Reconnect $objName} err]} {
   puts "Show_elements_prims:ERROR occured in $objName PM_TK::Update_placement\n$err"
  }
}

#___________________________________________________________________________________________________________________________________________
method PM_TK Add_prim_mother {c L_prims {index -1}} {
 set rep [this inherited $c $L_prims $index]
 if {$this(cmd_connect_to_mother) != ""} {
   #puts "On fait : {$this(cmd_connect_to_mother)}"
   if {[catch $this(cmd_connect_to_mother) err]} {
     puts "___!!!___Error in $objName Add_prim_mother $c {$L_prims} $index :\n$err"
	 set rep 0
    }
  }
 foreach p $this(L_prim_undisplayed) {
   if {[catch "pack forget $p" err]} {puts "$objName Add_prim_mother:ERROR pack forget : $err"}
  }
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method PM_TK Update_placement {args} {
 set PMM [this get_mothers]
 if {[catch {$PMM Reconnect} err]} {
   puts "Update_placement:ERROR occured in $objName PM_TK::Update_placement\n$err"
  }
}

#___________________________________________________________________________________________________________________________________________
method PM_TK Reconnect {{PMD {}}} {
 if {$PMD == ""} {set PMD [this get_out_daughters]}
 foreach PM $PMD {
   foreach p [$PM get_prim_handle] {
     eval [$PM get_cmd_deconnect]
    }
   set rep [this Add_prim_daughter $PM      [$PM get_prim_handle]]        
   set rep [$PM  Add_prim_mother   $objName [this get_root_for_daughters]]
  }
}

#___________________________________________________________________________________________________________________________________________
method PM_TK get_width  {{PM {}}} {if {[winfo exists $this(primitives_handle)]} {return [winfo width  $this(primitives_handle)]} else {return -1}}
method PM_TK get_height {{PM {}}} {if {[winfo exists $this(primitives_handle)]} {return [winfo height $this(primitives_handle)]} else {return -1}}

#___________________________________________________________________________________________________________________________________________
method PM_TK Adequacy {context {force_eval_ctx 0}} {
 if {[expr $force_eval_ctx||([this get_width]==-1)]} {# The PM is not plugged
   if {[regexp  {ws_w=([0-9|\.]*)} $context reco PMM_tx]} {
     if {[regexp {ws_h=([0-9|\.]*)} $context reco PMM_ty]} {
       set PM_tx  [this get_ideal_width]; set PM_ty  [this get_ideal_height]
       set ratio_x [expr ($PM_tx<$PMM_tx)?(double($PM_tx)/$PMM_tx):(double($PMM_tx)/(10*$PM_tx))]
       set ratio_y [expr ($PM_ty<$PMM_ty)?(double($PM_ty)/$PMM_ty):(double($PMM_ty)/(10*$PM_ty))]
       return [expr $ratio_x*$ratio_y]
      }
    }
   return -1
  }
# The context here contain the mother
 puts "   Adequation de \"$this(primitives_handle)\""
 if {[regexp  {<mother>(.*)</mother>} $context reco PMM]} {
   set PM_tx  [this get_ideal_width]; set PM_ty  [this get_ideal_height]
   set PMM_tx [winfo width $this(primitives_handle)]; set PMM_ty [winfo height $this(primitives_handle)]
   set ratio_x [expr ($PM_tx<$PMM_tx)?(double($PM_tx)/$PMM_tx):(double($PMM_tx)/(10*$PM_tx))]
   set ratio_y [expr ($PM_ty<$PMM_ty)?(double($PM_ty)/$PMM_ty):(double($PMM_ty)/(10*$PM_ty))]
   return [expr $ratio_x*$ratio_y]
  }
 return -1
}

#___________________________________________________________________________________________________________________________________________
method PM_TK set_cmd_placement_daughters {args} {
 set this(cmd_placement_daughters) $args
 if {[catch "eval $this(cmd_placement_daughters)" err]} {
   puts "___!!!___ERROR in $objName set_cmd_placement_daughters $args :\n$err"
   return 0
  }
  
 return 1
}

#___________________________________________________________________________________________________________________________________________
method PM_TK Add_prim_daughter {c Lprims {index -1}} {global debug
													  set rep [this inherited $c $Lprims $index]
													  if {$this(cmd_placement_daughters) != "" && [$c get_cmd_placement] == ""} {
													    if {[catch "eval $this(cmd_placement_daughters)" err]} {
														  puts "___!!!___ERROR in $objName Add_prim_daughter $c {$Lprims} $index :\n$err"
														 }
													   }
                                                      if {!$rep} {
                                                        set L [this get_prim_handle]
                                                        if {[expr [llength $L]==1 && [llength $Lprims]==1]} {
                                                          if {$debug} {puts "       ERROR gave rise to \"pack forget $L\""}
#                                                          pack forget $L
                                                         }
                                                       } else {set L [this get_prim_handle]
                                                              }
                                                    return $rep
                                                   }
												   
#___________________________________________________________________________________________________________________________________________
method PM_TK set_prim_handle {h} {
 if {![this Has_MetaData PRIM_STYLE_CLASS]} {
   this Add_MetaData PRIM_STYLE_CLASS [list $h ROOT]
  }
 return [this inherited $h]
}

#___________________________________________________________________________________________________________________________________________
method PM_TK get_prim_handle {{index -1}}  {
 set n [lindex $this(primitives_handle) 0]
 if {[winfo exists $n]} {return $this(primitives_handle)}
 return NULL
}
#___________________________________________________________________________________________________________________________________________
method PM_TK Sub_prim_daughter {c Lprims {index -1}} {
  #XXX A MODIFIER XXX
  foreach p $Lprims {
    if {![catch {pack forget $p} err]} {destroy $p}
   }
}
#___________________________________________________________________________________________________________________________________________
method PM_TK get_root_for_daughters {{index -1}} {
 set rep [this inherited]
 if {[string equal $rep {}]} {return {}}
 if {[winfo exists $rep]} {
   return $rep
  } else {return NULL}
}

#___________________________________________________________________________________________________________________________________________
method PM_TK Do_prims_still_exist {} {
 return [winfo exists [lindex $this(primitives_handle) 0]]
}

