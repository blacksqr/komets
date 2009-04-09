#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Specifyer_PM_P_encapsulator PM_Universal_encapsulator

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_encapsulator constructor {name descr core args} {
 this inherited $name $descr $core

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_encapsulator set_text {t} {
 set cmd "[this get_core] set_text $t"
 return [eval $cmd]
}

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_encapsulator get_text {} {
 set cmd "[this get_core] get_text"
 return [eval $cmd]
}

