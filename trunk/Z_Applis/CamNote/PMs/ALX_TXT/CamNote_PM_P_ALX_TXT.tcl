#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometCamNote_PM_ALX_TXT PM_U_Container

#___________________________________________________________________________________________________________________________________________
method CometCamNote_PM_ALX_TXT constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CT_CamNote_AUI_basic_CUI_basic_vocal_S207
   this set_nb_max_mothers 1
   set this(connected_to_speaker) 0
   this set_name $name
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometCamNote_PM_ALX_TXT [L_methodes_set_CamNote] {}          {}
Methodes_get_LC CometCamNote_PM_ALX_TXT [L_methodes_get_CamNote] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method CometCamNote_PM_ALX_TXT Branch_to_speaker {} {
 if {$this(connected_to_speaker)} {return 1}
 set spk [[this get_Common_FC] get_speaker]
 if {[string equal $spk {}]} {return 0}
 this set_daughters {}
 this set_L_nested_handle_LM    [[this get_Common_FC] get_speaker]_LM_LP
 this set_L_nested_daughters_LM {}
 [this get_LM] Connect_PM_descendants $objName $this(L_nested_handle_LM)
 set this(connected_to_speaker) 1
 return 1
}

#___________________________________________________________________________________________________________________________________________
method CometCamNote_PM_ALX_TXT Add_mother {m {index -1}} {
 this inherited $m $index
 this Branch_to_speaker
}

#___________________________________________________________________________________________________________________________________________
method CometCamNote_PM_ALX_TXT Analyse {str_name} {
 upvar $str_name  str
 set LC [this get_LC]
 set cmd {(login|pass)}
 set num {\[0-9\]*}
 this set_reg_exp "regexp -nocase \" *(in)? *(${objName}|[this get_name]|[$LC get_name]) *(.*)\$\" \$str reco in obj apres"

 this inherited str
}
