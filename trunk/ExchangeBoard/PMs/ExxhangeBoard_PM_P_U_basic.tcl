#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit ExchangeBoard_PM_P_U_basic PM_U_Container

#___________________________________________________________________________________________________________________________________________
method ExchangeBoard_PM_P_U_basic constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id ExchangeBoard_PM_P_U_basic
   set this(L_representation_comets)           [list]
   set this(L_representation_available_comets) [list]
   set this(L_representation_roots)            [list]
   
   #this set_nb_max_daugthers 0
   set this(C_cont_root) [CPool get_a_comet CometContainer -set_name "Root of nested graph of $objName" -Add_style_class Root]
     set this(C_cont_in) [CPool get_a_comet CometContainer -set_name "Operations of $objName" -Add_style_class ExchangeBoard]
	   set this(C_choice_comets_in)  [CPool get_a_comet CometChoice    -set_name "Choice of Comets that are in $objName"            -set_nb_max_choices 9999 -Add_style_class Comets_in]
	   set this(C_cont_get) [CPool get_a_comet CometContainer -set_name "Get" -Add_style_class get]
	     set this(C_op_get)           [CPool get_a_comet CometActivator -set_name "Get the selected Comets of $objName here" -set_text "PUT THESE ELEMENTS IN " -Add_style_class get]
	     set this(C_choice_get_where) [CPool get_a_comet CometChoice -set_name "Get the selected Comets of $objName here" -set_nb_max_choices 1 -Add_style_class get]
		 $this(C_cont_get) set_daughters_R [list $this(C_op_get) $this(C_choice_get_where)]
       $this(C_cont_in) set_daughters_R [list $this(C_choice_comets_in) $this(C_cont_get)]
     set this(C_cont_out) [CPool get_a_comet CometContainer -set_name "Operations of $objName" -Add_style_class LocalComets]
	   set this(C_choice_comets_out) [CPool get_a_comet CometChoice -set_name "Choice of Comets that are available for $objName" -set_nb_max_choices 9999 -Add_style_class Comets_out]
	   set this(C_op_set)            [CPool get_a_comet CometActivator -set_name "Set the selected Comets of the UI in $objName" -set_text "PUT IN CLIPBOARD" -Add_style_class set]
	   set this(C_op_remove_local)   [CPool get_a_comet CometActivator -set_name "Remove the local element from $objName" -set_text "REMOVE FROM LOCAL" -Add_style_class remove_from_local]
	   $this(C_cont_out) Add_daughters_R [list $this(C_choice_comets_out) $this(C_op_set) $this(C_op_remove_local)]
     set this(C_cont_for_daughters) [CPool get_a_comet CometContainer -set_name "Root for daughters of $objName" -Add_style_class RootDaughters]
	 $this(C_cont_root) Add_daughters_R [list $this(C_cont_in) $this(C_cont_out) $this(C_cont_for_daughters)]

# Subscribings...
 $this(C_op_get)          Subscribe_to_activate $objName "$objName Action_Get"
 $this(C_op_set)          Subscribe_to_activate $objName "$objName Action_Set"
 $this(C_op_remove_local) Subscribe_to_activate $objName "$objName Action_Remove_from_local"
 set this(AJAX_reload_all) 0
 
# Plug and finish
 this set_L_nested_handle_LM    $this(C_cont_root)_LM_LP
 this set_L_nested_daughters_LM $this(C_cont_for_daughters)_LM_LP
 
# Special AJAX
 set this(tps_AJAX_maj) 2000
 
