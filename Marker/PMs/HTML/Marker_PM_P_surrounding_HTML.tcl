#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Marker_PM_P_surrounding_HTML PM_HTML

#___________________________________________________________________________________________________________________________________________
method Marker_PM_P_surrounding_HTML constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id FUI_Marker_PM_P_surrounding_HTML

   set this(old_mark)   0
   set this(padding_px) 15
   
   set this(L_colors) [list white green]
   
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method Marker_PM_P_surrounding_HTML dispose {} {
 this inherited
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Marker_PM_P_surrounding_HTML [L_methodes_set_Marker] {}          {}
Methodes_get_LC Marker_PM_P_surrounding_HTML [L_methodes_get_Marker] {$this(FC)}

Generate_PM_setters Marker_PM_P_surrounding_HTML [L_methodes_CometRE_Marker]

#___________________________________________________________________________________________________________________________________________
method Marker_PM_P_surrounding_HTML maj_choices {} {}

#___________________________________________________________________________________________________________________________________________
Generate_accessors Marker_PM_P_surrounding_HTML [list padding_px color_selected color_unselected]

#___________________________________________________________________________________________________________________________________________
method Marker_PM_P_surrounding_HTML set_mark {v} {
 if {$v != $this(old_mark)} {
   if {$this(PM_root) != ""} {
     set cmd  "\$(\"#${objName}_for_padding\").css({padding: '[this get_padding_px]px', background: '[lindex $this(L_colors) $v]'});"
     $this(PM_root) Concat_update $objName set_mark $cmd
    }   
   set this(old_mark) $v
  }
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method Marker_PM_P_surrounding_HTML switch_mark {args} {
 this prim_set_mark [expr 1 - [this get_mark]]
}

#___________________________________________________________________________________________________________________________________________
method Marker_PM_P_surrounding_HTML Render {strm_name {dec {}}} {
 upvar $strm_name strm

 append strm $dec "<div [this Style_class]>"

 append strm $dec "  <div id=\"${objName}_for_padding\" style=\"padding : [this get_padding_px]px; background : [lindex $this(L_colors) [this get_mark]];\" onclick=\"addOutput_proc_val('${objName}__XXX__switch_mark', '', true);\">"
 append strm $dec "  <div id=\"${objName}_handle_for_daughters\" style=\"background : white; border : solid gray 1px;\">"
   this Render_daughters strm "$dec    "
 append strm $dec "  </div>"
 append strm $dec "  </div>"
 
 append strm $dec "</div>"
}

