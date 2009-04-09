

#___________________________________________ Définition of Logical Model of présentation ___________________________________________________
inherit CometComposer_LM_P Logical_presentation

method CometComposer_LM_P constructor {name descr args} {
 this inherited $name $descr

# Factories
 this Add_PM_factories [Generate_factories_for_PM_type [list {CometComposer_PM_P_U Ptf_ALL} \
                                                       ] $objName]

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometComposer_LM_P [L_methodes_set_CommonFC_CometComposer_LC] {}          {$this(L_actives_PM)}
Methodes_get_LC CometComposer_LM_P [L_methodes_get_CommonFC_CometComposer_LC] {$this(FC)}
