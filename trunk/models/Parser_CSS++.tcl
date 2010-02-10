#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
# Produce XML like list
# TYPE, List of names separated by '.', projection, filter, 
# where TYPE = NODE | AXE | FILTER
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method Parser_CSS++ constructor {default_root} {
 set this(default_root) $default_root
 
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method Parser_CSS++ Parse {str} {
 set str [string map [list ")" " )" "/" " /" "," " , " "\;" " \; " "<--<" "GOTO_ANCESTOR_$objName" ">-->" "GOTO_DESCENDANT_$objName" "->" "PROJECTION_$objName" "-" " - "] $str]
 set str [string map [list PROJECTION_$objName "->" GOTO_ANCESTOR_$objName "<--<" GOTO_DESCENDANT_$objName ">-->"] $str]
 
 set L_rep [list]
 
 set nb 0
 set p [this Parse_selector $str " "]
 while {$p != ""} {
   lassign $p sel axe rest
   lassign $axe axe_name axe_params
   if {$sel != ""} {lappend L_rep [list NODE $sel]}
   if {$axe != ""} {lappend L_rep [list AXE $axe_name $axe_params]}
   
   #puts "  sel:$sel  axe:$axe  rest:$rest"
   set p [this Parse_selector $rest $axe]
   
   incr nb
   if {$nb > 500} {puts "BREAK!"; break}
  }
 
# Re-organize so that the hierarchy (grouping, nesting, post filter) is represented
 set nb_open_parenthesis 0
 set nb_open_post_filter 0
 set nb_go_through       0
 set L_hierachical_rep   [list]
 
 set index_L_rep 0
 this Build_hierarchy L_hierachical_rep L_rep index_L_rep nb_open_parenthesis nb_open_post_filter nb_go_through

 if {$nb_open_parenthesis != 0} {puts "  WARNING : nb_open_parenthesis = $nb_open_parenthesis"}
 if {$nb_open_post_filter != 0} {puts "  WARNING : nb_open_post_filter = $nb_open_post_filter"}
 if {$nb_go_through       != 0} {puts "  WARNING : nb_go_through = $nb_go_through"}
 
 return [list ROOT "" $L_hierachical_rep]
}

#___________________________________________________________________________________________________________________________________________
method Parser_CSS++ Build_hierarchy {L_h_name L_flat_name index_L_flat_name nb_open_parenthesis_name nb_open_post_filter_name nb_go_through_name} {
 upvar $L_h_name                 L_h
 upvar $L_flat_name              L_flat
 upvar $nb_open_parenthesis_name nb_open_parenthesis
 upvar $nb_open_post_filter_name nb_open_post_filter
 upvar $index_L_flat_name        index_L_flat
 upvar $nb_go_through_name       nb_go_through
 
 set do_it_again 1
 while {$do_it_again} {
     if {$index_L_flat >= [llength $L_flat]} {break}
	 
	 if {[lindex [lindex $L_flat $index_L_flat] 0] == "NODE"} {
	   switch [lindex [lindex $L_flat $index_L_flat] 1] {
		 "/>>"   {set do_it_again 0; incr nb_go_through       -1}
		 "/"     {set do_it_again 0; incr nb_open_post_filter -1}
		 ")"     {set do_it_again 0; incr nb_open_parenthesis -1}
		 default {lappend L_h [lindex $L_flat $index_L_flat]}
		}
	  }
	  
	 if {[lindex [lindex $L_flat $index_L_flat] 0] == "AXE"} {
	   set axe_type [lindex [lindex $L_flat $index_L_flat] 1]
	   switch $axe_type {
	     DESCENDANTS      {lassign [lindex $L_h end] T t
		                   if {$T != "AXE" || $t != "GO_THROUGH"}  {lappend L_h [lindex $L_flat $index_L_flat]}
						  }
	     CHILDREN         {lassign [lindex $L_h end] T t
					       if {$T == "AXE" && $t == "DESCENDANTS"} {set L_h [lrange $L_h 0 end-1]}
						   lappend L_h [lindex $L_flat $index_L_flat]
		                  }
		 ALL_DESCENDANTS  {lassign [lindex $L_h end] T t
					       if {$T == "AXE" && $t == "DESCENDANTS"} {set L_h [lrange $L_h 0 end-1]}
						   lappend L_h [lindex $L_flat $index_L_flat]
		                  }
	     GOTO_ANCESTORS   {lassign [lindex $L_h end] T t
					       if {$T == "AXE" && $t == "DESCENDANTS"} {set L_h [lrange $L_h 0 end-1]}
						   lappend L_h [lindex $L_flat $index_L_flat]
		                  }
		 GOTO_DESCENDANTS {lassign [lindex $L_h end] T t
					       if {$T == "AXE" && $t == "DESCENDANTS"} {set L_h [lrange $L_h 0 end-1]}
						   lappend L_h [lindex $L_flat $index_L_flat]
		                  }
		 FILTER       {
		               # Update the expression so that it can be directly evaluated by TCL
					   set txt [lindex [lindex $L_flat $index_L_flat] 2]
					   set VAL ""; set add_guillemets 0
					   foreach e $txt {
					     if {$add_guillemets} {append VAL "\"" $e "\" "} else {append VAL $e " "}
					     if {$e == "=="} {set add_guillemets 1} else {set add_guillemets 0}
					    }
					   set VAL2 [string map [list {soft_type} "\[\${obj}_cou_ptf get_soft_type\]"] $VAL]
					   lappend L_h [list AXE $axe_type $VAL $VAL2]
		              }
	     UNION        {set L [list]; incr index_L_flat; this Build_hierarchy L L_flat index_L_flat nb_open_parenthesis nb_open_post_filter nb_go_through; 
		               lassign [lindex $L_h end] T t
					   if {$T == "AXE" && $t == "DESCENDANTS"} {set L_h [lrange $L_h 0 end-1]}
					   set L_h [list [list AXE $axe_type $L_h $L]]
					  }
		 DIFFERENCE   {set L [list]; incr index_L_flat; this Build_hierarchy L L_flat index_L_flat nb_open_parenthesis nb_open_post_filter nb_go_through; 
		               lassign [lindex $L_h end] T t
					   if {$T == "AXE" && $t == "DESCENDANTS"} {set L_h [lrange $L_h 0 end-1]}
					   set L_h [list [list AXE $axe_type $L_h $L]]
					  }
		 INTERSECTION {set L [list]; incr index_L_flat; this Build_hierarchy L L_flat index_L_flat nb_open_parenthesis nb_open_post_filter nb_go_through; 
		               lassign [lindex $L_h end] T t
					   if {$T == "AXE" && $t == "DESCENDANTS"} {set L_h [lrange $L_h 0 end-1]}
					   set L_h [list [list AXE $axe_type $L_h $L]]
					  }
         POST_FILTER  {incr nb_open_post_filter
		               set L [list]; incr index_L_flat; this Build_hierarchy L L_flat index_L_flat nb_open_parenthesis nb_open_post_filter nb_go_through; 
					   lassign [lindex $L_h end] T t
		               if {$T == "AXE" && $t == "DESCENDANTS"} {set L_h [lrange $L_h 0 end-1]}
					   lassign [lindex $L 0] T t
					   if {$T == "AXE" && $t == "NEGATION"}    {
					     lappend L_h [lindex $L 0]
						 set L [lrange $L 1 end]
					    }
					   lappend L_h [list AXE $axe_type $L]
					  }
		 GO_THROUGH   {set L [list]; incr nb_go_through       1; 
		               incr index_L_flat; 
					   this Build_hierarchy L L_flat index_L_flat nb_open_parenthesis nb_open_post_filter nb_go_through; 
					   lassign [lindex $L_h end] T t
					   if {$T == "AXE" && $t == "DESCENDANTS"} {set L_h [lrange $L_h 0 end-1]}
					   lappend L_h [list AXE $axe_type $L]
					  }
		 GROUP        {set L [list]; incr nb_open_parenthesis 1; 
		               incr index_L_flat
					   this Build_hierarchy L L_flat index_L_flat nb_open_parenthesis nb_open_post_filter nb_go_through
					   lassign [lindex $L_h end] T t
					   if {$T == "AXE"} {
					     #if {$t == "NEGATION"}    {set neg [lindex $L_h end]; set L_h [lrange $L_h 0 end-1]} else {set neg ""}
						 lappend L_h [list AXE $axe_type $L]
						} else {lappend L_h [list AXE INSIDE $L]
						       }
					  }
		 INSIDE       {set L [list]; incr nb_open_parenthesis 1; incr index_L_flat; if {$index_L_flat == 1} {set axe_type GROUP}
		               this Build_hierarchy L L_flat index_L_flat nb_open_parenthesis nb_open_post_filter nb_go_through
					   lappend L_h [list AXE $axe_type $L]
					  }
		 POST_FILTER  {set L [list]; incr nb_open_post_filter 1; incr index_L_flat; this Build_hierarchy L L_flat index_L_flat nb_open_parenthesis nb_open_post_filter nb_go_through; lappend L_h [list AXE $axe_type $L]}
		 default      {lappend L_h [lindex $L_flat $index_L_flat]}
		}
	  }
	  
   if {$do_it_again} {incr index_L_flat}
  }
  
 lassign [lindex $L_h end] T t
 if {$T == "AXE" && $t == "DESCENDANTS"} {set L_h [lrange $L_h 0 end-1]}
}

#___________________________________________________________________________________________________________________________________________
method Parser_CSS++ Parse_selector {str {last_axe ""}} {
 if {$str == ""} {return ""}
 
 #Parse until the first separator, the first parenthesis or the first projection
 set axe ""; set str_next ""
 set pos_axe 999999999
 
 
 if {[regexp {^ *\- *(.*)$}   $str reco str_next]} {set pos_axe [string first "-" $str];   set axe DIFFERENCE}       else {
 if {[regexp {^ *\, *(.*)$}   $str reco str_next]} {set pos_axe [string first "," $str];   set axe UNION}            else {
 if {[regexp {^ *\; *(.*)$}   $str reco str_next]} {set pos_axe [string first "\;" $str];  set axe INTERSECTION}     else {
 if {[regexp {^ *\<\-\-\<(.*)$} $str reco str_next]} {set pos_axe [string first "<--<" $str];set axe GOTO_ANCESTORS}   else {
 if {[regexp {^ *\>\-\-\>(.*)$} $str reco str_next]} {set pos_axe [string first ">-->" $str];set axe GOTO_DESCENDANTS} else {
 if {[regexp {^ *>> *(.*)$}   $str reco str_next]} {set pos_axe [string first ">>" $str];  set axe GO_THROUGH}       else {
 if {[regexp {^ * \( *(.*)$}  $str reco str_next]} {set pos_axe [string first " (" $str];  set axe GROUP}            else {
 if {[regexp {^ *# *(.*)$}    $str reco str_next]} {set pos_axe [string first "#" $str];   set axe GOTO}             else {
 if {[regexp {^!(.*)$}    $str reco str_next]} {set pos_axe [string first "!" $str];   set axe NEGATION}         else {
 if {[regexp {^ *> *(.*)$}    $str reco str_next]} {set pos_axe [string first ">" $str];   set axe CHILDREN}         else {
 if {[regexp {^ *\~ *(.*)$}    $str reco str_next]} {set pos_axe [string first "~" $str];   set axe ALL_DESCENDANTS}  else {
 if {[regexp {^ *\\(.*)$}   $str reco str_next]} {set pos_axe [string first "\\" $str];  set axe POST_FILTER}      
 
 }}}}}}}}}}}
 
# Si on a rien trouvé d'autre...
 set pos [string first " "  $str]
 if {$axe == "" && $pos >= 0} {set axe DESCENDANTS
                               set pos_axe $pos
							   set str_tmp [string range $str $pos end]
                               regexp {^ *(.*)$} $str_tmp reco str_next 
							  }


 set pos [string first "("  $str]
 if {$pos >= 0 && $pos < $pos_axe} {
   set pos_axe $pos
     if { [lsearch [list  DIFFERENCE UNION INTERSECTION GO_THROUGH NEGATION CHILDREN DESCENDANTS ALL_DESCENDANTS GOTO_ANCESTORS GOTO_DESCENDANTS POST_FILTER] $last_axe] >= 0} {
       if {[lsearch [list DIFFERENCE UNION INTERSECTION] $last_axe] >= 0} {
	     set pos_space [string first " " $str]
         if {$pos_space >= 0 && $pos_space < $pos_axe} {set axe GROUP} else {set axe INSIDE}
		} else {set axe GROUP}
	  } else {set axe INSIDE}
   set str_tmp [string range $str 1+$pos_axe end]
   regexp {^ *(.*)$} $str_tmp reco str_next
  }
  
 set pos [string first {[}  $str]
 if {$pos >= 0 && $pos < $pos_axe} {set pos_axe $pos
									set str_tmp [string range $str 1+$pos_axe end]
									set pos_end_filter [string first {]} $str_tmp]
									set axe [list FILTER [string range $str_tmp 0 ${pos_end_filter}-1]]
									set str_tmp [string range $str_tmp ${pos_end_filter}+1 end]
									regexp {^ *(.*)$} $str_tmp reco str_next
					               }
 
 
 set pos [string first "->" $str]
 if {$pos >= 0 && $pos < $pos_axe} {set pos_axe $pos
                                    set axe     PROJECTION
									set str_tmp [string range $str 2+$pos_axe end]
									if {[string equal -length 2 "LC"     $str_tmp]} {set str_tmp [string range $str_tmp 2 end]; set axe [list $axe LC]}
									if {[string equal -length 3 "PMs"    $str_tmp]} {set str_tmp [string range $str_tmp 3 end]; set axe [list $axe PMs]}
									if {[string equal -length 3 "_LM_LP" $str_tmp]} {set str_tmp [string range $str_tmp 6 end]; set axe [list $axe _LM_LP]}
									if {[string equal -length 3 "_LM_FC" $str_tmp]} {set str_tmp [string range $str_tmp 6 end]; set axe [list $axe _LM_FC]}
									regexp {^\.*(.*)$} $str_tmp reco str_next
									#set str_next $str_tmp
					               }
								   
 set pos_space [string first " " $str]
 if {$pos_space >= 0 && $pos_space < $pos_axe} {set pos_axe $pos_space}
 set sel  [string range $str 0 ${pos_axe}-1]
 if {$axe == ""} {set str_next [string range $str $pos_axe end]}
  
 #puts "  $str  ==> $sel $axe"
 set L_rep [list $sel $axe $str_next]
 
 return $L_rep
}


#___________________________________________________________________________________________________________________________________________
method Parser_CSS++ Interprets {{L_root {}} str} {
 return [this Interprets_parsed $L_root [this Parse $str]]
}

#___________________________________________________________________________________________________________________________________________
method Parser_CSS++ Interprets_parsed {L_root P_CSS} {
 if {[llength $L_root] == 0} {set L_root $this(default_root)}

 lassign $P_CSS R pipo LF
 
 set this(next_name) daughters
 set this(cmd_next)  get_out_
 set this(go_in)     0
 #set this(L_syntax)  $LF
 set this(negation)  0
 set this(recurse)   1
 set this(goto_mode) 0
 
 set L_rep [list]
 foreach C [this Parse_$R $L_root $LF 0] {Add_element L_rep [lindex $C 0]}

 return $L_rep
}

#___________________________________________________________________________________________________________________________________________
method Parser_CSS++ Save_state { } {return [list $this(next_name) $this(cmd_next) $this(go_in) $this(negation) $this(recurse) $this(goto_mode)]}
#___________________________________________________________________________________________________________________________________________
method Parser_CSS++ Load_state {L} {lassign $L this(next_name) this(cmd_next) this(go_in) this(negation) this(recurse) this(goto_mode)}

#___________________________________________________________________________________________________________________________________________
method Parser_CSS++ Parse_ROOT {L_root L_syntax index} {
 set current [lindex $L_syntax $index]
 while {$current != ""} {
   lassign $current T VAR VAL VAL2
   set L_root [this Parse_$T $L_root $index $VAR $VAL $VAL2]
   incr index
   set current [lindex $L_syntax $index]
  }
  
 return $L_root
}

#___________________________________________________________________________________________________________________________________________
method Parser_CSS++ Parse_NODE {L_root index VAR VAL VAL2} {
 
 if {$this(goto_mode)} {
   set this(goto_mode) 0
   if {[gmlObject info exists object $VAR]} {set nL $VAR} else {
   if {[gmlObject info exists class  $VAR]} {set nL [gmlObject info objects $VAR]} else {set nL [list]}}
  } else {set nL [this get_nodes_from_where $L_root $VAR]}
 
 set this(go_in)    0
 set this(negation) 0
 
 return $nL
}


#___________________________________________________________________________________________________________________________________________
method Parser_CSS++ Parse_AXE {L_root index VAR VAL VAL2} {
 set nL [list]
 
 switch $VAR {
   DIFFERENCE       {set state [this Save_state]
                     set L1 [Liste_to_set [this Parse_ROOT $L_root $VAL  0]]; this Load_state $state
                     set L2 [this Parse_ROOT $L_root $VAL2 0]; this Load_state $state
					 Sub_list L1 $L2
					 set L_root $L1
                    }
   UNION            {set state [this Save_state]
                     set L2 [this Parse_ROOT $L_root $VAL2 0]; this Load_state $state
                     set L1 [this Parse_ROOT $L_root $VAL  0]; this Load_state $state
					 set L_root [concat $L1 $L2]
                    }
   INTERSECTION     {set state [this Save_state]
                     set L1 [Liste_to_set [this Parse_ROOT $L_root $VAL  0]]; this Load_state $state
                     set L2 [Liste_to_set [this Parse_ROOT $L_root $VAL2 0]]; this Load_state $state
					 set L_root [Liste_Intersection $L1 $L2]
                    }
   GOTO             {set this(goto_mode) 1}
   NEGATION         {set this(negation)  1}
   DESCENDANTS      {set this(recurse)   1; set this(cmd_next) "get_out_"; if {!$this(go_in)} {set L_root [this get_next_level $L_root]}}
   CHILDREN         {set this(recurse)   0; set this(cmd_next) "get_out_"; if {!$this(go_in)} {set L_root [this get_next_level $L_root]}}
   ALL_DESCENDANTS  {set this(recurse)   1; set this(cmd_next) "get_"    ; if {!$this(go_in)} {set L_root [this get_next_level $L_root]}}
   GOTO_ANCESTORS   {set this(next_name) mothers  }
   GOTO_DESCENDANTS {set this(next_name) daughters}
   INSIDE           {set state [this Save_state]
                     set this(recurse)   1; set this(cmd_next) "get_out_"; set this(next_name) daughters
					 foreach C $L_root {lassign $C r in
                                        set handle [$r get_handle_composing_comet]
                                        foreach h $handle {lappend nL [list $h $r]}
									   }
					 set this(go_in) 1
					 set L_root [this Parse_ROOT $nL $VAL 0]
					 this Load_state $state
					}
   FILTER           {set nL [list]
                     foreach C $L_root {
                       lassign $C obj in
					   set cmd "if {$VAL2} {lappend nL \$C}"
					   if {[catch {eval $cmd} err]} {puts "Error while evaluating the filter \"$VAL2\" for $obj\n$err"}
                      }
					 set L_root $nL
                    }
   POST_FILTER      {set nL [list]
                     set neg $this(negation); set this(negation) 0
                     set state [this Save_state]
					 foreach C $L_root {
					   set this(recurse)   1; set this(cmd_next) "get_out_";
					   lassign $C r in
					   set L_post [list $C]
					   #set L_post [concat $L_post [this get_next_level $L_post]]
					   #set L_post [this get_next_level $L_post]
					   set L_C_post [this Parse_ROOT $L_post $VAL 0]
					   if { [llength $L_C_post]      && !$neg
					      ||[llength $L_C_post] == 0 &&  $neg} {lappend nL $C}
					   this Load_state $state
					  }
					 set L_root $nL
					}
   PROJECTION       {set nL [list]
                     set this(recurse) 0
                     switch $VAL {
                       LC      {foreach C $L_root {lassign $C r in; lappend nL [list [$r get_LC] $in]}
					            set L_root $nL
							   }
					   PMs     {foreach C $L_root {lassign $C r in
					                               foreach PM [[$r get_LC]_LM_LP get_L_actives_PM] {lappend nL [list $PM $in]}
												  }
								set L_root $nL
					           }
					   default {foreach C $L_root {lassign $C r in; lappend nL [list [$r get_LC]$VAL $in]}
					            set L_root $nL
							   }
					  }
                    }
   GROUP            {set neg $this(negation); set this(negation) 0
					 set state [this Save_state]
					 set L_tmp [this Parse_ROOT $L_root $VAL 0]; set state2 [this Save_state]
					 if {$neg} {
					   this Load_state $state
					   set L_all [this get_nodes_from_where $L_root "*"]
					   set L_root $L_all; Sub_list L_root $L_tmp
					   this Load_state $state2
					  } else {set L_root $L_tmp}
                    }
   GO_THROUGH       {set nL [list]; set L_currents $L_root
                     set state [this Save_state]; set nb 0
					 while {[llength $L_currents]} {
					   set this(recurse)   0
					   set L_currents [this get_next_level $L_currents]
					   set L_currents  [this Parse_ROOT $L_currents $VAL 0]
					   #puts "  Check $VAL => $L_currents"
					   set nL [concat $nL $L_currents]
					   this Load_state $state; set this(recurse) 0
					   
					   incr nb; if {$nb >100} {puts "  OUT OF GO_THROUGH!!!"; break}
					  }
					 set L_root $nL
                    }
   default          {puts "_-_-_-_-_-_-_- Unknow axe '${VAR}'"}
  }
  
  
 return $L_root
}

#___________________________________________________________________________________________________________________________________________
method Parser_CSS++ get_next_level {L_root} {
 set L_rep [list]
 
 foreach C $L_root {
   lassign $C r in
   foreach e [$r $this(cmd_next)$this(next_name)] {lappend L_rep [list $e $in]}
  }
  
 return $L_rep
}

#___________________________________________________________________________________________________________________________________________
method Parser_CSS++ get_nodes_from_where {L_root sel} {
 if {[llength $L_root] == 0} {return [list]}
 
 set id [split $sel .]
 
 set rep [list]
 foreach C $L_root {
     lassign $C r in
	 set go 0
	 if {$id == "*"} {set go 1} else  {
	   # <DEBUG>
	   #if {$id == "CORE"} {puts "  CORE? $r in $in"}
	   # </DEBUG>
	   if {[$r Has_for_styles $id]} {
		 if {$id == "CORE"} {
		   if {[catch {set core [$in get_core]}]} {set core ""}
		   if {$r == $core} {set go 1}
		  } else {set go 1}
		}
	  }

	 if {($go && !$this(negation)) || (!$go && $this(negation))} {
	   Add_element rep $r
	  }
  }
  
# Continue to the next level
 set nL $rep
 
 if {$this(recurse)} {
   set L_to_go [list]
   foreach C $L_root {lassign $C r in; foreach e [$r $this(cmd_next)$this(next_name)] {lappend L_to_go [list $e $in]}}
   set nL [concat $nL [this get_nodes_from_where $L_to_go $sel]]
  }	
  
 return $nL
}

#Trace Parser_CSS++ Interprets

#Trace Parser_CSS++ get_nodes_from_where
#___________________________________________________________________________________________________________________________________________
proc Batterie_test_Parser_CSS++ {{display_ok 1}} {
 if {![gmlObject info exists object PS]} {Parser_CSS++ PS cr}
 if {![gmlObject info exists object pipo_old_style_css]} {Style pipo_old_style_css -set_comet_root cr}
 
 set L_to_check [list {swl} \
                      {#swl} \
					  {#cr swl} \
					  {* *} \
					  {cr (*)} \
					  {(swl, cr)} \
					  {cr->PMs.PM_TK} \
					  {cr->PMs.PM_TK *} \
					  {cr->PMs ~ *} \
					  {cr->PMs ~ CometContainer.PM_HTML} \
					  {cr->PMs ~ CometInterleaving} \
					  {cr->PMs ~ CometInterleaving CometContainer} \
					  {#U_encapsulator_PM_CPool_COMET_24_PM_P_2_66(sub.player)} \
					  {#swl->PMs} \
					  {#cr swl->PMs} \
					  {#cr swl->PMs(*)} \
					  {#cr swl->PMs(>*)} \
					  {#cr swl->PMs(!CometContainer)} \
					  {#cr swl->PMs(>* CometContainer)} \
					  {#cr swl->PMs(* \ CometContainer/)} \
					  {#cr swl->PMs(* \! CometContainer/)} \
					  {#cr swl->PMs(* \ !CometContainer/)} \
					  {#cr swl->PMs(* \>CometContainer/)} \
					  {#cr swl->PMs(* \!>CometContainer/)} \
					  {#cr swl->PMs(>* CometInterleaving)} \
					  {#cr swl->PMs(>* (CometContainer, CometInterleaving))} \
					  {#cr swl->PMs(>* !(CometContainer, CometInterleaving))} \
					  {#cr swl->PMs(* \! */)} \
					  {#cr swl->PMs(* \! */ <--< *)} \
					  {#cr swl->PMs(* \! */ <--< * \! */)} \
                      {#swl->PMs[soft_type == BIGre]}     \
                      {CometSWL->PMs[soft_type == BIGre]} \
					  {#swl->PMs(>* >>!CometSWL_Player/>> (CONT.OP.SHIP, ACT.SUB.PLANET, ACT.SUB.PLAYER))} \
					  {#swl->PMs(CometSWL_Player(>*))} \
					  {#swl->PMs(CometSWL_Player(CORE(>*)))} \
					  {#swl->PMs(CometSWL_Player(>*), CometSWL_Player(CORE(>*)))} \
					  {#swl->PMs(CometSWL_Player(>*), CometSWL_Player (CORE(>*)))} \
                ]
				
 set nb 0
 foreach cmd $L_to_check { 
   set display "______________________________________________________________________\n  Checking : $cmd\n______________________________________________________________________\n"
   set expected [pipo_old_style_css Interprets $cmd cr]
   lassign [Check_that_list_are_equivalent [list PS Interprets cr $cmd] $expected] i err
   incr nb $i
   if {$i} {
     if {$display_ok} {puts "${display}Success with \"$cmd\"\n$expected"}
	} else {puts "$display  Error with \"$cmd\"\;\n     -expected : $expected\n    -     got : $err"
	        set got [PS Interprets cr $cmd]
			set L $expected; Sub_list L $got; puts "In expected but not in got : $L"
			set L $got; Sub_list L $expected; puts "In got but not in expected : $L"
		   }
  }
  
 set NB [llength $L_to_check]
 puts "$nb success on $NB tests (rate of [expr 100 * ${nb}.0 / ${NB}.0]%)"
}
