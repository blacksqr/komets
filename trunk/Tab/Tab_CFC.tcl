#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Tab_CFC CommonFC

#___________________________________________________________________________________________________________________________________________
method Tab_CFC constructor {} {
 set this(T) ""
 set this(nb_L) 0
 set this(nb_C) 0
}

#___________________________________________________________________________________________________________________________________________
method Tab_CFC get_nb_L {} {return $this(nb_L)}
method Tab_CFC get_nb_C {} {return $this(nb_C)}
method Tab_CFC get_dims {} {return [list $this(nb_L) $this(nb_C)]}
method Tab_CFC set_dims {L C} {
 set this(nb_L) $L
 set this(nb_C) $C
 for {set i 0} {$i<$L} {incr i} {
   for {set j 0} {$j<$C} {incr j} {
     this set_case      $i $j ""
	 this Init_MetaData $i $j
    }
  }
}

#___________________________________________________________________________________________________________________________________________
method Tab_CFC Display {} {
 set C [this get_nb_C]; set L [this get_nb_L]
# Compute texte size for each column
 for {set j 0} {$j<$C} {incr j} {
   set lg_max 0
   for {set i 0} {$i<$L} {incr i} {
     set e [this get_case $i $j]
	 set l [string length $e]
	 set lg_max [expr $l>$lg_max?$l:$lg_max]
    }
   set T($j) [expr $lg_max>0?$lg_max:1]
  }
# Display the tab thanks to the computed size
 for {set i 0} {$i<$L} {incr i} {
   set L_txt {}; set txt {|}
   for {set j 0} {$j<$C} {incr j} {
     set e [this get_case $i $j] 
	 lappend L_txt $e
    }
   set j 0
   foreach e $L_txt {
     set rest [expr $T($j)-[string length $e]]
     append txt $e; for {set k 0} {$k<$rest} {incr k} {append txt { }}
	 append txt |
	 incr j
    }
   puts $txt
  }
}

#___________________________________________________________________________________________________________________________________________
method Tab_CFC get_case {i j}   {return $this(T,$i,$j)}
#___________________________________________________________________________________________________________________________________________
method Tab_CFC set_case {i j v} {set this(T,$i,$j) $v}
#___________________________________________________________________________________________________________________________________________
method Tab_CFC Insert_col {pos} {
 for {set j $this(nb_C)} {$j > $pos} {incr j -1} {
   for {set i 0} {$i < $this(nb_L)} {incr i} {
     this set_case      $i $j [this get_case      $i [expr $j-1]]
	 this set_MetaDatas $i $j [this get_MetaDatas $i [expr $j-1]]
    }
  }
 this Init_col $pos
 incr this(nb_C)
}
#___________________________________________________________________________________________________________________________________________
method Tab_CFC Init_col {j} {
 for {set i 0} {$i < $this(nb_L)} {incr i} {this set_case $i $j ""; this Init_MetaData $i $j}
}
#___________________________________________________________________________________________________________________________________________
method Tab_CFC Delete_col {pos} {
 for {set j $pos} {$j < $this(nb_C)-1} {incr j} {
   for {set i 0} {$i < $this(nb_L)} {incr i} {
     this set_case      $i $j [this get_case      $i [expr $j+1]]
	 this set_MetaDatas $i $j [this get_MetaDatas $i [expr $j+1]]
    }
  }
 incr this(nb_C) -1
}
#___________________________________________________________________________________________________________________________________________
method Tab_CFC Insert_line {pos} {
 for {set i $this(nb_L)} {$i > $pos} {incr i -1} {
   for {set j 0} {$j < $this(nb_C)} {incr j} {
     this set_case      $i $j [this get_case      [expr $i-1] $j]
	 this set_MetaDatas $i $j [this get_MetaDatas [expr $i-1] $j]
    }
  }
 incr this(nb_L)
}
#___________________________________________________________________________________________________________________________________________
method Tab_CFC Delete_line {pos} {
 for {set i $pos} {$i < $this(nb_L)-1} {incr i} {
   for {set j 0} {$j < $this(nb_C)} {incr j} {
     this set_case      $i $j [this get_case      [expr $i+1] $j]
	 this set_MetaDatas $i $j [this get_MetaDatas [expr $i+1] $j]
    }
  }
 incr this(nb_L) -1
}
#___________________________________________________________________________________________________________________________________________
method Tab_CFC Add_MetaData {i j var val} {set this(M,$i,$j,$var) $val}
#___________________________________________________________________________________________________________________________________________
method Tab_CFC Sub_MetaData {i j var} {unset this(M,$i,$j,$var)}
#___________________________________________________________________________________________________________________________________________
method Tab_CFC get_MetaData {i j var} {return this(M,$i,$j,$var)}
#___________________________________________________________________________________________________________________________________________
method Tab_CFC Init_MetaData {i j} {
 set L [array names this -regexp M,$i,$j]
 foreach e $L {unset this($e)}
}
#___________________________________________________________________________________________________________________________________________
method Tab_CFC exists_MetaData {i j var} {
 set L [array names this -regexp M,$i,$j,$var]
 return [expr [llength $L]>0]
}

#___________________________________________________________________________________________________________________________________________
method Tab_CFC get_MetaDatas {i j} {
 set rep {}
 set L [array names this -regexp M,$i,$j]
 foreach e $L {
   regexp "M,$i,$j,(.)" $e reco tmp
   lappend rep "$tmp $this($e)"
  }
 return $rep
}
#___________________________________________________________________________________________________________________________________________
method Tab_CFC set_MetaDatas {i j L} {
 this Init_MetaData $i $j
 foreach e $L {
   this Add_MetaData $i $j [lindex $e 0] [lindex $e 1]
  }
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_get_Tab {} {return [list {get_nb_L {}} {get_nb_C {}} {get_dims {}} {get_case {i j}} {get_MetaData {i j var}} {exists_MetaData {i j var}} {get_MetaDatas {i j}}]}
proc P_L_methodes_set_Tab {} {return [list {set_dims {L C}} {Init_col {j}} {Insert_col {pos}} {set_case {i j v}} {Delete_col {pos}} {Insert_line {pos}} {Delete_line {pos}} {Add_MetaData {i j var val}} {Sub_MetaData {i j var}} {Init_MetaData {i j}} {set_MetaDatas {i j L}}]}

                                    