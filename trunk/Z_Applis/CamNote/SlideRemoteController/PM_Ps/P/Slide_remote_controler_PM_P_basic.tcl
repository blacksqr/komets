inherit CometSlideRemoteController_PM_P_basic PM_U_Container

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometSlideRemoteController_PM_P_basic constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id N_controller_CUI_basic_Universal
   set this(num_to_set)  0
   set this(t_ms)	 500
   set this(current_ccn) {}
   set this(reconnect_LM) 0
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometSlideRemoteController_PM_P_basic dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
Generate_accessors CometSlideRemoteController_PM_P_basic [list t_ms]
#___________________________________________________________________________________________________________________________________________
Generate_PM_setters CometSlideRemoteController_PM_P_basic [L_methodes_set_SlideRemoteController]

#___________________________________________________________________________________________________________________________________________
method CometSlideRemoteController_PM_P_basic set_LM {LM} {
 this inherited $LM
 set this(cont)   "${LM}_CometSlideRemoteController_PM_P_basic_cont"
   set this(ccn)    "${LM}_CometSlideRemoteController_PM_P_basic_ccN"
   set this(bt_bgn) "${LM}_CometSlideRemoteController_PM_P_basic_bt_bgn"
   set this(bt_prv) "${LM}_CometSlideRemoteController_PM_P_basic_bt_prv"
   set this(bt_nxt) "${LM}_CometSlideRemoteController_PM_P_basic_bt_nxt"
   set this(bt_end) "${LM}_CometSlideRemoteController_PM_P_basic_bt_end"
   set this(cont_daughters)   "${LM}_CometSlideRemoteController_PM_P_basic_cont_for_daughters"
# set L [list $this(bt_bgn) $this(bt_prv) $this(ccn) $this(bt_nxt) $this(bt_end)]
 this set_L_nested_handle_LM    $this(cont)_LM_LP
 this set_L_nested_daughters_LM $this(cont_daughters)_LM_LP

 if {[info exists class($LM)]} {} else {
   set class($LM) $LM
   CometContainer $this(cont)   "remote controller's toplevel container" {}
   CometContainer $this(cont_daughters)   "remote controller's container for daughters" {}
   CometChoiceN   $this(ccn)    "Choice of the slide num" "Common CometChoiceN used by all PM_basic of $LM"
   CometActivator $this(bt_bgn) "First slide button"      {} -set_text First
   CometActivator $this(bt_prv) "Previous slide button"   {} -set_text Prev
   CometActivator $this(bt_nxt) "Next slide button"       {} -set_text Next
   CometActivator $this(bt_end) "Last slide button"       {} -set_text Last
   $this(bt_bgn)_LM_LP set_COMET_RE_expr activate NO
   $this(bt_prv)_LM_LP set_COMET_RE_expr activate NO
   $this(bt_nxt)_LM_LP set_COMET_RE_expr activate NO
   $this(bt_end)_LM_LP set_COMET_RE_expr activate NO
   set this(reconnect_LM) 1
  }

 if {$this(reconnect_LM)} {
   $this(cont) Add_daughters_R [list $this(bt_bgn) $this(bt_prv) $this(ccn) $this(bt_nxt) $this(bt_end) $this(cont_daughters)]
   set this(reconnect_LM) 0
  }
}

#___________________________________________________________________________________________________________________________________________
method CometSlideRemoteController_PM_P_basic Sub_mother    {m} {
 if {[string equal $this(current_ccn) {}]} {} else {
   #puts "_______________________\n   $this(current_ccn) UnSubscribe_to_prim_set_val $objName\n"
   $this(current_ccn) UnSubscribe_to_prim_set_val $objName
  }
 set rep [this inherited $m]
 if {$rep} {
   #this set_daughters {}
  }
}

