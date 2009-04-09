#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit PM_ALX_TXT Physical_model
#___________________________________________________________________________________________________________________________________________
method PM_ALX_TXT constructor {name descr args} {
 this inherited $name $descr
 set this(root) ""
 set ptf [$this(cou) get_ptf]
 $ptf maj Ptf_ALX_TXT

 set this(reg_exp) {regexp "^$" $str reco}
 set this(L_tags)  {}

 this set_cmd_placement      ""
 this set_prim_handle        ""
 this set_root_for_daughters ""
 
 set class(mark) 0
 
# eval "$objName configure $args"
}

#___________________________________________________________________________________________________________________________________________
#method PM_ALX_TXT get_mark {}  {return $class(mark)}
#method PM_ALX_TXT set_mark {m} {set class(mark) $m}

Generate_List_accessor PM_ALX_TXT L_tags L_tags
Generate_accessors     PM_ALX_TXT reg_exp
#___________________________________________________________________________________________________________________________________________
method PM_ALX_TXT Reconnect {PMD} {
 set pos [lsearch $this(L_daughters) $PMD]
 if {$pos == -1} {return}
 set this(L_daughters) [lreplace $this(L_daughters) $pos $pos]
 lappend this(L_daughters) $PMD
}

#___________________________________________________________________________________________________________________________________________
method PM_ALX_TXT get_width  {{PM {}}} {return -1}
method PM_ALX_TXT get_height {{PM {}}} {return -1}

#___________________________________________________________________________________________________________________________________________
method PM_ALX_TXT Adequacy {context {force_eval_ctx 0}} {return -1}

#___________________________________________________________________________________________________________________________________________
method PM_ALX_TXT Process_TXT {e} {return {}}

#___________________________________________________________________________________________________________________________________________
method PM_ALX_TXT Interprets {str} {
 set str [string tolower $str]
 return [this Analyse str]
}

#___________________________________________________________________________________________________________________________________________
method PM_ALX_TXT Analyse {str_name} {
 upvar $str_name  str
 if {[string length $str] == 0} {return {}}
 set L_rep {}

# Do we have a match ?
 set exp   {}
 set apres $str
 if {[eval [this get_reg_exp]]} {
   # if yes then try to recurs with this result
   set L {}
   #set apres " $apres"
   foreach d [this get_daughters] {
     set L_tmp [$d Analyse apres]
     set element [lindex $L_tmp 0]
     if {[llength $L_tmp] > 0 && [string length [lindex $element 1]] > 0} {
       #puts "Reco bonus de \{$L_tmp\}"
       #lappend L $L_tmp
       set L [concat $L $L_tmp]
      }
    }
   #puts "Reco de \{[list $objName $reco $apres $L]\}"
   lappend L_rep [list $objName $reco $apres $L]
  }
 # Look for the rest
 foreach d [this get_daughters] {
   set L_tmp [$d Analyse str]
   set element [lindex $L_tmp 0]
   if {[string length [lindex $element 1]] > 0} {
     #puts "Ajout de \{$L_tmp\}"
     set L_rep [concat $L_rep $L_tmp]
    } else {
           #puts "Rejet de \{$L_tmp\}"
           }
  }

 return $L_rep
}

#_________________________________________________________________________________________________________
method PM_ALX_TXT get_or_create_prims {root} {return {}}

#_________________________________________________________________________________________________________
method PM_ALX_TXT Add_prim_daughter {c Lprims {index -1}} {return 1}
method PM_ALX_TXT Add_prim_mother   {c Lprims {index -1}} {return 1}

#_________________________________________________________________________________________________________
method PM_ALX_TXT Do_prims_still_exist {} {return 1}
