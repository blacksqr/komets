#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
proc Encapsulate_for_extendability {LM PM LM_encaps {txt_bt Add} {txt_add {New element}} } {
 set i_DSL interpretor_DSL_comet_interface
 set inner_cont      "${LM}_inner_cont"
 set inner_spec      "${LM}_inner_spec"
 set inner_spec_cont "${LM}_inner_spec_cont"
 set inner_spec_txt  "${LM}_inner_text"
 set inner_bt        "${LM}_inner_bt"

   set r $LM; Encapsulate $r $PM $LM_encaps;
     $r Nested_style $i_DSL "$inner_cont = C_Cont(, [$r get_factice_LC](), $inner_spec = C_Spec())" [$r get_core]

   set r ${inner_spec}_LM_LP; Encapsulate $r PM_Universal U_LM_encaps_specifyer_LM_P;
     $r Nested_style $i_DSL "$inner_spec_cont = C_Cont(, $inner_spec_txt = C_Text(set_text \"$txt_add\"),[$r get_factice_LC](), $inner_bt = C_Act(set_text $txt_bt))" ${inner_spec_cont}_LM_LP

   $inner_bt Subscribe_to_activate $LM "[$LM get_LC] Add_daughter_R \[$inner_spec get_text\]"

 return $LM
}

