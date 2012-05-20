#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit PM_HTML Physical_model
#___________________________________________________________________________________________________________________________________________
method PM_HTML constructor {name descr args} {
 this inherited $name $descr
 set this(root) ""
 set ptf [$this(cou) get_ptf]
 $ptf maj Ptf_HTML

 set this(L_tags)          {}
 set this(embeded_style)   {}
 set this(html_style)      {}
 set this(after_render_js) [dict create]
 
 set this(id_for_style)  $objName

 this set_cmd_placement      ""
 this set_prim_handle        ""
 this set_root_for_daughters ""
 
 this set_prim_handle        $objName
 this set_root_for_daughters $objName
  
 set this(AJAX_id_for_daughters) $objName

 set class(mark) 0
 
 set this(PM_root) ""
 
 if {![info exists class(enable_AJAX_UPDATE)]} {set class(enable_AJAX_UPDATE) 1}
 
# eval "$objName configure $args"
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML get_after_render_js {key} {if {$key == ""} {return $this(after_render_js)} else {return [dict get $this(after_render_js) $key]}}

#___________________________________________________________________________________________________________________________________________
method PM_HTML set_after_render_js {key js_cmd} {dict set this(after_render_js) $key $js_cmd}

#___________________________________________________________________________________________________________________________________________
method PM_HTML unset_after_render_js {key} {dict unset this(after_render_js) $key}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method PM_HTML load_HTML_from_file        {file_name L_maps} {
 set   f [open $file_name r]
 set rep [string map $L_maps [read $f]]
 close $f
 
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML load_HTML_from_file_for_JS {file_name L_maps} {
 set   f [open $file_name r]
 set rep [string map [list "\n" "" "\t" "" "\"" "\\\""] [read $f]]
 close $f

 return [string map $L_maps $rep]
}

#___________________________________________________________________________________________________________________________________________
#method PM_HTML get_mark {}  {return $class(mark)}
#method PM_HTML set_mark {m} {set class(mark) $m}

Generate_List_accessor PM_HTML L_tags L_tags
Generate_accessors     PM_HTML [list AJAX_id_for_daughters id_for_style embeded_style]

#___________________________________________________________________________________________________________________________________________
method PM_HTML get_class_enable_AJAX_UPDATE { } {return $class(enable_AJAX_UPDATE)}
method PM_HTML set_class_enable_AJAX_UPDATE {v} {set class(enable_AJAX_UPDATE) $v}

#___________________________________________________________________________________________________________________________________________
method PM_HTML HTML_mouse_event {event_L} {
 lassign $event_L event L
 
 set L_rep [list]
 
 foreach e $L {
   if {[gmlObject info exists object $e]} {
     if {[lsearch [gmlObject info classes $e] Physical_model] >= 0} {
	   lappend L_rep $e
	  }
    }
  }
  
 this HTML_element_selected $event $L_rep
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML HTML_element_selected {event L_PM} {}

#___________________________________________________________________________________________________________________________________________
Manage_CallbackList PM_HTML [list HTML_element_selected] end

#___________________________________________________________________________________________________________________________________________
method PM_HTML Catch_mouse_event {event return_value {id {}}} {
 if {$id == ""} {set id "#$objName"}
 set cmd "\$('$id').attr('$event', \"javascript:mouseEventHandler(event, '$objName'); return $return_value;\" );"
 this Concat_update $objName Catch_mouse_event $cmd
 
 this Subscribe_to_Render_post_JS Catch_mouse_event_$objName [this Translate_JS_for_subscribe cmd]
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML get_id_for_style {{id {}}} {
 if {$id == ""} {return $this(id_for_style)} else {return $id}
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML Encode_param_for_JS {txt} {
 set    rep "\""
   set txt [string map [list {\"} %GUILLEMETS% "\"" {\"} "\n" {\n}] $txt]
   append rep [string map [list %GUILLEMETS% {\\\"}] $txt]
 append rep "\""
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML Reconnect {PMD} {
 set pos [lsearch $this(L_daughters) $PMD]
 if {$pos == -1} {return}
 set this(L_daughters) [lreplace $this(L_daughters) $pos $pos]
 lappend this(L_daughters) $PMD
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML Show_elements_prims {b L_prims} {
 #puts "$objName PM_HTML::Show_elements_prims $b {$L_prims}"
 if {[string equal $L_prims ""]} {set L_prims $objName}
# Puts some kinds of embeded style in Render_all...
 set Lr [split $this(embeded_style) "\n"]
 set this(embeded_style) ""
 foreach r $Lr {
   set found 0
   foreach p $L_prims {
     if {[string equal "#$p" [lindex $r 0]]} {set found 1; break}
	}
   if {!$found} {append this(embeded_style) $r "\n"}
  }
  
 set cmd ""

 if {$b == 0} {
   foreach p $L_prims {
						append this(embeded_style) "#$p { display :none; }"
						append cmd "\$(\"#$p\").css({ display : \"none\" });\n"
                      }
  } else {foreach p $L_prims {
								append cmd "\$(\"#$p\").css({ display : \"block\" });\n"
							 }
         }
 set root [this get_L_roots]
 #puts $cmd
 if {[lsearch [gmlObject info classes $root] PhysicalHTML_root] != -1} { $root Concat_update $L_prims "hideshow$L_prims" $cmd }
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML get_width  {{PM {}}} {return -1}
method PM_HTML get_height {{PM {}}} {return -1}
#___________________________________________________________________________________________________________________________________________
method PM_HTML Adequacy {context {force_eval_ctx 0}} {return -1}

#___________________________________________________________________________________________________________________________________________
method PM_HTML Render_daughters {strm_name {dec {}}} {
 upvar $strm_name strm
 foreach elmt [this get_daughters] {
   $elmt Render_all strm $dec
  }
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML Render_all {strm_name {dec {}}} {
 upvar $strm_name strm
 set nb_tags [llength $this(L_tags)]
 
 if {![string equal $this(embeded_style) ""]} {
   append strm $dec {<style media="all" type="text/css"><!--} "\n"
   append strm      $this(embeded_style)
   append strm $dec {--></style>} "\n"
  }
 if {$nb_tags>0} {
   append strm $dec
   foreach t $this(L_tags) {append strm "<$t>"}
   append strm "\n"
     this Render strm $dec
   append strm $dec
   for {set i [expr $nb_tags-1]} {$i>=0} {incr i -1} {set t [lindex $this(L_tags) $i]; append strm "</$t>"}
   append strm "\n"
  } else {this Render strm $dec}
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML Render {strm_name {dec {}}} {
 upvar $strm_name strm
 this MAGELLAN_Designer_constraint
 this Render_daughters strm $dec
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML Render_post_JS {strm_name {dec {}}} {
 upvar $strm_name strm
 dict for {k v} $this(after_render_js) {append strm $v "\n"}
 this Render_daughters_post_JS strm $dec
}

#___________________________________________________________________________________________________________________________________________
Manage_CallbackList PM_HTML Render_post_JS end strm

#___________________________________________________________________________________________________________________________________________
method PM_HTML Render_daughters_post_JS {strm_name {dec {}}} {
 upvar $strm_name strm
 foreach d [this get_daughters] {
   $d Render_post_JS strm $dec
  }
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML Render_JS {strm_name mark {dec {}}} {
 upvar $strm_name strm
 this MAGELLAN_Designer_constraint
 this Render_daughters_JS strm $mark $dec
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML Render_daughters_JS {strm_name mark {dec {}}} {
 upvar $strm_name strm
 foreach PM [this get_daughters] {
   $PM Render_JS strm $mark $dec
  }
}

#_________________________________________________________________________________________________________
method PM_HTML get_or_create_prims {root} {return {}}

#_________________________________________________________________________________________________________
method PM_HTML Add_prim_daughter {c Lprims {index -1}} {this inherited $c $Lprims $index; return 1}
method PM_HTML Add_prim_mother   {c Lprims {index -1}} {this inherited $c $Lprims $index; return 1}

#_________________________________________________________________________________________________________
method PM_HTML Style_class {} {
 #set c [this get_style_class]
 #set    rep " class=\"$this(names_obj) $this(base_classes) $c\" id=\"$objName\" style=\""
 set    rep " class=\"$objName [this get_LM] [this get_LC]\" id=\"$objName\" style=\"[this get_html_style_in_text]\" "
 return $rep
}

#_________________________________________________________________________________________________________
method PM_HTML get_html_style_in_text {{id {}}} {
 set rep ""
 foreach {var val} [this get_html_style $id] {
	append rep $var ": " $val ";"
  }  
 return $rep
}

#_________________________________________________________________________________________________________
method PM_HTML Do_prims_still_exist {} {return 1}

#___________________________________________________________________________________________________________________________________________
method PM_HTML AJAX_annalyse_msg {msg_name pos L_name} {
 upvar $msg_name msg
 upvar $L_name   L

 set t [string length $msg]
 #puts "In $objName AJAX_annalyse_msg :\n$msg"
 while {$pos < $t} {
  # Variable
  set next [string first { } $msg $pos]
     set t_var [string range $msg $pos [expr $next-1]]
     #puts "t_var : $t_var"
   set pos [expr $next+1]
     set var [string range $msg $pos [expr $pos+$t_var-1]]
     #puts "var   : $var"
   set pos [expr $pos+$t_var+1]
  # Valeur
   set next [string first { } $msg $pos]
     set t_val [string range $msg $pos [expr $next-1]]
     #puts "t_val : $t_val"
   set pos [expr $next+1]
     set val [string range $msg $pos [expr $pos+$t_val-1]]
     #puts "val   : $val"
   set pos [expr $pos+$t_val+1]
 
   lappend L [list $var $val]
  }
  

}

#_________________________________________________________________________________________________________
method PM_HTML get_PM_root {  } {return $this(PM_root)}

#_________________________________________________________________________________________________________
method PM_HTML set_PM_root {PM} {
 set this(PM_root) $PM
 foreach d [this get_daughters] {
   if {[catch {if {[$d get_PM_root] != $PM} {$d set_PM_root $PM}} err]} {
     #puts "___________ set_PM_root non implemented for $d set_PM_root {$PM}"
	}
  }
}

#_________________________________________________________________________________________________________
method PM_HTML Do_in_root {cmd} {
 if {$this(PM_root) != ""} {
   eval "$this(PM_root) $cmd"
  }
  
#XXX set root [this get_L_roots] 
#XXX if {[lsearch [gmlObject info classes $root] PhysicalHTML_root] != -1} {
#XXX     eval "$root $cmd"
#XXX }
}

#_________________________________________________________________________________________________________
method PM_HTML Sub_daughter {e} {
 set rep [this inherited $e]
   if {$rep} {catch "$e set_PM_root {}"}
   if {$class(enable_AJAX_UPDATE)} {this Do_in_root "Add_L_PM_to_sub $e"}
 return $rep
}

#_________________________________________________________________________________________________________
method PM_HTML Add_daughter {e {index -1}} {
 set rep [this inherited $e $index]
   this set_PM_root $this(PM_root)
   if {$class(enable_AJAX_UPDATE)} {this Do_in_root "Add_L_PM_to_add $e"}
 return $rep
}

#_________________________________________________________________________________________________________
method PM_HTML set_html_style {lstyles {id {}}} {
 set Lsub [list ]
 foreach {var val} [this get_html_style $id] {
   lappend Lsub $var
  }
 this sub_html_style $Lsub    $id
 this add_html_style $lstyles $id
}

#_________________________________________________________________________________________________________
method PM_HTML get_html_style {{id {}}} {
 set L [list]
 set size [string length html_style$id,]
 foreach {var val} [array get this html_style$id,*] {lappend L [string range $var $size end] $val; }
 return $L
}

#_________________________________________________________________________________________________________
method PM_HTML add_html_style {L_var_val {id {}}} {
 foreach {var val} $L_var_val {
   set this(html_style$id,$var) $val
  }
 this Send_updated_style $id
}

#_________________________________________________________________________________________________________
method PM_HTML sub_html_style {L_vars {id {}}} {
 foreach var $L_vars {
	unset this(html_style$id,$var)
  }
 this Send_updated_style $id
}

#_________________________________________________________________________________________________________
method PM_HTML Send_updated_style {{id {}}} {
 #set root [this get_L_roots] 
 set root $this(PM_root)
 
 if {$class(enable_AJAX_UPDATE) && $root != ""} {
   set id_style [this get_id_for_style $id]
   set    cmd  "\$(\"#${id_style}\").removeAttr(\"style\");\n"
   append cmd  "\$(\"#${id_style}\").css({"
   foreach {var val} [this get_html_style $id] {
	 append cmd \' $var \' " : \'" $val "\',"
	}
   if {[string index $cmd end] == ","} {set cmd [string range $cmd 0 end-1]}
   append cmd "});" "\n"
 
   $root Concat_update $objName htmlstyle$id $cmd
  } 
}

#_________________________________________________________________________________________________________
method PM_HTML Concat_update {o m cmd} {
 if {$this(PM_root) != ""} {$this(PM_root) Concat_update $o $m $cmd}
}

#_________________________________________________________________________________________________________
method PM_HTML Add_JS {e} {
 if {[gmlObject info exists object $e]} {
     set marker [clock clicks]
	 $e Render_JS      cmd $marker
	 
	 #set objNameMother [lindex [$e get_mothers] 0]

	 set pos       [lsearch [this get_daughters] $e]
	 set tailletot [llength [this get_daughters]]
	  
	 set strm {}; $e Render strm
	 set strm [$e Encode_param_for_JS $strm]
	 
	 set cmd "\$('#$e').remove();"
	 if { $tailletot-1 > $pos} {
		set objAfter [lindex [this get_daughters] [expr $pos+1]]
		set objAfter [$objAfter get_prim_handle]
		append cmd "\$($strm).insertBefore('#$objAfter');"
	  } else {set root_for_daughters [this get_root_for_daughters]
			  append cmd "\$($strm).appendTo('#$root_for_daughters');"
			 }

	 
	 
	 $e Render_post_JS cmd 
  } else {set cmd [this Sub_JS $e]}
  
 return $cmd
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML Sub_JS {e} {
 set cmd "\$('#$e').remove();"
 return $cmd
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML Drag_zone {v {id {}} {abs 1}} {
 if {$id == ""} {set id $objName}
 if {$abs} {set id "#$id"} else {set id ".$id"}
 
 if {$v} {
   set cmd        "\$('$id').draggable( {opacity: 0.7, helper: 'clone'} )"
   set cmd_enable ""
   this send_jquery_message Drag_zone_$objName "$cmd\; $cmd_enable\;"
   this Subscribe_to_Render_post_JS "${objName}_PM_HTML::Draggable" "
     append strm \"\\$cmd\\\;\"
	" UNIQUE
  } else {this UnSubscribe_to_Render_post_JS "${objName}_PM_HTML::Draggable"
          set cmd "\$('$id').draggable( 'disable' )"
		  this send_jquery_message Drag_zone_$objName "$cmd\;"
         } 
}
Trace PM_HTML Drag_zone

#___________________________________________________________________________________________________________________________________________
method PM_HTML get_Drop_zone_filters {} {
 set L_rep [list]
 foreach {filter cmd} [array get this Drop_zone,*] {
   lappend L_rep .[string range $filter 10 end]
  }
  
 return [join $L_rep ", "]
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML get_Drop_zone_cmd {} {
 set L_rep [list]
 foreach {filter cmd} [array get this Drop_zone,*] {
   lappend L_rep [string range $filter 10 end] $cmd
  }
  
 return $L_rep
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML Trigger_Drop_cmd {PM__DROP__metadata_filter} {
 lassign $PM__DROP__metadata_filter PM DROP_zone metadata_filter

 eval $this(Drop_zone,$metadata_filter)
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML Drop_zone {metadata_filter cmd {id {}} {abs 1} {activeClass {}} {hoverClass {}}} {
 if {$id == ""} {set id $objName}
 if {$abs} {set id "#$id"} else {set id ".$id"}
 
 set this(Drop_zone,$metadata_filter) $cmd
 
 set fct "\$('$id').droppable({accept: '[this get_Drop_zone_filters]', "
   if {$activeClass != ""} {append fct "activeClass: '$activeClass', "}
   if {$hoverClass  != ""} {append fct "hoverClass: '$hoverClass', "}
 append fct "drop: function(event, ui) {"
 foreach {filter cmd} [this get_Drop_zone_cmd] {
   append fct "if ( ui.draggable.hasClass( '$metadata_filter\') ) {addOutput_proc_val('${objName}__XXX__Trigger_Drop_cmd' , ui.draggable.attr('id') + ' ' + \$(this).attr('id') + ' $metadata_filter\', true);}"
  }
 append fct "}});"
 
 this send_jquery_message Drop_zone_$objName $fct
 this Subscribe_to_Render_post_JS "${objName}_PM_HTML::Drop_zone" [this Translate_JS_for_subscribe fct] UNIQUE
}
Trace PM_HTML Drop_zone

#___________________________________________________________________________________________________________________________________________
method PM_HTML Translate_JS_for_subscribe {cmd_name} {
 upvar $cmd_name cmd
 
 set cmd_subscribe ""
 foreach line [split $cmd "\n"] {
   append cmd_subscribe "append strm \"" [string map [list {$} {\$} {;} {\;} "\"" {\"} "\\" {\\}] $line] "\"\n"
  }
  
 return $cmd_subscribe
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML Resizable {v {id {}}} {
 if {$id == ""} {set id $objName}
 
 set    cmd ""
 append cmd "var parent = \$('#$id').parent();"
 append cmd "\$('#$id').resizable( {containment: parent} );\n\$('#$id').resizable( 'disable' );\n"

 if {$v} {
   append cmd "\$('#$id').resizable( 'enable' );\n"
   this Subscribe_to_Render_post_JS "${objName}_PM_HTML::Resizable" [this Translate_JS_for_subscribe cmd] UNIQUE
  } else {append cmd "\$('#$id').resizable( 'destroy' );\n"
          this UnSubscribe_to_Render_post_JS "${objName}_PM_HTML::Resizable"
         }
		 
 this send_jquery_message Rezisable_$objName $cmd
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML Draggable {{v 1}} {
 set id $objName 
 
 set    cmd ""
 append cmd "var parent = \$('#$id').parent();"
 append cmd "\$('#$id').draggable( {containment: parent} );\n\$('#$id').draggable( 'disable' );\n"

 if {$v} {
   append cmd "\$('#$id').draggable( 'enable' );\n"
   this Subscribe_to_Render_post_JS "${objName}_PM_HTML::Draggable" [this Translate_JS_for_subscribe cmd] UNIQUE
  } else {this UnSubscribe_to_Render_post_JS "${objName}_PM_HTML::Draggable"
          append cmd "\$('#$objName').draggable( 'disable' );\n"
         }
		 
 this send_jquery_message Draggable_$objName $cmd
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML DragDrop_event {type x y} {
 set cmd "\$('#$objName').${type}();"
 this send_jquery_message DragDrop_event $cmd
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML Substitute_by {PM} {
 set html_style [this get_html_style]
 set rep [this inherited $PM]
 $PM set_html_style $html_style
 
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML send_jquery_message {methode cmd} {
 if {$class(enable_AJAX_UPDATE) && $this(PM_root) != ""} {
   $this(PM_root) Concat_update $objName $methode $cmd
  }
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML HEIGHT {x} {
	this add_html_style [list "height" "$x%"]
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML WIDTH {x} {
	this add_html_style [list "width" "$x%"]	
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML bg_fg {BG_param FG_param {target {}} } {
	if {$target == "core" || $target == ""} {set id {}} else { set id ${objName}_$target ; }
	
	lassign $BG_param type bg1 bg2 angle 

	lassign $bg1 r g b a 
	lassign $bg2 r1 g1 b1 a1 
	#puts "$type : rgba([expr int(255 * $r)],[expr int(255 * $g)],[expr int(255 * $b)],$a)"
	switch -- $type {
		"uniform" { this add_html_style [list "background" "rgba([expr int(255 * $r)],[expr int(255 * $g)],[expr int(255 * $b)],$a) !important"] $id }
		"gradient" {this add_html_style [list "background" "-moz-linear-gradient(${angle}deg,rgba([expr int(255 * $r)],[expr int(255 * $g)],[expr int(255 * $b)],$a), rgba([expr int(255 * $r1)],[expr int(255 * $g1)],[expr int(255 * $b1)],$a1)) !important" ]  $id }		
		default {puts stderr "bg_fg pas bon : $type" ;
		this add_html_style [list "background" "rgba(128,0,128,0.5) /*erreur*/ !important"] $id }		
	}
	lassign $FG_param r g b a  
	this add_html_style [list "color" "rgba([expr int(255 * $r)],[expr int(255 * $g)],[expr int(255 * $b)],$a) !important"] $id 
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML enrich {LC} {
	U_encapsulator_PM $objName "CometContainer(, ${LC}(), \$obj())" 
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML Reorder {v} {
	if {[lsearch [this get_MAGELLAN_Designer_constraint] FIXED_ORDER] > -1} {return}
	set L_reord [[this get_LC] get_out_daughters]
	set L_reord [MAGELLAN__PERMUTATION $v $L_reord]
	this set_L_display_order $L_reord
}
# U_encapsulator_PM CPool_COMET_55_PM_P_17 {CometContainer(, CPool_COMET_72 ,$obj)}

#___________________________________________________________________________________________________________________________________________
method PM_HTML Block {t} {
	this add_html_style [list "display" "block"]	
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML Column {nb} {
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML Border {width style color {radius {}}  {target {}}} {
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML MAGELLAN_Designer_constraint {} {

	foreach constraint [[this get_LC] get_MAGELLAN_Designer_constraint] {
		if {[lindex $constraint 0] == "LIST"} {
			foreach daugther [this get_out_daughters] {
				$daugther Block 1
			}
		}
	}
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML Float {position} {
	if {$position == "center" } {
		this add_html_style [list "margin" "auto"]	
	} else {
		this add_html_style [list "float" $position]	
	}
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML Float_daughters {position} {
	this add_html_style [list "overflow" "auto"]
	foreach daugther [this get_out_daughters] {
		$daugther Float $position
	}
}
