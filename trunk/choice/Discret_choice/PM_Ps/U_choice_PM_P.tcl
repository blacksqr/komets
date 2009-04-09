inherit U_choice_PM_P PM_Universal

#___________________________________________________________________________________________________________________________________________
method U_choice_PM_P constructor {name descr args} {
 this inherited $name $descr
 
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method U_choice_PM_P dispose {} {this inherited}

#______________________________________________________ Adding the choices functions _______________________________________________________
Methodes_set_LC U_choice_PM_P $L_methodes_set_choices {$this(FC)} {}
Methodes_get_LC U_choice_PM_P $L_methodes_get_choices {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method U_choice_PM_P maj_choices {} {}