# Finish...
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method ExchangeBoard_PM_P_U_basic dispose {} {
 this inherited
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors ExchangeBoard_PM_P_U_basic [list L_representation_comets]

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC ExchangeBoard_PM_P_U_basic [P_L_methodes_set_ExchangeBoard] {} {}
Methodes_get_LC ExchangeBoard_PM_P_U_basic [P_L_methodes_get_ExchangeBoard] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
#__________________________________________________________ Special AJAX ___________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method ExchangeBoard_PM_P_U_basic Render_JS {strm_name mark {dec {}}} {
 upvar $strm_name strm

# set this(PM_cont_telec) [CSS++ $objName "CometContainer \\>[this get_LC]_telec/"]
# set this(PM_cont_visu)  [CSS++ $objName "CometContainer \\>[this get_LC]_visu_cont/"]
 set this(PM_questions)  [CSS++ $objName "#$objName ~ [this get_LC]_questions"]
 append strm $dec "function ${objName}_AJAX_maj() \{\n"
 append strm $dec "  if(Ajax.is_sending) {\n"
 append strm $dec "    setTimeout(\"${objName}_AJAX_maj()\", 100)\;\n"
 append strm $dec "    return\;}\n"
 append strm $dec "  var state = document.getElementById(\"${objName}_state\").value\;\n"
   set AJAX_tab [this get_AJAX_POST_tab_name]
   append strm $dec "  ${AJAX_tab} = new Array()\;"
   append strm $dec {  } $AJAX_tab {["Comet_port"] = } [[this get_L_roots] get_server_port] "\;\n"
   append strm $dec {  } $AJAX_tab {["} ${objName}__XXX__AJAX_update_state {"]  = "5 state " + state.length + " " + state} "\;\n"

   append strm $dec {  Ajax.get("set", "#", "} $objName {", } $AJAX_tab {, false)} "\;\n"
 append strm $dec "  setTimeout(\"${objName}_AJAX_maj()\", $this(tps_AJAX_maj))\;\n"
 append strm $dec " \}\n"
 #append strm $dec "setTimeout(\"${objName}_AJAX_maj()\", $this(tps_AJAX_maj))\;\n"

 this Render_daughters_JS strm $mark $dec
 this set_mark $mark
}

#___________________________________________________________________________________________________________________________________________
method ExchangeBoard_PM_P_U_basic get_AJAX_POST_tab_name {} {return ${objName}_AJAX_tab}

#___________________________________________________________________________________________________________________________________________
method ExchangeBoard_PM_P_U_basic AJAX_Render_state {strm_name} {
 upvar $strm_name strm
 
 if {$this(AJAX_reload_all)} {
   set this(AJAX_reload_all) 0
   set var reload
   set val {}
   append strm [string length $var] { } [string length $val] { } $var { } $val { }
  } else {set var $objName
          set val ""; this Render val; set val [string map [list "\n" {}] $val]
          append strm [string length $var] { } [string length $val] { } $var { } $val { }
         }
}

#___________________________________________________________________________________________________________________________________________
method ExchangeBoard_PM_P_U_basic AJAX_update_state {params} {
 set L_var_val {}
 this AJAX_annalyse_msg params 0 L_var_val
 foreach e $L_var_val {set [lindex $e 0] [lindex $e 1]}
 
 if {$state < [this get_last_change]} {
   puts "Update HTML by : [this get_L_roots] set_AJAX_root \"$objName AJAX_Render_state\""
   [this get_L_roots] set_AJAX_root "$objName AJAX_Render_state" 
  } else {[this get_L_roots] set_AJAX_root NOTHING}
}

#___________________________________________________________________________________________________________________________________________
method ExchangeBoard_PM_P_U_basic Render {strm_name {dec {}}} {
 upvar $strm_name strm

 append strm $dec "<div [this Style_class]>\n"
 append strm $dec {  <input type="hidden" name="" id="} ${objName}_state {" value="} [this get_last_change] {" />} "\n"
   this Render_daughters strm "$dec  " 
 append strm $dec "</div>\n"
}

#___________________________________________________________________________________________________________________________________________
method ExchangeBoard_PM_P_U_basic Action_Get {} {
 puts "$objName Action_Get:\n  [[this get_L_roots] get_LC] Add_daughters_R {[$this(C_choice_comets_in) get_currents]}"
 set L {}
 foreach c [$this(C_choice_comets_in) get_currents] {
   lappend L [$c Val_MetaData "Represents in ExchangeBoard"]
  }
 set root [$this(C_choice_get_where) get_currents]
 if {[string equal $root ""]} {return}
 [$root Val_MetaData "Represents_root"] Add_daughters_R $L
}

