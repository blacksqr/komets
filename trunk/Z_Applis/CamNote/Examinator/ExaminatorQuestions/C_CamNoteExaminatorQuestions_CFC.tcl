#__________________________________________________
inherit CommonFC_CamNoteExaminatorQuestions CommonFC

method CommonFC_CamNoteExaminatorQuestions constructor {} {
 this inherited
 set this(L_questions)            {}
 set this(current_question_index)  0
 set this(mode)                    WAIT_START
}

#______________________________________________________
Generate_accessors     CommonFC_CamNoteExaminatorQuestions [list mode current_question_index]

#______________________________________________________
method CommonFC_CamNoteExaminatorQuestions set_question {Q num_slide} {
 lappend this(L_questions) [list $Q $num_slide]
}

#______________________________________________________
method CommonFC_CamNoteExaminatorQuestions get_current_question {} {
 set Q [lindex $this(L_questions) $this(current_question_index)]
 return [lindex $Q 0]
}
#__________________________________________________
#__________________________ Adding the activator functions 
proc L_methodes_get_CamNote_ExaminatorQuestions {} {return [list {get_mode { }} {get_current_question { }}   ]}
proc L_methodes_set_CamNote_ExaminatorQuestions {} {return [list {set_mode {m}} {set_question {Q num_slide}} ]}
