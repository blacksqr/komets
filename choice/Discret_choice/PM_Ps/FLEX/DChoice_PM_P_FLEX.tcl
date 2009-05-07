inherit PM_Choice_FLEX PM_FLEX

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method PM_Choice_FLEX constructor {name descr args} {
 this inherited $name $descr
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC PM_Choice_FLEX $L_methodes_set_choices {} 		    {$this(L_LC)}
Methodes_get_LC PM_Choice_FLEX $L_methodes_get_choices {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method PM_Choice_FLEX prim_set_currents {c} {
puts "method PM_Choice_FLEX prim_set_currents \n"
 if {[string equal [this get_currents] $c]} {return}
 [this get_LC] set_currents $c
}

