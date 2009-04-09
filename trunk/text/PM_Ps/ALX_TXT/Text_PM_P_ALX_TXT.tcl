#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Text_PM_P_ALX_TXT PM_ALX_TXT

#___________________________________________________________________________________________________________________________________________
method Text_PM_P_ALX_TXT constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id TextDisplay_CUI_label_S207
 this set_name $name
 set class(mark) 0

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Text_PM_P_ALX_TXT $L_methodes_set_Text {} {}
Methodes_get_LC Text_PM_P_ALX_TXT $L_methodes_get_Text {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method Text_PM_P_ALX_TXT Analyse {str_name} {
 upvar $str_name  str
 set LC [this get_LC]
 set cmd {(login|pass)}
 set num {\[0-9\]*}
# set L_d [$LC get_out_daughters]
# set L_choices {}
# foreach e $L_d {append L_choices }
 this set_reg_exp "regexp -nocase \" *(${objName}|[this get_name]|[$LC get_name]) *(.*)\$\" \$str reco obj apres"

 this inherited str
}
