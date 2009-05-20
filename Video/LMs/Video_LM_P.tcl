#___________________________________________ Définition of Logical Model of présentation ___________________________________________________
inherit LogicalVideo Logical_presentation

method LogicalVideo constructor {name descr args} {
 this inherited $name $descr

 this Add_PM_factories [Generate_factories_for_PM_type [list {Video_PM_P_BIGre Ptf_BIGre}  \
															 {Video_PM_P_HTML  Ptf_HTML}  \
                                                       ] $objName]

 eval "$objName configure $args"
 return $objName
}


#___________________________________________________________________________________________________________________________________________
Methodes_set_LC LogicalVideo [P_L_methodes_set_Video] {} {$this(L_actives_PM)}
Methodes_get_LC LogicalVideo [P_L_methodes_get_Video] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method LogicalVideo set_PM_active {PM} {
 this inherited $PM
 if {[string equal [this get_LC] {}]} {return}
 set s [this get_video_source]
 if {![string equal $s {}]} {$PM set_video_source $s [this get_audio_canal]}
}
