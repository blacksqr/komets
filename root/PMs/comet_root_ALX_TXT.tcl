inherit root_PM_P_ALX_TXT PM_ALX_TXT

#___________________________________________________________________________________________________________________________________________
method root_PM_P_ALX_TXT constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CT_Comet_Root_FUI_S207
   set class(mark) 0

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC root_PM_P_ALX_TXT [L_methodes_set_CometRoot] {} {}

#___________________________________________________________________________________________________________________________________________
method root_PM_P_ALX_TXT get_depth {e} {
 set rep 1
   set nb_max 0
   set chemins {}
   foreach d [lindex $e 3] {
     set rep_tmp [this get_depth $d]
     set nb      [lindex $rep_tmp 0]
     if {$nb >  $nb_max} {set nb_max $nb; set chemins {}}
     if {$nb == $nb_max} {lappend chemins $d}
    }
 incr rep $nb_max
 return [list $rep [list [lindex $e 0] [lindex $e 1] [lindex $e 2] $chemins]]
}

#___________________________________________________________________________________________________________________________________________
method root_PM_P_ALX_TXT Evaluate {e} {
 puts "    [lindex $e 0] Process_TXT $e"
   set res [[lindex $e 0] Process_TXT $e]
   if {[string equal $res {}]} {
     #set res [lindex $e 1]
     set deb [string first [lindex $e 2] [lindex $e 1]]
     if {$deb != -1} {
       set res [string range [lindex $e 1] 0 [expr $deb-1]]
      } else {set res [lindex $e 1]}
    }  
 foreach d [lindex $e 3] {
   #while {[llength $d] == 1} {set d [lindex $d 0]}
   append res [this Evaluate $d]
  }
 return $res
}

#___________________________________________________________________________________________________________________________________________
method root_PM_P_ALX_TXT Analyse {str_name} {
 upvar $str_name str

 puts "$objName Analyse \"$str\""
 set L [this inherited str]
 set nb_max 0
 puts "Analyser found following possibilities :"
 set L_chemins {}
 foreach e $L {
   puts "  * [lindex $e 1] : $e"
   set rep [this get_depth $e]
   set nb [lindex $rep 0]
   if {$nb >  $nb_max} {set nb_max $nb; set L_chemins {}}
   if {$nb == $nb_max} {set nb_max $nb; lappend L_chemins [lindex $rep 1]}
  }

 puts "\nAnalyser evaluate the most probable wich are :"
 set L_chemins [list [lindex $L_chemins 0]]
 foreach e $L_chemins {
   if {[string equal $e ""]} {continue}
   puts "EVAL \{$e\}"
   set rep [this Evaluate $e]
   if {[string equal $rep {}]} {
     catch "Say \{[lindex $e 1]\}" res
    } else {puts "______________________\n$rep\n______________________"
            catch {Say $rep} res
           }
  }

 return $L
}

