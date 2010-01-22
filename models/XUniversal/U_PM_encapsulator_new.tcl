#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit PM_U_encapsulator PM_U_Container

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
# Let's consider a fake LM for the core PM                                                                                                 _
# It's aim is just to facilitate branchs                                                                                                   _
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method PM_U_encapsulator constructor {name descr PM_core args} {
 this inherited $name $descr
   set this(L_created)    [list]
   set this(core)         $PM_core
   set LM                 [$PM_core get_LM]
   #set CFC                [$PM_core get_Common_FC]
   set CFC                $LM
   set this(core_factice_LC) "${objName}_Fake_LC_of_$PM_core"
   set this(core_factice_LM) "$this(core_factice_LC)_LM_LP"
   this set_nesting_element [$PM_core get_nesting_element]
   [this get_cou] maj [$PM_core get_cou]
    # Build the class U_encaps corresponding to PM
     [this get_LC_class_for_PM $PM_core] $this(core_factice_LC) "Core of [[$PM_core get_LC] get_name]" "Fake LC of $PM_core"
	   $this(core_factice_LC) set_Common_FC $CFC
	   $this(core_factice_LC) Add_MetaData Core_of_PM $objName
     [this get_LM_class_for_PM $PM_core] $this(core_factice_LM) "Core of [[$PM_core get_LC] get_name]" "Fake LM of $PM_core"
       $this(core_factice_LC) Add_LM $this(core_factice_LM)
	   $LM configure -set_PM_inactive $PM_core -Sub_PM $PM_core
	   $this(core_factice_LM) Add_PM        $PM_core
       $this(core_factice_LM) set_PM_active $PM_core
       $this(core_factice_LM) Add_MetaData Core_of_PM $objName	   
	   $LM configure -Add_PM $objName -set_PM_active $objName
	   
	   $this(core_factice_LC) Add_style_class CORE
	   
   
   this set_L_nested_handle_LM    $this(core_factice_LM)
   this set_L_nested_daughters_LM $this(core_factice_LM)

   this Add_MetaData Encapsulated_graph $PM_core

   # DEBUG $PM_core Substitute_by $objName
     
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors PM_U_encapsulator [list core core_factice_LC core_factice_LM]

#___________________________________________________________________________________________________________________________________________
method PM_U_encapsulator dispose {} {
 $this(core_factice_LC) set_Common_FC ""
 this inherited
}

#___________________________________________________________________________________________________________________________________________
method PM_U_encapsulator get_LC_class_for_PM {PM} {
 set class_PM [lindex [gmlObject info classes $PM] 0]
 set class_LC LC_U_encaps_for_${class_PM}
 if {![gmlObject info exists class $class_LC]} {
   inherit $class_LC Logical_consistency
   eval "method $class_LC constructor {name descr args} {\n this inherited \$name \$descr\n eval \"\$objName configure \$args\"\n return \$objName\n}"
   this U_encaps_generate_semantic_API_for_LC_class_from_PM $class_LC $PM
  }
 return $class_LC
}

#___________________________________________________________________________________________________________________________________________
method PM_U_encapsulator get_LM_class_for_PM {PM} {
 set class_PM [lindex [gmlObject info classes $PM] 0]
 set class_LM LM_U_encaps_for_${class_PM}
 if {![gmlObject info exists class $class_LM]} {
   inherit $class_LM Logical_model
   eval "method $class_LM constructor {name descr args} {\n this inherited \$name \$descr\n eval \"\$objName configure \$args\"\n return \$objName\n}"
   this U_encaps_generate_semantic_API_for_LM_class_from_PM $class_LM $PM
  }
 return $class_LM
}

#___________________________________________________________________________________________________________________________________________
method PM_U_encapsulator U_encaps_generate_semantic_API_for_LM_class_from_PM {LM_class PM} {
 set sem_API_get [$PM get_Semantic_API_get]
 set sem_API_set [$PM get_Semantic_API_set]
 Methodes_get_LC $LM_class $sem_API_get {$this(FC)}
 Methodes_set_LC $LM_class $sem_API_set {} {[this get_L_actives_PM]}
 
 Generate_LM_setters $LM_class [$PM get_Semantic_API_prim_set] 
}

#___________________________________________________________________________________________________________________________________________
method PM_U_encapsulator U_encaps_generate_semantic_API_for_LC_class_from_PM {LC_class PM} {
 set sem_API_get [$PM get_Semantic_API_get]
 set sem_API_set [$PM get_Semantic_API_set]
 Methodes_get_LC $LC_class $sem_API_get {$this(FC)}
 Methodes_set_LC $LC_class $sem_API_set {} {$this(L_LM)}
 
 #puts "____$objName U_encaps_generate_semantic_API_for_LC_class_from_PM $LC_class $PM"
 foreach m [$PM get_Semantic_API_prim_set] {
   set m_name [lindex $m 0]
   set m_args [lindex $m 1]
   set    cmd "method $LC_class $m_name {$m_args} {\n"
   append cmd " \[this Val_MetaData Core_of_PM\] prim_$m_name "
     foreach arg $m_args {append cmd " \$[lindex $arg 0]"}
   append cmd "}\n"
   eval $cmd
  }
}

#___________________________________________________________________________________________________________________________________________
method PM_U_encapsulator Has_for_style  {s} {
 if {[this inherited $s]} {return 1} else {return [[this get_core] Has_for_style $s]}
}

#___________________________________________________________________________________________________________________________________________
method PM_U_encapsulator Has_for_styles {Ls} {
 if {[this inherited $Ls]} {return 1} else {return [[this get_core] Has_for_styles $Ls]}
}

#___________________________________________________________________________________________________________________________________________
proc get_PM_encaps_class_for_PM {PM} {
 set class_PM [lindex [gmlObject info classes $PM] 0]
 set class_U_PM PM_U_encaps_for_${class_PM}
 if {![gmlObject info exists class $class_U_PM]} {
  # Constructor 
   inherit $class_U_PM PM_U_encapsulator
   eval "method $class_U_PM constructor {name descr PM_core args} {\n this inherited \$name \$descr \$PM_core\n eval \"\$objName configure \$args\"\n return \$objName\n}"
  # Semantic API
   set sem_API_get [$PM get_Semantic_API_get]
   set sem_API_set [$PM get_Semantic_API_set]
   Methodes_get_LC $class_U_PM $sem_API_get {$this(FC)}
   Methodes_set_LC $class_U_PM $sem_API_set {$this(core_factice_LM)} {}
   Generate_PM_setters $class_U_PM [$PM get_Semantic_API_prim_set] 
  }
 return $class_U_PM
}

#___________________________________________________________________________________________________________________________________________
proc U_encapsulator_PM_techno {ptf PM graph {handle_for_daughters {}}} {
 set PM_encaps [U_encapsulator_PM $PM $graph $handle_for_daughters]
 [[$PM_encaps get_cou] get_ptf] maj $ptf
 if {[llength [$PM_encaps get_mothers]]} {
   $PM_encaps set_mode_plug Full
   [$PM_encaps get_LM] Connect_PM_descendants $PM_encaps [$PM_encaps get_L_nested_handle_LM]
   set L [join [$PM_encaps get_L_nested_daughters_LM] ", "]
   $PM_encaps set_L_nested_daughters_PM [CSS++ $PM_encaps "#$PM_encaps ~ ($L)"]
  }
}


#___________________________________________________________________________________________________________________________________________
proc U_encapsulator_PM {PM graph {handle_for_daughters {}}} {
 #puts "U_encapsulator_PM {$PM} {$graph}"
# Save PM mothers and daughters
 set L_mothers {} 
   foreach m [$PM get_out_mothers] {
     set L_m_d [$m get_daughters]
     lappend L_mothers [list $m [lsearch $L_m_d $PM]]
    }
 set L_daugthers [$PM get_out_daughters]
 
# Check if it is still a U_encapsulator or not...
 if {[lsearch [gmlObject info classes $PM] PM_U_encapsulator] != -1} {
   #puts "  - Still an encapsulator PM_U_encapsulator\n    | Encapsulated_graph : [$PM Val_MetaData Encapsulated_graph]"
   if {[string equal [$PM Val_MetaData Encapsulated_graph] $graph]} {
     #puts "  - NOTHING TO DO";
	 return $PM
	}
   set PM_encaps $PM
  } else {$PM set_mothers   ""
          $PM set_daughters ""
		  set LM [$PM get_LM]
		  set PM_encaps "U_encapsulator_PM_${PM}_[interpretor_DSL_comet_interface get_a_unique_id]"
		    [get_PM_encaps_class_for_PM $PM] $PM_encaps U_encapsulator_PM "Generated to encapsulate $PM" $PM
         }
# Update the nested graph !
 $PM_encaps Add_MetaData Encapsulated_graph $graph
 set obj [$PM_encaps get_core_factice_LC]
   set graph [string map [list {$obj(} "${obj}(" {$obj} "${obj}()"] $graph]
   #puts "interpretor_DSL_comet_interface Interprets {$graph} \[$PM_encaps get_core_factice_LC\]_nesting_root_name"
   set L_res_Comets [interpretor_DSL_comet_interface Interprets $graph [$PM_encaps get_core_factice_LC]_nesting_root_name]
   
     foreach C "[lindex $L_res_Comets 0] [lindex $L_res_Comets 1]" {$C Add_MetaData "Generated_to_be_encapsulated_in" $PM_encaps}
	 
   set root [CSS++ [$PM get_L_roots] "((#${obj}->_LM_LP <--< *), #${obj}->_LM_LP) \\ <--<!> */"]
   #puts "  - root : $root"
   $PM_encaps set_L_nested_handle_LM $root
   if {[string equal $handle_for_daughters ""]} {
     set handle_for_daughters [$PM get_LM]
	} else {set handle_for_daughters [CSS++ $root "$handle_for_daughters"]
	       }
   $PM_encaps set_L_nested_daughters_LM [CSS++ cr "#${handle_for_daughters}->_LM_LP"]
   #puts "$PM_encaps L_nested_daughters_LM is {[$PM_encaps get_L_nested_daughters_LM]}"
 #$PM Substitute_by $PM_encaps
		set nesting_element [$PM_encaps get_nesting_element]
		if {![string equal $nesting_element ""]} {$nesting_element Update}
 [$PM_encaps get_LM] Connect_PM_descendants $PM_encaps [$PM_encaps get_L_nested_handle_LM]
 
 foreach m $L_mothers   {[lindex $m 0] Add_daughter $PM_encaps [lindex $m 1]}
 #puts "End of adding mothers ($L_mothers) to $PM_encaps"
 if {[llength $L_mothers] == 0} {
   $PM_encaps set_mode_plug Full
   [$PM_encaps get_LM] Connect_PM_descendants $PM_encaps [$PM_encaps get_L_nested_handle_LM]
   set L [join [$PM_encaps get_L_nested_daughters_LM] ", "]
   $PM_encaps set_L_nested_daughters_PM [CSS++ cr "#$PM_encaps ~ ($L)"]
   #puts "Did the job for $PM_encaps"
  } else {set L [join [$PM_encaps get_L_nested_daughters_LM] ", "]
		  #puts "_________________ EVAL ___________________"
		  #puts "$PM_encaps set_L_nested_daughters_PM \[CSS++ cr \"#$PM_encaps ~ ($L)\"\]"  
          $PM_encaps set_L_nested_daughters_PM [CSS++ cr "#$PM_encaps ~ ($L)"]
         }
 #$PM_encaps set_daughters $L_daugthers
 #puts "___________________________________\n$PM_encaps set_daughters {$L_daugthers}___________________________________\n"
 foreach d $L_daugthers {
   #puts "$PM_encaps Add_daughter $d"
   $PM_encaps Add_daughter $d
  }
 #puts "___________________________________"
 return $PM_encaps
}

