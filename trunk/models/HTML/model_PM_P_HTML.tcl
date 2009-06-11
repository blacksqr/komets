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

 set this(L_tags)        {}
 set this(embeded_style) {}
 set this(html_style)    {}

 this set_cmd_placement      ""
 this set_prim_handle        ""
 this set_root_for_daughters ""
 
 this set_prim_handle        $objName
 this set_root_for_daughters $objName
  
 set this(AJAX_id_for_daughters) $objName

 set class(mark) 0
 
# eval "$objName configure $args"
}

#___________________________________________________________________________________________________________________________________________
#method PM_HTML get_mark {}  {return $class(mark)}
#method PM_HTML set_mark {m} {set class(mark) $m}

Generate_List_accessor PM_HTML L_tags L_tags
Generate_accessors     PM_HTML AJAX_id_for_daughters

#___________________________________________________________________________________________________________________________________________
method PM_HTML Encode_param_for_JS {txt} {
 set    rep "\""
 append rep [string map [list {"} {\"} "\n" {\n}] $txt]
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
 puts "$objName PM_HTML::Show_elements_prims $b {$L_prims}"
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
 this Render_daughters strm $dec
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML Render_post_JS {strm_name {dec {}}} {
 upvar $strm_name strm
 this Render_daughters_post_JS strm $dec
}

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
 this Render_daughters_JS strm $mark $dec
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML Render_daughters_JS {strm_name mark {dec {}}} {
 upvar $strm_name strm
 foreach PM [this get_daughters] {
   puts "<$PM Render_JS>"
   $PM Render_JS strm $mark $dec
   puts "</$PM Render_JS>"; flush stdout
  }
}

#_________________________________________________________________________________________________________
method PM_HTML get_or_create_prims {root} {return {}}

#_________________________________________________________________________________________________________
method PM_HTML Add_prim_daughter {c Lprims {index -1}} {this inherited $c $Lprims $index; return 1}
method PM_HTML Add_prim_mother   {c Lprims {index -1}} {this inherited $c $Lprims $index; return 1}

#_________________________________________________________________________________________________________
method PM_HTML Style_class {} {
 set c [this get_style_class]
 set    rep " class=\"$this(names_obj) $this(base_classes) $c\" id=\"$objName\" style=\""
 foreach {var val} [this get_html_style] {
	append rep $var ": " $val ";"
  }  
 append rep "\" "
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
method PM_HTML Do_in_root {cmd} {
 set root [this get_L_roots] 
 if {[lsearch [gmlObject info classes $root] PhysicalHTML_root] != -1} {
     eval "$root $cmd"
 }
}

#_________________________________________________________________________________________________________
method PM_HTML Sub_daughter {e} {
 set rep [this inherited $e]
   this Do_in_root "Add_L_PM_to_sub $e"
 return $rep
}

#_________________________________________________________________________________________________________
method PM_HTML Add_daughter {e {index -1}} {
 set rep [this inherited $e $index]
   this Do_in_root "Add_L_PM_to_add $e"
 return $rep
}

#_________________________________________________________________________________________________________
method PM_HTML set_html_style {lstyles} {
 set Lsub [list ]
 foreach {var val} [this get_html_style] {
   lappend Lsub $var
  }
 this sub_html_style $Lsub
 this add_html_style $lstyles 
}

#_________________________________________________________________________________________________________
method PM_HTML get_html_style {} {
 set L [list]
 foreach {var val} [array get this html_style,*] {lappend L [string range $var 11 end] $val; }
 return $L
}

#_________________________________________________________________________________________________________
method PM_HTML add_html_style {L_var_val} {
 foreach {var val} $L_var_val {
   set this(html_style,$var) $val
  }
 this Send_updated_style
}

#_________________________________________________________________________________________________________
method PM_HTML sub_html_style {L_vars} {
 foreach var $L_vars {
	unset this(html_style,$var)
  }
 this Send_updated_style
}

#_________________________________________________________________________________________________________
method PM_HTML Send_updated_style {} {
 set root [this get_L_roots] 
 if {[lsearch [gmlObject info classes $root] PhysicalHTML_root] != -1} {
   set    cmd  "\$(\"#${objName}\").removeAttr(\"style\");\n"
   append cmd  "\$(\"#${objName}\").css({"
   foreach {var val} [this get_html_style] {
	 append cmd $var ": \"" $val "\","
	}
   # set cmd [string range $cmd 0 end-1]	
   append cmd "});" "\n"
 
   $root Concat_update $objName "htmlstyle" $cmd
  } 
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
	 
	 if { $tailletot-1 > $pos} {
		set objAfter [lindex [this get_daughters] [expr $pos+1]]
		set objAfter [$objAfter get_prim_handle]
		set cmd "\$($strm).insertBefore('#$objAfter');"
	  } else {set root_for_daughters [this get_root_for_daughters]
			  set cmd "\$($strm).appendTo('#$root_for_daughters');"
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
method PM_HTML Draggable {} {
 set cmd "\$('#$objName').draggable();"
 append cmd ""
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML DragDrop_event {type x y} {
 set cmd "\$('#$objName').${type}();"
 append cmd ""
}

#___________________________________________________________________________________________________________________________________________
method PM_HTML send_jquery_message {methode cmd} {
 set root [this get_L_roots]
 
 if {[lsearch [gmlObject info classes $root] PhysicalHTML_root] != -1} {
	$root Concat_update $objName $methode $cmd
 }
}