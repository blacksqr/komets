#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Clock_PM_P_ALX_TXT PM_ALX_TXT

#___________________________________________________________________________________________________________________________________________
method Clock_PM_P_ALX_TXT constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Clock_CUI_standard_vocal_S207
 this set_name $name
 set class(mark) 0

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Clock_PM_P_ALX_TXT [L_methodes_set_Clock] {$this(FC)} {}
Methodes_get_LC Clock_PM_P_ALX_TXT [L_methodes_get_Clock] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method Clock_PM_P_ALX_TXT Analyse {str_name} {
 upvar $str_name  str

 this set_reg_exp "regexp -nocase \" *what *time *is *it *(.*)\$\" \$str reco apres"

 this inherited str
}

#___________________________________________________________________________________________________________________________________________
method Clock_PM_P_ALX_TXT Process_TXT {e} {
 set t [this get_time]
   set mins   [expr ($t % 3600)/60]
   set heures [clock format $t -format %k]
   set txt [clock format $t -format %p]
   if {[string equal $txt AM]} {set txt "A, M"} else {set txt "P, M"}
 return "It is, $heures , past $mins, $txt"
}