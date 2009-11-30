#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit PM_Universal PM_HTML

#___________________________________________________________________________________________________________________________________________
method PM_Universal constructor {name descr args} {
 this inherited $name $descr
   this set_nb_max_mothers 1
   this set_cmd_placement {}

   set this(L_prim_undisplayed) ""

   set this(cmd_deconnect) {pack forget $p}

   set this(reg_exp) {regexp "^$" $str reco}

   set ptf [$this(cou) get_ptf]
     $ptf set_hard_type *
     $ptf set_soft_type *
     $ptf set_OS_type   *
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors     PM_Universal reg_exp

#___________________________________________________________________________________________________________________________________________
method PM_Universal Show_elements {b L_tags} {
 set rep [this inherited $b $L_tags]
 foreach d [this get_out_daughters] {$d Show_elements $b $L_tags
									}

 return $rep
}

#___________________________________________________________________________________________________________________________________________
method PM_Universal Show_elements_prims {b L_prims} {
 #puts "$objName PM_Universal::Show_elements_prims $b {$L_prims}"
 this inherited $b $L_prims
 foreach d [this get_out_daughters] {$d Show_elements_prims $b $L_prims
                                     #puts "$d Show_elements_prims $b $L_prims"
									}

 #puts "$objName Show_elements_prims $b {$L_prims}"
 if {$b} {
   Sub_list this(L_prim_undisplayed) $L_prims
  } else {set this(L_prim_undisplayed) [Liste_Union $this(L_prim_undisplayed) $L_prims]
         }
 #puts "Undisplay list : {$this(L_prim_undisplayed)}"
 [this get_mothers] Reconnect $objName
}

#_________________________________________________________________________________________________________
method PM_Universal Hide_Elements args {
 #puts "$objName PM_Universal::Hide_Elements $args"
 this inherited $args
 set this(L_prim_undisplayed) ""; set this(L_prim_undisplayed) [Liste_Union $this(L_prim_undisplayed) $args]
 foreach d [this get_out_daughters] {
   #puts "  | $d Hide_Elements $args"
   eval "$d Hide_Elements $args"
  }
}

#___________________________________________________________________________________________________________________________________________
method PM_Universal Reconnect {{PMD {}}} {
 set PMM [this get_mothers]
 $PMM Reconnect $PMD
}

#___________________________________________________________________________________________________________________________________________
set    cmd "method PM_Universal Analyse \{str_name\} \{\n"
append cmd [gmlObject info body PM_ALX_TXT Analyse]
append cmd "\}\n"
eval $cmd

#___________________________________________________________________________________________________________________________________________
set    cmd "method PM_Universal Process_TXT \{str_name\} \{\n"
append cmd [gmlObject info body PM_ALX_TXT Process_TXT]
append cmd "\}\n"
eval $cmd


#___________________________________________________________________________________________________________________________________________
method PM_Universal Render {strm_name {dec {}}} {
 upvar $strm_name strm
 append strm $dec "<div [this Style_class]>\n"
   this Render_daughters strm $dec
 append strm $dec "</div>\n"
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method PM_Universal Add_prim_daughter {c Lprims {index -1}} {
 #puts "$objName PM_Universal::Add_prim_daughter $c {$Lprims}"
 set m [this get_mothers]
 if {[string equal $m {}]} {
  #puts "  rep1 : 0"; 
   return 0
  }
 set rep [$m Add_prim_daughter $c $Lprims $index]
 
 # DEBUG Manage the hidden elements
 #puts "$objName PM_Universal:Add_prim_daughter => $c Hide_Elements"
 eval "$c Hide_Elements $this(L_prim_undisplayed)"

 #puts "  rep2 : $rep"
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method PM_Universal get_or_create_prims {root} {
 #puts "$objName PM_Universal::get_or_create_prims $root"
 set d [this get_daughters]
 if {[string equal $d {}]} {
  #puts "  rep1 : {}"; 
   return ""
  }
 set rep {}
 foreach PM $d {
   set rep [concat $rep [$PM get_or_create_prims $root]]
  }
 #puts "  rep2 : $rep"
 return $rep
}
#___________________________________________________________________________________________________________________________________________
method PM_Universal get_prim_handle {{index -1}}  {
 #puts "$objName get_prim_handle $index"
 set d [this get_daughters]
 if {[string equal $d {}]} {
  #puts "  rep1 : {}"; 
   return ""
  }
###
 set rep {}
 foreach PM $d {
   set rep [concat $rep [$PM get_prim_handle $index]]
  }
 #puts "  rep1 : $rep"
 return $rep
# return [$d get_prim_handle $index]
}
#___________________________________________________________________________________________________________________________________________
method PM_Universal Sub_prim_daughter {c Lprims {index -1}} {
 #puts "$objName Sub_prim_daughter $c {$Lprims}"
 set m [this get_mothers]
 if {[string equal $m {}]} {
  #puts "  rep1: 0"; 
   return 0
  }
 set rep [$m Sub_prim_daughter $c $Lprims $index]
 #puts "  rep2 : $rep"
 return $rep
}
#___________________________________________________________________________________________________________________________________________
method PM_Universal get_root_for_daughters {{index -1}} {
 #puts "$objName get_root_for_daughters $index"
 set m [this get_mothers]
 if {[string equal $m {}]} {
  #puts "  rep1 : NULL"; 
   return NULL
  }
 set rep [$m get_root_for_daughters]
 #puts "  rep2 : $rep"
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method PM_Universal Do_prims_still_exist {} {
 set d [this get_daughters]
 if {[string equal $d {}]} {return 0}
 foreach PM $d {
   if {[$PM Do_prims_still_exist]==0} {return 0}
  }
 return 1
}

#___________________________________________________________________________________________________________________________________________
method PM_Universal Add_mother    {m {index -1}} {
 #puts "$objName PM_Universal::Add_mother $m $index"
 set rep [this inherited $m $index]
 if {$rep} {
   this Add_prim_mother $m ""
   $this(cou) maj [$m get_cou]
   # XXX DEBUG 2009 02 16
   # Was : this set_cmd_deconnect [$m get_cmd_deconnect]
   this set_cmd_deconnect [string map [list $m $objName] [$m get_cmd_deconnect]]
   this set_cmd_placement [string map [list $m $objName] [$m get_cmd_placement]]
  }
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method PM_Universal Sub_mother    {m} {
 set rep [this inherited $m]
 if {$rep} {
   set ptf [$this(cou) get_ptf]
     $ptf set_hard_type *
     $ptf set_soft_type *
     $ptf set_OS_type   *
    #this set_daughters {}  
  }
 return $rep
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
proc Generate_Universal_PM_methods {class_name L_methods} {
 set entete "method $class_name "
# set    fin { return [eval $cmd]}
# append fin "\n" "\}"

 foreach m $L_methods {
   set methode_name [lindex $m 0]
   set params       [lindex $m 1]
     set    cmd $entete
     append cmd $methode_name " \{" $params "\} \{\n"
#     append cmd {[this get_core] } "$methode_name "
#       foreach p $params {
#         append cmd "\$[lindex $p 0]" { }
#        }
#     append cmd "\n" $fin
     append cmd "\n\}"
     eval $cmd
  }
}

