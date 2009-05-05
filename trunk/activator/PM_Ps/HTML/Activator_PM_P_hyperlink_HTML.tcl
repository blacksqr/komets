#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Activator_PM_P_hyperlink_HTML PM_HTML

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_hyperlink_HTML constructor {name descr args} {
 this inherited $name $descr
   set class(mark) 0
   this set_GDD_id CT_Activator_AUI_basic_CUI_hyperlink_HTML
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML get_mark {}  {return $class(mark)}
method PM_HTML set_mark {m} {set class(mark) $m}

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_hyperlink_HTML dispose {} {
 this inherited
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Activator_PM_P_hyperlink_HTML $L_methodes_set_Activator {}          {}
Methodes_get_LC Activator_PM_P_hyperlink_HTML $L_methodes_get_Activator {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters Activator_PM_P_hyperlink_HTML [list {activate {{type {}}}}]
  Manage_CallbackList Activator_PM_P_hyperlink_HTML prim_activate begin

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_hyperlink_HTML Trigger_prim_activate {args} {
 set cmd ""
 foreach {var val} [this get_Params] {append cmd " " $var " $val"}
 this prim_activate $cmd
}

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_hyperlink_HTML activate {args} {
 set root    [this get_L_roots] 
 set methode "val"
 set cmd    "\$('#${objName}_hyperlink').removeAttr('disabled');\n"
 append cmd "\$('#${objName}_hyperlink_img').attr('style','position:absolute; visibility:hidden;');"

 if {[lsearch [gmlObject info classes $root] PhysicalHTML_root] != -1} {
	$root Concat_update $objName $methode $cmd
 }
}

#___________________________________________________________________________________________________________________________________________
Manage_CallbackList Activator_PM_P_hyperlink_HTML Trigger_prim_activate begin

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_hyperlink_HTML Render {strm_name {dec {}}} {
 upvar $strm_name strm

 append strm $dec <span [this Style_class]> "\n"
	append strm $dec <img { src="src_img/load.gif" id="} ${objName}_hyperlink_img {" style="position:absolute; visibility:hidden;" />} "\n"
	append strm $dec <a { href="#} ${objName}_hyperlink {" id="} ${objName}_hyperlink {"  name="} ${objName}__XXX__Trigger_prim_activate {" onclick="javascript:$('#} $objName {_button').attr('disabled','disabled');$('#} $objName {_button_img').attr('style','position:absolute; visibility:visible;');addOutput(this,true)">} [this get_text] {</a>} "\n"
	this Render_daughters strm "$dec  "
 append strm $dec </span> "\n"
}

