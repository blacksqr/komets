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
puts $v
 set root [this get_L_roots] 

 set cmd "${objName}.selectedLabel=$v;"
 puts "$cmd \n"
 if {[lsearch [gmlObject info classes $root] Comet_root_PM_P_FLEX] != -1} {
    $root send_to_FLEX $cmd
	puts "message envoyé ! \n"
 }
}
#___________________________________________________________________________________________________________________________________________
method DChoice_PM_P_Menu_FLEX Render {strm_name {dec {}}} {
 upvar $strm_name strm
 
 append strm $dec " var $objName:ComboBox = new ComboBox(); \n"
 append strm $dec " var ${objName}_array:Array = new Array(); \n"
	set i 0;
	foreach elem [[this get_real_LC] get_out_daughters] {
		set name [string map [list "\"" {\"} "\n" {\n}] [$elem get_name]]
		append strm $dec "  ${objName}_array\[$i\] = \"$name\";\n"
		incr i;
	}
 append strm $dec " $objName.dataProvider=${objName}_array; \n"
 append strm $dec " $objName.addEventListener(ListEvent.CHANGE,listValueChanged_${objName}); \n"
 append strm $dec " function listValueChanged_${objName}(${objName}_event:ListEvent):void{ \n"
 append strm $dec "			FLEX_to_TCL(\"$objName\", \"prim_set_currents\", \"$objName.selectedLabel\") } \n"
 append strm $dec " Dyna_context.$objName = $objName; \n"
 
 this set_prim_handle        $objName
 this set_root_for_daughters $objName
}


