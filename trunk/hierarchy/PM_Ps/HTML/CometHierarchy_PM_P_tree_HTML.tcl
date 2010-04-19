#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometHierarchy_PM_P_tree_HTML PM_HTML

#___________________________________________________________________________________________________________________________________________
method CometHierarchy_PM_P_tree_HTML constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id FUI_CometHierarchy_PM_P_tree_HTML
   
   set this(item_draggable) 0
   
 eval "$objName configure $args"
 return $objName
}

#_________________________________________________________________________________________________________
Methodes_set_LC CometHierarchy_PM_P_tree_HTML [L_methodes_set_hierarchy] {} {}
Methodes_get_LC CometHierarchy_PM_P_tree_HTML [L_methodes_get_hierarchy] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_accessors CometHierarchy_PM_P_tree_HTML [list item_draggable]

#___________________________________________________________________________________________________________________________________________
method CometHierarchy_PM_P_tree_HTML Render {strm_name {dec {}}} {
 upvar $strm_name strm
 
 append strm $dec "<script language=\"JavaScript\" type=\"text/javascript\" src=\"./Comets/hierarchy/PM_Ps/HTML/switch_plus_minus.js\"></script>\n"
 append strm $dec <div [this Style_class] {> } "\n"
   this Recurse_display strm "$dec  " [this get_L_h] 0
 append strm $dec "</div>\n"
 
 append strm $dec "<div id=\"${objName}_daughters\">"
   this Render_daughters strm "$dec  " 
 append strm $dec "</div>\n"
}

#___________________________________________________________________________________________________________________________________________
method CometHierarchy_PM_P_tree_HTML Render_post_JS {strm_name {dec {}}} {
 upvar $strm_name strm
 
 if {[this get_item_draggable]} {
   append strm $dec "\$('.${objName}_item').draggable( {opacity: 0.7, helper: 'clone'} );\n"
  }
 this inherited strm $dec
}


#___________________________________________________________________________________________________________________________________________
method CometHierarchy_PM_P_tree_HTML Recurse_display {strm_name dec L_h level} {
 upvar $strm_name strm
 incr level
 
 lassign $L_h id L_att L_daughters
 
 foreach {att val} $L_att {set $att $val}
 if {![info exists name]} {set name $id}
 append strm $dec "<div id=\"${objName}_$id\">\n"
   if {[llength $L_daughters] == 0} {
     set img_name "void.png"
    } else {set img_name "minus.png"}
	
 append strm "<span id=\"${objName}_icon_of_$id\""
 if {$img_name != "void.png"} {append strm " onclick=\"CometHierarchy_PM_P_tree_HTML__switch_plus_minus('${objName}_icon_of_$id', '${objName}_daughters_of_$id', 0); \""}
 append strm ">\n"
 append strm $dec "<img src=\"./Comets/hierarchy/PM_Ps/HTML/images/" $img_name "\""
 append strm "/></span> <span id=\"${objName}_item_$id\" class=\"CometHierarchy_PM_P_tree_HTML_NODE ${objName}_item"
 if {$img_name == "void.png"} {append strm " ${objName}_leaf"}
 append strm "\">" $name "</span>\n"
 
 append strm $dec "<div id=\"${objName}_daughters_of_$id\" style=\"margin-left: 10px;\">\n"
 foreach d $L_daughters {
   this Recurse_display strm "$dec  " $d $level
  }
 append strm $dec "</div>\n" $dec "</div>\n" 
}

#___________________________________________________________________________________________________________________________________________
method CometHierarchy_PM_P_tree_HTML set_all_item_draggable {v} {
 this Drag_zone $v ${objName}_item 0
}

#___________________________________________________________________________________________________________________________________________
method CometHierarchy_PM_P_tree_HTML set_leaf_item_draggable {v} {
 this Drag_zone $v ${objName}_leaf 0
}

#___________________________________________________________________________________________________________________________________________
Inject_code CometHierarchy_PM_P_tree_HTML set_L_h {} {
 set    cmd "\$('#$objName').html("
   set strm ""
   this Recurse_display strm "" [this get_L_h] 0
   append cmd [this Encode_param_for_JS $strm]
 append cmd ");\n"
 this Concat_update $objName set_L_h $cmd
}
