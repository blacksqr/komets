#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
proc Split_to {str_name args} {
 upvar $str_name str

 set t [string length $str]
 set pos $t
 foreach a $args {
   set p   [string first $a $str]
   if {$p==-1} {continue}
   set pos [expr "($p<$pos)?$p:$pos"]
  }
 if {$pos!=$t} {
   set rep [string range $str 0 [expr $pos-1]]
   set str [string range $str $pos end]
   return $rep
  }

 return {}
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
proc Compensate {str_name p m nb} {
 upvar $str_name str

 set pos 0
 set t     [string length $str]
 set pos_p [string first $p $str $pos]; if {$pos_p==-1} {set pos_p $t}
 set pos_m [string first $m $str $pos]; if {$pos_m==-1} {set pos_m $t}
 while {$nb!=0} {
   if {$pos_p<$pos_m} {
     set pos $pos_p
     set pos_p [string first $p $str $pos]; if {$pos_p==-1} {set pos_p $t}
     incr nb
    } else {set pos $pos_m
            set pos_m [string first $m $str $pos]; if {$pos_m==-1} {set pos_m $t}
            incr nb -1
           }
  }

 set rep [string range $str 0 [expr $pos-1]]
 set str [string range $str [expr $pos+1] end]

 return $rep
}
