set L_methodes_get_choicesN [list {get_comet_label {}}  {get_b_inf {}}  {get_b_sup {}}  {get_step {}}  {get_val {}} ]
set L_methodes_set_choicesN [list {set_comet_label {c}} {set_b_inf {v}} {set_b_sup {v}} {set_step {v}} {set_val {v}}]

#___________________________________________________________________________________________________________________________________________
inherit ChoiceN_CFC CommonFC

#___________________________________________________________________________________________________________________________________________
method ChoiceN_CFC constructor { {comet_label label} {borne_inf 0} {borne_sup 100} {step 1} } {
 this inherited
 set this(comet_label) $comet_label
 set this(b_inf)       $borne_inf
 set this(b_sup)       $borne_sup
 set this(step)        $step
 set this(val)         $borne_inf
}

#___________________________________________________________________________________________________________________________________________
method ChoiceN_CFC get_comet_label {}  {return $this(comet_label)}
method ChoiceN_CFC set_comet_label {c} {set this(comet_label) $c}

#___________________________________________________________________________________________________________________________________________
method ChoiceN_CFC get_b_inf {}  {return $this(b_inf)}
method ChoiceN_CFC set_b_inf {v} {set this(b_inf) $v}

#___________________________________________________________________________________________________________________________________________
method ChoiceN_CFC get_b_sup {}  {return $this(b_sup)}
method ChoiceN_CFC set_b_sup {v} {set this(b_sup) $v}

#___________________________________________________________________________________________________________________________________________
method ChoiceN_CFC get_step  {}  {return $this(step)}
method ChoiceN_CFC set_step  {v} {set this(step) $v}

#___________________________________________________________________________________________________________________________________________
method ChoiceN_CFC get_val  {}  {return $this(val)}
method ChoiceN_CFC set_val  {v} {set this(val) $v}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
if {[info exists nb_ChoiceN_CFC]} {} else {set ChoiceN_CFC 0}

proc New_ChoiceN_CFC {label_name borne_inf borne_sup step} {
 global nb_ChoiceN_CFC
 set name "ChoiceN_$nb_ChoiceN_CFC"
 ChoiceN_CFC $name $label_name $borne_inf $borne_sup $step
 incr nb_ChoiceN_CFC
 return $name
}

