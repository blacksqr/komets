#_________________________________________________________________________________________________________
#_________________________________________________________________________________________________________
#_ SELECTOR : CLASS OP_HIERA CLASS | CLASS
#_ OP_HIERA : > | ' '
#_    CLASS : DEF | DEF '\' SELECTOR '/'
#_      DEF : ID | ID(SELECTOR) |
#_       ID : NAME | NAME->PROJ
#_     NAME : alphanum | *
#_     PROJ : _LM_LP | _LM_FC | ...
#_________________________________________________________________________________________________________
#_________________________________________________________________________________________________________
method Style constructor args {
 set this(style_def)               {}
 set this(internal_representation) {}
 set this(comet_root)              {}
 set this(core_to_find)            {}

 set this(lettre) {[a-zA-Z0-9!*_\.]}
 set this(sep)    "\[ \n\]"
 # XXX DEBUG OPTIMISATION
 set this(sep) " "
 
 set this(lexic,letters)     {[a-zA-Z0-9_"]}
 set this(lexic,spaces)      {[ \n\t]}
 set this(lexic,op_cmp)      {[!~=<>]}

 set this(cmd_daughter) get_out_daughters
 set this(ERROR) {}
 
 set this(sens) daughters

 eval "$objName configure $args"
 return $objName
}

#_________________________________________________________________________________________________________
Generate_accessors Style [list style_def comet_root ERROR]
method Style get_internal_representation {} {return $this(internal_representation)}

#_________________________________________________________________________________________________________
method Style configure args {
 set L_cmd [split $args -]
 foreach cmd $L_cmd {
   if {[string equal $cmd {}]} {continue}
   if {[string equal [string index $cmd 0] | ]} {
     set cmd [string range $cmd 1 end]
     eval $cmd
    } else {eval "$objName $cmd"}
  }
}

#_________________________________________________________________________________________________________
method Style load_from_file {fn} {
 set f [open $fn]
   this set_style_def [read $f]
   this Style_to_List
 close $f
}

#_________________________________________________________________________________________________________
method Style Style_to_List {} {
 set L [split $this(style_def) "\}"]
 set L_rep [list]
   set sep "\[ |	|\n\]"

 set expression "^$sep*(.*)$sep*\{${sep}*(.*)$sep*\$"

 foreach e $L {
   if {[regexp $expression $e reco selector flags]} {
     lappend L_rep [list $selector [this Get_flags flags]]
    }
  }

 set this(internal_representation) $L_rep
}

#_________________________________________________________________________________________________________
method Style Get_flags {str_name} {
 upvar $str_name str
 set sep "\[ |	|\n\]"

 set L [split $str "\;"]
 set rep [list]
 foreach e $L {
   if {[regexp "^$sep*(.*)$sep*:$sep*(.*)$sep*\$" $e reco var val]} {
     lappend rep [list $var $val]
    }
  }

 return $rep
}

#_________________________________________________________________________________________________________
#____________________________________________ Apply the style ____________________________________________
#_________________________________________________________________________________________________________
method Style Display_search_results {txt L_name} {
 upvar $L_name L
 set rep {}
 foreach e $L {
   puts "$txt : [lindex $e 0]"
   foreach c [lindex $e 1] {
     puts "  $c"
    }
  }
 return $rep
}

#_________________________________________________________________________________________________________
method Style Apply {} {
 set L_rep {}
 this set_ERROR {}
 foreach rule $this(internal_representation) {
   set selector  [lindex $rule 0]
   set modifyers [lindex $rule 1]
#   puts "Selector \"$selector\""
     set L   {}
     set str $selector
	 set this(sens) daughters
     this DSL_SELECTOR str L $this(comet_root) 1
#     foreach PM [$this(comet_root)_LM_LP get_L_actives_PM] {
#       set L [concat $L [this get_comet_elements $PM $selector]]
#       this Display_search_results $PM L
#      }
#     puts "   L <- $L"
     lappend L_rep [list $selector $L]
  }

 return $L_rep
}

#_________________________________________________________________________________________________________
method Style Interprets {str root} {
 return [this Interprets_and_parse str $root]
}

#_________________________________________________________________________________________________________
method Style Interprets_and_parse {str_name root} {
 upvar $str_name str
 set rep {}
   this set_ERROR {}
   set this(sens)         daughters
   set this(cmd_daughter) get_out_$this(sens)
   this DSL_SELECTOR str rep $root 1
 return $rep
}

#_________________________________________________________________________________________________________
#_________________________________________________________________________________________________________
#_ SELECTOR : CLASS OP_HIERA SELECTOR | CLASS | SELECTOR, SELECTOR
#_ OP_HIERA : > | ' '
#_    CLASS : DEF | DEF '\' SELECTOR '/'
#_      DEF : ID | ID(SELECTOR)
#_       ID : NAME | NAME->PROJ
#_     NAME : alphanum | *
#_     PROJ : _LM_LP | _LM_FC | ...
#_________________________________________________________________________________________________________
#_________________________________________________________________________________________________________
method Style DSL_SELECTOR {str_name rep_name L_root recursive} {
 upvar $str_name str
 upvar $rep_name rep
 
 #puts "DSL_SELECTOR\n  -str : $str\n  -L_root : $L_root\n  -recurs  $recursive"
 if {[regexp "^$this(sep)*>-->(.*)\$" $str reco str]} {set this(sens) daughters; set this(cmd_daughter) [string map [list mothers daughters] $this(cmd_daughter)]}
 if {[regexp "^$this(sep)*<--<(.*)\$" $str reco str]} {set this(sens) mothers  ; set this(cmd_daughter) [string map [list daughters mothers] $this(cmd_daughter)]}

 if {[regexp "^$this(sep)*\\\~ *(.*)\$" $str reco str]} {
   set this(cmd_daughter) get_$this(sens)
   set str2 " "; append str2 $str; set str $str2
  } else {if {[string index $str 0] == " "} {
            set this(cmd_daughter) get_out_$this(sens)
		   }
         }
 
 this DSL_CLASS str rep $L_root $recursive
 set ok 0

 # Recursion with nesting ?
 if {[regexp "^$this(sep)*>-->(.*)\$" $str reco str]} {set this(sens) daughters; set this(cmd_daughter) [string map [list mothers daughters] $this(cmd_daughter)]}
 if {[regexp "^$this(sep)*<--<(.*)\$" $str reco str]} {set this(sens) mothers  ; set this(cmd_daughter) [string map [list daughters mothers] $this(cmd_daughter)]}

 if {[regexp "^$this(sep)*\\\~ *(.*)\$" $str reco str]} {
	   set this(cmd_daughter) get_$this(sens)
	   set str " $str"
	  } else {if {[string index $str 0] == " "} {
				set this(cmd_daughter) get_out_$this(sens)
			   }
			 }
  
  
# Do we have a '>>' ?
 if {[regexp "^$this(sep)*>>$this(sep)*(.*)\$" $str reco str]} {
   set L_rep_>> [this Go_through_path str $c $this(cmd_daughter)]

     set found_end_>> 0
     while {${found_end_>>} == 0} {
       set pos_end_>> [string first / $str]
       if {${pos_end_>>} == -1} {break} else {set str [string range $str [expr ${pos_end_>>}+1] end]}
       if {[string equal -length 1 $str ~ ]} {set str [string range $str 1 end]; set this(cmd_daughter) get_$this(sens)}
	   if {[string equal -length 1 $str " " ]} {set this(cmd_daughter) get_out_$this(sens)}
       if {[string equal -length 2 $str >>]} {set str [string range $str 2 end]; set found_end_>> 1}
      }
     if {${found_end_>>} == 0} {this set_ERROR "A >>.../\[~\]>> expression do not end correctly, do not found the '>>' in : \nstr : $str"; return}
     set n_rep  [list]
	 set L_next [list]
     foreach e ${L_rep_>>} {
       foreach d [$e $this(cmd_daughter)] {Add_list L_next $d}
	  } 
     this DSL_SELECTOR str n_rep $L_next 0
     set rep $n_rep
     return
  }

# Do we have a '>' or a ' ' ?
 if {[regexp "^$this(sep)*>$this(sep)*(.*)\$" $str reco str]} {
   set ok 1; set rec 0
  } else {
      if {[regexp "^$this(sep)* +$this(sep)*(.*)\$" $str reco str]} {
        if { ![string equal -length 1 $str ,]
           &&![string equal -length 1 $str \;]
           &&![string equal -length 1 $str -] } {
        set ok 1; set rec 1}
       }
     }
 if {[regexp "^$this(sep)*\$" $str]}    {return}
 if {[regexp "^$this(sep)*/.*\$" $str]} {return}

# Allons voir plus loin s'il y a lieu
 if {$ok} {
   set new_rep {}
   set c       ""
   set L_next [list]
   foreach r $rep {
     foreach c [$r $this(cmd_daughter)] {Add_list L_next $c}
	}
   this DSL_SELECTOR str new_rep $L_next $rec
   set rep $new_rep
  }
  
# Case of the virgule
 if {[regexp "^$this(sep)*,$this(sep)*(..*)\$" $str reco str]} {
   set other_reps [list]
   this DSL_SELECTOR str other_reps $L_root $recursive
   set rep [Liste_Union $rep $other_reps]
  } else {if {[regexp "^$this(sep)*\\;$this(sep)*(..*)\$" $str reco str]} {
		   set other_reps [list]
		   this DSL_SELECTOR str other_reps $L_root $recursive
		   set rep [Liste_Intersection $rep $other_reps]
		  } else {if {[regexp "^$this(sep)*\\\-$this(sep)*(..*)\$" $str reco str]} {
				   set other_reps [list]
				   this DSL_SELECTOR str other_reps $L_root $recursive
				   Sub_list rep $other_reps
				  }
				 }
		 }
		 
}

#_________________________________________________________________________________________________________
#_    CLASS : DEF | DEF '\' SELECTOR '/' | DEF '\>' SELECTOR '/'
#_________________________________________________________________________________________________________
# XXX AJOUTER LE !
method Style DSL_CLASS {str_name rep_name L_root recursive} {
 upvar $str_name str
 upvar $rep_name rep

# Cas classique expression entre parenthèse
 this DSL_DEF str rep $L_root $recursive
 while {[regexp "^$this(sep)*\\\\(.*)\$" $str reco str]} {
   if {[string equal -length 4 $str MATH]} {
     set str [string range $str 4 end]
     #XXX PASSER A UNE FONCTION QUI ANNALYSE LES EXPR MATHEMATIQUES
     #XXX PUIS FINIR LE PARSING
     set rep "WORK IN PROGRESS : NEED TO IMPLEMENT MATH FILTER"
       puts $rep
       this set_ERROR $rep
     return
    }

	if {![regexp "^->($this(lettre)*) +(.*)" $str reco proj str]} {set proj ""} else {puts "Projection sur $proj"}
	
    if {[regexp "^$this(sep)*>-->$this(sep)*(.*)\$" $str reco str]} {set this(sens) daughters; set this(cmd_daughter) [string map [list mothers daughters] $this(cmd_daughter)]}
    if {[regexp "^$this(sep)*<--<$this(sep)*(.*)\$" $str reco str]} {set this(sens) mothers  ; set this(cmd_daughter) [string map [list daughters mothers] $this(cmd_daughter)]}
    if {[string equal [string index $str 0] !]} {set str [string range $str 1 end]
                                                set not 1
                                               } else {set not 0}
   if {[string equal [string index $str 0] (]} {set nested 1
												set str [string range $str 1 end]
											   } else {set nested 0}
   if {[string equal [string index $str 0] ~]} {set cmd_daughter get_$this(sens)
                                                set tilde ~
                                                set str [string range $str 1 end]
                                               } else {set tilde {}
											           set cmd_daughter $this(cmd_daughter)
                                                      }
   if {[string equal [string index $str 0] >]} {set str [string range $str 1 end]
                                                set rec 0
                                                # Is it a '>>' ?
                                                if {[string equal [string index $str 0] >]} {
                                                  set cmd_daughter get_COMET_id
                                                  set str "* ${tilde}>$str"
                                                 }
                                               } else {set rec 1}
#   puts "DSL_DEF($root) :\n  |rec : $rec\n  |str : $str"
   # Filter the responses
   set n_rep          [list]
   set L_indesirables [list]
   set L_rep_proj     [list]
   switch $proj {
	 _LM_LP  {foreach nr $rep {Add_list L_rep_proj [$nr get_LC]_LM_LP}}
	 LC      {foreach nr $rep {Add_list L_rep_proj [$nr get_LC]}}
	 PMs     {foreach nr $rep {Add_list L_rep_proj [[$nr get_LC]_LM_LP get_L_actives_PM]}}
	 default {foreach nr $rep {Add_list L_rep_proj $nr}}
	}
   
   if {$nested} {
     set L_rep_proj_nested [list]
	 foreach r $L_rep_proj {if {![string equal $r ""]} {Add_list L_rep_proj_nested [$r get_handle_composing_comet]}}
     set L_rep_proj_nested $L_rep_proj
    } else {set L_rep_proj_nested $L_rep_proj}
	
   set old_cmd_daughters $this(cmd_daughter)
   set this(cmd_daughter) $cmd_daughter

   #puts "  Filtre (rec $rec) : $str"
   set str_tmp $str
   foreach r $L_rep_proj_nested {
     set rep_tq  [list]
     set str $str_tmp
	 this DSL_SELECTOR str rep_tq [$r $cmd_daughter] $rec
     if {[llength $rep_tq]} {if {$not} {
						       Add_element L_indesirables $r
							  } else {Add_element n_rep $r}
						    }
     set this(cmd_daughter) $old_cmd_daughters
    }
	
   if {$not==1} {set n_rep $rep
				 Sub_list n_rep $L_indesirables
				}
		
   set rep $n_rep
  }

}

#_________________________________________________________________________________________________________
#_      DEF : ID | ID(SELECTOR) | ID(>SELECTOR)
#_________________________________________________________________________________________________________
method Style DSL_DEF {str_name rep_name L_root recursive} {
 upvar $str_name str
 upvar $rep_name rep

 this DSL_ID str rep $L_root $recursive

# Save state 
 set sens_SVG              $this(sens)
 set cmd_get_daughters_SVG $this(cmd_daughter)
 set this(sens)            daughters
 set this(cmd_daughter)    get_out_$this(sens)
 
 if {[regexp "^\\\((.*)\$" $str reco str]} {
   if {[string equal [string index $str 0] >]} {set str [string range $str 1 end]
                                                set rec 0} else {set rec 1}
   set rep_nesting [list]
   set n_rep       [list]
   set str_tmp     {}
   set str_rep     {}
   #XXX Find a way to optimize !
   foreach r $rep {
     set core_to_find_SVG $this(core_to_find)
	 if {[lsearch [gmlObject info classes $r] PM_U_encapsulator] >= 0} {
	   set this(core_to_find) [$r get_core]
	  }
     foreach c [$r get_handle_composing_comet] {
       set str_tmp $str
       set rep_nesting {}
       this DSL_SELECTOR str_tmp rep_nesting $c $rec
       if {[llength $rep_nesting]} {set str_rep $str_tmp}
       set n_rep [Liste_Union $n_rep $rep_nesting]
      }
	 set this(core_to_find) $core_to_find_SVG
	}
   
   this DSL_SELECTOR str rep_nesting $L_root $rec
   
   set rep $n_rep
   if {[regexp "^$this(sep)*\\)(.*)$" $str reco str]} {
    }
  }

# Reload state
 set this(sens)         $sens_SVG
 set this(cmd_daughter) $cmd_get_daughters_SVG
}

#_________________________________________________________________________________________________________
#_       ID : NAME | NAME->PROJ | '(' SELECTOR ')'
#_________________________________________________________________________________________________________
method Style Specializations {c} {
 set L $c
 foreach s [gmlObject info specializations $c] {
   set L [concat $L [this Specializations $s]]
  }
 return $L
}

#_________________________________________________________________________________________________________
method Style DSL_ID {str_name rep_name L_root recursive} {
 upvar $str_name str
 upvar $rep_name rep

 set rep_tmp [list]
 set n_rep   [list]
 set ext     {}
 set go_PM 0
 set go_LC 0

# In case of goto
 if {[regexp "^$this(sep)*\\\#($this(lettre)*)(.*)$" $str reco id str]} {
   set id_simple   [lindex [split $id .] 0]
   if {[gmlObject info exists object $id_simple]} {
     if {[lsearch [gmlObject info classes $id_simple] Comet_element] != -1} {
	   set L_root $id
       set str $id$str
      }
    }
   if {[gmlObject info exists class $id_simple]} {
     set L_id {}
     foreach spec [this Specializations $id_simple] {
       set L_id [concat $L_id [gmlObject info objects $spec]]
      }
	 set str $id$str
     this DSL_ID str n_rep $L_id $recursive
     Add_list rep $n_rep

     return
    }
   if {![string equal $id $L_root]} {return {}}
  }

# In case of negation
 if {[regexp "^$this(sep)*\\\!(.*)$" $str reco str]} {
   set negation 1
  } else {set negation 0}

# In case of parenthesis
 if {[regexp "^$this(sep)*\\\((.*)$" $str reco str]} {
   this DSL_SELECTOR str rep_tmp $L_root $recursive
   if {$negation} {
     set str_all *
     set rep_all [list]
       this DSL_SELECTOR str_all rep_all $L_root $recursive
     Sub_list rep_all $rep_tmp
     set rep_tmp $rep_all
    }
   regexp "^$this(sep)*\\\)$this(sep)*(.*)" $str reco str
  } else {
          # In case of NAME
          set id  {}
          if {[regexp "^$this(sep)*\\.*($this(lettre)*)(.*)$" $str reco id str]} {
            set id [split $id .]
            if {[llength $id]==0} {return}
            if {$recursive} {
              this Add_recursively rep_tmp id $L_root $negation
             } else {
                 if {[string equal $id *] && $negation==0} {set rep_tmp $L_root} else {set rep_tmp [list]
																					   foreach r $L_root {
																						 set hfs [$r Has_for_styles $id]
																						 if {($hfs+$negation)==1} {Add_list rep_tmp $r}
																					    }
																					  }
                }
           } else {puts "ERROR in $objName;\n  str : $str"; return}
         }
 #puts "  We have for candidates : \{$rep_tmp\}"
 if {[llength $rep_tmp] == 0} {return}
 
 set n_rep $rep_tmp
 while {[regexp "^->($this(lettre)*)(.*)$" $str reco ext str]} {
		 if {[string equal -length 3 $ext PMs]} {set go_PM 1} else {
		 if {[string equal -length 2 $ext LC ]} {set go_LC 1; set go_ext 0} else {
		   if {[string length $ext]>0} {set go_LC 1; set go_ext 1}
		  }}

		 set n_rep [list]

		 if {$go_PM} {
		   foreach r $rep_tmp {
			 if {[lsearch [gmlObject info classes $r] Logical_model] >= 0} {set LM $r} else {set LM [$r get_LC]_LM_LP}
			 foreach PM [$LM get_L_actives_PM] {
			   Add_element n_rep $PM
			  }
			}
		  } else {if {$go_LC} {
					if {$go_ext} {set e $ext} else {set e {}}
					foreach r $rep_tmp {
					  Add_element n_rep [$r get_LC]$e
					 }
				   } else {set n_rep $rep_tmp}
				 }

		# Managing others marks
		 set id [lreplace [split $ext .] 0 0]
		 if {[string length $id]>0} {
		   set old_n_rep $n_rep
		   set n_rep     {}
		   foreach r $old_n_rep {
			 if {[$r Has_for_styles $id]} {lappend n_rep $r}
			}
		  }
		  
   # DEBUG
   set rep_tmp $n_rep
   if {[string equal $rep_tmp {}]} {return}
  }

# In case of crochets
 if {[regexp "^$this(sep)*\\\[(.*)$" $str reco str]} {
   foreach r $n_rep {
     set str_tmp $str
     if {[this COND_NODE str_tmp $r]} {Add_element rep $r}
    }
   set pos_end_braket [string first {]} $str]
     set str [string range $str [expr $pos_end_braket + 1] end]
   regexp "^$this(sep)*\\\](.*)" $str reco str
  } else {Add_list rep $n_rep}
  
 #puts "  Now rep = {$rep}"
}

#_________________________________________________________________________________________________________
method Style Go_through_path {str_name L_root cmd} {
 upvar $str_name str

 set L_rep   [list]
 set n_L_rep [list]
 
 this DSL_SELECTOR str L_rep $d 0
 Add_list n_L_rep [this Go_through_path str_rec $L_rep $cmd]
	
 Add_list n_L_rep $L_root
 return $n_L_rep
}

#_________________________________________________________________________________________________________
method Style Add_recursively {rep_name id_name L_root {negation 0}} {
 upvar $rep_name rep
 upvar $id_name  id

 foreach root $L_root {
	 set go 0
	 if {[string equal $id *]} {set go 1} else  {
	   if {[$root Has_for_styles $id]} {
		 if {[string equal $id CORE]} {
		   if {[string equal $root $this(core_to_find)]} {set go 1}
		  } else {set go 1}
		}
	  }

	 if {($go && !$negation) || (!$go && $negation)} {
	   Add_element rep $root
	  }

     this Add_recursively rep id [$root $this(cmd_daughter)]
  }
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
# COND_NODE : COND_NODE_AND '||' COND_NODE | COND_NODE_AND
method Style COND_NODE {str_name node} {
 upvar $str_name str

 if {[this COND_NODE_AND str $node]} {return 1}
 if {[regexp "^\\|\\|$this(lexic,spaces)*(.*)$" $str reco str]} {
   return [this COND_NODE str $node]
  }

 return 0
}
#___________________________________________________________________________________________________________________________________________
# COND_NODE_AND : COND_NODE_NOT '&&' COND_NODE_AND | COND_NODE_NOT
method Style COND_NODE_AND {str_name node} {
 upvar $str_name str

 if {[this COND_NODE_NOT str $node]} {} else {return 0}
 if {[regexp "^\\&\\&$this(lexic,spaces)*(.*)$" $str reco str]} {
   return [this COND_NODE_AND str $node]
  }
 return 1
}

#___________________________________________________________________________________________________________________________________________
# COND_NODE_AND : '!' COND_BASE | COND_BASE
method Style COND_NODE_NOT {str_name node} {
 upvar $str_name str

 if {[regexp "^!$this(lexic,spaces)*(.*)" $str reco str]} {
   if {[this COND_BASE str $node]} {return 0} else {return 1}
  } else {return [this COND_BASE str $node]}
}

#___________________________________________________________________________________________________________________________________________
# COND_BASE : '(' COND_NODE ')' | accessor OP val
# OP        : == | != | ~=
method Style COND_BASE {str_name node} {
 upvar $str_name str

 if {[string equal $str {}]} {return 1}
 if {[regexp "^\\((.*)$" $str reco str]} {
   set str_inside [Compensate str ( ) 1]
   set str [regexp "^$this(lexic,spaces)*(.*)$" $str reco str]
   return [this COND_NODE str_inside $node]
  }
 
 set str_tmp [string map [list {]} { ]} {==} { == } {!=} { != } {~=} { ~= } {! ~} {!~} ] $str]
 set acc [lindex $str_tmp 0]
 set op  [lindex $str_tmp 1]
 set val [lindex $str_tmp 2]
 
 set str [lrange $str_tmp 3 end]
 
 #if {[regexp "^($this(lexic,letters)*)$this(lexic,spaces)*($this(lexic,op_cmp)*)$this(lexic,spaces)*($this(lexic,letters)*)$this(lexic,spaces)*(.*)$" $str reco acc op val str]} {
 #}
 if {1} {
   #if \{[lsearch [gmlObject info classes $node] Physical_model] == -1\} \{set ptf $node\} else \{set ptf $\{node\}_cou_ptf\}
   set ptf $node
   if {[catch "set rep \[$node get_$acc\]" res]} {
    if {[catch "set rep \[${node} $acc\]" res]} {
     if {[catch "set rep \[${node}_cou_ptf get_$acc\]" res]} {
       append this(ERROR) "\n" "Invalid accessor ($acc) for NODE or REL ($node).\n  acc : $acc\n   op : $op\n  val : $val\n$res";
       puts "Invalid accessor ($acc) for NODE or REL ($node).\n  acc : $acc\n   op : $op\n  val : $val\n$res"
       return 0
      }
     }
    }
   #puts "COND_BASE :\n  this(lexic,letters) : $this(lexic,letters)\n  this(lexic,spaces) : $this(lexic,spaces)\n  set rep \[$node get_$acc\]\n  $rep $op $val"
   switch $op {
     ==  {return [string equal $rep $val]}
     !=  {return [expr ![string equal $rep $val]]}
     ~=  {switch $acc {
            type {if {[catch "set r \[$rep Is_a $val\]" res]} {
                    append this(ERROR) "\n" "Invalid operation ~= between $rep and $acc. Maybe $acc is not a GDD type ($acc return $rep for NODE or REL $node) \n$res"
                    return 0
                   } else {return $r}
                 }
            default {return [expr [lsearch $rep $val]!=-1]
                    }
           }
         }
     !~= {switch $acc {
            type {if {[catch "set r \[$rep Is_a $val\]" res]} {
                    append this(ERROR) "\n" "Invalid operation !~= between $rep and $acc. Maybe $acc is not a GDD type ($acc return $rep for NODE or REL $node) \n$res"
                    return 0
                   } else {return [expr 1-$r]}
                 }
            default {return [expr [lsearch $rep $val]==-1]
                    }
           }
         }
     >   {return [expr $rep $op $val]}
     >=  {return [expr $rep $op $val]}
     <   {return [expr $rep $op $val]}
     <=  {return [expr $rep $op $val]}
    }

   append this(ERROR) "\n" "Invalid condition:\n$str"
   return 0
  } else {return 1}
}
