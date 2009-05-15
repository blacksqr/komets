inherit DChoiceN_PM_P_Menu_FLEX PM_FLEX
#___________________________________________________________________________________________________________________________________________

#___________________________________________________________________________________________________________________________________________
method DChoiceN_PM_P_Menu_FLEX constructor {name descr args} {
 this inherited $name $descr
   this set_nb_max_daughters 0
 eval "$objName configure $args"
 set this(old_value) 0
 return $objName
}

#____________________________________________________________________________________________________________________________
Methodes_set_LC DChoiceN_PM_P_Menu_FLEX $L_methodes_set_choicesN {} 		    {}
Methodes_get_LC DChoiceN_PM_P_Menu_FLEX $L_methodes_get_choicesN {$this(FC)}

#____________________________________________________________________________________________________________________________
Generate_PM_setters DChoiceN_PM_P_Menu_FLEX [P_L_methodes_PM_set_ChoiceN_COMET_RE]

#___________________________________________________________________________________________________________________________________________
method DChoiceN_PM_P_Menu_FLEX maj_choices {} {}

#___________________________________________________________________________________________________________________________________________
method DChoiceN_PM_P_Menu_FLEX set_val {e} {
 if {$this(old_value) != $e} {
     set this(old_value) $e
	 puts "value = $e"
	 set cmd "${objName}.value=$e;"
	 puts "  cmd = $cmd"
	 set root [this get_L_roots] 
	 if {[lsearch [gmlObject info classes $root] Comet_root_PM_P_FLEX] != -1} {
		 puts "passé par ici"
		$root send_to_FLEX $cmd
	 }
 }
}

#___________________________________________________________________________________________________________________________________________
method DChoiceN_PM_P_Menu_FLEX Render {strm_name {dec {}}} {
 upvar $strm_name strm
 
 append strm $dec " var $objName:NumericStepper = new NumericStepper(); \n"
 append strm $dec " $objName.maximum=100; \n"
 append strm $dec " ${objName}.addEventListener(NumericStepperEvent.CHANGE,ValueChanged_${objName}); \n"
 append strm $dec " function ValueChanged_${objName}(${objName}_event:NumericStepperEvent):void{ \n"
 append strm $dec " 	var ${objName}_value:int = ${objName}.value; \n"
 append strm $dec "		FLEX_to_TCL(\"$objName\", \"prim_set_val\", String(${objName}_value)) } \n"
 append strm $dec " Dyna_context.$objName = $objName; \n"
 
 this set_prim_handle        $objName
 this set_root_for_daughters $objName
}

