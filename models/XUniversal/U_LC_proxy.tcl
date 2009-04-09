inherit CometProxy Logical_consistency

#___________________________________________________________________________________________________________________________________________
method CometProxy constructor {name descr args} {
 this inherited $name $descr

 Logical_model ${objName}_LM_LP "Presentation of $objName" {}
 this Add_LM ${objName}_LM_LP

 PM_Universal ${objName}_PM_P_U {} {}
 ${objName}_LM_LP Add_PM ${objName}_PM_P_U

# Evaluate arguments and return
 eval "$objName configure $args"
 return $objName
}
