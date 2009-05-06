#___________________________________________________________________________________________________________________________________________
#___________________________________________ Définition of Logical Model of présentation____________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit choice_LM_P Logical_presentation
#___________________________________________________________________________________________________________________________________________
method choice_LM_P constructor {name descr args} {
 set this(init_ok) 0
 this inherited $name $descr
 this set_L_actives_PM {}
 set this(num_sub) 0

 if {[regexp "^(.*)_LM_LP" $objName rep comet_name]} {} else {set comet_name $objName}
 set this(comet_name) $comet_name

# Nesting parts
 set this(Interleaving) "${objName}_nested_interleaving"
 CometInterleaving $this(Interleaving) "Interleaving of choices" "Nested part used to interleaved the different choices managed by $objName"
   this Add_handle_composing_comet $this(Interleaving) 0 _LM_LP

# Adding some PM of presentations
 if {[regexp "^(.*)_LM_LP" $objName rep comet_name]} {} else {set comet_name $objName}
# set TK_radio_bt "${comet_name}_PM_P_TK_radioBt_[this get_a_unique_id]"
#   PM_P_radiobutton_TK $TK_radio_bt $TK_radio_bt "A TK list of marked choices representing $objName"
#   this Add_PM $TK_radio_bt
 set TK_menu "${comet_name}_PM_P_TK_menu_[this get_a_unique_id]"
   PM_P_menu_TK $TK_menu $TK_menu "A TK menu representing $objName"
   this Add_PM $TK_menu
# set HTML_1 "${comet_name}_PM_P_HTML_interleaving_markers_[this get_a_unique_id]"
#   DChoice_PM_P_interleaving_markers_HTML $HTML_1 $HTML_1 "A HTML representation of $objName"
#   this Add_PM $HTML_1
  this Add_PM_factories [Generate_factories_for_PM_type [list {Choice_PM_P_ALX_TXT Ptf_ALX_TXT}                 \
                                                              {DChoice_PM_P_interleaving_markers_HTML Ptf_HTML} \
                                                              {DChoice_PM_P_Menu_HTML Ptf_HTML}                 \
                                                              {DChoice_PM_P_interleaving_markers_TK Ptf_TK}     \
															  {DChoice_PM_P_Menu_FLEX Ptf_FLEX} 				\
 															  {U_choice_PM_P Ptf_ALL} 							\

                                                        ] $objName]

 set this(init_ok) 1
 this set_PM_active $TK_menu
# this set_PM_active $HTML_1

 set this(is_making_marks_consistents) 0

 eval "$objName configure $args"
 return $objName
}
#______________________________________________________ Adding the choices functions _______________________________________________________
Methodes_set_LC choice_LM_P $L_methodes_set_choices {}          {$this(L_actives_PM)}
Methodes_get_LC choice_LM_P $L_methodes_get_choices {$this(FC)}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_set_choice_N_COMET_RE {} {return [list {set_currents {v}}]}
Generate_LM_setters choice_LM_P [P_L_methodes_set_choice_N_COMET_RE]

#___________________________________________________________________________________________________________________________________________
inherit choice_PM_P_encapsulator PM_Universal_encapsulator
  Generate_Universal_PM_methods choice_PM_P_encapsulator $L_methodes_get_choices
  Generate_Universal_PM_methods choice_PM_P_encapsulator $L_methodes_set_choices
  method choice_PM_P_encapsulator constructor {name descr PM_core args} {
    eval "this inherited \{$name\} \{$descr\} \{$PM_core\} $args"
   }
  method choice_PM_P_encapsulator maj_choices {} {[this get_core] maj_choices}

#___________________________________________________________________________________________________________________________________________
method choice_LM_P Stop_making_marks_consistents {} {
 set this(is_making_marks_consistents) 0
}

#___________________________________________________________________________________________________________________________________________
method choice_LM_P set_currents {Lc} {
global debug
 [this get_Common_FC] set_currents $Lc
 if {$debug} {puts "$objName set_currents $Lc"}
 this Make_marks_consistents
 foreach PM $this(L_actives_PM) {$PM set_currents $Lc}
}
#___________________________________________________________________________________________________________________________________________
method choice_LM_P set_PM_active {PM} {
 if {[expr $this(init_ok) == 0]} {return}
 set added [this inherited $PM]
 if {[expr $added == 1]} {$PM maj_choices
                         }
}
#___________________________________________________________________________________________________________________________________________
method choice_LM_P Make_marks_consistents {} {
global debug
 if {$this(is_making_marks_consistents)} {return}
 if {$debug} {puts "$objName Make_marks_consistents\n  choices are : [this get_currents]"}
 set this(is_making_marks_consistents) 1
   foreach CM [this get_handle_comet_daughters] {
     if {$debug} {puts "  $CM is still marked at [$CM get_mark]"}
#     if {[$CM get_mark]} {
       set choix_LM_P [$CM get_daughters]
       if {[string length $choix_LM_P]==0} {puts "Problème dans $objName Make_marks_consistents.\  => $CM n'a pas de fils!!!"
                                            continue
                                           }
       set choix_LC   [$choix_LM_P get_LC]
       if {$debug} {puts "lsearch \{[this get_currents]\} \"$choix_LC\""}
       set pos [lsearch [this get_currents] $choix_LC]
       if {[expr $pos == -1]} {
         [$CM get_LC] set_mark 0
        } else {[$CM get_LC] set_mark 1}
#      }
    }
 set this(is_making_marks_consistents) 0
}

