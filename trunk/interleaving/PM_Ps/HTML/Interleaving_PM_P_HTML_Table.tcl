#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Interleaving_PM_P_HTML_Table PM_HTML
#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id FUI_HTML_Interleaving_Table
   set this(descr_table) [list [list *]]
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
Generate_accessors Interleaving_PM_P_HTML_Table [list descr_table]

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table Render {strm_name {dec {}}} {
 upvar $strm_name strm
 
 append strm $dec <div [this Style_class] {> } "\n"
 append strm $dec "<img id=\"goto_meta_UI_of_$objName\" onclick=\"addOutput_proc_val('${objName}__XXX__Display_meta_UI', '1', true);\" style=\"position: absolute; z-index: 1;\" src=\"Comets/models/HTML/tools.png\"></img>\n"
 append strm $dec "<table style=\"position: absolute; z-index: 0;\">\n"
   this Render_table strm $dec
 append strm $dec </table> "\n"
 append strm $dec </div> "\n"
}
Trace Interleaving_PM_P_HTML_Table Render

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table Update_layout {b} {
 if {$b} {
   set    cmd "\$('#$objName > table').html("
     set strm ""
	 this Render_table strm ""
     append cmd [this Encode_param_for_JS $strm] ");"
	 this Render_JS      cmd ""
	 this Render_post_JS cmd ""
	 
	 this Concat_update $objName Update_layout $cmd
  }
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table Render_table {strm_name {dec {}}} {
 upvar $strm_name strm

 set L_D [list]
 
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
	   if {$sel != ""} {set L_D_CSS [CSS++ $objName "#$objName > * > $sel"]} else {set L_D_CSS [list]}
	   foreach D $L_D_CSS {
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
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table maj_interleaved_daughters {} {}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table Display_meta_UI {b} {
 set    cmd "\$('#Meta_UI_of_$objName').remove();"
 if {$b} {
   set strm ""
   this Render_edition strm ""; set strm [this Encode_param_for_JS $strm]; puts "___________\n\n\n$strm\n\n\n"
   append cmd "\$('#$objName').append(" $strm ");"
   append cmd "\$('#Meta_UI_of_$objName').dialog();"
   this Render_JS_meta_UI cmd ""
  } 
 
 this Concat_update $objName Display_meta_UI $cmd
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table Render_edition {strm_name dec} {
 upvar $strm_name strm
 
 append strm $dec "<div title=\"Meta UI of [[this get_LC] get_name]\" id=\"Meta_UI_of_$objName\">\n"
 append strm $dec "<table>\n"
   append strm $dec "  <tr>\n"
   append strm $dec "  <td>\n"
     this Render_edition_daughers strm "$dec    "
   append strm $dec "  </td>\n"
   append strm $dec "  <td valign=\"top\">\n"
     this Render_edition_layout   strm "$dec    "
   append strm $dec "  </td>\n"
   append strm $dec "</tr>"
 append strm $dec "</table>\n"
 
 append strm $dec "<div style=\"margin-top: 10px; text-align: right;\">\n"
 append strm $dec "<input type=\"button\" value=\"Apply\" onclick=\"addOutput_proc_val('${objName}__XXX__Update_layout', '1', true);\"/>\n"
 append strm $dec "</div>\n"
 append strm $dec "</div>\n"
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table Render_edition_daughers {strm_name dec} {
 upvar $strm_name strm
 
 append strm $dec "<table id=\"Elements_of_$objName\">\n"
   set i 0
   foreach D [[this get_LC] get_out_daughters] {
     append strm $dec "  <tr>\n"
	 lassign [lindex $this(L_colors) $i] r g b
	 this Render_edition_descendant $D strm $dec "${objName}_daughter_$D" [expr int(255*$r)] [expr int(255*$g)] [expr int(255*$b)]
	 append strm $dec "  </tr>\n"
	 incr i
    }
 append strm $dec "</table>\n"
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table Render_edition_descendant {LC strm_name dec id r g b} {
 upvar $strm_name strm
 
 append strm $dec "<td style=\"text-align : right;\">[$LC get_name]</td>\n"
 append strm $dec "<td><div id=\"$id\" class=\"WS_$objName\" style=\"background-color: rgb($r,$g,$b); padding : 16px; border: solid black 1px;\"></div></td>\n"
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table Render_edition_layout   {strm_name dec} {
 upvar $strm_name strm
 
 append strm $dec "<script language=\"JavaScript\" type=\"text/javascript\">\n"
 append strm $dec "  function Display_config_of_cell(i, j, sel) {\n"
 append strm $dec "    var root = '${objName}_edit_cell';\n"
 append strm $dec "    \$('#'+root).remove();\n"
 append strm $dec "    \$('body').append(\""  [this load_HTML_from_file_for_JS [Comet_files_root]Comets/interleaving/PM_Ps/HTML/Interleaving_PM_P_HTML_Table_edit_cell.html  [list {$ID} "${objName}_edit_cell" {$NB_LINES} 1 {$NB_COLMUNS} 1 {$ON_CLICK_OK} "var root = '${objName}_edit_cell'; addOutput_proc_val('${objName}__XXX__Update_size', \$('#'+root+' .nb_lines').val() + ' ' + \$('#'+root+' .nb_columns').val() + ' ' + \$('#' + root + ' .line').val() + ' ' + \$('#' + root + ' .column').val() + ' \{' + \$('#' + root+ ' .sel').val() + '\}', true);"]]  "\");\n"
 append strm $dec "    \$('#' + root+ ' .line').val(i);\n"
 append strm $dec "    \$('#' + root+ ' .column').val(j);\n"
 append strm $dec "    \$('#' + root+ ' .sel').val(sel);\n"
 append strm $dec "    var cell = '${objName}_cell_' + i + '_' + j;\n"
 append strm $dec "    \$('#' + root + ' .nb_columns').val( \$('#'+cell).attr('colspan') );\n"
 append strm $dec "    \$('#' + root + ' .nb_lines'  ).val( \$('#'+cell).attr('rowspan') );\n"
 append strm $dec "    \$('#'+root).dialog();\n"
 append strm $dec "   }\n"
 append strm $dec "</script>\n"
 
 append strm $dec "<div id=\"Table_layout_root_$objName\">\n"
   this Update_edition_layout strm $dec 
 append strm $dec "</div>\n"
 
 append strm "<style media=\"all\" type=\"text/css\">\n"
 append strm "#CometEdition_PM_P_U_basic_HTML___display_L_GDD_FUI div.GDD_FUI {margin-left: 20px;}\n"
 append strm "#CometEdition_PM_P_U_basic_HTML___display_L_GDD_FUI div.GDD_FUI:hover {background: rgb(255,255,64); border: solid black 1px;}\n"
 append strm "#Layout_of_$objName .layout_cell {border: solid black 2px;}\n"
 append strm "#Layout_of_$objName *.active_drop_$objName {border: dashed black 2px;}\n"
 append strm "#Layout_of_$objName *.hoverClass_$objName  {border: solid black 2px;}\n"
 append strm "</style>\n"

}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table Render_JS_meta_UI {strm_name {dec {}}} {
 upvar $strm_name strm
 
 append strm $dec "\$('#Layout_of_$objName .layout_cell').droppable({accept: '.WS_$objName', activeClass: 'active_drop_$objName', hoverClass: 'hoverClass_$objName', drop: function(event, ui) {addOutput_proc_val('${objName}__XXX__Drop_cell' , ui.draggable.attr('id') + ' ' + \$(this).attr('id'), true);}});\n"
 append strm $dec "\$('#Elements_of_$objName .WS_$objName').draggable({opacity: 0.7, helper: 'clone'});\n"
 
 set num_line 0
 foreach row $this(descr_table) {
   set num_col 0
   foreach col $row {
     lassign $col sel x y
	 if {$x == ""} {set x 1}
     set id ${objName}_cell_${num_line}_${num_col}
	 append strm $dec "\$('#$id').attr('onContextMenu', \"javascript:mouseEventHandler(event, '$objName'); return false;\" );\n"
	 incr num_col $x
	}
   incr num_line
  }
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table HTML_mouse_event {event_L} {
 lassign $event_L event L
 set cell [lindex $L 0]
 
 lassign [split [string range $cell [string length ${objName}_cell_div_] end] "_"] l c
 set cell ${objName}_cell_${l}_${c}
 
 set root root_cell_context_menu_$objName
 set    cmd "\$('#$root').remove();\n"
 append cmd "\$('#$cell').append(\"" [this load_HTML_from_file_for_JS [Comet_files_root]Comets/interleaving/PM_Ps/HTML/root_cell_context_menu.html \
                                     [list {$ID} $root \
									       {$LINE_BEFORE} "addOutput_proc_val('${objName}__XXX__Insert_line'  , 'before ' + \$('#$root .line').val()  , true);" \
										   {$LINE_AFTER}  "addOutput_proc_val('${objName}__XXX__Insert_line'  , 'after '  + \$('#$root .line').val()  , true);" \
										   {$COL_BEFORE}  "addOutput_proc_val('${objName}__XXX__Insert_column', 'before ' + \$('#$root .column').val(), true);" \
										   {$COL_AFTER}   "addOutput_proc_val('${objName}__XXX__Insert_column', 'after '  + \$('#$root .column').val(), true);" \
										   {$DEL_CELL}    "addOutput_proc_val('${objName}__XXX__Delete_cell'  , \$('#$root .line').val() + ' ' + \$('#$root .column').val(), true);" \
										   {$DEL_LINE}    "addOutput_proc_val('${objName}__XXX__Delete_line'  , \$('#$root .line').val(), true);" \
										   {$DEL_COLUMN}  "addOutput_proc_val('${objName}__XXX__Delete_column', \$('#$root .column').val(), true);" \
										   {$ADD_CELL_BEFORE} "addOutput_proc_val('${objName}__XXX__Add_cell', 'before ' + \$('#$root .line').val() + ' ' + \$('#$root .column').val(), true);" \
										   {$ADD_CELL_AFTER}  "addOutput_proc_val('${objName}__XXX__Add_cell', 'after '  + \$('#$root .line').val() + ' ' + \$('#$root .column').val(), true);" \
									 ]] "\");\n"
 append cmd "\$('#$root .line'  ).val('$l');\n"
 append cmd "\$('#$root .column').val('$c');\n"
 this Concat_update $objName display_cell_context_menu $cmd
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table get_table_dims {} {
 set max_col 0
 foreach row $this(descr_table) {
   set nb_col 0
   foreach col $row {
     lassign $col sel x y; if {$x == ""} {set x 1}
	 incr nb_col $x
	}
   if {$nb_col > $max_col} {set max_col $nb_col}
  }
 
 return [list [llength $this(descr_table)] $max_col]
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table Insert_line {pos_num} {
 lassign $pos_num pos num
 lassign [this get_table_dims] nb_l nb_c
 if {$pos == "after"} {incr num}
 
 set new_line [list]; for {set i 0} {$i < $nb_c} {incr i} {lappend new_line [list "" "" ""]}
 set this(descr_table) [linsert $this(descr_table) $num $new_line]
 
 # Send the AJAX update
 this JS_Update_edition_layout
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table Insert_column {pos_num} {
 lassign $pos_num pos num
 lassign [this get_table_dims] nb_l nb_c
 if {$pos == "after"} {incr num}
 
 set new_descr [list]
 foreach row $this(descr_table) {
   lappend new_descr [linsert $row $num [list "" "" ""]]
  }
 
 set this(descr_table) $new_descr
 # Send the AJAX update
 this JS_Update_edition_layout
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table Add_cell {pos_l_c} {
 lassign $pos_l_c pos l c
 if {$pos == "after"} {incr c}
 
 set row [lindex $this(descr_table) $l]
 set i 0; set pos 0
 while {$i < $c} {
   lassign [lindex $row $i] sel x y; if {$x == ""} {set x 1}
   incr i $x; incr pos
  }
 set new_row           [linsert $row $pos [list "" "" ""]]
 set this(descr_table) [lreplace $this(descr_table) $l $l $new_row]
 
 # Send the AJAX update
 this JS_Update_edition_layout
}
Trace Interleaving_PM_P_HTML_Table Add_cell

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table Delete_cell {l_c} {
 lassign $l_c l c
 
 set i 0; set pos 0; set row [lindex $this(descr_table) $l]
 while {$i < $c} {
   lassign [lindex $row $i] sel x y; if {$x == ""} {set x 1}
   incr i $x; incr pos
  }
 set new_line          [lreplace $row $pos $pos]
 set this(descr_table) [lreplace $this(descr_table) $l $l $new_line]

 # Send the AJAX update
 this JS_Update_edition_layout
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table Delete_line {l} {
 set this(descr_table) [lreplace $this(descr_table) $l $l]
 
 # Send the AJAX update
 this JS_Update_edition_layout
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table Delete_column {c} {
 set new_descr [list]
 
 foreach row $this(descr_table) {
   set i 0; set pos 0
   while {$i < $c} {
     lassign [lindex $row $i] sel x y; if {$x == ""} {set x 1}
	 incr i $x; incr pos
    }
   if {[llength $row] > $pos} {lappend new_descr [lreplace $row $pos $pos]} else {lappend new_descr $row}
  }
  
 set this(descr_table) $new_descr
 # Send the AJAX update
 this JS_Update_edition_layout
}


#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table Drop_cell {L_html_WS_html_cell} {
 lassign $L_html_WS_html_cell html_WS html_cell
 
 set LC_WS [string range $html_WS   [string length ${objName}_daughter_] end]
 lassign   [split [string range $html_cell [string length ${objName}_cell_div_] end] _] l c
 
 puts "Drop $LC_WS on cell <$l , ${c}>"
 
 this set_cell $l $c $LC_WS
}
Trace Interleaving_PM_P_HTML_Table Drop_cell

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table set_cell {l c WS {nb_l {}} {nb_c {}}} { 
 set new_descr [list]
 
 # Copy and complete before line $l
 for {set i 0} {$i < $l} {incr i} {lappend new_descr [lindex $this(descr_table) $i]}
 
 # Set the line l
 set new_line [list]; set line [lindex $this(descr_table) $l]
   # Copy the elements before column $c
   for {set j 0} {$j < $c} {incr j} {lappend new_line [lindex $line $j]}
   # Add the new element
   lassign [lindex $line $c] sel y x
   if {$nb_l == ""} {set nb_l $x}
   if {$nb_c == ""} {set nb_c $y}
   lappend new_line [list $WS $nb_c $nb_l]
   # Copy the rest of elements
   for {set j [expr $c + 1]} {$j < [llength $line]} {incr j} {lappend new_line [lindex $line $j]}
   # Update the description with the new line
   lappend new_descr $new_line
 
 # Copy the others lines
 for {set i [expr $l + 1]} {$i < [llength $this(descr_table)]} {incr i} {lappend new_descr [lindex $this(descr_table) $i]}
 
 # Set the new table description
 set this(descr_table) $new_descr
 
 # Send the AJAX update
 this JS_Update_edition_layout
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table JS_Update_edition_layout {} {
 # Send the AJAX update
 set strm ""
 this Update_edition_layout strm ""
 
 set    cmd "\$('#Table_layout_root_$objName').html("
 append cmd [this Encode_param_for_JS $strm] ");\n"
 this Render_post_JS cmd
 
 this Concat_update $objName Update_edition_layout $cmd
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table Update_edition_layout {strm_name dec} {
 upvar $strm_name strm

 set L_D [[this get_LC] get_out_daughters]
 
 append strm $dec "<table id=\"Layout_of_$objName\" style=\"border: solid black 1px;\">\n"
   set i 0
   foreach row $this(descr_table) {
     append strm $dec "  <tr>\n"
	 set j 0
	 foreach column $row {
	   lassign $column sel tx ty
         if {$tx == ""} {set tx 1}
		 if {$ty == ""} {set ty 1}
	   if {$sel != ""} {set D [CSS++ $objName "#$objName > * > $sel"]} else {set D ""}
	   if {[llength $D] > 1} {
	     puts "WARNING in $objName Interleaving_PM_P_HTML_Table::Render_edition_layout"
		 puts "  We have to deal with multiple answer for selector $sel"
		 set D [lindex $D 0]
	    }
	   if {$D != ""} {lassign [lindex $this(L_colors) [lsearch $L_D [$D get_LC]]] r g b} else {set r 255; set g 255; set b 255;}
	   if {$r == ""} {
	     set r 255; set b 255; set g 255
		 puts "WARNING in $objName Interleaving_PM_P_HTML_Table::Render_edition_layout"
		 puts "  $D not found in the list of daughters..."
		} else {set r [expr int(255*$r)] 
			    set g [expr int(255*$g)] 
			    set b [expr int(255*$b)]
			   }
	   
	   # We now have an element of the form <selector, [row_span, col_span]>
       append strm $dec "    <td id=\"${objName}_cell_${i}_${j}\""
	     if {$tx >= 1} {append strm " colspan=\"$tx\""}
		 if {$ty >= 1} {append strm " rowspan=\"$ty\""}
	   append strm "><div id=\"${objName}_cell_div_${i}_${j}\" onclick=\"Display_config_of_cell($i, $j, '$sel');\" class=\"layout_cell line_$i column_$j\" valign=\"top\" style=\"background-color: rgb($r,$g,$b); padding: 16px;\"></div></td>\n"
	   incr j $tx
	  }
	 append strm $dec "  </tr>\n"
	 incr i
    }
 append strm $dec "</table>\n"
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_Table Update_size {params} {
 lassign $params nb_lines nb_columns line column sel
 
 this set_cell $line $column $sel $nb_lines $nb_columns
}
