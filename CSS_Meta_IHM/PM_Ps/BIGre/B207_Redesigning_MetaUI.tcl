# TEST
# B207_Redesigning_MetaUI meta
# set infos_scalar [meta add_reference_var "$fen Longueur_corp" "$fen Longueur_corp" "$fen abonner_a_dimension" "$fen desabonner_de_dimension"]
# set obj_var [$infos_scalar Add_var "$poly Px" "$poly Px"]
# $obj_var Add_exemple 0 0 <
# $obj_var Add_exemple 100 100 <
# meta Compute
#______________________________________________________________________________
# In these objects, we will manage the differents couple <Scalar_ref, Scalar_value>
# where Scalar_ref is the scalar used as reference (e.g. a length or a stretch)
# and Scalar value is the corresponding value (e.g. a x-position)
#______________________________________________________________________________
# L_infos_scalar : list of infos_scalar
# infos_scalar   : <reference variable, internal_id, B_rappel, L_var_steps>
# L_var_steps    : <variable, list of steps>
# step           : <scalar reference value, scalar result for variable>
# NOTE : a variable is defined by a get, a set, a subscribe and unsubscribe functions...<get, set, subscribe, unsubscribe>
#______________________________________________________________________________
#______________________________________________________________________________
#______________________________________________________________________________
method B207_var_obj constructor {var_get_cmd var_set_cmd} {
 set this(var_get_cmd) $var_get_cmd
 set this(var_set_cmd) $var_set_cmd
 set this(L_exemples)  {}
 set this(interpolate_fct) inter_extra_polate
 set this(ref_var) ""
 return $objName
}

#______________________________________________________________________________
method B207_var_obj dispose {} {
 if {![string equal $this(ref_var) ""]} {
   $this(ref_var) Sub_existing_var $objName
  }
 this inherited
}

#______________________________________________________________________________
method B207_var_obj set_current_val {v} {return [eval "$this(var_set_cmd) $v"]}

#______________________________________________________________________________
method B207_var_obj get_current_val {} {return [eval $this(var_get_cmd)]}

#______________________________________________________________________________
method B207_var_obj Display {{dec {}}} {
 puts "$dec$objName"
 puts "$dec  get : $this(var_get_cmd)"
 puts "$dec  set : $this(var_set_cmd)"
 puts "$dec  Lex : $this(L_exemples)"
} 

#______________________________________________________________________________
method B207_var_obj set_ref_var {v} {set this(ref_var) $v}
#______________________________________________________________________________
method B207_var_obj get_cmd_get {} {return $this(var_get_cmd)}
#______________________________________________________________________________
method B207_var_obj get_cmd_set {} {return $this(var_set_cmd)}
#______________________________________________________________________________
method B207_var_obj set_cmd_get {cmd} {set this(var_get_cmd) $cmd}
#______________________________________________________________________________
method B207_var_obj set_cmd_set {cmd} {set this(var_set_cmd) $cmd}
#______________________________________________________________________________
method B207_var_obj get_nb_examples {} {return [llength $this(L_exemples)]}
#______________________________________________________________________________
method B207_var_obj get_L_examples { } {return $this(L_exemples)}
#______________________________________________________________________________
method B207_var_obj set_L_examples {L} {set this(L_exemples) $L}
#______________________________________________________________________________
method B207_var_obj get_L_refs {} {
 set rep {}
 foreach e $this(L_exemples) {lappend $rep [lindex $e 0]}
}
#______________________________________________________________________________
method B207_var_obj Add_current_exemple {ref op id} {
 return [this Add_exemple $ref [eval $this(var_get_cmd)] $op $id]
}
#______________________________________________________________________________
method B207_var_obj Add_exemple {ref val op id} {
 set pos 0
 foreach e $this(L_exemples) {
   set r [lindex $e 0]
   if {[expr "$ref $op $r"]} {
	 set this(L_exemples) [linsert $this(L_exemples) $pos "$ref $val $id"]
	 return
    }
   incr pos	
  }
 lappend this(L_exemples) "$ref $val $id"
}