#___________________________________________________________________________________________________________________________________________
method ExchangeBoard_PM_P_U_basic Action_Remove_from_local {} {
 set L {}
 foreach c [$this(C_choice_comets_out) get_currents] {
   puts "  $objName : Remove $c ([$c get_name])"
   lappend L [$c Val_MetaData "Represents in ExchangeBoard"]
  }
 [this get_LC] Remove_local_comets $L
}

#___________________________________________________________________________________________________________________________________________
method ExchangeBoard_PM_P_U_basic Action_Set {} {
 set L {}
 foreach c [$this(C_choice_comets_out) get_currents] {
   lappend L [$c Val_MetaData "Represents in ExchangeBoard"]
  }
 [this get_LC] Add_comets $L
}

#___________________________________________________________________________________________________________________________________________
method ExchangeBoard_PM_P_U_basic Update {} {
 puts "$objName Update"
 foreach c $this(L_representation_available_comets) {
   puts "  CPool Release_a_comet $c"
   CPool Release_a_comet $c
  }
 set this(L_representation_available_comets) ""
 puts "CSS++ cr \"(#$objName <--< * \\\\!>*/)->LC >--> *\""
 foreach c [CSS++ cr "(#$objName <--< * \\!>*/)->LC >--> *"] {
   set c [CPool get_a_comet CometText -set_name [$c get_name] -set_text [$c get_name] -Add_MetaData "Represents in ExchangeBoard" $c]
   lappend this(L_representation_available_comets) $c
  }
 puts "  $this(C_choice_comets_out) set_L_choices {$this(L_representation_available_comets)}"
 $this(C_choice_comets_out) set_L_choices $this(L_representation_available_comets)
 
# Update the list of possible "roots"
 set L_to_add {}
 foreach r [CSS++ cr "#$objName->LC <--< > *"] {
   set found 0
   foreach c $this(L_representation_roots) {
     if {[string equal $r [$c Val_MetaData Represents_root]]} {set found 1; break}
    }
   if {!$found} {lappend L_to_add $r}
  }
 foreach r $L_to_add {
   set rep [CPool get_a_comet CometText -set_name [$r get_name] -set_text [$r get_name] -Add_MetaData "Represents_root" $r]
   lappend this(L_representation_roots)     $rep
   $this(C_choice_get_where) Add_choices    $rep
  }
}

#___________________________________________________________________________________________________________________________________________
method ExchangeBoard_PM_P_U_basic set_L_comets {L} {
 foreach c $this(L_representation_comets) {CPool Release_a_comet $c}
 set this(L_representation_comets) {}
 this Add_comets $L
 $this(C_choice_comets_in) set_daughters_R ""
}

#___________________________________________________________________________________________________________________________________________
method ExchangeBoard_PM_P_U_basic Add_comets {L} {
 puts "$objName Add_comets $L"
 foreach c_name $L {
   puts "  - $c_name"
   set rep ""
   foreach c $this(L_representation_comets) {
     if {[string equal $c_name [$c Val_MetaData "Represents in ExchangeBoard"]]} {
	   puts "  $c_name already there..."
	   set rep $c; break
	  }
    }
   if {[string equal $rep ""]} {
     set c [CPool get_a_comet CometText -set_name [$c_name get_name] -set_text [$c_name get_name] -Add_MetaData "Represents in ExchangeBoard" $c_name]
	 lappend this(L_representation_comets) $c
	 $this(C_choice_comets_in) Add_daughters_R $c
	}
  }
}

#___________________________________________________________________________________________________________________________________________
method ExchangeBoard_PM_P_U_basic Sub_comets {L} {
 set L_comets ""
 foreach c_name $L {
   foreach c $this(L_representation_comets) {
     if {[string equal $c_name [$c get_text]]} {lappend L_comets $c}
    }
   set c [CPool get_a_comet CometText -set_text $c_name]
   lappend this(L_representation_comets) $c
  }
 $this(C_choice_comets_in) Sub_daughters_R $L_comets
 CPool Release_comets $L_comets
}

#___________________________________________________________________________________________________________________________________________
method ExchangeBoard_PM_P_U_basic Remove_local_comets {L} {this Update}
