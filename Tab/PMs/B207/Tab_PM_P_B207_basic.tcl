inherit Tab_PM_P_B207_basic PM_BIGre

#___________________________________________________________________________________________________________________________________________
method Tab_PM_P_B207_basic constructor {name descr args} {
 this inherited $name $descr
  #XXX this set_GDD_id N_controller_CUI_basic_gfx_luna_B207
 if {[string length [info proc B_noeud]] > 0} {} else {return $objName}
 set this(root) [B_noeud] 

 this set_prim_handle [list $this(root)]
# Call of the extra constructor parameters
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Tab_PM_P_B207_basic [P_L_methodes_set_Tab] {} {}
Methodes_get_LC Tab_PM_P_B207_basic [P_L_methodes_get_Tab] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method Tab_PM_P_B207_basic Maj_tab {} {
}