#______________________________________________________________________________
method B207_var_obj Sub_exemples_related_to {x y} {
 set nL {}
 foreach e [this get_L_examples] {
   if { ($x != [lindex $e 4]) || ($y != [lindex $e 5]) } {lappend nL $e}
  }
 this set_L_examples $nL
}

#______________________________________________________________________________
method B207_var_obj Sub_exemple {ref val} {
 set pos [lsearch $this(L_exemples) "$ref $val"]
 if {$pos == -1} {return 0}
 set this(L_exemples) [lreplace $this(L_exemples) $pos $pos]
 return 1
}

#______________________________________________________________________________
method B207_var_obj get_interpolate_function { } {return $this(interpolate_fct)}
#______________________________________________________________________________
method B207_var_obj set_interpolate_function {f} {set this(interpolate_fct) $f}

#______________________________________________________________________________
method B207_var_obj Compute_val {ref} {
 if {[string equal $this(L_exemples) ""]} {return}
 set rep [$this(interpolate_fct) $ref $this(L_exemples)]
 return $rep
}
#______________________________________________________________________________
method B207_var_obj Compute {ref} {
 set rep [this Compute_val $ref]
 if {[string equal $rep {}]} {return}
 eval "$this(var_set_cmd) $rep"
}

#______________________________________________________________________________
#______________________________________________________________________________
#______________________________________________________________________________
method B207_infos_scalar constructor {var_get_cmd var_set_cmd var_subscribe var_unsubscribe} {
 set this(var_get_cmd)     $var_get_cmd
 set this(var_set_cmd)     $var_set_cmd
 set this(var_subscribe)   $var_subscribe
 set this(var_unsubscribe) $var_unsubscribe
 set this(L_var_steps)     {}
 set this(rap)             [B_rappel [Interp_TCL] "$objName Compute"]
 set this(var_obj_id)      0
# Subscribe...
 eval "$var_subscribe [$this(rap) Rappel]"
 
 return $objName
}

#______________________________________________________________________________
method B207_infos_scalar dispose {} {
 foreach v $this(L_var_steps) {$v dispose}
 eval "$this(var_unsubscribe) [$this(rap) Rappel]"
 this inherited
}

#______________________________________________________________________________
method B207_infos_scalar Display {{dec {}}} {
 puts "$dec$objName"
 puts "$dec  get : $this(var_get_cmd)"
 puts "$dec  set : $this(var_set_cmd)"
 puts "$dec  sbc : $this(var_subscribe)"
 puts "$dec  usb : $this(var_unsubscribe)"
 puts "$dec  list of related vars :"
 foreach v $this(L_var_steps) {$v Display "$dec   | "}
}

#______________________________________________________________________________
method B207_infos_scalar get_cmd_get { } {return $this(var_get_cmd)}
method B207_infos_scalar set_cmd_get {c} {set this(var_get_cmd) $v}
#______________________________________________________________________________
method B207_infos_scalar get_cmd_set { } {return $this(var_set_cmd)}
method B207_infos_scalar set_cmd_set {c} {set this(var_set_cmd) $v}
#______________________________________________________________________________
method B207_infos_scalar get_cmd_subscribe { } {return $this(var_subscribe)}
method B207_infos_scalar set_cmd_subscribe {c} {set this(var_subscribe) $v}
#______________________________________________________________________________
method B207_infos_scalar get_cmd_unsubscribe { } {return $this(var_unsubscribe)}
method B207_infos_scalar set_cmd_unsubscribe {c} {set this(var_unsubscribe) $v}
#______________________________________________________________________________
method B207_infos_scalar get_L_related_vars  {} {return $this(L_var_steps)}
method B207_infos_scalar get_nb_related_vars {} {return [llength $this(L_var_steps)]}

