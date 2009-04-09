

#___________________________________________________________________________________________________________________________________________
#___________________________________________ Définition of Logical Model of présentation____________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Hierarchy_LM_P Logical_model
#___________________________________________________________________________________________________________________________________________
method Hierarchy_LM_P constructor {name descr args} {

 this inherited $name $descr

# Adding some PM of presentations
 if {[regexp "^(.*)_LM_LP" $objName rep comet_name]} {} else {set comet_name $objName}

 set TK_treectrl "${comet_name}_PM_P_TK_treectrl_$this(unique_PM_id)"
 PM_P_treectrl_TK $TK_treectrl "$comet_name->treectrl" "A treectrl representing $comet_name"

 this Add_PM        $TK_treectrl
 this set_PM_active $TK_treectrl
 
 eval "$objName configure $args"
}

#_________________________________________________________________________________________________________
Methodes_set_LC Hierarchy_LM_P [L_methodes_set_hierarchy] {$this(FC)} {$this(L_actives_PM)}
Methodes_get_LC Hierarchy_LM_P [L_methodes_get_hierarchy] {$this(FC)}

