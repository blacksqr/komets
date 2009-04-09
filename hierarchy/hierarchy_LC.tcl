#_______________________________________________________________________________________________________________________________________
inherit CometHierarchy Logical_consistency

#set methodes_choice [list {AddChoice {c}} {SubChoice {c}} {CurrentChoice {c}} {Exclusive {e}}]

#_______________________________________________________________________________________________________________________________________
method CometHierarchy constructor {name descr label_name root ll_name_cmd args} {
 this inherited $name $descr
   this set_GDD_id CT_Hierarchy
   this set_nb_max_daughters 0

 set CFC [New_Hierarchy_CFC $root $ll_name_cmd]
 this set_Common_FC $CFC

# Classicals comet model parts
 set this(LM_LP) "${objName}_LM_LP"
 Hierarchy_LM_P $this(LM_LP) "${name}_LM_LP" "The logical presentation of $name"
 this Add_LM $this(LM_LP);

 eval "$objName configure $args"
}

#______________________________________________________________________________________________________________________________________
method CometHierarchy dispose {} {this inherited}

#_________________________________________________________________________________________________________
Methodes_set_LC CometHierarchy [L_methodes_set_hierarchy] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometHierarchy [L_methodes_get_hierarchy] {$this(FC)}

Manage_CallbackList CometHierarchy set_currents end

