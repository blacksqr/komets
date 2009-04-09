#___________________________________________________________________________________________________________________________________________
inherit CometInterleaving Logical_consistency

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometInterleaving constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Interleaving
 set this(LM_FC) "${objName}_LM_FC";
   Logical_model $this(LM_FC) $this(LM_FC) "The logical functionnal core of $objName"; this Add_LM $this(LM_FC);
   this Add_LM $this(LM_FC)
 set this(LM_LP) "${objName}_LM_LP";
   LogicalInterleaving $this(LM_LP) $this(LM_LP) "The logical presentation of $objName"; this Add_LM $this(LM_LP);
   this Add_LM $this(LM_LP)

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometInterleaving dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
method CometInterleaving get_daughters_name {} {
 set L {}
 foreach ct [this get_daughters] {
   lappend L [$ct get_name]
  }
 return $L
}

#___________________________________________________________________________________________________________________________________________
method CometInterleaving maj_txt_daughters {Lf} {
 set Ld   [this get_daughters]
 set nbLd [llength $Ld]
 set nbLf [llength $Lf]
 set nb [expr ($nbLd<$nbLf)?$nbLd:$nbLf]
 for {set i 0} {$i<$nb} {incr i} {
   set ct [lindex $Ld $i]
   $ct set_text [lindex $Lf $i]
  }
 for {set i $nbLf} {$i<$nbLd} {incr i} {
   set ct [lindex $Ld $i]
   this Sub_daughter_R $ct
   $ct dispose
  }
 for {set i $nbLd} {$i<$nbLf} {incr i} {
   set name "${objName}_ct_$i"
   CometText $name $name {} -set_text [lindex $Lf $i]
   this Add_daughter_R $name
  }
}


#___________________________________________________________________________________________________________________________________________
#___________________________________________ Définition of Logical Model of présentation____________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit LogicalInterleaving Logical_presentation
method LogicalInterleaving constructor {name descr args} {
 this inherited $name $descr
# set p0 [New_proposer]; set this(proposer1) [$p0 P_${objName}_$p0]
# $this(proposer1) Add_successor $this(analyser)
# this Add_EE $this(proposer1)
# Adding some automats
# $this(proposer1) set_current_state "$objName EE_State_ChooseBestPM $this(proposer1) 0.475 0.5"

# Enabling some physical presentations
 if {[regexp "^(.*)_LM_LP" $objName rep comet_name]} {} else {set comet_name $objName}
 set this(comet_name) $comet_name

# set node_name "${comet_name}_PM_P_TK_v_[this get_a_unique_id]"
#   Interleaving_PM_P_TK_frame   $node_name "TK vertical"   {NO MORE TO SAY}
#   $node_name set_cmd_placement {pack $p -expand 1 -fill both}
#   this Add_PM        $node_name
#   this set_PM_active $node_name

 this Add_PM_factories [Generate_factories_for_PM_type [list {Interleaving_PM_P_TK_frame Ptf_TK}			  \
															 {Interleaving_PM_P_nav_mono_TK_menu Ptf_TK}      \
                                                             {CometInterleaving_PM_P_line_BIGre Ptf_BIGre}    \
                                                             {Interleaving_PM_P_HTML Ptf_HTML}                \
                                                             {CometInterleaving_PM_P_ALX_TXT Ptf_ALX_TXT}             \
                                                       ] $objName]

# Managing the subCOmets names
 set this(num_sub) 0

 eval "$objName configure $args"
 return $objName
}
#___________________________________________________________________________________________________________________________________________
method LogicalInterleaving Add_daughter    {m {index -1}} {
global debug

	set pos [this Has_for_daughter $m]
	if { $debug } {puts "XXXX LogicalInterleaving: $objName Add_daughter $m\n  => $pos : [this get_daughters]"}
	if {$pos >= 0} {
          return 2
         }
	set node_name       "$this(comet_name)_subspace_$this(num_sub)"
	set node_name_LM_LP "${node_name}_LM_LP"
	incr this(num_sub)
	CometContainer $node_name "Workspace of [[$m get_LC] get_name]" {Each is used to embody a daughter}
	if {($index == -1) || ([llength $this(L_handle_composing_daughters)] <= $index)} {
	  set pos [llength $this(L_handle_composing_daughters)]
	 } else {set pos $index}
	if {$debug} {puts "LogicalInterleaving: Ajout d'un sous espace ($node_name)"}

        set L_svg $this(L_handle_composing_daughters)
        set this(L_handle_composing_comets)    {}
        set this(L_handle_composing_daughters) {}
  	  set rep [this inherited $node_name_LM_LP $index]
  	 #puts "$objName Add_daughter (inherited) $node_name_LM_LP $index : $rep"
	set this(L_handle_composing_daughters) $L_svg
        set rep [this Add_handle_comet_daughters ${node_name}_LM_LP $pos ""]
#	puts "$objName Add_handle_comet_daughters $node_name $pos _LM_LP : $rep"
	  set rep [$node_name_LM_LP Add_daughter $m]
#	  puts "$node_name_LM_LP Add_daughter $m : $rep"

        this maj_interleaved_daughters
        set this(L_handle_composing_comets) $this(L_handle_composing_daughters)

	return 1
}
#_________________________________________________________________________________________________________
method LogicalInterleaving Sub_daughter    {m} {set rep [this inherited $m]
                                                if {$rep == 1} {} else {return $rep}
                                                set cont $this(last_nested_daughter_subbing)
                                                if {[string equal $cont {}]} {
                                                  #puts "ARGHH COMMENT CA ON ENLEVE PAS DE CONTENEUR GENERE???"
                                                 } else {foreach LM $cont {
                                                           set LC [$LM get_LC]
                                                           set L_svg $this(L_handle_composing_daughters)
                                                             set this(L_handle_composing_daughters) {}
                                                             set rep2 [this inherited $LM]
                                                           set this(L_handle_composing_daughters) $L_svg
                                                           this Sub_composing_comet $LM
                                                           $LC dispose
                                                           Sub_element this(L_composing_comets)           $LM
                                                           Sub_element this(L_handle_composing_comets)    $LM
                                                           Sub_element this(L_handle_composing_daughters) $LM
                                                           this maj_interleaved_daughters
                                                          }
                                                        }
                                                set this(L_handle_composing_comets) $this(L_handle_composing_daughters)
                                                return $rep}
