#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit SlideRemoteController_PM_P_ALX_TXT PM_ALX_TXT

#___________________________________________________________________________________________________________________________________________
method SlideRemoteController_PM_P_ALX_TXT constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id N_controller_CUI_basic_vocal_S207
   this set_name $name
   set class(mark) 0

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC SlideRemoteController_PM_P_ALX_TXT $L_methodes_set_choicesN {} {}
Methodes_get_LC SlideRemoteController_PM_P_ALX_TXT $L_methodes_get_choicesN {$this(FC)}
Methodes_set_LC SlideRemoteController_PM_P_ALX_TXT [L_methodes_set_SlideRemoteController] {} {}
Methodes_get_LC SlideRemoteController_PM_P_ALX_TXT [L_methodes_get_SlideRemoteController] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters SlideRemoteController_PM_P_ALX_TXT [L_methodes_set_SlideRemoteController]

#___________________________________________________________________________________________________________________________________________
method SlideRemoteController_PM_P_ALX_TXT Analyse {str_name} {
 upvar $str_name  str
 set LC [this get_LC]
 set cmd {(next|previous|first|last|current)}
 set num {\[0-9\]*}
 this set_reg_exp "regexp -nocase \" *(in)? *(${objName}|[this get_name]|[$LC get_name])? *(set|get|what is|go|goto|go to)? *${cmd}? *(slide) *(is|to|num|number)? *($num)? *(.*)\$\" \$str reco in obj goto cmd slide nb num apres"
 puts "coucou : \"$str\""
 this inherited str
}

#___________________________________________________________________________________________________________________________________________
method SlideRemoteController_PM_P_ALX_TXT Process_TXT {e} {
 set str   [lindex $e 1]
 set telec [this get_LC]

 eval [this get_reg_exp]

 if {[string equal $goto get] || [string equal $goto {what is}]} {return "Current slide is slide number [$telec get_val]"}
 if {[string equal $num {}]} {
   switch $cmd {
     next     {this prim_go_to_nxt}
     previous {this prim_go_to_prv}
     first    {this prim_go_to_bgn}
     last     {this prim_go_to_end}
    }
  } else {this prim_set_current $num
         }
 return {}
}
