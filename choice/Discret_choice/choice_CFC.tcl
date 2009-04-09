

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
set L_methodes_get_choices [list {maj_choices {}} {get_label_name {}}   {get_L_choices {}}   {get_currents {}}   {get_nb_max_choices {}}   {get_nb_min_choices {}}   {get_nb_choices {}}]
set L_methodes_set_choices [list {set_label_name {ln}} {set_L_choices {lc}} {set_currents {lc}} {set_nb_max_choices {nb}} {set_nb_min_choices {nb}} {Add_choices {L}} {Sub_choices {L}} {sub_current_choice {ch}} {add_current_choice {ch}} ]

#___________________________________________________________________________________________________________________________________________
inherit FC_Choice CommonFC
#___________________________________________________________________________________________________________________________________________
method FC_Choice constructor {{label_name label} {L_choices {}}} {
 set this(label_name) $label_name
 set this(L_choices)  $L_choices
 set this(nb_max_choice) 1
 set this(nb_min_choice) 0
 set this(currents) [list]
}
#___________________________________________________________________________________________________________________________________________
method FC_Choice get_label_name     {}   {return $this(label_name)}
method FC_Choice set_label_name     {ln} {set this(label_name) $ln}
#___________________________________________________________________________________________________________________________________________
method FC_Choice get_L_choices      {}   {return $this(L_choices)}
method FC_Choice set_L_choices      {lc} {set this(L_choices) $lc}
#___________________________________________________________________________________________________________________________________________
method FC_Choice Add_choices        {L}  {Add_list this(L_choices) $L}
method FC_Choice Sub_choices        {L}  {Sub_list this(L_choices) $L}
#___________________________________________________________________________________________________________________________________________
method FC_Choice get_currents       {}   {return $this(currents)}
method FC_Choice set_currents       {lc} {set this(currents) $lc}
#___________________________________________________________________________________________________________________________________________
method FC_Choice sub_current_choice {ch} {return [Sub_element this(currents) $ch]}
method FC_Choice add_current_choice {ch} {return [Add_element this(currents) $ch]}
#___________________________________________________________________________________________________________________________________________
method FC_Choice get_nb_choices     {}   {return [llength $this(currents)]}
method FC_Choice get_nb_max_choices {}   {return $this(nb_max_choice)}
method FC_Choice set_nb_max_choices {nb} {set this(currents) [lrange $this(currents) 0 [expr $nb-1]]; set this(nb_max_choice) $nb}
method FC_Choice get_nb_min_choices {}   {return $this(nb_min_choice)}
method FC_Choice set_nb_min_choices {nb} {set this(nb_min_choice) $nb}

#___________________________________________________________________________________________________________________________________________
method FC_Choice maj_choices {} {}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
if {[info exists nb_FC_Choice]} {} else {set nb_FC_Choice 0}
proc New_FC_Choice {label_name L_choices} {
 global nb_FC_Choice
 set name "FC_Choice_$nb_FC_Choice"
 FC_Choice $name $label_name $L_choices
 incr nb_FC_Choice
 return $name
}

