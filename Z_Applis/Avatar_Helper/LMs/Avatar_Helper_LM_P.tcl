#___________________________________________ Définition of Logical Model of présentation ___________________________________________________
inherit Avatar_Helper_LM_P Logical_presentation

#___________________________________________________________________________________________________________________________________________
method Avatar_Helper_LM_P constructor {name descr args} {
 this inherited $name $descr
 
# Factories
 this Add_PM_factories [Generate_factories_for_PM_type [list {Avatar_Helper_PM_P_B207_Hasselt Ptf_BIGre} \
                                                       ] $objName]

 eval "$objName configure $args"
 return $objName
}


#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Avatar_Helper_LM_P [L_methodes_set_Avatar_Helper] {}          {$this(L_actives_PM)}
Methodes_get_LC Avatar_Helper_LM_P [L_methodes_get_Avatar_Helper] {$this(FC)}

