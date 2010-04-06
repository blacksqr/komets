#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometHierarchy_PM_P_tree_HTML PM_HTML

#___________________________________________________________________________________________________________________________________________
method CometHierarchy_PM_P_tree_HTML constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id FUI_CometHierarchy_PM_P_tree_HTML
   
   
 eval "$objName configure $args"
 return $objName
}

#_________________________________________________________________________________________________________
Methodes_set_LC CometHierarchy_PM_P_tree_HTML [L_methodes_set_hierarchy] {} {}
Methodes_get_LC CometHierarchy_PM_P_tree_HTML [L_methodes_get_hierarchy] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_accessors CometHierarchy_PM_P_tree_HTML [list pipo_C_container]

#___________________________________________________________________________________________________________________________________________
method CometHierarchy_PM_P_tree_HTML Render {strm_name {dec {}}} {
 upvar $strm_name strm
 
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
 
 this Render_daughters_post_JS strm $dec
}


#___________________________________________________________________________________________________________________________________________
method CometHierarchy_PM_P_tree_HTML Recurse_display {strm_name dec L_h level} {
 upvar $strm_name strm
 incr level
 
 lassign $L_h id L_att L_daughters
 
 foreach {att val} $L_att {set $att $val}
 if {![info exists name]} {set name $id}
 append strm $dec "<div id=\"${objName}_$id\">"
   if {[llength $L_daughters] == 0} {
     set img_name "void.png"
    } else {set img_name "minus.png"}
	
 append strm "<img id=\"${objName}_icon_of_$id\" src=\"./Comets/hierarchy/PM_Ps/HTML/images/" $img_name "\""
   if {$img_name != "void.png"} {
     append strm " onclic=\"\$('${objName}_icon_of_$id').attr('src', './Comets/hierarchy/PM_Ps/HTML/images/plus.png'); \""
    }
 append strm "/> " $name "\n"
 
 append strm $dec "<div id=\"${objName}_daughters_of_$id\" style=\"margin-left: [expr $level * 10]px;\">\n"
 foreach d $L_daughters {
   this Recurse_display strm "$dec  " $d $level
  }
 append strm $dec "</div>\n" $dec "</div>\n" 
}
