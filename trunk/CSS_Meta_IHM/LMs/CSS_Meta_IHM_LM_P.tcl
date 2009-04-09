#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CSS_Meta_IHM_LM_P Logical_presentation

#___________________________________________________________________________________________________________________________________________
method CSS_Meta_IHM_LM_P constructor {name descr args} {
 this inherited $name $descr
 
 set this(init_ok) 0
  
# Factories
 this Add_PM_factories [Generate_factories_for_PM_type [list {CSS_Meta_IHM_PM_P_U_1 Ptf_ALL} \
                                                       ] $objName]

 set this(init_ok) 1

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
proc L_methodes_set_CSS_Meta_IHM_LM_LP {} {return [concat [list {Select_elements {L}} {Select_rules {L}} {Apply_rules {}}] [L_methodes_set_CSS_Meta_IHM]]}
  Generate_LM_setters CSS_Meta_IHM_LM_P [L_methodes_set_CSS_Meta_IHM_LM_LP]

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CSS_Meta_IHM_LM_P [L_methodes_set_CSS_Meta_IHM_LM_LP] {}          {$this(L_actives_PM)}
Methodes_get_LC CSS_Meta_IHM_LM_P [L_methodes_get_CSS_Meta_IHM]       {$this(FC)}
