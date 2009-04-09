#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Marker_PM_P_ALX_TXT PM_ALX_TXT

#___________________________________________________________________________________________________________________________________________
method Marker_PM_P_ALX_TXT constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Marker_simple_CUI_vocal_S207
 this set_name $name
 set class(mark) 0

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Marker_PM_P_ALX_TXT [L_methodes_set_Marker] {$this(FC)} {}
Methodes_get_LC Marker_PM_P_ALX_TXT [L_methodes_get_Marker] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method Marker_PM_P_ALX_TXT Analyse {str_name} {
 upvar $str_name  str
 set LC [this get_LC]
 set cmd {(login|pass)}
 set num {\[0-9\]*}
 this set_reg_exp "regexp -nocase \" *(set|unmark|mark|get)? *(${objName}|[this get_name]|[$LC get_name]) *(true|false)? *(.*)\$\" \$str reco cmd obj val apres"

 this inherited str
}

#___________________________________________________________________________________________________________________________________________
method Marker_PM_P_ALX_TXT Process_TXT {e} {
 set str [lindex $e 0]
 set LC [this get_LC]

 eval [this get_reg_exp]
 switch -nocase {$cmd} {
   get    {if {[this get_mark]} {set rep true} else {set rep false}; $return "[$LC get_name] is valued $rep"}
   set    {if {[string equal $val {}   ]} {set val 1}
           if {[string equal $val true ]} {set val 1}
           if {[string equal $val false]} {set val 0}
           $LC set_mark $val
          }
   mark   {if {[string equal $val {}   ]} {set val 1}
           if {[string equal $val true ]} {set val 1}
           if {[string equal $val false]} {set val 0}
           $LC set_mark $val
          }
   unmark {if {[string equal $val {}   ]} {set val 0}
           if {[string equal $val true ]} {set val 0}
           if {[string equal $val false]} {set val 1}
           $LC set_mark $val
          }
   default {if {[string equal $val {}   ]} {if {[this get_mark]} {set rep true} else {set rep false}; $return "[$LC get_name] is valued $rep"}
            if {[string equal $val true ]} {set val 1}
            if {[string equal $val false]} {set val 0}
            $LC set_mark $val
           }
  }
}
