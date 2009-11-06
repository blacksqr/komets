#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit PM_U_Container PM_Universal

#___________________________________________________________________________________________________________________________________________
method PM_U_Container constructor {name descr args} {
 this inherited $name $descr
   this set_nb_max_daughters 99999
   this set_nb_max_mothers   1
   set this(L_nested_handle_LM)    {}
   set this(L_nested_daughters_PM) {}
   set this(L_nested_daughters_LM) {}
   set this(mode_plug)			   Empty
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method PM_U_Container dispose {} {
 puts "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-$objName dispose"
 this inherited
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors PM_U_Container [list L_nested_daughters_LM L_nested_daughters_PM L_nested_handle_LM mode_plug]

#___________________________________________________________________________________________________________________________________________
method PM_U_Container Register_nested_element_from {Ln} {
 foreach n $Ln {
   #puts "Considering $n"
   set n_ancestors [CSS++ $objName "#$n <--< * \\!>*/"]
   set n_handles   [CSS++ $objName "#${objName}(>*->LC)"]
   if {![Is_sub_list $n_ancestors $n_handles]} {continue}
   #if {![$n Has_MetaData Generated_to_be_encapsulated_in]}             {continue}
   #if { [$n Val_MetaData Generated_to_be_encapsulated_in] != $objName} {continue}
   #puts "  OK"
   this Add_composing_comet          $n
   this Register_nested_element_from [$n get_out_daughters]
  }
}

#___________________________________________________________________________________________________________________________________________
method PM_U_Container set_L_nested_daughters_PM {L} {
 set this(L_nested_daughters_PM) $L
 this set_handle_comet_daughters $L ""
}

#___________________________________________________________________________________________________________________________________________
method PM_U_Container Add_mother    {m {index -1}} {
 set rep [this inherited $m $index]
 #puts "$objName Add_mother $m\n  -mode_plug : [this get_mode_plug]\n  -rep : $rep\n  - daughters : [this get_daughters]\n  - prim : [this get_prim_handle]"
 if {$rep} {
   this set_mode_plug Empty
   this set_daughters {}
   this set_L_nested_daughters_PM ""
   this set_mode_plug Full
   #global debug; set debug 1
   #puts "   ___ Connect PM descendant, type = [${objName}_cou_ptf get_soft_type]"
   [this get_LM] Connect_PM_descendants $objName $this(L_nested_handle_LM)
   #set debug 0
   
  #puts "  obj $objName prim : [this get_prim_handle]\n  obj daughters : {[this get_daughters]}\n  Mother $m prim : [$m get_root_for_daughters]"
  # Let's find a nested PM among handles to connect to $m
   set L [join [this get_L_nested_daughters_LM] ", "]
   this set_L_nested_daughters_PM [CSS++ $objName "#$objName ~ ($L)"]
   if {[llength [this get_L_nested_daughters_PM]] == 0} {
     this set_L_nested_daughters_PM [CSS++ $objName "#[this get_L_nested_daughters_LM]->PMs"]
    }
   #puts "_______________\n  $objName set_L_nested_daughters_PM {[this get_L_nested_daughters_PM]}\n__________________________"
   this set_mode_plug Full
   if {![string equal $this(L_nested_handle_LM) ""]} {
     set LC [$this(L_nested_handle_LM) get_LC]
	 if {![string equal $LC ""]} {this Register_nested_element_from $LC}
    }
	
   this Apply_default_style
  } else {this set_daughters {}; this set_mode_plug Empty; puts "$objName Add_mother $m => GROS ECHEC"}

 
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method PM_U_Container Basic_Sub_daughter {d} {
# A daughter has been deleted !
 this inherited $d
 Sub_list this(L_nested_daughters_PM) $d
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
		  set pos [lsearch $this(L_nested_daughters_PM) $m]
		  if {$pos != -1} {
		    #puts "  $m is a nested daughter"
			set this(L_nested_daughters_PM) [lreplace this(L_nested_daughters_PM) $pos $pos]
			if {[llength $this(L_nested_daughters_PM)] == 0} {set this(mode_plug) Empty}
			set rep [this inherited $m]
		   } else {set pos [lsearch [this get_handle_composing_comet] $m]
		           if {$pos != -1} {
				     this Sub_handle_composing_comet $m
					 set rep [this inherited $m]
				    }
		          }
		  set rep 0
		  if {$debug} {puts "<$objName Unplug $ m from nested_daughters/>"}
		  foreach PM $this(L_nested_daughters_PM) {
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
 global debug; 
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
		           set handle_daughter [lindex $this(L_nested_daughters_PM) $i]
				   if {$handle_daughter == ""} {set handle_daughter [lindex $this(L_nested_daughters_PM) end]}
				   if {$handle_daughter != ""} {
				     $handle_daughter Add_daughter $m $index
					 [$handle_daughter get_LM] Connect_PM_descendants $handle_daughter [$m get_LM]
				    }
				   #foreach PM $this(L_nested_daughters_PM) {
                   #  set rep [expr $rep && [$PM Add_daughter $m $index]]
                   #  [$PM get_LM] Connect_PM_descendants $PM [$m get_LM]
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
 #puts "$objName Reconnect $PMD"
 set L_d [this get_daughters]
 set rep [this inherited [Liste_Intersection $PMD $L_d]]
 #puts "  rep : $rep"
 foreach PM $this(L_nested_daughters_PM) {
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
#method PM_U_Container set_L_nested_handle_LM {L} {set this(L_nested_handle_LM) $L}

#___________________________________________________________________________________________________________________________________________
method PM_U_Container Add_prim_daughter {c Lprims {index -1}} {
 #puts "$objName Add_prim_daughter $c $Lprims"
 set rep [this inherited $c $Lprims $index]
 #puts "  rep : $rep"
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method PM_U_Container Sub_prim_daughter {c Lprims {index -1}} {
 #puts "$objName Sub_prim_daughter $c $Lprims"
 set rep [this inherited $c $Lprims $index]
 #puts "  rep : $rep"
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method PM_U_Container get_or_create_prims {root} {
 #puts "$objName get_or_create_prims $root"
 set rep [this inherited $root]
 #puts "  rep : $rep"
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method PM_U_Container get_prim_handle {{index -1}}  {
 #puts "$objName get_prim_handle $index"
 set rep [this inherited $index]
 #puts "  rep : $rep"
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method PM_U_Container get_root_for_daughters {{index -1}} {
 #puts "$objName get_root_for_daughters $index"
 set rep [this inherited $index]
 #puts "  rep : $rep"
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method PM_U_Container Do_prims_still_exist {} {
 return [this inherited]
}

