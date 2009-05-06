inherit DChoice_PM_P_Menu_FLEX PM_FLEX
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method DChoice_PM_P_Menu_FLEX constructor {name descr args} {
 this inherited $name $descr
   this set_nb_max_daughters 0
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method DChoice_PM_P_Menu_FLEX maj_choices {} {}

#____________________________________________________________________________________________________________________________
Methodes_set_LC DChoice_PM_P_Menu_FLEX $L_methodes_set_choices {} 		    {$this(L_LM)}
Methodes_get_LC DChoice_PM_P_Menu_FLEX $L_methodes_get_choices {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters DChoice_PM_P_Menu_FLEX [P_L_methodes_set_choice_N_COMET_RE]

#___________________________________________________________________________________________________________________________________________
method DChoice_PM_P_Menu_FLEX set_currents {v} {
 set root [this get_L_roots] 

 if {![info exists this(old_currents)]} {set this(old_currents) [this get_currents]}
 
 if {$v != $this(old_currents)} {
   if {$v} {
     set cmd "${objName}.selected=true;"
    } else {set cmd "${objName}.selected=false;"}

    if {[lsearch [gmlObject info classes $root] Comet_root_PM_P_FLEX] != -1} {
     $root send_to_FLEX $cmd
    }
   set this(old_currents) $v
  }
}
#___________________________________________________________________________________________________________________________________________
method DChoice_PM_P_Menu_FLEX Render {strm_name {dec {}}} {
 upvar $strm_name strm
 
 append strm $dec " var $objName:ComboBox = new ComboBox(); \n"
 append strm $dec " var $objName_array:Array = new Array(\"lundi\",\"mardi\",\"mercredi\",\"jeudi\",\"vendredi\",\"samedi\",\"dimanche\",\"une image\"); \n"
 append strm $dec " $objName.dataProvider=$objName_array; \n"
 append strm $dec " Dyna_context.$objName = $objName; \n"
 
 this set_prim_handle        $objName
 this set_root_for_daughters $objName
}


