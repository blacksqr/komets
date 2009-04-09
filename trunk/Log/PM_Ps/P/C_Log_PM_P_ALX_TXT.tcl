inherit CometLog_PM_P_ALX_TXT PM_ALX_TXT

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometLog_PM_P_ALX_TXT constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CT_Log_AUI_basic_CUI_vocal_S207
   set this(Log_root) {}
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometLog_PM_P_ALX_TXT dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometLog_PM_P_ALX_TXT [L_methodes_set_Log] {$this(FC)} {}
Methodes_get_LC CometLog_PM_P_ALX_TXT [L_methodes_get_Log] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method CometLog_PM_P_ALX_TXT Process_TXT {str} {
 set speaker [this     get_speaker]
 set telec   [$speaker get_telec]

 eval [this get_reg_exp]
 switch -regexp $cmd {
   login  {[this get_LC] set_id   $val}
   pass   {[this get_LC] set_pass $val}
  }
}

#___________________________________________________________________________________________________________________________________________
method CometLog_PM_P_ALX_TXT Analyse {str_name} {
 upvar $str_name  str
 set LC [this get_LC]
 set cmd {(login|pass)}
 set num {\[0-9\]*}
 this set_reg_exp "regexp \" *(in )? *($objName|[this get_name]|[$LC get_name])? *$cmd *\\\(.*)"\\\" *(.*)\$\" \$str reco in obj cmd val apres"

 this inherited str
}

