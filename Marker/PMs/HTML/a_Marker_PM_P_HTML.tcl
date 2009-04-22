#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Marker_PM_P_HTML PM_HTML

#___________________________________________________________________________________________________________________________________________
method Marker_PM_P_HTML constructor {name descr args} {
 this inherited $name $descr
   set this(next_val) {}
 set this(HTML_var) ${objName}__XXX__prim_set_mark
 set this(HTML_val) 1
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors Marker_PM_P_HTML [list next_val]
method Marker_PM_P_HTML init_next_val    {v} {set this(next_val) 0}
method Marker_PM_P_HTML process_next_val {v} {if {$this(next_val) != [this get_mark]} {[this get_LC] set_mark $this(next_val)}}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Marker_PM_P_HTML [L_methodes_set_Marker] {}          {}
Methodes_get_LC Marker_PM_P_HTML [L_methodes_get_Marker] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method Marker_PM_P_HTML get_HTML_var { } {return $this(HTML_var)}
method Marker_PM_P_HTML set_HTML_var {v} {set this(HTML_var) $v}

#___________________________________________________________________________________________________________________________________________
method Marker_PM_P_HTML get_HTML_val { } {return $this(HTML_val)}
method Marker_PM_P_HTML set_HTML_val {v} {set this(HTML_val) $v}

#___________________________________________________________________________________________________________________________________________
method Marker_PM_P_HTML prim_set_mark {v} {
 set this(next_val) 1
}

#___________________________________________________________________________________________________________________________________________
method Marker_PM_P_HTML Render {strm_name {dec {}}} {
 upvar $strm_name strm

 append strm $dec "<span id=\"$objName\">"
 if {[string equal ${objName}__XXX__prim_set_mark [this get_HTML_var]]} {
   append strm $dec {<input type="hidden" name="} ${objName}__XXX__init_next_val {"    value="}  {" />} "\n"
     this Render_prim strm "$dec  "
   append strm $dec {<input type="hidden" name="} ${objName}__XXX__process_next_val {" value="}  {" />} "\n"
  } else {this Render_prim strm "$dec  "
         }

 append strm $dec "  <span id=\"${objName}_handle_for_daughters\">"
   this Render_daughters strm "$dec    "
 append strm $dec "  </span>"
 append strm $dec "</span>"
}

#___________________________________________________________________________________________________________________________________________
method Marker_PM_P_HTML Render_prim {strm_name {dec {}}} {}

