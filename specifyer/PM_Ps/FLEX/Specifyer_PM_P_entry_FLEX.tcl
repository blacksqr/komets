#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Specifyer_PM_P_textarea_FLEX PM_FLEX

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_textarea_FLEX constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Specifyer_PM_P_textarea_FLEX
   set this(flex_text) ""
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Specifyer_PM_P_textarea_FLEX $L_methodes_set_Specifyer {}          {}
Methodes_get_LC Specifyer_PM_P_textarea_FLEX $L_methodes_get_Specifyer {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters Specifyer_PM_P_textarea_FLEX [P_L_methodes_set_specifyer_COMET_RE]

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_textarea_FLEX Render {strm_name {dec {}}} {
 upvar $strm_name strm

 set this(flex_text) [this get_text]
 
 append strm $dec "<mx:Script>\n"
 append strm $dec "  <!\[CDATA\[\n"
 append strm $dec "  private function Text_entered_${objName}():void{ \n"
 append strm $dec "  	FLEX_to_TCL(\"$objName\", \"prim_set_text\", ${objName}.text); \n"
 append strm $dec "  } \n"
 append strm $dec "  ]]> \n"
 append strm $dec "</mx:Script> \n"
 
 append strm $dec "<mx:TextArea id=\"$objName\" keyUp=\"Text_entered_${objName}()\" text=\"[this get_text]\"/>\n"
  this Render_daughters strm "$dec  "
}
#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_textarea_FLEX set_text {t} {
 if {$t != $this(flex_text)} {
    set this(flex_text) $t
    #envoi un message au serveur FLEX
    set root [this get_L_roots]
    if {[lsearch [gmlObject info classes $root] Comet_root_PM_P_FLEX] != -1} {
	   $root send_to_FLEX "${objName}.text=\"$t\""
    }
 #celui-ci transmet le message au client SWF
 }
}







