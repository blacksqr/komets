#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Interleaving_PM_P_Magnetic_List_HTML PM_HTML
#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_Magnetic_List_HTML constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id MagneticList_HTML
 eval "$objName configure $args"
}
#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_Magnetic_List_HTML Render {strm_name {dec {}}} {
 upvar $strm_name strm
 append strm $dec "<script language=\"JavaScript\" type=\"text/javascript\">\n"
 append strm $dec "<!--\n"
 append strm $dec "  var dragsort = ToolMan.dragsort();\n"
 append strm $dec "  function initMagneticList_${objName}() \{\n"
 append strm $dec "    dragsort.makeListSortable(document.getElementById('magnetic_list_${objName}'));\n"
 append strm $dec "  \}\n"
 append strm $dec "  function saveMagneticList_${objName}() \{\n"
 append strm $dec "    document.getElementById('${objName}__XXX__maj_interleaved_daughters').value = ToolMan.junkdrawer().serializeList(document.getElementById('magnetic_list_${objName}'));\n"
 append strm $dec "  \}\n"
 append strm $dec "  StkFunc(initMagneticList_${objName});\n"
 append strm $dec "-->\n"
 append strm $dec "</script>\n"
 
 set L_ordre {}
 foreach c [this get_daughters] {lappend L_ordre "magnetic_item_$c"}
 set L_ordre [join $L_ordre |]
 
 append strm $dec "<input type=\"hidden\" name=\"${objName}__XXX__maj_interleaved_daughters\" id=\"${objName}__XXX__maj_interleaved_daughters\" value=\"$L_ordre\" />\n"
 append strm $dec "<ul id=\"magnetic_list_${objName}\" style=\"list-style-type:none;margin:0px;padding:0px;\" onClick=\"javascript:saveMagneticList_${objName}();\">\n"
 this Render_daughters strm "$dec  "
 append strm $dec "</ul>\n"
}

#__________________________________________________
Methodes_set_LC Interleaving_PM_P_Magnetic_List_HTML [P_L_methodes_set_CometInterleaving] {}  {}
Methodes_get_LC Interleaving_PM_P_Magnetic_List_HTML [P_L_methodes_get_CometInterleaving] {}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_Magnetic_List_HTML maj_interleaved_daughters {L} {
 puts "$objName maj_interleaved_daughters $L"
# L contient une liste avec des |
 set L [split $L |]
# Pour chaque élément, enlever magnetic_item_ 
 set nL {}
 foreach e $L { 
   if {[regexp {^magnetic_item_(.*)$} $e reco ne]} {lappend nL $ne}
  }
# Vider les fils
 this set_daughters $nL
} 


#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_Magnetic_List_HTML Render_daughters {strm_name {dec {}}} {
 upvar $strm_name strm
 set L   [this get_daughters]
 set pos 0
 foreach c [this get_daughters] {
    append strm $dec "<li itemID=\"magnetic_item_[lindex $L $pos]\" style=\"margin-bottom:10px;margin-right:10px;\">\n"
    append strm $dec "  <img src=\"./src_img/move.gif\" style=\"cursor:move;vertical-align:middle;float:left;\">\n"
    append strm $dec "  <div style=\"padding:2px 2px 2px 2px;border:0px solid #000000;\">\n"
      $c Render_all strm "$dec    "
    append strm $dec "  </div>\n"
    append strm $dec "</li>\n"
    incr pos
  }
}
