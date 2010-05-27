#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Interleaving_PM_P_HTML_Table PM_HTML
#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id FUI_HTML_Interleaving_Table
   set this(descr_table) "{*}"
   set this(mode)        "use"
   set this(L_colors)    [list {1 0 0} \
                               {0 1 0} \
							   {0 0 1} \
							   {1 1 0} \
							   {1 0 1} \
							   {0 1 1} \
							   {0.5 0.5 0.5} \
                         ]
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors Interleaving_PM_P_HTML_Table [list descr_table mode]

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table Render {strm_name {dec {}}} {
 upvar $strm_name strm
 
 if {[this get_mode] == "edition"} {return [this Render_edition strm $dec]}
 
 set L_D [list]
 
 append strm $dec <table [this Style_class] {> } "\n"
   foreach row $this(descr_table) {
     append strm $dec "  <tr>\n"
     foreach column $row {
	   lassign $column sel tx ty
         if {$tx == ""} {set tx 1}
		 if {$ty == ""} {set ty 1}
	   # We now have an element of the form <selector, [row_span, col_span]>
       append strm $dec "    <td valign=\"top\""
	     if {$tx > 1} {append strm " colspan=\"$tx\""}
		 if {$ty > 1} {append strm " rowspan=\"$ty\""}
	   append strm ">\n"
	   foreach D [CSS++ $objName "#$objName > * > $sel"] {
	     set do_render 1
	     if {$sel == "*" && [lsearch $L_D $D] >= 0} {set do_render 0}
		 if {$do_render} {
	       append strm "      $dec"
		   $D Render_all strm $dec
		   lappend L_D $D
		  } 
		}
	   append strm $dec "    </td>\n"
	  }
	 append strm $dec "  </tr>\n"
    }

 append strm "$dec</table>\n"
}
Trace Interleaving_PM_P_HTML_Table Render

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table maj_interleaved_daughters {} {}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table Render_edition {strm_name dec} {
 upvar $strm_name strm
 
 append strm $dec "<table id=\"Meta_UI_of_$objName\">\n"
   append strm $dec "  <tr>\n"
   append strm $dec "  <td>\n"
     this Render_edition_daughers strm "$dec    "
   append strm $dec "  </td>\n"
   append strm $dec "  <td valign=\"top\">\n"
     this Render_edition_layout   strm "$dec    "
   append strm $dec "  </td>\n"
   append strm $dec "</tr>"
 append strm $dec "</table>\n"
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table Render_edition_daughers {strm_name dec} {
 upvar $strm_name strm
 
 append strm $dec "<table id=\"Elements_of_$objName\">\n"
   set i 0
   foreach D [[this get_LC] get_out_daughters] {
     append strm $dec "  <tr>\n"
	 lassign [lindex $this(L_colors) $i] r g b
	 this Render_edition_descendant $D strm $dec [expr int(255*$r)] [expr int(255*$g)] [expr int(255*$b)]
	 append strm $dec "  </tr>\n"
	 incr i
    }
 append strm $dec "</table>\n"
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table Render_edition_descendant {LC strm_name dec r g b} {
 upvar $strm_name strm
 
 append strm $dec "<td style=\"text-align : right;\">[$LC get_name]</td>\n"
 append strm $dec "<td><div style=\"background-color: rgb($r,$g,$b); padding : 16px; border: solid black 1px;\"></div></td>\n"
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table Render_edition_layout   {strm_name dec} {
 upvar $strm_name strm
 
 set L_D [[this get_LC] get_out_daughters]
 
 append strm $dec "<script language=\"JavaScript\" type=\"text/javascript\">\n"
 append strm $dec "  function Display_config_of_cell(i, j, sel) {\n"
 append strm $dec "    var root = '${objName}_edit_cell';\n"
 append strm $dec "    \$('#'+root).remove();\n"
 append strm $dec "    \$('body').append(\""  [this load_HTML_from_file_for_JS [Comet_files_root]Comets/interleaving/PM_Ps/HTML/Interleaving_PM_P_HTML_Table_edit_cell.html  [list {$ID} ${objName}_edit_cell {$NB_LINES} 1 {$NB_COLMUNS} 1]]  "\");\n"
 append strm $dec "    \$('#'+root).dialog();\n"
 append strm $dec "   }\n"
 append strm $dec "</script>\n"
 
 append strm $dec "<table id=\"Layout_of_$objName\" style=\"border: solid black 1px;\">\n"
   set i 0
   foreach row $this(descr_table) {
     append strm $dec "  <tr>\n"
	 set j 0
	 foreach column $row {
	   lassign $column sel tx ty
         if {$tx == ""} {set tx 1}
		 if {$ty == ""} {set ty 1}
	   set D [CSS++ $objName "#$objName > * > $sel"]
	   if {[llength $D] > 1} {
	     puts "WARNING in $objName Interleaving_PM_P_HTML_Table::Render_edition_layout"
		 puts "  We have to deal with multiple answer for selector $sel"
		 set D [lindex $D 0]
	    }
	   lassign [lindex $this(L_colors) [lsearch $L_D [$D get_LC]]] r g b
	   if {$r == ""} {
	     set r 255; set b 255; set g 255
		 puts "WARNING in $objName Interleaving_PM_P_HTML_Table::Render_edition_layout"
		 puts "  $D not found in the list of daughters..."
		} else {set r [expr int(255*$r)] 
			    set g [expr int(255*$g)] 
			    set b [expr int(255*$b)]
			   }
	   
	   # We now have an element of the form <selector, [row_span, col_span]>
       append strm $dec "    <td valign=\"top\" style=\"background-color: rgb($r,$g,$b); padding: 16px; border: solid black 1px;\""
       append strm $dec " onclick=\"Display_config_of_cell($i, $j, '$sel');\""
	     if {$tx > 1} {append strm " colspan=\"$tx\""}
		 if {$ty > 1} {append strm " rowspan=\"$ty\""}
	   append strm "></td>\n"
	   incr j
	  }
	 append strm $dec "  </tr>\n"
	 incr i
    }
 append strm $dec "</table>\n"
 
 append strm "<style type=\"text/css\">\n"
 append strm "#CometEdition_PM_P_U_basic_HTML___display_L_GDD_FUI div.GDD_FUI {margin-left: 20px;}"
 append strm "#CometEdition_PM_P_U_basic_HTML___display_L_GDD_FUI div.GDD_FUI:hover {background: rgb(255,255,64); border: solid black 1px;}"
 append strm "</style>"

}