#___________________________________________________________________________________________________________________________________________
method CometSlideRemoteController_PM_P_basic Add_mother    {m {index -1}} {
# set this(reconnect_LM) 1
# this set_LM [this get_LM]
   #puts "______________________________________________________________________ [${objName}_cou_ptf get_soft_type]"
   #puts "  LM                    : [this get_LM]"
   #puts "  L_nested_handle_LM    : {[this get_L_nested_handle_LM]}"
   #puts "  L_nested_daughters_LM : {[this get_L_nested_daughters_LM]}"
 set rep [this inherited $m $index]
   #puts "AFTER $objName Add_mother $m $index : $rep"
   #puts "  daughters             : \{[this get_daughters]\}"
   #puts "______________________________________________________________________"
#   puts "  PM for ccn : \"[eval [this get_DSL_CSSpp] Interprets \{$this(ccn)\} $objName]\""
 if {$rep} {
   set PM [CSS++ $objName "#$objName\($this(bt_bgn)\)"]; if {![string equal $PM {}]} {$PM Subscribe_to_prim_activate __FOREACH_PM__[this get_LC] "$objName prim_go_to_bgn" 1}
   set PM [CSS++ $objName "#$objName\($this(bt_prv)\)"]; if {![string equal $PM {}]} {$PM Subscribe_to_prim_activate __FOREACH_PM__[this get_LC] "$objName prim_go_to_prv" 1}
   set PM [CSS++ $objName "#$objName\($this(bt_nxt)\)"]; if {![string equal $PM {}]} {$PM Subscribe_to_prim_activate __FOREACH_PM__[this get_LC] "puts {$objName prim_go_to_nxt from $PM}; $objName prim_go_to_nxt" 1}
   set PM [CSS++ $objName "#$objName\($this(bt_end)\)"]; if {![string equal $PM {}]} {$PM Subscribe_to_prim_activate __FOREACH_PM__[this get_LC] "$objName prim_go_to_end" 1}


   set ccn_PM [CSS++ $objName $objName\($this(ccn)\)]
   #puts "  ccn_PM : $ccn_PM"
   if {[string equal $ccn_PM {}]} {
     #puts "$objName CometSlideRemoteController_PM_P_basic::Add_mother $m $index\n  Could not found $this(ccn)"
    } else {
       if {[string equal $this(current_ccn) {}]} {} else {
         $this(current_ccn) UnSubscribe_to_prim_set_val $objName
        }
       $ccn_PM          Subscribe_to_prim_set_val    __FOREACH_PM__$objName "$objName Buffer_num_slide $ccn_PM \$v" UNIQUE
	   #[$ccn_PM get_LM] Subscribe_to_set_PM_inactive $objName "$objName UnActivate_CB_on_PM  \$PM"    UNIQUE
	   #[$ccn_PM get_LM] Subscribe_to_set_PM_active   $objName "$objName Activate_CB_on_PM    \$PM"    UNIQUE
       set this(current_ccn) $ccn_PM
    }

   set c_cont_PM [CSS++ $objName $objName\($this(cont)\)]
   if {[string equal $c_cont_PM {}]} {} else {
     $c_cont_PM set_cmd_placement {pack $p -side left -expand 1 -fill x}; $c_cont_PM Reconnect [$c_cont_PM get_daughters]
    }
  }
 return $rep
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometSlideRemoteController_PM_P_basic $L_methodes_set_choicesN {} {}
Methodes_get_LC CometSlideRemoteController_PM_P_basic $L_methodes_get_choicesN {$this(FC)}
Methodes_set_LC CometSlideRemoteController_PM_P_basic [L_methodes_set_SlideRemoteController] {} {}
Methodes_get_LC CometSlideRemoteController_PM_P_basic [L_methodes_get_SlideRemoteController] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometSlideRemoteController_PM_P_basic maj_val {num} {
 #puts "$objName CometSlideRemoteController_PM_P_basic::maj_val $num (num_to_set $this(num_to_set))"
 if {$this(num_to_set) != $num} {return}
 set LM [this get_LM]; if {[string equal $LM {}]} {return}
 set LC [$LM get_LC] ; if {[string equal $LC {}]} {return}
 this prim_set_current $num
}

#___________________________________________________________________________________________________________________________________________
method CometSlideRemoteController_PM_P_basic Update_ccn_PM_val {} {
 #puts "$objName Update_ccn_PM_val"
 set ccn_PM [CSS++ $objName $objName\($this(ccn)\)]
 if {[string equal $ccn_PM {}]} {return}
 $ccn_PM set_val [this get_val]
} 

method CometSlideRemoteController_PM_P_basic go_to_bgn {} {this Update_ccn_PM_val}
method CometSlideRemoteController_PM_P_basic go_to_prv {} {this Update_ccn_PM_val}
method CometSlideRemoteController_PM_P_basic go_to_nxt {} {this Update_ccn_PM_val}
method CometSlideRemoteController_PM_P_basic go_to_end {} {this Update_ccn_PM_val}
method CometSlideRemoteController_PM_P_basic set_val  {v} {this Update_ccn_PM_val}
method CometSlideRemoteController_PM_P_basic set_current {v} {this Update_ccn_PM_val}

#___________________________________________________________________________________________________________________________________________
method CometSlideRemoteController_PM_P_basic Buffer_num_slide {ccn_PM num} {
 puts "  $objName Buffer_num_slide $ccn_PM $num"
 if {[string equal $ccn_PM $this(current_ccn)] && [this Accept_PM_for_daughter $ccn_PM]} {puts "  NO"} else {
   #puts "___________\n$ccn_PM UnSubscribe_to_prim_set_val $objName\n______________"
   $ccn_PM UnSubscribe_to_prim_set_val $objName
   set this(num_to_set) $num
   return
  }
 set this(num_to_set) $num
 if {[Ptf_HTML Accept_for_daughter ${objName}_cou_ptf]} {
   puts "$objName is a HTML PM, it received $num from $ccn_PM"
   this maj_val $num
  } else {
          puts "$objName is NOT a HTML PM, it received $num from $ccn_PM"
          after $this(t_ms) "$objName maj_val $num"}
}

#___________________________________________________________________________________________________________________________________________
method CometSlideRemoteController_PM_P_basic set_val {v} {
 puts "  $this(ccn) get_val => [$this(ccn) get_val]"
 if {[$this(ccn) get_val] != $v} {
   puts "$this(ccn) set_val $v"
   $this(ccn) set_val $v
  }
}
#Trace CometSlideRemoteController_PM_P_basic set_val

#___________________________________________________________________________________________________________________________________________
method CometSlideRemoteController_PM_P_basic set_b_inf {n} {$this(ccn) set_b_inf $n}
method CometSlideRemoteController_PM_P_basic set_b_sup {n} {$this(ccn) set_b_sup $n}

#___________________________________________________________________________________________________________________________________________
method CometSlideRemoteController_PM_P_basic maj_choices {} {$this(ccn) maj_choices}
