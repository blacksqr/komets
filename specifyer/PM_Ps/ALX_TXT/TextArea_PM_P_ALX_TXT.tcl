inherit TextArea_PM_P_ALX_TXT PM_ALX_TXT

#___________________________________________________________________________________________________________________________________________
method TextArea_PM_P_ALX_TXT constructor {name descr args} {
 this inherited $name $descr

 this set_name $name
 set class(mark) 0

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC TextArea_PM_P_ALX_TXT $L_methodes_set_Specifyer {$this(FC)} {}
Methodes_get_LC TextArea_PM_P_ALX_TXT $L_methodes_get_Specifyer {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method TextArea_PM_P_ALX_TXT set_text {{t {}}} {}
method TextArea_PM_P_ALX_TXT get_text {} {}

#___________________________________________________________________________________________________________________________________________
method TextArea_PM_P_ALX_TXT Process_TXT {e} {
 set str [lindex $e 1]
 eval [this get_reg_exp]
 [this get_LC] set_text $val
}

#___________________________________________________________________________________________________________________________________________
method TextArea_PM_P_ALX_TXT Analyse {str_name} {
 upvar $str_name  str
 set LC [this get_LC]
 this set_reg_exp "regexp \" *(set)? (${objName}|[$LC get_name]|[this get_name]) *(is|take value|to) *\\\"(.*)\\\"(.*)\\\$\" \$str reco set obj to val apres"
 
 this inherited str
}

