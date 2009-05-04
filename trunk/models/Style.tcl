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
method Style DSL_SELECTOR {str_name rep_name root recursive} {
 upvar $str_name str
 upvar $rep_name rep
 
 if {[regexp "^$this(sep)*>-->(.*)\$" $str reco str]} {set this(sens) daughters; set this(cmd_daughter) [string map [list mothers daughters] $this(cmd_daughter)]}
 if {[regexp "^$this(sep)*<--<(.*)\$" $str reco str]} {set this(sens) mothers  ; set this(cmd_daughter) [string map [list daughters mothers] $this(cmd_daughter)]}
 if {[regexp "^$this(sep)*\\\~(.*)\$" $str reco str]} {
   set this(cmd_daughter) get_$this(sens)
   set str2 " "; append str2 $str; set str $str2
  } else {set this(cmd_daughter) get_out_$this(sens)}
 
 #puts "DSL_SELECTOR($root); str=\{$str\}; rec($recursive); sens($this(sens))"
 this DSL_CLASS str rep $root $recursive
 #puts "  |rep1=\{$rep\}\n  |reste: \"$str\""
 set ok 0
# if {[regexp "^$this(sep)*>$this(sep)*($this(lettre).*)\$" $str reco str]} {
#   set ok 1; set rec 0
#  } else {
#      if {[regexp "^$this(sep)* +($this(lettre).*)\$" $str reco str]} {
#        set ok 1; set rec 1
#       }
#     }
# Recursion with nesting ?
 if {[regexp "^$this(sep)*>-->(.*)\$" $str reco str]} {set this(sens) daughters; set this(cmd_daughter) [string map [list mothers daughters] $this(cmd_daughter)]}
 if {[regexp "^$this(sep)*<--<(.*)\$" $str reco str]} {set this(sens) mothers  ; set this(cmd_daughter) [string map [list daughters mothers] $this(cmd_daughter)]}
 
 if {[regexp "^$this(sep)*\\\~(.*)\$" $str reco str]} {
   set this(cmd_daughter) get_$this(sens)
   set str " $str"
  } else {set this(cmd_daughter) get_out_$this(sens)}

# Do we have a '>>' ?
 if {[regexp "^$this(sep)*>>$this(sep)*(.*)\$" $str reco str]} {
   set L_rep_>> {}
   #puts "Go through path with:\n  str : $str\n  rep : \{$rep\}"
   foreach c $rep {
     set str_tmp $str
     set cmd_svg $this(cmd_daughter)
       Add_list L_rep_>> [this Go_through_path str_tmp $c $this(cmd_daughter)]
     set this(cmd_daughter) $cmd_svg
    }
   #puts "  L_rep_>> : ${L_rep_>>}"
   #if {[regexp "^$this(sep)*/(.*)\$" $str reco str]} {
     set found_end_>> 0
     while {${found_end_>>} == 0} {
       set pos_end_>> [string first / $str]
       if {${pos_end_>>} == -1} {break} else {set str [string range $str [expr ${pos_end_>>}+1] end]}
       if {[string equal -length 1 $str ~ ]} {set str [string range $str 1 end]; set this(cmd_daughter) get_$this(sens)}
	   if {[string equal -length 1 $str " " ]} {set this(cmd_daughter) get_out_$this(sens)}
       if {[string equal -length 2 $str >>]} {set str [string range $str 2 end]; set found_end_>> 1}
      }
     if {${found_end_>>} == 0} {this set_ERROR "A >>.../\[~\]>> expression do not end correctly, do not found the '>>' in : \nstr : $str"; return}
     set n_rep {}
     set str_tmp {}
     foreach e ${L_rep_>>} {
       foreach d [$e $this(cmd_daughter)] {
         set str_tmp $str
         #puts "After the path, we try \"$objName DSL_SELECTOR str_tmp L_rep_tmp_>> $d 0\""
         set L_rep_tmp_>> {}; this DSL_SELECTOR str_tmp L_rep_tmp_>> $d 0
         Add_list n_rep ${L_rep_tmp_>>}
        }
      }
     set str $str_tmp
     set rep $n_rep
     return
    #} else {this set_ERROR "A >>.../\[~\]>> expression do not end correctly : \nstr : $str"; return}
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
   set str_tmp {}
   set str_rep {}
   foreach r $rep {
   foreach c [$r $this(cmd_daughter)] {
     set str_tmp $str
     set tmp     {}
     this DSL_SELECTOR str_tmp tmp $c $rec
     if {[string length $tmp]>0} {set str_rep $str_tmp}
     set new_rep [Liste_Union $new_rep $tmp]
    }}
   
   #DEBUG set str $str_rep
     set tmp_rep ""
     this DSL_SELECTOR str tmp_rep $root $rec
   
   set rep $new_rep
  }
# puts "__DSL_SELECTOR($root); rep=\{$rep\}"
# Case of the virgule
 if {[regexp "^$this(sep)*,$this(sep)*(..*)\$" $str reco str]} {
   set other_reps {}
   set str_tmp $str
   this DSL_SELECTOR str other_reps $root $recursive
   #puts "set other_reps \{\}; set str \{$str_tmp\}; $objName DSL_SELECTOR str other_reps $root $recursive"
   #puts "UNION BETWEEN $str_tmp : \{$other_reps\} AND \{$rep\}"
   set rep [Liste_Union $rep $other_reps]
  } else {
 if {[regexp "^$this(sep)*\\;$this(sep)*(..*)\$" $str reco str]} {
   set other_reps {}
   this DSL_SELECTOR str other_reps $root $recursive
   #puts "INTERSECTION BETWEEN \{$other_reps\} AND \{$rep\}"
   set rep [Liste_Intersection $rep $other_reps]
  } else {
 if {[regexp "^$this(sep)*\\\-$this(sep)*(..*)\$" $str reco str]} {
   set other_reps {}
   this DSL_SELECTOR str other_reps $root $recursive
   #puts "SUBSTRACTION OF \{$other_reps\}\nFROM \{$rep\}\n"
   Sub_list rep $other_reps
  }
  }}
}

