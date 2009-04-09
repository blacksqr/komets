#_____________________________________________________________________________________________
#_____________________________________________________________________________________________
#_____________________________________________________________________________________________
method PTF constructor {{hard_type *} {soft_type *} {OS_type *} {min_mem 0} {HCI_type gfx}} {
 set this(hard_type) $hard_type
 set this(soft_type) $soft_type
 set this(OS_type)   $OS_type
 set this(min_mem)   $min_mem
 set this(HCI_type)  $HCI_type

 return $objName
}

#_____________________________________________________________________________________________
method PTF maj {ptf} {
 this set_hard_type [$ptf get_hard_type]
 this set_soft_type [$ptf get_soft_type]
 this set_OS_type   [$ptf get_OS_type]
 this set_min_mem   [$ptf get_min_mem]
 this set_HCI_type  [$ptf get_HCI_type]
}

#_____________________________________________________________________________________________
method PTF get_HCI_type {}  {return $this(HCI_type)}
method PTF set_HCI_type {t} {set this(HCI_type) $t}
#_____________________________________________________________________________________________
method PTF get_hard_type {}  {return $this(hard_type)}
method PTF set_hard_type {t} {set this(hard_type) $t}
#_____________________________________________________________________________________________
method PTF get_soft_type {}  {return $this(soft_type)}
method PTF set_soft_type {t} {set this(soft_type) $t}
#_____________________________________________________________________________________________
method PTF get_OS_type {}  {return $this(OS_type)}
method PTF set_OS_type {t} {set this(OS_type) $t}
#_____________________________________________________________________________________________
method PTF get_min_mem {}  {return $this(min_mem)}
method PTF set_min_mem {t} {set this(min_mem) $t}

#_____________________________________________________________________________________________
method PTF Accept_for_daughter {ptf} {
 # Conditions on the hardware
 if {[string equal $ptf *]} {return 1}
 if { [string equal $this(hard_type) [$ptf get_hard_type]] \
    ||[string equal *                [$ptf get_hard_type]] \
    ||[string equal $this(hard_type) *]} {} else {return 0}
 # Conditions on the software
 if { [string equal $this(soft_type) [$ptf get_soft_type]] \
    ||[string equal $this(soft_type) *]} {} else {if {[string equal [$ptf get_soft_type] *]} {} else {return 0}}
 if { [string equal $this(OS_type) [$ptf get_OS_type]] \
    ||[string equal $this(OS_type) *]}   {} else {if {[string equal [$ptf get_OS_type] *]}   {} else {return 0}}

 # If no condition were violated, then plateforms are compatibles
 return 1
}

if {[info exists PTF_defined]} {} else {
  set PTF_defined 1
  PTF Ptf_ALL     *  *        *     0
  PTF Ptf_TK      *  TCL_TK   *     0
  PTF Ptf_HTML    *  PHP_HTML *     0
  PTF Ptf_BIGre   PC BIGre    WinXP 0
  PTF Ptf_ALX_TXT *  TCL_TK_ALX_TXT  *     0  vocal
 } 

set Tab_PTF(*)              Ptf_ALL
set Tab_PTF(TCL_TK)         Ptf_TK
set Tab_PTF(PHP_HTML)       Ptf_HTML
set Tab_PTF(BIGre)          Ptf_BIGre
set Tab_PTF(TCL_TK_ALX_TXT) Ptf_ALX_TXT

proc get_Tab_PTF {p} {
 global Tab_PTF
 return $Tab_PTF($p)
}

#_____________________________________________________________________________________________
proc Select_PM_from_where_style {L_PM style} {
 set L {}
 foreach PM $L_PM {
   set ptf [[$PM get_cou] get_ptf]
   if {[string equal [$ptf get_HCI_type] $style]} {lappend L $PM}
  }
 return $L
}

#_____________________________________________________________________________________________
proc Select_PM_from_where_ptf {L_PM p} {
 set L {}
 foreach PM $L_PM {
   set ptf [[$PM get_cou] get_ptf]
   if {[$ptf Accept_for_daughter $p]} {lappend L $PM}
  }
 return $L
}
