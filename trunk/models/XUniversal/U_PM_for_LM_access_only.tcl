inherit U_PM_for_LM_only PM_Universal

#___________________________________________________________________________________________________________________________________________
method U_PM_for_LM_only constructor {name descr args} {
 this inherited $name $descr
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method U_PM_for_LM_only Add_daughter {m {index -1}} {
 set LM_m [$m get_LM]
 set LM   [this get_LM]
 if {[lsearch [$LM get_handle_composing_comet] $LM_m] != 1} {this inherited $m $index}
}
