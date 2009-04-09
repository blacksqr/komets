
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometCamNote_Examinator_PM_U PM_Universal
#___________________________________________________________________________________________________________________________________________
method CometCamNote_Examinator_PM_U constructor {name descr args} {
 this inherited $name $descr
   this set_nb_max_mothers 1
   this set_cmd_placement {}
   
   set this(last_mode)   {}
   set this(refresh_all) 0
   set this(reload)      0
   set this(tps_AJAX_maj) 2000
   set class(mark) 0
   set this(last_reload) 0

   eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors CometCamNote_Examinator_PM_U [list refresh_all]

#___________________________________________________________________________________________________________________________________________
method CometCamNote_Examinator_PM_U get_mark {}  {return $class(mark)}
method CometCamNote_Examinator_PM_U set_mark {m} {set class(mark) $m}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometCamNote_Examinator_PM_U [L_methodes_set_CamNote_Examinator] {$this(FC)} {}
Methodes_get_LC CometCamNote_Examinator_PM_U [L_methodes_get_CamNote_Examinator] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_accessors CometCamNote_Examinator_PM_U [list tps_AJAX_maj]

#___________________________________________________________________________________________________________________________________________
method CometCamNote_Examinator_PM_U get_AJAX_POST_tab_name {} {return ${objName}_AJAX_tab}

#___________________________________________________________________________________________________________________________________________
method CometCamNote_Examinator_PM_U set_mode {m} {
 if {[string equal $this(last_mode) $m]} {} else {set this(refresh_all) 1}
# puts "$objName set_mode $m"
# if {[string equal $m PRESENTATION]} {
#   [this get_LM]_interleaving_for_LC_nested Sub_daughter_R [this get_LC]_telec
#  } else {if {[string equal $m QUESTIONS]} {[this get_LM]_interleaving_for_LC_nested Add_daughter_R [this get_LC]_telec 0
#                                           }
#         }
}

#___________________________________________________________________________________________________________________________________________
method CometCamNote_Examinator_PM_U Render_JS {strm_name mark {dec {}}} {
 upvar $strm_name strm

# set this(PM_cont_telec) [CSS++ $objName "CometContainer \\>[this get_LC]_telec/"]
# set this(PM_cont_visu)  [CSS++ $objName "CometContainer \\>[this get_LC]_visu_cont/"]
 set this(PM_questions)  [CSS++ $objName "#$objName ~ [this get_LC]_questions"]
 append strm $dec "function ${objName}_AJAX_maj() \{\n"
 append strm $dec "  if(Ajax.is_sending) {\n"
 append strm $dec "    setTimeout(\"${objName}_AJAX_maj()\", 100)\;\n"
 append strm $dec "    return\;}\n"
 append strm $dec "  var v   = document.getElementById(\"${objName}_num_slide\").value\;\n"
 append strm $dec "  var txt = document.getElementById(\"[$this(PM_questions) get_XML_id]\").value\;\n"
   set AJAX_tab [this get_AJAX_POST_tab_name]
   append strm $dec "  ${AJAX_tab} = new Array()\;"
   append strm $dec {  } $AJAX_tab {["Comet_port"] = } [[this get_L_roots] get_server_port] "\;\n"
   append strm $dec {  } $AJAX_tab {["} ${objName}__XXX__AJAX_server {"]  = "1 v " + v.length + " " + v + " 8 question " + txt.length + " " + txt} "\;\n"

   append strm $dec {  Ajax.get("set", "#", "} $objName {", } $AJAX_tab {, false)} "\;\n"
 append strm $dec "  setTimeout(\"${objName}_AJAX_maj()\", $this(tps_AJAX_maj))\;\n"
 append strm $dec " \}\n"
 #append strm $dec "setTimeout(\"${objName}_AJAX_maj()\", $this(tps_AJAX_maj))\;\n"

 this Render_daughters_JS strm $mark $dec
 this set_mark $mark
}

#___________________________________________________________________________________________________________________________________________
method CometCamNote_Examinator_PM_U Render {strm_name {dec {}}} {
 upvar $strm_name strm

 append strm $dec "<div [this Style_class]>\n"
   this AJAX_Render strm "$dec  "
 append strm $dec "</div>\n"
}

#___________________________________________________________________________________________________________________________________________
method CometCamNote_Examinator_PM_U AJAX_Render {strm_name {dec {}}} {
 puts "  $objName Render"
 upvar $strm_name strm

 append strm $dec "<div id=\"${objName}_div_hidden_slide\">\n"
 append strm $dec {  } [this AJAX_num_slide] "\n"
 append strm $dec "</div>\n"
 this Render_daughters strm $dec
}

#___________________________________________________________________________________________________________________________________________
method CometCamNote_Examinator_PM_U AJAX_num_slide {} {
 set telec [[this get_LC] get_telec]
 set    rep {}
 append rep {<input type="hidden" name="" id="} ${objName}_num_slide {" value="} [$telec get_val] "|$this(last_reload)|[this get_mode]" {" />}
 return $rep
} 


#___________________________________________________________________________________________________________________________________________
method CometCamNote_Examinator_PM_U AJAX_server {params} {
 set L_var_val {}
 this AJAX_annalyse_msg params 0 L_var_val
 foreach e $L_var_val {set [lindex $e 0] [lindex $e 1]}
 set L [split $v |]
 set num [lindex $L 0]
 set rld [lindex $L 1]
 set mde [lindex $L 2]

   set telec [[this get_LC] get_telec]
   if { (![string equal $mde [this get_mode]]) } {
     set this(reload) 1
     set this(last_reload) [clock clicks]
     [this get_L_roots] set_AJAX_root "$objName AJAX_maj"
    } else {if { ($num != [$telec get_val]) } {
              [this get_L_roots] set_AJAX_root "$objName AJAX_maj"
             } else {[this get_L_roots] set_AJAX_root NOTHING
                    }
           }

 if {[info exists question]} {
   [[this get_LC] get_C_questions] set_question $question 1
  }

 if {$this(reload) || (![string equal $rld $this(last_reload)])} {
   puts "WE HAVE TO RELOAD"
   set this(reload) 1
   [this get_L_roots] set_AJAX_root "$objName AJAX_maj"
  }
}

#_________________________________________________________________________________________________________
method CometCamNote_Examinator_PM_U Propagate_info_substitution_of {PM1 PM2} {
 #puts "objName Propagate_info_substitution_of $PM1 $PM2"
 this inherited $PM1 $PM2
 set this(reload) 1
 set this(last_reload) [clock clicks]
}

#___________________________________________________________________________________________________________________________________________
method CometCamNote_Examinator_PM_U AJAX_maj {strm_name} {
 upvar $strm_name strm

 if {$this(reload)} {
   #puts "TRYING TO RELOAD"
   set var reload
   set val {}
   append strm [string length $var] { } [string length $val] { } $var { } $val { }
   set this(reload) 0
   return
  }

 if {$this(refresh_all)} {
   set var [this get_AJAX_id_for_daughters]
   this AJAX_Render val
   append strm [string length $var] { } [string length $val] { } $var { } $val { }
   set this(refresh_all) 0
   return
  }

 set this(PM_cont_telec) [CSS++ $objName "CometContainer \\>[this get_LC]_telec/"]
 set this(PM_cont_visu)  [CSS++ $objName "CometContainer \\>[this get_LC]_visu_cont/"]
 #set this(PM_questions)  [CSS++ $objName "[this get_LC]_questions"]

 set L [list "${objName}_div_hidden_slide \{set val \[this AJAX_num_slide\]\}"]
 if {[string equal $this(PM_cont_telec) {}]} {} else {lappend L "[$this(PM_cont_telec) get_AJAX_id_for_daughters] \{set val \{\}; $this(PM_cont_telec) Render_daughters val\}"}
 if {[string equal $this(PM_cont_visu)  {}]} {} else {lappend L "[$this(PM_cont_visu)  get_AJAX_id_for_daughters] \{set val \{\}; $this(PM_cont_visu)  Render_daughters val\}"}
 foreach var_cmd $L {
     set var [lindex $var_cmd 0]
     eval [lindex $var_cmd 1]
     set val [string map [list "\n" {}] $val]
     append strm [string length $var] { } [string length $val] { } $var { } $val { }
    }
}
