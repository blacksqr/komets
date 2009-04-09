inherit PM_P_ScrollableListBox_TK PM_TK

#___________________________________________________________________________________________________________________________________________
method PM_P_ScrollableListBox_TK constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Choice_CUI_list_TK
 this set_root_for_daughters NULL
 set this(all_currents) ""
 set this(var_choice) "${objName}_var"
 set this(frame) {}

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method PM_P_ScrollableListBox_TK dispose {} {this inherited}

#______________________________________________________ Adding the choices functions _______________________________________________________
Methodes_set_LC PM_P_ScrollableListBox_TK $L_methodes_set_choices {$this(FC)} {}
Methodes_get_LC PM_P_ScrollableListBox_TK $L_methodes_get_choices {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method PM_P_ScrollableListBox_TK get_or_create_prims {root} {
 set common_FC [$this(LM) get_Common_FC]
 set this(root) $root
 set LC [this get_LC]

# set choiceLabel   [$common_FC get_label_name]
 set choiceOptions [$common_FC get_L_choices]

# set label_name "$root.tk_${objName}_label"
 set this(frame) "${root}.tk_${objName}_f"
 if {[winfo exists $this(frame)]} {} else {
   frame $this(frame)
   listbox $this(frame).lb -listvariable $this(var_choice)
     pack $this(frame).lb -side left -expand 1 -fill both
   scrollbar $this(frame).sb -orient vertical
     pack $this(frame).sb -side left -expand 0 -fill y
   $this(frame).lb configure -yscrollcommand "$this(frame).sb set"
   $this(frame).sb configure -command        "$this(frame).lb yview"
   bind $this(frame).lb <<ListboxSelect>> "set L {}; set Ld \[$LC get_out_daughters\]; foreach p \[$this(frame).lb curselection\] \{lappend L \[lindex \$Ld \$p\]\}\n$LC set_currents \$L"
   this set_nb_max_choices [this get_nb_max_choices]
  }

# Bindings
# set L [list $label_name $options_name]
 set L [list $this(frame)]
 this set_prim_handle $L

# this set_currents [$common_FC get_currents]
 this maj_choices

 return [this set_prim_handle $L]
}
#___________________________________________________________________________________________________________________________________________
method PM_P_ScrollableListBox_TK maj_choices        {}   {
 global debug
 global $this(var_choice)

 set LC [this get_LC]
 set L  {}
 foreach c [$LC get_out_daughters] {
   lappend L [$c get_name]
  }
 set $this(var_choice) $L

 this set_nb_max_choices [this get_nb_max_choices]
 this set_currents [$LC get_currents]
}

#___________________________________________________________________________________________________________________________________________
method PM_P_ScrollableListBox_TK set_nb_max_choices {nb} {
 if {[winfo exists $this(frame)]} {
   if {$nb > 1} {
     $this(frame).lb configure -selectmode extended
    } else {$this(frame).lb configure -selectmode normal}
  }
}

#___________________________________________________________________________________________________________________________________________
method PM_P_ScrollableListBox_TK set_currents       {lc} {
 global debug

#puts "$objName set_currents {$lc}"

 if {[winfo exists $this(frame)]} {} else {return}
 set LC [this get_LC]
 $this(frame).lb selection clear 0 end
 set L {}
 foreach c $lc {
   set pos [lsearch [$LC get_out_daughters] $c]
   if {$pos != -1} {lappend L $pos
				    $this(frame).lb selection set $pos
				   }
  }
#puts "$this(frame).lb selection set $L"
}

#___________________________________________________________________________________________________________________________________________
method PM_P_ScrollableListBox_TK Add_choices {L} {
 this maj_choices
}

#___________________________________________________________________________________________________________________________________________
method PM_P_ScrollableListBox_TK set_L_choices { L_choices } {
 this maj_choices
 this set_currents $L_choices
}
