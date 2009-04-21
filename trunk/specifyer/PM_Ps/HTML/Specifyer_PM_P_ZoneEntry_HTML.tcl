#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Specifyer_PM_P_ZoneEntry_HTML PM_HTML

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_ZoneEntry_HTML constructor {name descr args} {
 this inherited $name $descr
   set this(prim_text) ""
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_ZoneEntry_HTML dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_ZoneEntry_HTML maj_choices {} {}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Specifyer_PM_P_ZoneEntry_HTML $L_methodes_set_Specifyer {$this(FC)} {}
Methodes_get_LC Specifyer_PM_P_ZoneEntry_HTML $L_methodes_get_Specifyer {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters Specifyer_PM_P_ZoneEntry_HTML [P_L_methodes_set_specifyer_COMET_RE]

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_ZoneEntry_HTML set_text {v} {
 if {$this(prim_text) != $v} {
   #puts "$objName set_text $v"
 
   set root [this get_L_roots] 

   set param [this Encode_param_for_JS $v]
   set cmd "\$('#$objName').val($param);"

   if {[lsearch [gmlObject info classes $root] PhysicalHTML_root] != -1} {
	 $root Concat_update $cmd
    }
 }
}

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_ZoneEntry_HTML MY_set_text {str} {
 set this(prim_text) $str
 this prim_set_text $str
}

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_ZoneEntry_HTML Render {strm_name {dec {}}} {
 upvar $strm_name rep

 set txt [string map [list {"} {&quot;}] [this get_text]]
# append rep $dec <textarea [this Style_class] {value="} [this Encode_param_for_JS $txt] {" name ="} [this get_LC]__XXX__set_text  {" onchange="javascript:addOutput(this)" >}
 append rep $dec <textarea [this Style_class] { name ="} ${objName}__XXX__MY_set_text  {" onkeyup="javascript:addOutput(this)" >}
   this Render_daughters rep
   append rep $txt
 append rep {</textarea>} "\n"
}
