#___________________________________________________________________________________________________________________________________________
# Add a new factory that will generate a nested graph $graph.
# A PM typed PM_type_to_encaps is the PM that will be the core of the encapsulation.
#___________________________________________________________________________________________________________________________________________
proc Add_U_fine_tuned_factory_for_encaps {LM ptf_for_mothers ptf_for_daughters PM_type_to_encaps graph} {
 set factory [CPool get_a_unique_name]
 PM_factory $factory $ptf_for_mothers "" [list U_fine_tuned_factory_for_encaps $LM $ptf_for_mothers $ptf_for_daughters $PM_type_to_encaps $graph]
 [$factory get_ptf]
}

#___________________________________________________________________________________________________________________________________________
proc U_fine_tuned_factory_for_encaps {LM ptf_for_mothers ptf_for_daughters PM_type_to_encaps graph} {
 set PM [CPool get_a_comet $PM_type_to_encaps]
 $LM Add_PM $PM
 U_encapsulator_PM $PM $graph
} 