#______________________________________________________________________________
method B207_infos_scalar get_current_value {} {return [eval $this(var_get_cmd)]}
#______________________________________________________________________________
method B207_infos_scalar Do_subscribe      {} {return [eval "$this(var_subscribe)   [$this(rap) Rappel]"]}
#______________________________________________________________________________
method B207_infos_scalar Do_unsubscribe    {} {return [eval "$this(var_unsubscribe) [$this(rap) Rappel]"]}

#______________________________________________________________________________
method B207_infos_scalar get_nb_max_example {} {
 set rep 0
 foreach v $this(L_var_steps) {
   set nb [$v get_nb_examples]
   set rep [expr $nb>$rep?$nb:$rep]
  }
 return $rep
}

#______________________________________________________________________________
method B207_infos_scalar set_current_val {v} {return [eval "$this(var_set_cmd) $v"]}
#______________________________________________________________________________
method B207_infos_scalar get_current_val { } {return [eval $this(var_get_cmd)]}

#______________________________________________________________________________
method B207_infos_scalar add_current_exemple {op id} {
 set ref [this get_current_val]
 foreach v $this(L_var_steps) {
   set val [$v get_current_val]
   $v Add_exemple $ref $val $op $id
  }
}

#______________________________________________________________________________
method B207_infos_scalar Add_existing_var {v} {
 Add_element this(L_var_steps) $v
 $v set_ref_var $objName
}

#______________________________________________________________________________
method B207_infos_scalar Sub_existing_var {v} {
 Sub_element this(L_var_steps) $v
 $v set_ref_var ""
}

#______________________________________________________________________________
method B207_infos_scalar Add_var {var_get_cmd var_set_cmd} {
# Check here if there is still such a variable...
 foreach v $this(L_var_steps) {
   if {[string equal $var_get_cmd [$v get_cmd_get]] && [string equal $var_set_cmd [$v get_cmd_set]]} {
     return $v
    }
  }
# Else where, create it
 set name ${objName}_obj_id_$this(var_obj_id)
 incr this(var_obj_id)
   B207_var_obj $name $var_get_cmd $var_set_cmd
   lappend this(L_var_steps) $name
 $name set_ref_var $objName
 return $name
}

#______________________________________________________________________________
method B207_infos_scalar Compute {} {
#puts "$objName Compute"
 set ref_v [eval $this(var_get_cmd)]
 foreach var_obj $this(L_var_steps) {
   $var_obj Compute $ref_v
  }
}

#______________________________________________________________________________
#______________________________________________________________________________
#______________________________________________________________________________
method B207_Redesigning_MetaUI constructor {} {
# set the list of reference nodes, for each of them associate couple information 
 set this(L_infos_scalar) {}
 set this(infos_scalar_id) 0
}

#______________________________________________________________________________
method B207_Redesigning_MetaUI dispose {} {
 foreach i $this(L_infos_scalar) {$i dispose}
 this inherited
}

#______________________________________________________________________________
method B207_Redesigning_MetaUI get_L_infos_scalar {} {return $this(L_infos_scalar)}

#______________________________________________________________________________
method B207_Redesigning_MetaUI Display {} {
 foreach infos_scalar $this(L_infos_scalar) {
   $infos_scalar Display
  }
}

#______________________________________________________________________________
method B207_Redesigning_MetaUI add_reference_var {get_fct set_fct subscribe unsubscribe} {
# Is the variable stille present?
 set name ${objName}_infos_scalar_$this(infos_scalar_id)
 incr this(infos_scalar_id)
   B207_infos_scalar $name $get_fct $set_fct $subscribe $unsubscribe
   lappend this(L_infos_scalar) $name
 return $name  
}

#______________________________________________________________________________
method B207_Redesigning_MetaUI sub_reference_var {name} {
 set pos [lsearch $this(L_infos_scalar) $name]
 if {$pos == -1} {return 0}
 set this(L_infos_scalar) [lreplace $this(L_infos_scalar) $pos $pos]
 return 1
}
