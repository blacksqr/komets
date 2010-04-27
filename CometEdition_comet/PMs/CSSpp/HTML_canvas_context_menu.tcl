#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
proc CometEdition_PM_P_U_basic_HTML___display_L_PM {CE x y L_PM} {
 set    strm "" 
 append strm "<div id=\"CometEdition_PM_P_U_basic_HTML___display_L_PM\" title=\"List of elements\">"
 append strm "<style type=\"text/css\">#CometEdition_PM_P_U_basic_HTML___display_L_PM .text_PM:hover {background: rgb(255,255,64); border: solid black 1px;}</style>"
 foreach PM $L_PM {
   append strm "<div id=\"CometEdition_PM_P_U_basic_HTML___display_L_PM___for_$PM\" class=\"text_PM\" onclick=\"addOutput_proc_val('${CE}' + '__XXX__get_possible_FUI', '${PM}', true);\">[[$PM get_LC] get_name]</div>"
  }
 append strm "</div>"
 
 set    cmd "\$('#CometEdition_PM_P_U_basic_HTML___display_L_PM').remove(); \$('#$CE').append( "
 append cmd [$CE Encode_param_for_JS $strm]
 append cmd " ); \$('#CometEdition_PM_P_U_basic_HTML___display_L_PM').dialog();"
 
 $CE Concat_update $CE CometEdition_PM_P_U_basic_HTML___display_L_PM $cmd
}

#___________________________________________________________________________________________________________________________________________
proc CometEdition_PM_P_U_basic_HTML___display_L_GDD_FUI {CE x y PM L_GDD_FUI} {
 set strm "" 
 append strm "<div id=\"CometEdition_PM_P_U_basic_HTML___display_L_GDD_FUI\" title=\"Substitut for [[$PM get_LC] get_name]\">"
 append strm "<input id=\"CometEdition_PM_P_U_basic_HTML___display_L_GDD_FUI___PM\" type=\"hidden\" value=\"$PM\"/>"
 append strm "<style type=\"text/css\">#CometEdition_PM_P_U_basic_HTML___display_L_GDD_FUI div.GDD_FUI {margin-left: 20px;}"
 append strm "#CometEdition_PM_P_U_basic_HTML___display_L_GDD_FUI div.GDD_FUI:hover {background: rgb(255,255,64); border: solid black 1px;}"
 append strm "</style>"
 foreach CT_L_FUI [lrange $L_GDD_FUI 0 end-1] {
   lassign $CT_L_FUI CT L_FUI
   append strm "<div class=\"GDD_CT\">$CT"
   foreach FUI $L_FUI {
     append strm "<div class=\"GDD_FUI\" onclick=\"addOutput_proc_val('${CE}' + '__XXX__Exec_a_substitution', \$('#CometEdition_PM_P_U_basic_HTML___display_L_GDD_FUI___PM').val() + ' $FUI', true);\">$FUI</div>"
    }
   append strm "</div>"
  }
 append strm "</div>"
 
 set    cmd "\$('#CometEdition_PM_P_U_basic_HTML___display_L_GDD_FUI').remove(); \$('#$CE').append( "
 append cmd [$CE Encode_param_for_JS $strm]
 append cmd " ); \$('#CometEdition_PM_P_U_basic_HTML___display_L_GDD_FUI').dialog();"
 
 $CE Concat_update $CE CometEdition_PM_P_U_basic_HTML___display_L_GDD_FUI $cmd
}

#___________________________________________________________________________________________________________________________________________
proc CometEdition_PM_P_U_basic_HTML___Update_PM {CE old_PM new_PM} {
 set    cmd ""
 append cmd "\$('#CometEdition_PM_P_U_basic_HTML___display_L_GDD_FUI___PM').val('$new_PM');\n"
 append cmd "\$('#CometEdition_PM_P_U_basic_HTML___display_L_PM___for_$old_PM').attr('onClick', \"addOutput_proc_val('${CE}' + '__XXX__get_possible_FUI', '${new_PM}', true);\");"
 
 $CE Concat_update $CE CometEdition_PM_P_U_basic_HTML___Update_PM $cmd 
}