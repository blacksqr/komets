#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Marker_PM_P_RadioBouton_FLEX PM_FLEX

#___________________________________________________________________________________________________________________________________________
method Marker_PM_P_RadioBouton_FLEX constructor {name descr args} {
 this inherited $name $descr
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method Marker_PM_P_RadioBouton_FLEX dispose {} {
 this inherited
}
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Marker_PM_P_RadioBouton_FLEX [L_methodes_set_Marker] {}          {$this(L_actives_PM)}
Methodes_get_LC Marker_PM_P_RadioBouton_FLEX [L_methodes_get_Marker] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters Marker_PM_P_RadioBouton_FLEX [L_methodes_CometRE_Marker]

#___________________________________________________________________________________________________________________________________________
method Marker_PM_P_RadioBouton_FLEX maj_choices {} {}

#___________________________________________________________________________________________________________________________________________
method Marker_PM_P_RadioBouton_FLEX set_mark {v} {
  set root [this get_L_roots] 

 if {![info exists this(old_mark)]} {set this(old_mark) [this get_mark]}
 
 if {$v != $this(old_mark)} {
   if {$v} {
     set cmd "${objName}.selected=true;"
    } else {set cmd "${objName}.selected=false;"}
  foreach r $root {
	puts "$r \t"
  }
    if {[lsearch [gmlObject info classes $root] Comet_root_PM_P_FLEX] != -1} {
     $root send_to_FLEX $cmd
    }
   set this(old_mark) $v
  }
}
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method Marker_PM_P_RadioBouton_FLEX Render {strm_name {dec {}}} {
 upvar $strm_name rep
 
  set this(checkBox_mark) [this get_mark]

 append rep $dec " function RadioButtonMark_${objName}(${objName}_selec:MouseEvent):void{ \n"
 append rep $dec " 		if($objName.selected) { \n"
 append rep $dec "			FLEX_to_TCL(\"$objName\", \"prim_set_mark\", \"1\") } \n"
 append rep $dec " 		else {  \n"
 append rep $dec "			FLEX_to_TCL(\"$objName\", \"prim_set_mark\", \"0\") } \n"
 append rep $dec " } \n"
 append rep $dec " function doubleClic_${objName}(${objName}_doubleClic:MouseEvent):void{ \n"
 append rep $dec " 		$objName.selected=false;\n"
 append rep $dec "		FLEX_to_TCL(\"$objName\", \"prim_set_mark\", \"0\") \n"
 append rep $dec " 	}\n"
 append rep $dec " var $objName:RadioButton = new RadioButton(); \n"
 append rep $dec " $objName.doubleClickEnabled=true; \n"
 append rep $dec " $objName.addEventListener(MouseEvent.DOUBLE_CLICK,doubleClic_${objName}); \n"
 append rep $dec " $objName.addEventListener(MouseEvent.CLICK,RadioButtonMark_${objName}); \n"
 append rep $dec " Dyna_context.$objName = $objName; \n"
  
 this set_prim_handle        $objName
 this set_root_for_daughters $objName
 this Render_daughters strm "$dec "

 return [this get_prim_handle]
}

