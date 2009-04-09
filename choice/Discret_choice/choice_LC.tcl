#source choice_CFC.tcl

#___________________________________________________________________________________________________________________________________________
inherit CometChoice Logical_consistency

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometChoice constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Choice
 set this(is_setting) 0
# Specfic choice datas
 set this(FC) [New_FC_Choice "A choice" {}]

# Classicals comet model parts
 set this(LM_LP) "${objName}_LM_LP"; choice_LM_P $this(LM_LP) "${name}_LM_LP" "The logical presentation of $name"; this Add_LM $this(LM_LP);

# foreach comet $L_choices {this Add_daughter $comet}
 
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometChoice dispose {} {this inherited}

#_______________________________________________________ Adding the choices functions _______________________________________________
Methodes_set_LC CometChoice $L_methodes_set_choices {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometChoice $L_methodes_get_choices {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method CometChoice set_nb_max_choices {nb} {
 this set_currents [lrange [this get_currents] 0 [expr $nb-1]]
 foreach LM [this get_L_LM] {
   $LM set_nb_max_choices $nb
  }
}

#_________________________________________________________________________________________________________
Manage_CallbackList CometChoice set_currents       end
Manage_CallbackList CometChoice set_nb_max_choices end

#_________________________________________________________________________________________________________
method CometChoice Choices {L} {
 this set_daughters_R $L
}

#_________________________________________________________________________________________________________
method CometChoice Sub_daughter {c} {
 set res [this inherited $c]
 this set_currents [Liste_Intersection [this get_currents] [this get_out_daughters]]
 return $res
}

#_________________________________________________________________________________________________________
method CometChoice Add_choices {L} {
    $this(FC) Add_choices $L
    this Add_daughters_R $L
    this Propagate_excusive "Add_choices \{$L\}"
}
#_________________________________________________________________________________________________________
method CometChoice Sub_choices {L} {
    $this(FC) Sub_choices $L
    this Sub_daughters_R $L
    this Propagate_excusive "Sub_choices \{$L\}"
}

#_________________________________________________________________________________________________________
method CometChoice set_L_choices { L_choices } {
    $this(FC) set_L_choices $L_choices
    this set_daughters_R $L_choices
    set LD [this get_daughters]
    this Propagate_excusive "set_L_choices \{$LD\}"
    this set_currents ""
}

#_________________________________________________________________________________________________________
method CometChoice get_L_choices {} {
 return [this get_out_daughters]
}

#_________________________________________________________________________________________________________
method CometChoice Add_daughter {m {index -1}} {
 set rep [this inherited $m $index]
   [this get_Common_FC] set_L_choices [this get_out_daughters]
 return $rep
}

#_________________________________________________________________________________________________________
method CometChoice Sub_daughter {m} {
 set rep [this inherited $m]
   [this get_Common_FC] set_L_choices [this get_out_daughters]
 return $rep
}

#_________________________________________________________________________________________________________
method CometChoice set_currents_by_name {L_names} {
 set L_c ""
 foreach n $L_names {
   set c_t ""; foreach d [this get_out_daughters] {if {[$d get_name] == $n} {set c_t $d; break}}
   if {$c_t != ""} {lappend L_c $c_t}
  }
 this set_currents $L_c
}
