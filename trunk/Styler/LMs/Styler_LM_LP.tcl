#___________________________________________________________________________________________________________________________________________
#___________________________________________ Définition of Logical Model of présentation____________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Styler_LM_LP Logical_presentation

#___________________________________________________________________________________________________________________________________________
method Styler_LM_LP constructor {name descr args} {
 set this(init_ok) 0
 this inherited $name $descr
 this set_L_actives_PM {}
 set this(num_sub) 0
 
 if {[regexp "^(.*)_LM_LP" $objName rep comet_name]} {} else {set comet_name $objName}
 set this(comet_name) $comet_name

# Nesting parts
set i_DSL interpretor_DSL_comet_interface
set str "${objName}_c_style = C_Cont ( \
     , ${objName}_spec_fct  = C_Spec()\
     , ${objName}_spec_rule = C_Cont (, ${objName}_Cspec_selector_req = C_Spec()               \
                                      , ${objName}_Cact_selector_req  = C_Act(set_text SEARCH) \
                                      , ${objName}_Ctxt_result_req    = C_Text()               \
                                      , ${objName}_Cspec_style        = C_Spec()               \
                                      , ${objName}_Cact_add_rule      = C_Act(set_text \"ADD RULE\"))   \
     , ${objName}_L_rules   = C_Cont (, ${objName}_Cchoice            = C_DC(set_nb_max_choices 999)    \
                                      , ${objName}_Cact_sub_rules     = C_Act(set_text \"SUB RULES\")   \
                                      , ${objName}_Cspec_save_rules   = C_Spec(set_name \"SAVE RULES\")  \
                                      , ${objName}_Cchoice_load_rules = C_DC  (set_name \"LOAD RULES\")  \
                                      , ${objName}_Cspec_root         = C_Spec()  \
                                      , ${objName}_Cact_apply_rules   = C_Act(set_text \"APPLY RULES\"))\
                                     )"
# set L_res_DSL [$i_DSL Interprets $str StyleEditor]

 set L_nested [interpretor_DSL_comet_interface Interprets $str $objName]
# puts "$objName Add_nested_daughters [lindex $L_nested 1] $this(Interleaving) $this(Interleaving) _LM_LP"
 this Add_nested_daughters [lindex $L_nested 1] ${objName}_c_style ${objName}_c_style _LM_LP

  ${objName}_Cspec_style_LM_LP       Ptf_style [list {Ptf_TK Specifyer_PM_P_text_TK}]
  ${objName}_spec_fct_LM_LP          Ptf_style [list {Ptf_TK Specifyer_PM_P_text_TK}]
  ${objName}_Ctxt_result_req_LM_LP   Ptf_style [list {Ptf_TK Text_PM_P_zone_TK}]
  set r ${objName}_Cspec_style_LM_LP;        Encapsulate $r PM_Universal U_LM_encaps_specifyer_LM_P;
    $r Nested_style $i_DSL "${r}_nested_style_descr = C_Cont(,\"Style: \", [$r get_factice_LC]())" ${r}_nested_style_descr_LM_LP
  set r ${objName}_Cspec_selector_req_LM_LP; Encapsulate $r PM_Universal U_LM_encaps_specifyer_LM_P;
    $r Nested_style $i_DSL "${r}_nested_style_descr = C_Cont(,\"Selector: \", [$r get_factice_LC]())" ${r}_nested_style_descr_LM_LP
  set r ${objName}_Cspec_root_LM_LP;         Encapsulate $r PM_Universal U_LM_encaps_specifyer_LM_P;
    $r Nested_style $i_DSL "${r}_nested_style_descr = C_Cont(,\"Comet root: \", [$r get_factice_LC]())" ${r}_nested_style_descr_LM_LP
  set r ${objName}_spec_fct_LM_LP;           Encapsulate $r PM_Universal U_LM_encaps_specifyer_LM_P;
    $r Nested_style $i_DSL "${r}_nested_style_descr = C_Cont(,\"Functions: \", [$r get_factice_LC]())" ${r}_nested_style_descr_LM_LP

  ${objName}_Cact_selector_req Subscribe_to_activate metacomet "\[$objName get_LC\] set_comet_root \[${objName}_Cspec_root get_text\]; \
                                                                set str   \[${objName}_Cspec_selector_req get_text\]; \
                                                                set L_rep {}; \
                                                                \[$objName get_styler\] DSL_SELECTOR str L_rep \[$objName get_comet_root\] 1; \
                                                                ${objName}_Ctxt_result_req set_text \$L_rep; \
                                                               "
  ${objName}_Cact_add_rule    Subscribe_to_activate metacomet "$objName Add_rule \[${objName}_Cspec_selector_req get_text\] \[${objName}_Cspec_root get_text\] \[${objName}_Cspec_style get_text\]"
  ${objName}_Cact_sub_rules   Subscribe_to_activate metacomet "$objName Sub_rule \[${objName}_Cchoice get_currents\]"
  ${objName}_Cact_apply_rules Subscribe_to_activate metacomet "set root \[${objName}_Cspec_root get_text\]; \
                                                               \$root set_styler \[$objName get_styler\]; \
                                                               \[$objName get_LC\] set_comet_root \$root; \
                                                               \$root set_style \[$objName get_rule\]; \
                                                               Update_style \[\$root get_DSL_GDD_QUERY\] \[\$root get_DSL_CSSpp\] \[$objName get_functions\] \[$objName get_rule\]; \
                                                              "
  ${objName}_Cchoice Subscribe_to_set_currents metacomet "$objName maj_editor \[lindex \$lc end\]"

  set name ${objName}_Cchoice_load_rules_PM_P_dialog_TK
    ${objName}_Cchoice_load_rules_LM_LP Add_PM    [Choice_file_PM_P_dialog_TK $name $name {}]
    ${objName}_Cchoice_load_rules_LM_LP Ptf_style [list {Ptf_TK Choice_file_PM_P_dialog_TK}]
    ${objName}_Cchoice_load_rules       Subscribe_to_set_currents metacomet "if \{\[string equal \$lc \{\}\]\} \{\} else \{$objName Load_style \$lc\}"
  set name ${objName}_Cspec_save_rules_PM_P_dialog_TK
    ${objName}_Cspec_save_rules_LM_LP Add_PM    [Specifyer_file_PM_P_dialog_TK $name $name {}]
    ${objName}_Cspec_save_rules_LM_LP Ptf_style [list {Ptf_TK Specifyer_file_PM_P_dialog_TK}]
    ${objName}_Cspec_save_rules       Subscribe_to_set_text   metacomet "if \{\[string equal \$t \{\}\]\} \{\} else \{$objName Save_style \$t\}"

# Adding some PM of presentations
 if {[regexp "^(.*)_LM_LP" $objName rep comet_name]} {} else {set comet_name $objName}
 set UPM "${comet_name}_PM_P_UPM_[this get_a_unique_id]"
   Styler_U_PM_P $UPM $UPM "A PM representing $objName"
   this Add_PM $UPM

#  this Add_PM_factories [Generate_factories_for_PM_type [list {DChoice_PM_P_interleaving_markers_HTML Ptf_HTML} \
#                                                              {DChoice_PM_P_Menu_HTML Ptf_HTML}                 \
#                                                              {PM_P_radiobutton_TK Ptf_TK}                      \
#                                                        ] $objName]

 set this(init_ok) 1
 this set_PM_active $UPM

 eval "$objName configure $args"
 return $objName
}

