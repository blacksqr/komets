#__________________________________________________
inherit CSS_Meta_IHM_CFC CommonFC

method CSS_Meta_IHM_CFC constructor {} {
 this inherited
 set this(root_meta)         {}
 set this(L_set_of_rules)    [list]
 set this(selected_elements) [list]
}

#______________________________________________________
Generate_accessors CSS_Meta_IHM_CFC [list root_meta]

#______________________________________________________
method CSS_Meta_IHM_CFC get_L_set_of_rules {} {return $this(L_set_of_rules)}

#______________________________________________________
#______________________________________________________
#______________________________________________________
method CSS_Meta_IHM_CFC Index_of_set_of_rules_named {name} {
 set pos 0
 foreach sr $this(L_set_of_rules) {
   if {[string equal $name [lindex $sr 0]]} {return $pos}
   incr pos
  }
 return -1
}

#______________________________________________________
method CSS_Meta_IHM_CFC Maj_set_of_rules {name txt} {
 set pos [this Index_of_set_of_rules_named $name]
 set this(L_set_of_rules) [lreplace $this(L_set_of_rules) $pos $pos [list $name $txt]]
}

#______________________________________________________
method CSS_Meta_IHM_CFC Delete_rules_named {L_names} {
 foreach n $L_names {
   set n_rules {}
   foreach r $this(L_set_of_rules) {
     if {![string equal $n [lindex $r 0]]} {lappend n_rules $r}
    }
   set this(L_set_of_rules) $n_rules
  }
}

#______________________________________________________
method CSS_Meta_IHM_CFC get_rule_named {n} {
 foreach r $this(L_set_of_rules) {
   if {[string equal $n [lindex $r 0]]} {return $r}
  }
 return {}
}

#_________________________________________________________________________________________________________
method CSS_Meta_IHM_CFC Get_flags {str_name} {
 upvar $str_name str
 set sep "\[     \n\]"

 set L [split $str "\;"]
 set rep [list]
 foreach e $L {
   if {[regexp "^$sep*(.*)$sep*:$sep*(.*)$sep*\$" $e reco var val]} {
     lappend rep [list $var $val]
    }
  }

 return $rep
}

#______________________________________________________
method CSS_Meta_IHM_CFC Apply_set_of_rules_to {Element L_names} {
 set L_roots [$Element get_L_roots]
 set root [lindex $L_roots 0]
 $root set_style ""
 set L_fct   ""
 set L_RULES ""
 foreach name $L_names {
   set txt {}
   foreach rule $this(L_set_of_rules) {
     if {[string equal [lindex $rule 0] $name]} {
       #puts "  $objName : Rule named \"$name\" has been found in the CFC";
       set txt [lindex $rule 1];
	   #puts "$txt \n"
       break
      }
    }
   if {[string equal $txt {}]} {
     puts "  $objName : Rule named \"$name\" has no body";
     continue
    }
   #set txt [lindex [lindex $this(L_set_of_rules) $index] 1]

   if {[regexp "^(.*)\n___* *(RULES)? *_*\n(.*)\$" $txt reco fct rule_txt txt]} {
    } else {set fct {}}
   #puts "Functions:\n$fct\n ----"

   set L_rep {}
     # <DEBUG 2009 02 04> set L [split $txt "\}"]
	 set L_sel_rule [Read_string_as_css++ $txt]
	 set L {}
	 foreach sel_rule $L_sel_rule {
	   lappend L "[lindex $sel_rule 0] \{\n[lindex $sel_rule 1]"
	  }
	 # </DEBUG 2009 02 04>
   set sep "\[ \n\]"
   set letter {[a-zA-Z0-9_\*\)/\[\]}
     append letter "\#\]"
     #append letter "\{\}\]"
   set expression "^\n* *($letter.*$letter) *\{ *\n$sep*(.*;)$sep*\$"

   foreach e $L {
     #puts "  $objName : Analysing rule\n$e\n   ____"
     if {[regexp $expression $e reco selector flags]} {
       set flags [this Get_flags flags]
       lappend L_rep [list $selector $root $flags]
       #puts "Trouvé :\n  selec : $selector\n  flags : $flags"
      }
    }

   set L_rules {}
   foreach r $L_rep {
     set style {}
     foreach s [lindex $r 2] {append style "[lindex $s 0]: [lindex $s 1];\n"}
     lappend L_rules [list [lindex $r 0] [lindex $r 1] $style]
    }

  if {![string equal $fct ""]} {
    append L_fct "\n$fct"
	if {![string equal [string index $L_fct end] "\;"]} {append L_fct "\;"}
   }
  
  set L_RULES [concat $L_RULES $L_rules]
  # Apply the styles rules to roots of $Element
  # Modify set of rules for the root
   #this Update_style_to_with $root $fct $sel $L_rep
   Update_style [$root get_DSL_GDD_QUERY] [$root get_DSL_CSSpp] $fct $L_rules $root
  }
 #puts "_______________ Functions _______________\n$L_fct\n______________________________________"
 $root set_style $L_RULES
 [$root get_LC] set_styler [$root get_DSL_CSSpp]
#Update_style [$root get_DSL_GDD_QUERY] [$root get_DSL_CSSpp] $L_fct $L_RULES
}

