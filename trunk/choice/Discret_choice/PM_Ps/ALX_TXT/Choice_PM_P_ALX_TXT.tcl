#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Choice_PM_P_ALX_TXT PM_ALX_TXT

#___________________________________________________________________________________________________________________________________________
method Choice_PM_P_ALX_TXT constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id ChoiceInterleavingMarkers_S207
 this set_name $name
 set class(mark) 0

 eval "$objName configure $args"
 return $objName
}

#______________________________________________________ Adding the choices functions _______________________________________________________
Methodes_set_LC Choice_PM_P_ALX_TXT $L_methodes_set_choices {$this(FC)} {}
Methodes_get_LC Choice_PM_P_ALX_TXT $L_methodes_get_choices {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method Choice_PM_P_ALX_TXT maj_choices {} {}

#___________________________________________________________________________________________________________________________________________
method Choice_PM_P_ALX_TXT Analyse {str_name} {
 upvar $str_name  str
 set LC [this get_LC]
 set cmd {(login|pass)}
 set num {\[0-9\]*}
# set L_d [$LC get_out_daughters]
# set L_choices {}
# foreach e $L_d {append L_choices }
 this set_reg_exp "regexp -nocase \" *(what is|what is the|in|set|put|get)? *(current|possible)? *(${objName}|[this get_name]|[$LC get_name]) *(unchoose|choose|select|unselect|to|at)? *(.*)\$\" \$str reco in current obj cmd apres"

 this inherited str
}

#___________________________________________________________________________________________________________________________________________
method Choice_PM_P_ALX_TXT Process_TXT {e} {
 # Look at daughters in e, and comlpare to out daughters of the LC
 set LC     [this get_LC]
 set L_d_LC [$LC get_out_daughters]
 set L_new_select {}

   set str [lindex $e 1]
   eval [this get_reg_exp]

 if {[string equal $in get]} {
   if {[string equal $current possible]} {
     set rep "Possibles choices for $obj are : "
     set L {}
     foreach e [$LC get_daughters] {lappend L [$e get_name]}
     append rep [join $L {, }]
     return $rep
    }
   set L    [$LC get_currents]
   set verb is
   if {[llength $L] == 0} {return "There are no element selected in [$LC get_name]"}
   if {[llength $L] >  1} {set verb are}

   set names {}
   foreach e $L {append names " [$e get_name]"}
   return "[$LC get_name] $verb $names"
  }
 foreach d [lindex $e 3] {
   while {[llength $d] == 1} {set d [lindex $d 0]}
   set d_PM [lindex $d 0]
   set d_LC [$d_PM get_LC]
   if {[lsearch $L_d_LC $d_LC] != -1} {lappend L_new_select $d_LC}
  }
 $LC set_currents $L_new_select
 return {}
}
