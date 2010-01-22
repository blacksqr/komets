#___________________________________________________________________________________________________________________________________________
# Add a new factory that will generate a nested graph $graph.
# A PM typed PM_type_to_encaps is the PM that will be the core of the encapsulation.
#___________________________________________________________________________________________________________________________________________
proc Add_U_fine_tuned_factory_for_encaps {LM ptf_for_mothers ptf_for_daughters PM_type_to_encaps graph} {
 puts "Add_U_fine_tuned_factory_for_encaps $LM $ptf_for_mothers $ptf_for_daughters $PM_type_to_encaps $graph"
 set factory [CPool get_a_unique_name]
 PM_factory $factory $ptf_for_mothers "Add_U_fine_tuned_factory_for_encaps_$PM_type_to_encaps" [list U_fine_tuned_factory_for_encaps $LM $ptf_for_mothers $ptf_for_daughters $PM_type_to_encaps $graph]
 $LM Add_PM_factories $factory
}

#___________________________________________________________________________________________________________________________________________
proc U_fine_tuned_factory_for_encaps {LM ptf_for_mothers ptf_for_daughters PM_type_to_encaps graph} {
 puts "U_fine_tuned_factory_for_encaps $LM $ptf_for_mothers $ptf_for_daughters $PM_type_to_encaps $graph"
 set PM [CPool get_a_comet $PM_type_to_encaps]
 $LM Add_PM $PM
 set rep [U_encapsulator_PM $PM $graph]
 
 [[$rep get_cou] get_ptf] set_soft_type          [$ptf_for_mothers get_soft_type]
 [[$rep get_cou] get_ptf] set_daughter_soft_type [$ptf_for_daughters get_soft_type]
 
 
 puts "  _-_-_-_ Produced $rep"
 Afficher_structure $rep
 
 return $rep
}
