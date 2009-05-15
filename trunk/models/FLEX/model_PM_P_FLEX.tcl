#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit PM_FLEX Physical_model
#___________________________________________________________________________________________________________________________________________
method PM_FLEX constructor {name descr args} {
 this inherited $name $descr
 set class(mark) 0
	
 set this(root) ""
 set ptf [$this(cou) get_ptf]
 $ptf maj Ptf_FLEX

 this set_cmd_placement      ""
 this set_prim_handle        ""
 this set_root_for_daughters ""
}

#___________________________________________________________________________________________________________________________________________
method PM_FLEX get_mark {}  {return $class(mark)}
method PM_FLEX set_mark {m} {set class(mark) $m}

#___________________________________________________________________________________________________________________________________________
method PM_FLEX Reconnect {PMD} {
 set pos [lsearch $this(L_daughters) $PMD]
 if {$pos == -1} {return}
 set this(L_daughters) [lreplace $this(L_daughters) $pos $pos]
 lappend this(L_daughters) $PMD
}

#___________________________________________________________________________________________________________________________________________
method PM_FLEX Show_elements_prims {b L_prims} {
 puts "$objName PM_FLEX::Show_elements_prims $b {$L_prims}"
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
 if {$b == 0} {
   foreach p $L_prims {append this(embeded_style) "#$p {display: none;}\n"}
  }
}

#___________________________________________________________________________________________________________________________________________
method PM_FLEX get_width  {{PM {}}} {return -1}
method PM_FLEX get_height {{PM {}}} {return -1}

#___________________________________________________________________________________________________________________________________________
method PM_FLEX Adequacy {context {force_eval_ctx 0}} {return -1}

#___________________________________________________________________________________________________________________________________________
method PM_FLEX Render_daughters {strm_name {dec {}}} {
 set L [list]
 
 upvar $strm_name strm
 foreach elmt [this get_daughters] {
   $elmt Render_all strm $dec
   lappend L [$elmt get_prim_handle]
  }
 
 set root [this get_root_for_daughters]
 if {$root != ""} {
   append strm "\t" " while(${root}.numChildren > 0) \n"
   append strm "\t" "  {${root}.removeChildAt(0);} \n"
   foreach e $L {
     append strm "\t" " ${root}.addChild($e); \n"
	}
  }
  
 return $L
}

#___________________________________________________________________________________________________________________________________________
method PM_FLEX Render_all {strm_name {dec {}}} {
 upvar $strm_name strm
 return [this Render strm $dec]
}

#___________________________________________________________________________________________________________________________________________
method PM_FLEX Render {strm_name {dec {}}} {
 upvar $strm_name strm
 return [this Render_daughters strm $dec]
}

#_________________________________________________________________________________________________________
method PM_FLEX get_or_create_prims {root} {return {}}

#_________________________________________________________________________________________________________
method PM_FLEX Add_prim_daughter {c Lprims {index -1}} {this inherited $c $Lprims $index; return 1}
method PM_FLEX Add_prim_mother   {c Lprims {index -1}} {this inherited $c $Lprims $index; return 1}

#_________________________________________________________________________________________________________
method PM_FLEX Do_prims_still_exist {} {return 1}

#_________________________________________________________________________________________________________
method PM_FLEX Add_daughter {m {index -1}} {
 puts "$objName Add_daughter $m"
 puts "  set still_daughter [this Has_for_daughter $m]"
 set still_daughter [this Has_for_daughter $m]
 set rep [this inherited $m $index]
 if {$still_daughter == -1} {
   # Envoyer le code de création / branchement de $m dans les clients FLEX
   set cmd ""; $m Render cmd
   set root_for_daughters [this get_root_for_daughters]
   set daughter_handle    [$m   get_prim_handle]
   if {$index == -1} {set index [this get_nb_daughters]}
   append cmd "${root_for_daughters}.addChildAt($daughter_handle, 0); "
   
   set root [this get_L_roots] 
   puts "$cmd \n"
   if {[lsearch [gmlObject info classes $root] Comet_root_PM_P_FLEX] != -1} {
     $root send_to_FLEX $cmd
    }
  }
 return $rep
}

#_________________________________________________________________________________________________________
method PM_FLEX Sub_daughter {m} {
 set rep [this inherited $m]
   # Envoyer le code de destruction / débranchement de $m dans les clients FLEX
 return $rep
}
