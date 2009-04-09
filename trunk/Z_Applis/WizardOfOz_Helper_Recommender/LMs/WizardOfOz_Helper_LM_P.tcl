#___________________________________________ Définition of Logical Model of présentation ___________________________________________________
inherit WizardOfOz_Helper_LM_P Logical_presentation

#___________________________________________________________________________________________________________________________________________
method WizardOfOz_Helper_LM_P constructor {name descr args} {
 this inherited $name $descr
 
# Factories
 this Add_PM_factories [Generate_factories_for_PM_type [list {WizardOfOz_Helper_PM_P_U_standard Ptf_ALL} \
                                                       ] $objName]

 eval "$objName configure $args"
 return $objName
}


#___________________________________________________________________________________________________________________________________________
Methodes_set_LC WizardOfOz_Helper_LM_P [L_methodes_set_WizardOfOz_Helper] {}          {$this(L_actives_PM)}
Methodes_get_LC WizardOfOz_Helper_LM_P [L_methodes_get_WizardOfOz_Helper] {$this(FC)}