#___________________________________________________________________________________________________________________________________________
method LogicalInterleaving EE_State_NoPM {proposer} {
 set nb_active_PM [llength $this(L_actives_PM)]
 if {[expr $nb_active_PM > 0]} {return "$objName EE_State_NoPM $proposer"}
# Check if it is possible to plug this LM on one of its mothers
 foreach LM_M $this(L_mothers) {# Check if a PM can be plugged
                                foreach PM_M [$LM_M get_L_PM] {
                                  foreach PM [this get_L_PM] {if {[$PM_M Accept_for_daughter $PM]} {
                                                                # Propose to plug PM on PM_M
                                                                 set p [$proposer New_proposition]
                                                                 $p set_Conviction 0.8
                                                                 $p set_Author Conceptor
                                                                 $p set_Nature User_suitability
                                                                 $p set_Fonction "$LM_M Add_PM_daughter $PM"
                                                                 $proposer Add_action $p
                                                               }
                                                             }
                                 }
                               }
 return "$objName EE_State_NoPM $proposer"
}
#___________________________________________________________________________________________________________________________________________
method LogicalInterleaving EE_State_SomePM {proposer} {
 return "$objName EE_State_SomePM $proposer"
}

#___________________________________________________________________________________________________________________________________________
method LogicalInterleaving maj_interleaved_daughters {} {
 foreach PM [this get_L_actives_PM] {
   $PM maj_interleaved_daughters
  }
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Interleaving_PM_P_TK_frame PhysicalContainer_TK_frame
#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_TK_frame constructor {name descr args} {
 this inherited $name $descr
 
 eval "$objName configure $args"
 return $objName
}
#___________________________________________________________________________________________________________________________________________
method PhysicalContainer_TK_frame maj_interleaved_daughters {} {}

