#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Activator_PM_P_button_HTML PM_HTML

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_button_HTML constructor {name descr args} {
 this inherited $name $descr
   set class(mark) 0
   this set_GDD_id CT_Activator_AUI_basic_CUI_button_HTML
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML get_mark {}  {return $class(mark)}
method PM_HTML set_mark {m} {set class(mark) $m}

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_button_HTML dispose {} {
 this inherited
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Activator_PM_P_button_HTML $L_methodes_set_Activator {}          {}
Methodes_get_LC Activator_PM_P_button_HTML $L_methodes_get_Activator {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters Activator_PM_P_button_HTML [list {activate {{type {}}}}]
  Manage_CallbackList Activator_PM_P_button_HTML prim_activate begin

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_button_HTML Trigger_prim_activate {args} {
 set cmd ""
 foreach {var val} [this get_Params] {append cmd " " $var " $val"}
 this prim_activate $cmd
}

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_button_HTML activate {args} {
 set root    [this get_L_roots] 
 set methode "val"
 set cmd   "\$('#$objName').val('OK');"

 if {[lsearch [gmlObject info classes $root] PhysicalHTML_root] != -1} {
	$root Concat_update $objName $methode $cmd
 }
}

#___________________________________________________________________________________________________________________________________________
Manage_CallbackList Activator_PM_P_button_HTML Trigger_prim_activate begin

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_button_HTML Render {strm_name {dec {}}} {
 upvar $strm_name strm

 append strm $dec <input [this Style_class] { type="button" value="} [this get_text] {" name="} ${objName}__XXX__Trigger_prim_activate {" onclick="javascript:addOutput(this,true)" />} "\n"
  this Render_daughters strm "$dec  "
}