#______________________________________________________
method CSS_Meta_IHM_CFC Update_style_to_with {root fct L_rules} {
 return
 puts "______ $objName Update_style_to_with $root $fct $sel $L_attr_val"
 # Pour chaque règle de rule_txt, voir si un correspondant dans l'existant (root get_style)
 # si oui, mettre à jour à la fois le attribut mais aussi (éventuellement), les fonction GDD genre avec renommage si différent
   set L_original_rules [$root get_rule]
   foreach rule $L_rules {
    # Chercher si rule est présente dans l'ensemble de règle original
     set sel_trouve 0
    # Si rule est trouvé dans le style d'origine, mettre à jour ce dernier
	# sinon ajouter la règle
    }
 puts "__END_ "
}

#______________________________________________________
method CSS_Meta_IHM_CFC Delete_styles {} {
 set this(L_set_of_rules) {}
}

#______________________________________________________
method CSS_Meta_IHM_CFC Load_styles {L_file_names} {
 #puts "$objName Load_styles $L_file_names"
 foreach file_name $L_file_names {
   if {[regexp {^.*\.multi_css\+\+$} $file_name]} {
     this Load_styles_from_meta_style_file $file_name
    } else {this Load_styles_from_css++_files [list $file_name]}
  }
}

#______________________________________________________
# In meta style file, just alist, line by line, of files to load
method CSS_Meta_IHM_CFC Save_styles_to_meta_style_file {file_name} {
 # Save all the rules in css++ files
 this Save_styles_to_css++_files
 # Then save the css++ files list!
 set f [open $file_name w]
   foreach rule $this(L_set_of_rules) {
     puts $f [lindex $rule 0].css++
    }
 close $f
}

#______________________________________________________
method CSS_Meta_IHM_CFC Load_styles_from_meta_style_file {file_name} {
 if {![file exists $file_name]} {return}
 set f [open $file_name]
   set txt [read $f]
   set L [split $txt "\n"]
   set L_file_names {}
   foreach e $L {
     if {[regexp {^.*\.css\+\+$} $e]} {lappend L_file_names $e}
    }
   this Load_styles_from_css++_files $L_file_names
 close $f
}

#______________________________________________________
method CSS_Meta_IHM_CFC Save_styles_to_css++_files {} {
 foreach rule $this(L_set_of_rules) {
   set f_name [lindex $rule 0].css++
   set f [open $f_name w]
     puts $f [lindex $rule 1]
   close $f
  }
}

#______________________________________________________
method CSS_Meta_IHM_CFC Load_styles_from_css++_files {L_files} {
 #this Delete_styles
 foreach f_name $L_files {
   if {![file exists $f_name]} {continue}
   set f   [open $f_name]; puts "Loading $f_name"
   set txt [read $f]
     if {[regexp {^(.*)\.(.*)$} $f_name reco prefix suffix]} {
       set name $prefix
      } else {set name $f_name}
   this Maj_set_of_rules $name $txt
   close $f
  }
}

#______________________________________________________
method CSS_Meta_IHM_CFC Select_rules {L} {}

#______________________________________________________
method CSS_Meta_IHM_CFC Apply_rules  {}  {}

#______________________________________________________
method CSS_Meta_IHM_CFC Select_elements  {L}  {set this(selected_elements) $L}

#______________________________________________________
method CSS_Meta_IHM_CFC get_selected_elements {}  {return $this(selected_elements)}


#______________________________________________________
proc L_methodes_get_CSS_Meta_IHM {} {return [list {get_selected_elements {}} {get_L_set_of_rules {}} {get_root_meta { }} {get_rule_named {n}} {Maj_set_of_rules {name txt_name}} {Apply_set_of_rules_to {Element L_index}} ]}
proc L_methodes_set_CSS_Meta_IHM {} {return [list {Select_elements {L}} {Load_styles {L_file_names}} {Load_styles_from_meta_style_file {file_name}} {Save_styles_to_meta_style_file {file_name}} {Save_styles_to_css++_files {}} {Load_styles_from_css++_files {L_files}} {Delete_styles {}} {Delete_rules_named {L_names}} {set_root_meta {t}} ]}

#______________________________________________________
