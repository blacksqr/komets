

#___________________________________________ Définition of Logical Model of présentation ___________________________________________________
inherit LogicalSpecifyer Logical_presentation

method LogicalSpecifyer constructor {name descr args} {
 this inherited $name $descr

 set this(init_ok) 0

# Adding some physical presentations
 #if {[regexp "^(.*)_LM_LP" $objName rep comet_name]} {} else {set comet_name $objName}

 set this(init_ok) 1

# Factories
 this Add_PM_factories [Generate_factories_for_PM_type [list {Specifyer_PM_P_entry_TK Ptf_TK}         \
                                                             {Specifyer_PM_P_text_TK Ptf_TK}          \
                                                             {Specifyer_PM_P_Entry_HTML Ptf_HTML}     \
                                                             {Specifyer_PM_P_ZoneEntry_HTML Ptf_HTML} \
                                                             {Specifyer_PM_P_BIGre_text Ptf_BIGre}    \
                                                             {TextArea_PM_P_ALX_TXT Ptf_ALX_TXT}      \
															 {Specifyer_PM_P_textarea_FLEX Ptf_FLEX}  \
                                                       ] $objName]

 eval "$objName configure $args"
 return $objName
}


#___________________________________________________________________________________________________________________________________________
Methodes_set_LC LogicalSpecifyer $L_methodes_set_Specifyer {}         {$this(L_actives_PM)}
Methodes_get_LC LogicalSpecifyer $L_methodes_get_Specifyer {$this(FC)}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_set_specifyer_COMET_RE {} {return [list {set_text {{v ""}}}]}
Generate_LM_setters LogicalSpecifyer [P_L_methodes_set_specifyer_COMET_RE]

#___________________________________________________________________________________________________________________________________________
method LogicalSpecifyer set_PM_active {PM} {
 this inherited $PM
 if {[string equal [this get_LC] {}]} {return}
 $PM set_text [this get_text]
}
