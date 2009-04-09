source plate_forme.tcl

#____________________________________________________________________________________
#____________________________________________________________________________________
#____________________________________________________________________________________
method COU constructor {} {
 set ptf_name "${objName}_ptf"
 PTF $ptf_name
 set this(ptf_type) $ptf_name
}
#____________________________________________________________________________________
method COU dispose {} {
 $this(ptf_type) dispose
 this inherited
}

#____________________________________________________________________________________
method COU get_ptf {} {return $this(ptf_type)}
#____________________________________________________________________________________
method COU Accept_for_daughter {cou} {
 set ptf [$cou get_ptf]
 return [$this(ptf_type) Accept_for_daughter $ptf]
}

#____________________________________________________________________________________
method COU maj {c} {
 set ptf [$c get_ptf]
 [this get_ptf] maj $ptf
}

