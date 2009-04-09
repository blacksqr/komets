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
Methodes_set_LC Activator_PM_P_button_HTML $L_methodes_set_Activator {$this(FC)} {}
Methodes_get_LC Activator_PM_P_button_HTML $L_methodes_get_Activator {$this(FC)}
Generate_PM_setters Activator_PM_P_button_HTML [list {activate {{type {}}}}]
  Manage_CallbackList Activator_PM_P_button_HTML prim_activate begin

  #___________________________________________________________________________________________________________________________________________
method Activator_PM_P_button_HTML Trigger_prim_activate {} {
 set cmd ""
 foreach {var val} [array get this PARAMS,*] {append cmd " " [string range $var 7 end] " $val"}
 this prim_activate $cmd
}

#___________________________________________________________________________________________________________________________________________
Manage_CallbackList Activator_PM_P_button_HTML Trigger_prim_activate begin

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_button_HTML Add_Params {L_var_val} {
 foreach {var val} $L_var_val {
   set this(PARAMS,$var) $val
  }
}

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_button_HTML Sub_Params {L_var_val} {
 foreach {var val} $L_var_val {
   unset this(PARAMS,$var)
  }
}

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_button_HTML Has_Params {L_var} {
 foreach {var val} [array get this PARAMS,*] {
   set var [string range $var 7 end]
   foreach v $L_var {if {$v == $var} {return 1}}
  }
 return 0
}

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_button_HTML Val_Param {v} {
 return $this(PARAMS,$v)
}

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_button_HTML Render_JS {strm_name mark {dec {}}} {
 upvar $strm_name strm
 if {$mark != [this get_mark]} {
   append strm {function actionBouton(v) } "\{\n"
   append strm {Ajax.stop_sending = true; document.forms["root"].elements["pipo_button"].value = v;} "\n"
   append strm {document.root.submit();} "\n"
   append strm "\}\n"
  }

 this set_mark $mark
 this Render_daughters_JS strm $mark $dec
}

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_button_HTML Render {strm_name {dec {}}} {
 upvar $strm_name strm

 append strm $dec <input [this Style_class] { type="button" value="} [this get_text] {" onclick="javascript:actionBouton( '} ${objName}__XXX__Trigger_prim_activate {' )" />} "\n"
  this Render_daughters strm "$dec  "
}

