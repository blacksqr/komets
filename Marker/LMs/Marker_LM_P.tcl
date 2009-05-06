#___________________________________________________________________________________________________________________________________________
#___________________________________________ Définition of Logical Model of présentation____________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit LogicalMarker Logical_presentation
method LogicalMarker constructor {name descr args} {
 this inherited $name $descr

# Enabling some physical presentations
 if {[regexp "^(.*)_LM_LP" $objName rep comet_name]} {} else {set comet_name $objName}
 set this(comet_name) $comet_name

 set node_name "${comet_name}_PM_P_TK_RadioBt"
   Marker_PM_P_TK_RadioBt   $node_name "TK RadioButtons"   {NO MORE TO SAY}
   this Add_PM        $node_name
   this set_PM_active $node_name
   
   
#________  la partie html __________________
# set node_name "${comet_name}_PM_P_HTML_Radio"
#   Marker_PM_P_Radio_HTML   $node_name "HTML RadioButtons"   {NO MORE TO SAY}
#   this Add_PM        $node_name
#   this set_PM_active $node_name

 this Add_PM_factories [Generate_factories_for_PM_type [list {Marker_PM_P_ALX_TXT Ptf_ALX_TXT}    \
                                                             {Marker_PM_P_Radio_HTML Ptf_HTML}    \
                                                             {Marker_PM_P_CheckBox_HTML Ptf_HTML} \
															 {Marker_PM_P_B207_surrounding Ptf_BIGre} \
															 {Marker_PM_P_RadioBouton_FLEX Ptf_FLEX} \
															 {Marker_PM_P_CheckBox_FLEX Ptf_FLEX} \
                                                       ] $objName]
# set node_name "${comet_name}_PM_P_HTML_CheckBox"
#   Marker_PM_P_CheckBox_HTML   $node_name "HTML CheckBox"   {NO MORE TO SAY}
#   this Add_PM        $node_name
	#this set_PM_active $node_name


   

 
  #________ fin la partie html __________________

   
# Managing the subCOmets names
 set this(num_sub) 0
 
 eval "$objName configure $args"
}
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC LogicalMarker [L_methodes_set_Marker] {}          {$this(L_actives_PM)}
Methodes_get_LC LogicalMarker [L_methodes_get_Marker] {$this(FC)}
Generate_LM_setters LogicalMarker [L_methodes_CometRE_Marker]


#___________________________________________________________________________________________________________________________________________
method LogicalMarker set_PM_active {PM} {
 this inherited $PM
 if {[string equal [this get_LC] {}]} {return}
 $PM set_mark [this get_mark]
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method LogicalMarker EE_State_NoPM {proposer} {
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
method LogicalMarker EE_State_SomePM {proposer} {
 return "$objName EE_State_SomePM $proposer"
}