#_________________________________________________________________________________________________________
#_    CLASS : DEF | DEF '\' SELECTOR '/' | DEF '\>' SELECTOR '/'
#_________________________________________________________________________________________________________
# XXX AJOUTER LE !
method Style DSL_CLASS {str_name rep_name root recursive} {
 upvar $str_name str
 upvar $rep_name rep

# Cas d'une expression entre parenthèse
# if {[regexp]}

# Cas classique expression entre parenthèse
 this DSL_DEF str rep $root $recursive
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

	if {![regexp "^($this(lettre)*) +(.*)" $str reco proj str]} {set proj ""}
	
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
                                                #set str " $str"
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
   set rep_tq  {}
   set n_rep   {}
   set str_tmp {}
   # Filter the responses
      # <DEBUG 2009 02 02>
	    set old_cmd_daughters $this(cmd_daughter)
	    set this(cmd_daughter) $cmd_daughter
	  # </DEBUG 2009 02 02>
	  
   set L_indesirables {}
   foreach nr $rep {
     switch $proj {
	   _LM_LP {set nr [$nr get_LC]}
	   LC     {set nr [$nr get_LC]_LM_LP}
	  }
     if {$nested} {
	   set r [$nr get_handle_composing_comet]
	   if {$r == ""} {continue}
	  } else {set r $nr}
     foreach c [$r $cmd_daughter] {
       set str_tmp $str
       set rep_tq {}
	   #puts "FILTER found : \n  cmd_daughter : $cmd_daughter\n  * str_tmp : \"$str_tmp\" \n  * set rep_tq {}; set str_tmp {$str}; $objName DSL_SELECTOR str_tmp rep_tq $c $rec"
       this DSL_SELECTOR str_tmp rep_tq $c $rec
       #puts "  * rep_tq : \{$rep_tq\}"
       set lg [string length $rep_tq]
       if {$lg>0} {
         if {$not==1} {lappend L_indesirables $nr}
         Add_element n_rep $nr
        }
      }
	}
      # <DEBUG 2009 02 02>
	    set this(cmd_daughter) $old_cmd_daughters
	  # </DEBUG 2009 02 02>

   if {$not==1} {set n_rep $rep
                 Sub_list n_rep $L_indesirables
                }
     #DEBUG set str $str_rep
     this DSL_SELECTOR str rep_tq $root $rec
	 set rep $n_rep
   regexp "^$this(sep)*\\\)*$this(sep)*/(.*)$" $str reco str
  }
# puts "DSL_CLASS : \{$rep\}"
}

