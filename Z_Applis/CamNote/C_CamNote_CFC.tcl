#__________________________________________________
inherit CommonFC_CometCamNote CommonFC

method CommonFC_CometCamNote constructor {} {
 this inherited
 set this(presentation_name) {}
 set this(L_examinators)     {}
 set this(speaker)           {}
 set this(president)         {}
 set this(mode)              {}
 
 set this(L_pass)            {}
}

#______________________________________________________
#______________________________________________________
Generate_accessors     CommonFC_CometCamNote [list presentation_name mode L_pass]

#______________________________________________________
method CommonFC_CometCamNote get_speaker {}    {return [lindex $this(speaker) 0]}
method CommonFC_CometCamNote set_speaker {n p id} {set this(speaker) [list $n $p $id]}
#______________________________________________________
method CommonFC_CometCamNote get_president {}    {return [lindex $this(president) 0]}
method CommonFC_CometCamNote set_president {n p id} {set this(president) [list $n $p $id]}

#______________________________________________________
method CommonFC_CometCamNote get_L_users {} {
 set L {}
 if {[string equal $this(speaker)   {}]} {} else {lappend L [lindex $this(speaker)   0]}
 if {[string equal $this(president) {}]} {} else {lappend L [lindex $this(president) 0]}
 foreach E $this(L_examinators) {
   lappend L [lindex $E 0]
  }
 return $L
}

#______________________________________________________
method CommonFC_CometCamNote get_speaker_slide_num {} {
 set telec [[this get_speaker] get_telec]
 return [$telec get_val]
}

#______________________________________________________
method CommonFC_CometCamNote get_L_valid_id_pass {} {
 set L {}
 if {[string equal $this(speaker)   {}]} {} else {lappend L [list [lindex $this(speaker)   2] [lindex $this(speaker)   1]]}
 if {[string equal $this(president) {}]} {} else {lappend L [list [lindex $this(president) 2] [lindex $this(president) 1]]}
 foreach E $this(L_examinators) {
   lappend L [list [lindex $E 2] [lindex $E 1]]
  }
 return $L
}

#______________________________________________________
method CommonFC_CometCamNote get_user_comet_from_id {id} {
 if {[string equal [lindex $this(speaker)   2] $id]} {return [lindex $this(speaker)   0]}
 if {[string equal [lindex $this(president) 2] $id]} {return [lindex $this(president) 0]}
 foreach E $this(L_examinators) {
   if {[string equal [lindex $E 2] $id]} {return [lindex $E 0]}
  }
}

#______________________________________________________
method CommonFC_CometCamNote get_L_Examinators {}    {return $this(L_examinators)}
method CommonFC_CometCamNote get_Examinators {}      {set L {}
                                                      foreach e $this(L_examinators) {lappend L [lindex $e 0]}
                                                      return $L
                                                     }
method CommonFC_CometCamNote set_Examinators {L_n_p} {set this(president) $L_n_p}
method CommonFC_CometCamNote Add_Examinator {n p id}   {set pos 0
                                                      foreach e $this(L_examinators) {
                                                        if {[string equal [lindex $e 0] $n]} {
                                                          set this(L_examinators) [lreplace $this(L_examinators) $pos $pos [list $n $p $id]]
                                                          return 2
                                                         }
                                                        incr pos
                                                       }
                                                      lappend this(L_examinators) [list $n $p $id]
                                                      return 1
                                                     }
method CommonFC_CometCamNote Sub_Examinator {n p id}   {set pos 0
                                                      foreach e $this(L_examinators) {
                                                        if {[string equal [lindex $e 0] $n] && [string equal [lindex $e 1] $p] && [string equal [lindex $e 2] $id]} {
                                                          set this(L_examinators) [lreplace $this(L_examinators) $pos $pos]
                                                          return 1
                                                         }
                                                        incr pos
                                                       }
                                                      return 0
                                                     }
#______________________________________________________
method CommonFC_CometCamNote Role_of {n} {
 if {[string equal $n [lindex $this(speaker)   0]]} {return SPEAKER}
 if {[string equal $n [lindex $this(president) 0]]} {return PRESIDENT}
 foreach e $this(L_examinators) {
   if {[string equal $n [lindex $this(speaker) 0]]} {return SPEAKER}
  }

 return NOTHING
}

#__________________________________________________
#__________________________ Adding the activator functions 
proc L_methodes_get_CamNote {} {return [list {get_mode { }} {get_presentation_name { }} {get_speaker { }}      {get_president { }}   {get_Examinators { }} {Role_of {n}} {get_L_users {}} {get_speaker_slide_num { }} ]}
proc L_methodes_set_CamNote {} {return [list {set_mode {m}} {set_presentation_name {n}} {set_speaker {n p id}} {set_president {n p}} {set_Examinators {L}} {Add_Examinator {n p id}} {Sub_Examinator {n p id}} ]}