#______________________________________________________ Adding the choices functions _______________________________________________________
Methodes_set_LC Styler_LM_LP [L_methodes_set_Styler] {$this(FC)} {$this(L_actives_PM)}
Methodes_get_LC Styler_LM_LP [L_methodes_get_Styler] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method Styler_LM_LP get_functions {} {return [${objName}_spec_fct get_text]}
#___________________________________________________________________________________________________________________________________________
method Styler_LM_LP set_functions {v} {${objName}_spec_fct set_text $v}

#___________________________________________________________________________________________________________________________________________
method Styler_LM_LP Add_rule {sel root style} {
 foreach c [${objName}_Cchoice get_daughters] {
   if {[string equal [$c get_text] $sel]} {
     [this get_Common_FC] Add_rule $sel $root $style
     return
    }
  }
 [this get_Common_FC] Add_rule       $sel $root $style
 set name ${objName}_CG_choix_[${objName} get_a_unique_id]
 CometText $name $sel "$sel (/$root) : $style"
   $name set_text $sel
 ${objName}_Cchoice   Add_daughter_R $name
}

#___________________________________________________________________________________________________________________________________________
method Styler_LM_LP Sub_rule {Lsel} {
 set L {}
 foreach sel $Lsel {lappend L [$sel get_text]}
 [this get_Common_FC] Sub_rule $L

# puts "${objName}_Cchoice Sub_daughters_R \{$Lsel\}"
 ${objName}_Cchoice Sub_daughters_R $Lsel
 foreach c $Lsel {$c dispose}
}

