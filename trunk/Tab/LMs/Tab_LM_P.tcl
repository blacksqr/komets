#___________________________________________ Définition of Logical Model of présentation ___________________________________________________
inherit Tab_LM_P Logical_presentation

method Tab_LM_P constructor {name descr args} {
 this inherited $name $descr

 set this(init_ok) 0

# Adding some physical presentations
 this Add_PM_factories [Generate_factories_for_PM_type [list {Tab_PM_P_TK_basic Ptf_TK} \
															 {Tab_PM_P_B207_basic Ptf_BIGre}  \
                                                       ] $objName]

 eval "$objName configure $args"
 return $objName
}


#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Tab_LM_P [P_L_methodes_set_Tab] {} {$this(L_actives_PM)}
Methodes_get_LC Tab_LM_P [P_L_methodes_get_Tab] {$this(FC)}
proc P_L_methodes_set_Tab_CARE {} {return [list {set_case {i j v}} {Insert_col {pos}} {Delete_col {pos}} {Insert_line {pos}} {Delete_line {pos}}]}
Generate_LM_setters Tab_LM_P [P_L_methodes_set_Tab_CARE]


#___________________________________________________________________________________________________________________________________________
method Tab_LM_P set_PM_active {PM} {
 this inherited $PM
 if {[catch "$PM Maj_tab" err]} {puts "Errot in $objName set_PM_active $PM, while doing $PM Maj_tab"}
}
