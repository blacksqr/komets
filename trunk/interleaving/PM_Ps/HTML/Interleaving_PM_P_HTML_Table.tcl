#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Interleaving_PM_P_HTML_Table PM_HTML
#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id FUI_HTML_Interleaving_Table
   set this(descr_table) "{*}"
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors Interleaving_PM_P_HTML_Table [list descr_table]

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table Render {strm_name {dec {}}} {
 upvar $strm_name strm
 
 set L_D [this get_daughters]
 
 append strm $dec <table [this Style_class] {> } "\n"
   foreach row $this(descr_table) {
     append strm $dec "  <tr>\n"
     foreach column $row {
	   lassign $row sel tx ty
         if {$tx == ""} {set tx 1}
		 if {$ty == ""} {set ty 1}
	   # We now have an element of the form <selector, [row_span, col_span]>
       append strm $dec "    <td"
	     if {$tx > 1} {append strm " colspan=\"$tx\""}
		 if {$ty > 1} {append strm " rowspan=\"$ty\""}
	   append strm ">\n"
	   foreach D [CSS++ $objName "#$objName $sel"] {
	     append strm "      $dec" [$D Render_all strm $dec]
		}
	   append strm $dec "    </td>\n"
	  }
	 append strm $dec "  </tr>\n"
    }

 append strm "$dec</table>\n"
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table maj_interleaved_daughters {} {}

