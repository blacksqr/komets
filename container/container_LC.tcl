#___________________________________________________________________________________________________________________________________________
inherit CometContainer Logical_consistency                          

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometContainer constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Container
# set this(LM_FC) "${objName}_LM_FC";
#   Logical_model $this(LM_FC) $this(LM_FC) "The logical functionnal core of $objName"; this Add_LM $this(LM_FC);
 set this(LM_LP) "${objName}_LM_LP";
   LogicalContainer $this(LM_LP) $this(LM_LP) "The logical presentation of $objName"; this Add_LM $this(LM_LP);
    
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometContainer dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
#___________________________________________ Définition of Logical Model of présentation ____________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit LogicalContainer Logical_presentation
method LogicalContainer constructor {name descr args} {
 this inherited $name $descr

# Enabling some physical presentations
 if {[regexp "^(.*)_LM_LP" $objName rep comet_name]} {} else {set comet_name $objName}
 set this(comet_name) $comet_name
 #set node_name "${comet_name}_PM_P_TK_frame_[this get_a_unique_id]"
 #  PhysicalContainer_TK_frame   $node_name "TK frame" {NO MORE TO SAY}
 #  this Add_PM        $node_name
 #  this set_PM_active $node_name

 this Add_PM_factories [Generate_factories_for_PM_type [list {PhysicalContainer_TK_frame Ptf_TK}      \
															 {PhysicalContainer_TK_window Ptf_TK}     \
                                                             {Container_PM_P_BIGre_normal Ptf_BIGre}  \
                                                             {Container_PM_P_HTML Ptf_HTML}           \
															 {Container_PM_P_SVG_group Ptf_SVG}       \
                                                             {Container_PM_P_BIGre_window Ptf_BIGre}  \
                                                             {Container_PM_P_ALX_TXT Ptf_ALX_TXT}     \
															 {Container_PM_P_FLEX_window Ptf_FLEX}    \

                                                       ] $objName]

 eval "$objName configure $args"
 return $objName
}

