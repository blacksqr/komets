inherit CometConsultationMedecin_CFC CommonFC

#___________________________________________________________________________________________________________________________________________
method CometConsultationMedecin_CFC constructor {} { 
 set this(textual_state) {You are 2 hours away from home.}
 set this(question)  {Would you like to see a doctor at home or here ?}
 set this(L_choices) {{At Home} Here}
 set this(choice)    {}
}
#___________________________________________________________________________________________________________________________________________
Generate_accessors CometConsultationMedecin_CFC [list textual_state choice question L_choices]

#___________________________________________________________________________________________________________________________________________
method CometConsultationMedecin_CFC validate {} {}
method CometConsultationMedecin_CFC cancel   {} {}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_get_CometConsultationMedecin {} {return [list {get_choice { }} {get_textual_state { }} {get_question { }} {get_L_choices { }} {validate {}} {cancel {}} ]}
proc P_L_methodes_set_CometConsultationMedecin {} {return [list {set_choice {v}} {set_textual_state {v}} {set_question {v}} {set_L_choices {v}} ]}