#___________________________________________________________________________________________________________________________________________
method choice_LM_P Is_making_marks_consistents {} {return $this(is_making_marks_consistents)}

#___________________________________________________________________________________________________________________________________________
method choice_LM_P Add_daughter    {m {index -1}} {
 global debug

 if {$this(init_ok) == 0} {
   return [this inherited $m $index]
   return 1
  }

 set pos [this Has_for_daughter $m]
 if { $debug } {puts "XXXX LogicalInterleaving: $objName Add_daughter $m $index"}
 if {[expr $pos >= 0]} {return 2}
 set node_name       "$this(comet_name)_marker_$this(num_sub)"
 set node_name_LM_LP "${node_name}_LM_LP"
 CometMarker $node_name "Marker for [[$m get_LC] get_name]" {Embeded comet used to mark a daughter}
 incr this(num_sub)
 if {[expr ($index == -1) || ([llength $this(L_handle_composing_daughters)] <= $index)]} {
   set pos -1
   #set pos [llength $this(L_handle_composing_daughters)]
  } else {set pos $index}
 set rep [$this(Interleaving) Add_daughter_R $node_name $index]
   this Add_handle_comet_daughters $node_name $pos _LM_LP
   $node_name_LM_LP Add_daughter $m
   set this(is_making_marks_consistents) 1
     set cmd {}
     append cmd "if \{\[$objName Is_making_marks_consistents\]\} \{\} else \{\n"
     append cmd "  if \{\[expr \[$node_name get_mark\]==1\]\} \{\n"
     append cmd "    set L \[$objName get_currents\]\n"
     append cmd "    if \{\[expr \[$objName get_nb_choices\] < \[$objName get_nb_max_choices\]\]\} \{\n"
     append cmd "      lappend L [$m get_LC]\n"
     append cmd "     \} else \{set L \[lreplace \$L 0 0\]; lappend L [$m get_LC]\}\n"
     append cmd "    [this get_LC] set_currents \$L\n"
     append cmd "   \} else \{"
     append cmd "            if \{\[expr \[$objName get_nb_choices\] <= \[$objName get_nb_min_choices\]\]\} \{\n"
     append cmd "               [this get_LC] set_currents \[$objName get_currents\]\n"
     append cmd "               \} else \{set L \[$objName get_currents\]\n"
#     append cmd "                         puts \"Sub_element L [$m get_LC]\"\n"
     append cmd "                         Sub_element L [$m get_LC]\n"
#     append cmd "                         puts \"[this get_LC] set_currents \\\"\$L\\\"\"\n"
     append cmd "                         [this get_LC] set_currents \$L\n"
     append cmd "                       \}\n"
     append cmd "           \}\n"
     append cmd " \}\n"
     $node_name Subscribe_to_set_mark $objName $cmd
   set this(is_making_marks_consistents) 0

 this set_composing_comets       [concat $this(Interleaving)_LM_LP [$this(Interleaving)_LM_LP get_out_daughters]]
 this set_handle_composing_comet $this(Interleaving)_LM_LP                     {}
 this set_handle_comet_daughters [$this(Interleaving)_LM_LP get_out_daughters] {}

 if {[expr $this(init_ok) == 1]} {
 	foreach pm [this get_L_actives_PM] {
 	  if {$debug} {puts "              $pm maj_choices"}
          $pm maj_choices
         }
  }

 return 1
}
#_________________________________________________________________________________________________________
method choice_LM_P Sub_daughter    {m} {
 global debug
 set rep [this inherited $m]
 if {$rep == 1} {} else {return $rep}
 if {[string equal $this(last_nested_daughter_subbing) {}]} {
  } else {
          set c $this(last_nested_daughter_subbing)
            $this(Interleaving) Sub_daughter_R [$c get_LC]
          #DEBUG set this(L_handle_composing_daughters) [$this(Interleaving)_LM_LP get_out_daughters]
		    this set_handle_comet_daughters [$this(Interleaving)_LM_LP get_out_daughters] ""
		  #/DEBUG
          this Sub_composing_comet $c
          [$c get_LC] dispose
         }
 if {[expr $this(init_ok) == 1 && $rep == 1]} {
   foreach pm [this get_L_actives_PM] {
     if {$debug} {puts "$pm maj_choices"}
     $pm maj_choices
    }
  }

 this set_composing_comets       [concat $this(Interleaving)_LM_LP [$this(Interleaving)_LM_LP get_out_daughters]]
 this set_handle_composing_comet $this(Interleaving)_LM_LP                     {}
 this set_handle_comet_daughters [$this(Interleaving)_LM_LP get_out_daughters] {}
 return $rep
}
#_________________________________________________________________________________________________________
method choice_LM_P set_daughters {L} {

}

