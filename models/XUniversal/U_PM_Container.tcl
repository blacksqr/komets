#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit PM_U_Container PM_Universal

#___________________________________________________________________________________________________________________________________________
method PM_U_Container constructor {name descr args} {
 this inherited $name $descr
   this set_nb_max_daughters 99999
   this set_nb_max_mothers   1
   set this(L_nested_handle_LM)    [list]
   set this(L_nested_daughters_PM) [list]
   set this(L_nested_daughters_LM) [list]; set this(L_nested_daughters_LM_only) [list]
   set this(mode_plug)			   Empty
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method PM_U_Container dispose {} {
 this inherited
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors PM_U_Container [list L_nested_daughters_LM L_nested_daughters_PM L_nested_handle_LM L_nested_daughters_LM_only mode_plug]

#___________________________________________________________________________________________________________________________________________
method PM_U_Container Register_nested_elements {} {
 set L_LC_inside [CSS++ $objName "#${objName}(>*->LC.GENERATED_FOR_$objName, >*->LC GENERATED_FOR_$objName)"]
 this set_L_composing_comets $L_LC_inside
}

#___________________________________________________________________________________________________________________________________________
# method PM_U_Container Register_nested_element_from {Ln} {
 # foreach n $Ln {
   # set n_ancestors [CSS++ $objName "#$n <--< * \\!>*/"]
   # set n_handles   [CSS++ $objName "#${objName}(>*->LC)"]
   # if {![Is_sub_list $n_ancestors $n_handles]} {continue}
   # this Add_composing_comet          $n
   # this Register_nested_element_from [$n get_out_daughters]
  # }
# }

#___________________________________________________________________________________________________________________________________________
method PM_U_Container set_L_nested_daughters_PM {L} {
 set this(L_nested_daughters_PM) $L
 
 set L_PM [list]; foreach e $L {lappend L_PM [lindex $e 0]}
 this set_handle_comet_daughters $L_PM ""
}

#___________________________________________________________________________________________________________________________________________
method PM_U_Container Update_L_nested_daughters_PM {} {
 set L [join [this get_L_nested_daughters_LM_only] ", "]; set L_nested_daughters_PM [list]
 foreach PM [CSS++ $objName "#$objName ~ ($L)"] LM_mark [this get_L_nested_daughters_LM] {
   if {$PM != ""} {lassign $LM_mark LM mark
                   lappend L_nested_daughters_PM [list $PM $mark]
				  }
  }
  
 this set_L_nested_daughters_PM $L_nested_daughters_PM
}

#___________________________________________________________________________________________________________________________________________
method PM_U_Container Add_mother    {m {index -1}} {
 set rep [this inherited $m $index]
 #puts "$objName Add_mother $m\n  -mode_plug : [this get_mode_plug]\n  -rep : $rep\n  - daughters : [this get_daughters]\n  - prim : [this get_prim_handle]"
 if {$rep} {
   this set_mode_plug Empty
   this set_daughters {}
   this set_L_nested_daughters_PM [list]
   this set_mode_plug Full
   #global debug; set debug 1
   #puts "   ___ Connect PM descendant, type = [${objName}_cou_ptf get_soft_type]"
   [this get_LM] Connect_PM_descendants $objName $this(L_nested_handle_LM)
   #set debug 0
   
  #puts "  obj $objName prim : [this get_prim_handle]\n  obj daughters : {[this get_daughters]}\n  Mother $m prim : [$m get_root_for_daughters]"
  # Let's find a nested PM among handles to connect to $m
  this Update_L_nested_daughters_PM
  
  if {[llength [this get_L_nested_daughters_PM]] == 0} {
     puts "STRANGE !!! In $objName Add_mother $m $index"
     this set_L_nested_daughters_PM [list [CSS++ $objName "#[this get_L_nested_daughters_LM_only]->PMs"] *]
    }

   this set_mode_plug Full
   if {$this(L_nested_handle_LM) != ""} {
     set LC [$this(L_nested_handle_LM) get_LC]
	 if {$LC != ""} {this Register_nested_elements}
    }
	
   this Apply_default_style
  } else {this set_daughters {}; this set_mode_plug Empty; puts "$objName Add_mother $m => GROS ECHEC"}

 
 #puts "FIN $objName Add_mother $m $index"
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method PM_U_Container Basic_Sub_daughter {d} {
# A daughter has been deleted !
 this inherited $d
 foreach e $this(L_nested_daughters_PM) {
   if {[lindex $e 0] == $d} {set this(L_nested_daughters_PM) [lreplace $this(L_nested_daughters_PM) $pos $pos]
                             break
							}
   incr pos
  }
 # OLD Sub_list this(L_nested_daughters_PM) $d
}

#___________________________________________________________________________________________________________________________________________
method PM_U_Container Sub_daughter {m} {
 global debug
 if {$debug} {puts "<$objName PM_U_Container::Sub_daughter $m>"}
 if {[string equal $this(mode_plug) Empty]} {
   #puts "  this inherited"
   set rep [this inherited $m]
  } else {
         #if {![gmlObject info exists object $m]} {puts "$objName PM_U_Container::Sub_daughter $m !!!\n  - $m NO MORE EXISTS"; return [this inherited $m]}
		  set pos [lsearch -index 0 $this(L_nested_daughters_PM) $m]
		  if {$pos != -1} {
		    set this(L_nested_daughters_PM) [lreplace $this(L_nested_daughters_PM) $pos $pos]
			if {[llength $this(L_nested_daughters_PM)] == 0} {set this(mode_plug) Empty}
			set rep [this inherited $m]
		   } else {
		           set pos [lsearch [this get_handle_composing_comet] $m]
		           if {$pos != -1} {
				     this Sub_handle_composing_comet $m
					 set rep [this inherited $m]
				    }
		          }
		  set rep 0
		  if {$debug} {puts "<$objName Unplug $ m from nested_daughters/>"}
		  foreach PM_mark $this(L_nested_daughters_PM) {
		    lassign $PM_mark PM mark
            set rep [expr $rep || [$PM Sub_daughter $m]]
           }
		  #return $rep 
		 }
 if {$debug} {puts "</$objName PM_U_Container::Sub_daughter $m>"}
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method PM_U_Container Sub_mother {m} {
 global debug
 if {$debug} {puts "<${objName}::Sub_mother $m>"}
 set rep [this inherited $m]
 # DEBUG, c'était juste la ligne avant
 if {$debug} {puts "<${objName}::Sub_mother $m MIDDLE />"}
 #if {[lsearch [this get_mothers] $m] >= 0} {
 #  this set_daughters {}
 # }
# /DEBUG
 if {$rep} {
   set ptf $this(cou)_ptf
     $ptf set_hard_type *
     $ptf set_soft_type *
     $ptf set_OS_type   *
  }
 
 this set_mode_plug Empty
 this set_L_nested_daughters_PM  ""
 this set_handle_composing_comet ""
 # DEBUG
   #this set_daughters {}
 # /DEBUG
 if {$debug} {puts "</${objName}::Sub_mother $m>"}
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method PM_U_Container Add_daughter {m {index -1}} {
 global debug
 if {$debug} {puts "<${objName}::Add_daughter $m>"}
 if {[lsearch $this(L_nested_handle_LM) [$m get_LM]] >= 0} {
   set nb [this get_nb_max_daughters]
   this set_nb_max_daughters 99999999
    set rep [this inherited $m $index]
   this set_nb_max_daughters $nb
   if {$debug} {puts "  CASE 1, rep $rep"}
  } else {if {[llength $this(L_nested_handle_LM)] == 0} {
			 set rep [this inherited $m $index]
			 if {$debug} {puts "  CASE 2, rep $rep"}
           } else {set rep 1
		           if {$index == -1} {set i end} else {set i $index}
				   
				   # Find the daughters handler that must be connected to $m\n
				   foreach handle $this(L_nested_daughters_PM) {
				     lassign $handle handle_daughter CSSpp_mark
					 if {[$m Has_for_style $CSSpp_mark]} {
					   $handle_daughter Add_daughter $m $index
					   [$handle_daughter get_LM] Connect_PM_descendants $handle_daughter [$m get_LM]
					   break
					  } else {lappend L_still_done }
				    }
				   
				   
		           # OLD set handle_daughter [lindex $this(L_nested_daughters_PM) $i]
				   # if {$handle_daughter == ""} {
				     # set handle_daughter [lindex $this(L_nested_daughters_PM) end]
					# } else {$handle_daughter Add_daughter $m $index
					        # [$handle_daughter get_LM] Connect_PM_descendants $handle_daughter [$m get_LM]
				           # }
				   if {$debug} {puts "  CASE 3, rep $rep"}
                  }
         }

 this set_handle_composing_comet [this get_daughters] ""
 
 if {$debug} {puts "  /DAUGHTERS : [this get_daughters]"
              puts "</${objName}::Add_daughter $m>"}
 
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method PM_U_Container Reconnect {PMD} {
 set L_d [this get_daughters]
 set rep [this inherited [Liste_Intersection $PMD $L_d]]
 foreach PM_mark $this(L_nested_daughters_PM) {
   lassign $PM_mark PM m
   $PM Reconnect [$PM get_daughters]
  }
 
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method PM_U_Container Update {} {
   this inherited
   set m [this get_mothers]
   if {[string equal $m ""]} {return}
     this Sub_mother $m
     this Add_mother $m
}
#

#___________________________________________________________________________________________________________________________________________
method PM_U_Container set_L_nested_daughters_LM {L} {
 set this(L_nested_daughters_LM) [list]; set this(L_nested_daughters_LM_only) [list]
 foreach e $L {
   lassign $e LM mark; lappend this(L_nested_daughters_LM_only) $LM
   if {$mark == ""} {set mark *}
   lappend this(L_nested_daughters_LM) [list $LM $mark]
  }
}

#___________________________________________________________________________________________________________________________________________
method PM_U_Container Add_prim_daughter {c Lprims {index -1}} {
 set rep [this inherited $c $Lprims $index]
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method PM_U_Container Sub_prim_daughter {c Lprims {index -1}} {
 set rep [this inherited $c $Lprims $index]
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method PM_U_Container get_or_create_prims {root} {
 set rep [this inherited $root]
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method PM_U_Container get_prim_handle {{index -1}}  {
 set rep [this inherited $index]
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method PM_U_Container get_root_for_daughters {{index -1}} {
 set rep [this inherited $index]
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method PM_U_Container Do_prims_still_exist {} {
 return [this inherited]
}

