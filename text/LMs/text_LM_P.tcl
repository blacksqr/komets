#___________________________________________________________________________________________________________________________________________
#___________________________________________ Définition of Logical Model of présentation ___________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit LogicalText Logical_presentation
method LogicalText constructor {name descr args} {
 this inherited $name $descr

# Adding some physical presentations
 this Add_PM_factories [Generate_factories_for_PM_type [list {Text_PM_P_ALX_TXT Ptf_ALX_TXT}     \
                                                             {PhysicalTextTK_horizontal Ptf_TK}  \
															 {Text_PM_P_zone_TK Ptf_TK}          \
                                                             {CometTexte_PM_P_HTML Ptf_HTML}     \
                                                             {CometText_PM_P_BIGre Ptf_BIGre}    \
													         {CometText_PM_P_FLEX Ptf_FLEX}     \
														] $objName]
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC LogicalText $L_methodes_set_Text {}          {$this(L_actives_PM)}
Methodes_get_LC LogicalText $L_methodes_get_Text {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method LogicalText set_PM_active {PM} {
 this inherited $PM
 if {[string equal [this get_LC] {}]} {return}
 $PM set_text [this get_text]
}
