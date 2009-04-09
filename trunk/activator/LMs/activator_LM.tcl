

#___________________________________________ Définition of Logical Model of présentation ___________________________________________________
inherit LogicalActivator Logical_presentation

method LogicalActivator constructor {name descr args} {
 this inherited $name $descr
 
 set this(init_ok) 0
  
# Adding some physical presentations
 #if {[regexp "^(.*)_LM_LP" $objName rep comet_name]} {} else {set comet_name $objName}
 #set TK_button "${comet_name}_PM_P_TK_button"
 #  Activator_PM_P_button_TK $TK_button $TK_button "A TK presentation of $name" 
 #  this Add_PM $TK_button

 this Add_PM_factories [Generate_factories_for_PM_type [list {Activator_PM_P_button_TK Ptf_TK}         \
                                                             {Activator_PM_P_ALX_TXT Ptf_ALX_TXT}      \
                                                             {Activator_PM_P_button_HTML Ptf_HTML}     \
                                                             {Activator_PM_P_BIGre_button Ptf_BIGre}   \
															 {Activator_PM_P_button_FLEX Ptf_FLEX}     \
                                                       ] $objName]

 set this(init_ok) 1
 #this set_PM_active $TK_button
 
 eval "$objName configure $args"
 return $objName
}


#___________________________________________________________________________________________________________________________________________
Methodes_set_LC LogicalActivator $L_methodes_set_Activator {} {$this(L_actives_PM)}
Methodes_get_LC LogicalActivator $L_methodes_get_Activator {$this(FC)}

Generate_LM_setters LogicalActivator [list {activate {{type {}}}}]

#___________________________________________________________________________________________________________________________________________
method LogicalActivator set_PM_active {PM} {
 this inherited $PM
 if {[string equal [this get_LC] {}]} {return}
 $PM set_text [this get_text]
}
