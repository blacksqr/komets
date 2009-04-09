inherit CometSlideRemoteController CometChoiceN


#___________________________________________________________________________________________________________________________________________
method CometSlideRemoteController constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id N_controller
 set CFC [this get_Common_FC];
   $CFC dispose
   CommonFC_CometSlideRemoteController $CFC
   this set_Common_FC $CFC

 set this(LM_LP) "${objName}_LM_LP";
   $this(LM_LP) dispose
   CometSlideRemoteController_LM_P  $this(LM_LP) $this(LM_LP) "The logical presentation of $name"
   this Sub_LM $this(LM_LP);
   this Add_LM $this(LM_LP);
 set this(LM_FC) "${objName}_LM_FC";
   CometSlideRemoteController_LM_FC $this(LM_FC) $this(LM_FC) "This logical part manage different protocoles"
   this Add_LM $this(LM_FC);

 this set_nb_max_daughters 999999
 
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometSlideRemoteController dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometSlideRemoteController [L_methodes_set_SlideRemoteController] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometSlideRemoteController [L_methodes_get_SlideRemoteController] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method CometSlideRemoteController set_current {v} {this set_val $v}
method CometSlideRemoteController go_to_nxt {} {set FC [this get_Common_FC]; $FC go_to_nxt; this set_val [this get_val]}
method CometSlideRemoteController go_to_prv {} {set FC [this get_Common_FC]; $FC go_to_prv; this set_val [this get_val]}
method CometSlideRemoteController go_to_bgn {} {set FC [this get_Common_FC]; $FC go_to_bgn; this set_val [this get_val]}
method CometSlideRemoteController go_to_end {} {set FC [this get_Common_FC]; $FC go_to_end; this set_val [this get_val]}

