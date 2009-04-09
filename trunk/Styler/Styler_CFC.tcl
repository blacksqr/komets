inherit CommonFC_Styler CommonFC

method CommonFC_Styler constructor {} {
 set this(comet_root) {}
 set this(styler)     [Style ${objName}_styler]
 set this(L_rules)    {}
}


#___________________________________________________________________________________________________________________________________________
Generate_accessors CommonFC_Styler [list comet_root]

#___________________________________________________________________________________________________________________________________________
method CommonFC_Styler get_styler {} {return $this(styler)}

#___________________________________________________________________________________________________________________________________________
method CommonFC_Styler set_comet_root {c} {
 set this(comet_root) $c
 $this(styler) set_comet_root $c
}

#___________________________________________________________________________________________________________________________________________
Generate_List_accessor CommonFC_Styler L_rules rule

#___________________________________________________________________________________________________________________________________________
method CommonFC_Styler Add_rule {sel root style} {
 set pos 0
 foreach r $this(L_rules) {
   set s [lindex $r 0]
   if {[string equal $s $sel]} {
     lset this(L_rules) $pos [list $sel $root $style]
     return
    }
   incr pos
  }

 lappend this(L_rules) [list $sel $root $style]
}

#___________________________________________________________________________________________________________________________________________
method CommonFC_Styler Sub_rule {L_sel} {
 set nL  {}

 foreach r $this(L_rules) {
   set conserve 1
   set s [lindex $r 0]
   foreach sel $L_sel {
     if {[string equal $s $sel]} {set conserve 0; break;}
    }
   if {$conserve} {lappend nL $r}
  }

 set this(L_rules) $nL
}

#___________________________________________________________________________________________________________________________________________
#_______________________________________________________ Adding the text functions _______________________________________________
#___________________________________________________________________________________________________________________________________________
proc L_methodes_get_Styler {} {return [list {get_comet_root {}}  {get_rule {}}  {get_styler {}}]}
proc L_methodes_set_Styler {} {return [list {set_comet_root {c}} {set_rule {r}} {Add_rule {sel style}} {Sub_rule {L_sel}}]}

