inherit CometChoixMedecin_CFC CommonFC

#___________________________________________________________________________________________________________________________________________
method CometChoixMedecin_CFC constructor {} {
 set this(textual_state) {You have asked to see a doctor here. It is 11 PM.}
 set this(question)      {Here are 4 solutions:}
 set this(L_choices)     [list "Doctor Mabuse (10 miles away from here)" \
                               "Hospital (25 miles away from here)" \
							   "Medical hotline (3624)" \
							   "Firemen (18)" \
						 ]
 set this(choice)        ""
}
#___________________________________________________________________________________________________________________________________________
Generate_accessors CometChoixMedecin_CFC [list textual_state question L_choices choice]

#___________________________________________________________________________________________________________________________________________
method CometChoixMedecin_CFC validate {} {}
method CometChoixMedecin_CFC cancel {} {}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_get_CometChoixMedecin {} {return [list {get_choice { }} {get_textual_state { }} {get_question { }} {get_L_choices { }} {validate {}} {cancel {}} ]}
proc P_L_methodes_set_CometChoixMedecin {} {return [list {set_choice {v}} {set_textual_state {v}} {set_question {v}} {set_L_choices {v}} ]}