#_________________________________________________________________________________________________________
#_      DEF : ID | ID(SELECTOR) | ID(>SELECTOR)
#_________________________________________________________________________________________________________
method Style DSL_DEF {str_name rep_name root recursive} {
 upvar $str_name str
 upvar $rep_name rep

 this DSL_ID str rep $root $recursive

# Save state 
 set sens_SVG              $this(sens)
 set cmd_get_daughters_SVG $this(cmd_daughter)
 set this(sens)         daughters
 set this(cmd_daughter) get_out_$this(sens)
 
 if {[regexp "^\\\((.*)$" $str reco str]} {
   if {[string equal [string index $str 0] >]} {set str [string range $str 1 end]
                                                set rec 0} else {set rec 1}
   set rep_nesting {}
   set n_rep       {}
   set str_tmp     {}
   set str_rep     {}
   foreach r $rep {
     set core_to_find_SVG $this(core_to_find)
	 if {[lsearch [gmlObject info classes $r] PM_U_encapsulator] >= 0} {
	   set this(core_to_find) [$r get_core]
	  }
     foreach c [$r get_handle_composing_comet] {
       set str_tmp $str
       set rep_nesting {}
       this DSL_SELECTOR str_tmp rep_nesting $c $rec
       if {[string length $rep_nesting]>0} {set str_rep $str_tmp}
       set n_rep [Liste_Union $n_rep $rep_nesting]
      }
	 set this(core_to_find) $core_to_find_SVG
	}
   
   #DEBUG set str $str_rep
     this DSL_SELECTOR str rep_nesting $root $rec
   
   set rep $n_rep
   if {[regexp "^$this(sep)*\\)(.*)$" $str reco str]} {
#     puts "    DSL_DEF : on passe la ) et il reste \"$str\""
    }
#   puts "  NESTING OK; reste \"$str\""
  }

# Reload state
 set this(sens)         $sens_SVG
 set this(cmd_daughter) $cmd_get_daughters_SVG
# puts "DSL_DEF : \{$rep\}"
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
method Style DSL_ID {str_name rep_name root recursive} {
 upvar $str_name str
 upvar $rep_name rep

 set rep_tmp {}
 set ext {}
 set go_PM 0
 set go_LC 0

# In case of goto
 if {[regexp "^$this(sep)*\\\#($this(lettre)*)(.*)$" $str reco id str]} {
   set id_simple   [lindex [split $id .] 0]
   #puts "GOTO $id_simple ($id)"
   if {[gmlObject info exists object $id_simple]} {
     if {[lsearch [gmlObject info classes $id_simple] Comet_element] != -1} {
       set root $id
       set str $id$str
      }
    }
   if {[gmlObject info exists class $id_simple]} {
     set L_id {}
     foreach spec [this Specializations $id_simple] {
       set L_id [concat $L_id [gmlObject info objects $spec]]
      }
     foreach e $L_id {
       set n_rep {}
       set str_tmp "$id$str"
       #puts "Sur $e : $str_tmp"
       this DSL_ID str_tmp n_rep $e $recursive
       #puts "  n_rep : \{$n_rep\}"
       Add_list rep $n_rep
      }
     # Parser le reste
     set str "$id$str"
     #puts "  PRE GOTO avec\n    str : $str"
       if {[llength $L_id] > 0} {this DSL_ID str n_rep [lindex $L_id 0] $recursive}
     #puts "  FIN GOTO avec\n    str : $str\n    L_id : \{$L_id\}"
     return
    }
   if {![string equal $id $root]} {return {}}
  }

# In case of negation
 if {[regexp "^$this(sep)*\\\!(.*)$" $str reco str]} {
   set negation 1
  } else {set negation 0}

# In case of parenthesis
 if {[regexp "^$this(sep)*\\\((.*)$" $str reco str]} {
   #puts "AVANT parenthèse (sur $root) : \"$str\""
   this DSL_SELECTOR str rep_tmp $root $recursive
   if {$negation} {
     set str_all *
     set rep_all {}
       this DSL_SELECTOR str_all rep_all $root $recursive
     Sub_list rep_all $rep_tmp
     set rep_tmp $rep_all
    }
   regexp "^$this(sep)*\\\)$this(sep)*(.*)" $str reco str
   #puts "APRES parenthèse (rep_tmp:\{$rep_tmp\}) : \"$str\""
  } else {
          # In case of NAME
          set id  {}
          if {[regexp "^$this(sep)*\\.*($this(lettre)*)(.*)$" $str reco id str]} {
            set id [split $id .]
            #puts "Dans $root : Reconnu liste d'id \{$id\}"
            if {[string length $id]==0} {return}
            set r $root
            if {$recursive} {
			  #puts "$objName DSL_ID:\n  | rep_tmp : {$rep_tmp}\n  | id : $id"
              this Add_recursively rep_tmp id $r $negation
			  #puts "  | this Add_recursively rep_tmp id $r $negation => rep_tmp == {$rep_tmp}"
             } else {
                 if {[string equal $id *] && $negation==0} {set rep_tmp $r} else {set hfs [$r Has_for_styles $id];
                                                                                  if {($hfs+$negation)==1} {set rep_tmp $r}
                                                                                 }
                }
           } else {puts "ERROR in $objName;\n  str : $str"; return}
         }
# puts "We have for candidates : \{$rep_tmp\}"
 if {[string equal $rep_tmp {}]} {return}

 regexp "^->($this(lettre)*)(.*)$" $str reco ext str
 if {[string equal -length 3 $ext PMs]} {set go_PM 1} else {
 if {[string equal -length 2 $ext LC ]} {set go_LC 1; set go_ext 0} else {
   if {[string length $ext]>0} {set go_LC 1; set go_ext 1}
  }}


# set rep {}
# Look for id in comet root-subgraph

 set n_rep {}
# if {$go_LC} {
#   foreach r $rep_tmp {
#     Add_element n_rep [$r get_LC]
#    }
#  }

 if {$go_PM} {
   foreach r $rep_tmp {
     set LM [$r get_LC]_LM_LP
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
 #puts "id:\"$id\""
# puts "AVANT vérification marquage \"$id\" pour \{$n_rep\} avec ext=\"$ext\""
 if {[string length $id]>0} {
   set old_n_rep $n_rep
   set n_rep     {}
   foreach r $old_n_rep {
     if {[$r Has_for_styles $id]} {lappend n_rep $r}
    }
  }
# puts "APRES vérification marquage \"$id\" reste \{$n_rep\}"

# In case of crochets
 if {[regexp "^$this(sep)*\\\[(.*)$" $str reco str]} {
   #puts "On $root, FILTER : $str"
   foreach r $n_rep {
     set str_tmp $str
     #puts "  CONDITION VERIFICATION NODE($r) COND\[$str_tmp\]"
     if {[this COND_NODE str_tmp $r]} {Add_element rep $r}
    }
   #this COND_NODE str $root
   set pos_end_braket [string first {]} $str]
     set str [string range $str [expr $pos_end_braket + 1] end]
   regexp "^$this(sep)*\\\](.*)" $str reco str
   #puts "  RESTE : $str"
  } else {Add_list rep $n_rep}
}

#_________________________________________________________________________________________________________
method Style Go_through_path {str_name root cmd} {
 upvar $str_name str
 #puts "$objName Go_through_path \{$str\} $root \{$cmd\}"
 set L_rep   {}
 set n_L_rep {}
   foreach d [$root $cmd] {
     set str_tmp $str
     this DSL_SELECTOR str_tmp L_rep $d 0
     #puts "Try with $d -> \{$L_rep\}"
    }
   if {[llength $L_rep] > 0} {
     foreach e $L_rep {
       set str_rec $str
       #puts "Recursion on $e"
       Add_list n_L_rep [this Go_through_path str_rec $e $cmd]
      }
    }
 Add_element n_L_rep $root
 return $n_L_rep
}

#_________________________________________________________________________________________________________
method Style Add_recursively {rep_name id_name root {negation 0}} {
 upvar $rep_name rep
 upvar $id_name  id

 #puts "    $objName Add_recursively $rep $id $root $negation"
 
 set go 0
 if {$id == "*"} {set go 1} else  {
   if {[$root Has_for_styles $id]} {
     if {$id == "CORE"} {
	   if {$root == $this(core_to_find)} {set go 1} else {set go 0}
	  } else {set go 1}
	} 
  }

 if {($go==1 && $negation==0) || ($go==0 && $negation==1)} {
   Add_element rep $root
  }

 foreach c [$root $this(cmd_daughter)] {
   this Add_recursively rep id $c
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
 if {[regexp "^($this(lexic,letters)*)$this(lexic,spaces)*($this(lexic,op_cmp)*)$this(lexic,spaces)*($this(lexic,letters)*)$this(lexic,spaces)*(.*)$" $str reco acc op val str]} {
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
