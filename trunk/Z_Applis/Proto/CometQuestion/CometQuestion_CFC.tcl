inherit CometQuestion_CFC CommonFC

#___________________________________________________________________________________________________________________________________________
method CometQuestion_CFC constructor {} {
 set this(question) {How can I help you (e.g. ask : I need to be at train station in 30 mns.)}
 set this(sentence) {}
}
#___________________________________________________________________________________________________________________________________________
Generate_accessors CometQuestion_CFC [list question sentence]

#___________________________________________________________________________________________________________________________________________
method CometQuestion_CFC Ask_sentence {} {}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_get_CometQuestion {} {return [list {get_question { }} {get_sentence { }} {Ask_sentence {}} ]}
proc P_L_methodes_set_CometQuestion {} {return [list {set_question {v}} {set_sentence {v}} ]}

