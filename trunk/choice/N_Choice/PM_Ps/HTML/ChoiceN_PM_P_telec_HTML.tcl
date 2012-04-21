#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________

inherit ChoiceN_PM_P_Telec_HTML PM_P_ChoiceN_HTML

#___________________________________________________________________________________________________________________________________________
method ChoiceN_PM_P_Telec_HTML constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id N_Choice_AUI_basic_CUI_telec_HTML
   set this(prim_text) ""
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
#______________________________________________________ Adding the choices functions _______________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC ChoiceN_PM_P_Telec_HTML $L_methodes_set_choicesN {}         {}
Methodes_get_LC ChoiceN_PM_P_Telec_HTML $L_methodes_get_choicesN {$this(FC)}


#___________________________________________________________________________________________________________________________________________
method ChoiceN_PM_P_Telec_HTML set_val {v} {
 if {$this(prim_text) != $v} { 
	 set root    [this get_L_roots] 
	 set methode "val"

	 set param [this Encode_param_for_JS $v]
	 set cmd   "\$('#text_for_$objName').val($param);"

	 if {[lsearch [gmlObject info classes $root] PhysicalHTML_root] != -1} {
		$root Concat_update $objName $methode $cmd
	 }
	 
	 set this(prim_text) $v
  }
}

#___________________________________________________________________________________________________________________________________________
method ChoiceN_PM_P_Telec_HTML Render {strm_name {dec {}}} {
 upvar $strm_name rep
 set CFC [this get_Common_FC]
	append rep $dec {<div } [this Style_class] ">\n"
	append rep $dec "  <button type=\"button\" name=\"${objName}__XXX__prim_Prev\" onclick=\"javascript:addOutput(this,true)\" >Prev</button>\n"
	append rep $dec "  <input id=\"text_for_$objName\"" { type="text" name="} ${objName}__XXX__prim_set_val {" value="} [this get_val] {" onkeyup="javascript:addOutput(this)" /> } "\n"
	append rep $dec "  <button type=\"button\" name=\"${objName}__XXX__prim_Next\" onclick=\"javascript:addOutput(this,true)\" >Next</button>\n"
	append rep $dec "</div>\n"
}

#___________________________________________________________________________________________________________________________________________
method ChoiceN_PM_P_Telec_HTML prim_Prev {args} {
	this prim_set_val [expr $this(prim_text) - [this get_step]]
}

#___________________________________________________________________________________________________________________________________________
method ChoiceN_PM_P_Telec_HTML prim_Next {args} {
	this prim_set_val [expr $this(prim_text) + [this get_step]]
}