#___________________________________________________________________________________________________________________________________________
method Styler_LM_LP set_comet_root {c} {${objName}_Cspec_root set_text $c}

#___________________________________________________________________________________________________________________________________________
method Styler_LM_LP maj_editor {c} {
 if {[string equal $c {}]} {return}
# puts "Styler_LM_LP maj_editor \{[$c get_text]\}"
 set Lr  [[this get_Common_FC] get_rule]
 set txt [$c get_text]
 foreach r $Lr {
#   puts "  Is \{[lindex $r 0]\} ok?"
   if {[string equal [lindex $r 0] $txt]} {
     ${objName}_Cspec_selector_req set_text $txt
     ${objName}_Cspec_style        set_text [lindex $r 2]
     ${objName}_Cspec_root         set_text [lindex $r 1]
     ${objName}_Cact_selector_req  activate
     break;
    }
  }
}

#_________________________________________________________________________________________________________
method Styler_LM_LP Get_flags {str_name} {
 upvar $str_name str
 set sep "\[ |	|\n\]"

 set L [split $str "\;"]
 set root [lindex $L 0]
 set L [lrange $L 1 end]
 set rep [list]
 foreach e $L {
   if {[regexp "^$sep*(.*)$sep*:$sep*(.*)$sep*\$" $e reco var val]} {
     lappend rep [list $var $val]
    }
  }

 return [list $root $rep]
}

#___________________________________________________________________________________________________________________________________________
method Styler_LM_LP Save_style {f_name} {
 set f [open $f_name w]
 puts $f [this get_functions]
 puts $f "\n__________ RULES __________\n"
 foreach r [this get_rule] {
   puts $f "[lindex $r 0] {\n[lindex $r 1]\;\n[lindex $r 2]\n}"
  }
 close $f
}

#___________________________________________________________________________________________________________________________________________
method Styler_LM_LP Load_style {f_name} {
 this Sub_rule [${objName}_Cchoice get_daughters]
 set f [open $f_name]
   set txt [read $f]
   if {[regexp "^(.*)\n__________ RULES __________\n(.*)\$" $txt reco fct txt]} {
     this set_functions $fct
    } else {puts "INVALID FILE: $f_name"
            return}
   set L [split $txt "\}"]
   set L_rep {}
   set sep "\[ |	|\n\]"
   set letter {[#a-zA-Z0-9_\*\)/]}
   set expression "^$sep*($letter.*$letter)$sep*\{${sep}*($letter.*;)$sep*\$"

   foreach e $L {
     if {[regexp $expression $e reco selector flags]} {
       set flags [this Get_flags flags]
       lappend L_rep [list $selector [lindex $flags 0] [lindex $flags 1]]
      }
    }

   foreach r $L_rep {
     set style {}
     foreach s [lindex $r 2] {append style "[lindex $s 0]: [lindex $s 1];\n"}
     this Add_rule [lindex $r 0] [lindex $r 1] $style
    }
 close $f
}
