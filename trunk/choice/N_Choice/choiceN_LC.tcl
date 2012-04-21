# source choiceN_CFC.tcl

#___________________________________________________________________________________________________________________________________________
inherit CometChoiceN Logical_consistency

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometChoiceN constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id N_Choice
 this set_nb_max_daughters 0

# Specfic choice datas
 set CFC "${objName}_CFC"
   ChoiceN_CFC $CFC 
   this set_Common_FC $CFC

# Classicals comet model parts
 set this(LM_LP) "${objName}_LM_LP";
 ChoiceN_LM_LP $this(LM_LP) "${name}_LM_LP" "The logical presentation of $name";
 this Add_LM $this(LM_LP);

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometChoiceN dispose {} {this inherited}


#_______________________________________________________ Adding the choices functions _______________________________________________
Methodes_set_LC CometChoiceN $L_methodes_set_choicesN {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometChoiceN $L_methodes_get_choicesN {$this(FC)}

Inject_code CometChoiceN set_val {
	set v [$this(FC) set_val $v]
} {} __RANGE__

Manage_CallbackList CometChoiceN  set_val   end
Manage_CallbackList CometChoiceN  set_b_inf end
Manage_CallbackList CometChoiceN  set_b_sup end

#Trace CometChoiceN set_val
