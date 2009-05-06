#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Activator_PM_P_button_FLEX PM_FLEX

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_button_FLEX constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Activator_PM_P_button_FLEX
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Activator_PM_P_button_FLEX $L_methodes_set_Activator {}          {}
Methodes_get_LC Activator_PM_P_button_FLEX $L_methodes_get_Activator {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters Activator_PM_P_button_FLEX [list {activate {{type {}}}}]
  Manage_CallbackList Activator_PM_P_button_FLEX prim_activate begin

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_button_FLEX Trigger_prim_activate {args} {
 #puts "$objName Trigger_prim_activate"
 set cmd ""
 foreach {var val} [this get_Params] {append cmd " " $var " $val"}
 this prim_activate $cmd
}

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_button_FLEX Render {strm_name {dec {}}} {
 upvar $strm_name strm
  
 append strm $dec " function buttonClickHandler_${objName}():void{\n"
 append strm $dec " 	FLEX_to_TCL(\"$objName\", \"Trigger_prim_activate\", \"\"); \n"
 append strm $dec " } \n \n"
 append strm $dec " var $objName:Button = new Button(); \n"
 append strm $dec " $objName.addEventListener(MouseEvent.CLICK,buttonClickHandler_${objName}); \n"
 append strm $dec " ${objName}.label =\"[this get_text]\"; \n"
 append strm $dec " Dyna_context.$objName = $objName; \n"
 #append strm $dec "<mx:Button id=\"$objName\" label=\"[this get_text]\" click=\"buttonClickHandler_${objName}()\"/>\n"

 this set_prim_handle        $objName
 this set_root_for_daughters $objName
 this Render_daughters strm "$dec "
 
 return [this get_prim_handle]
}
