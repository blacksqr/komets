#__________________________________________________
inherit CommonFC_CamNoteExaminator CommonFC

method CommonFC_CamNoteExaminator constructor {} {
 this inherited
 set this(L_notes)      {}
 set this(slide_viewer) {}
 set this(id)           {}
 set this(pass)         {}
 set this(mode)         WAIT_START
}

#______________________________________________________
Generate_List_accessor CommonFC_CamNoteExaminator L_notes notes
Generate_accessors     CommonFC_CamNoteExaminator [list slide_viewer mode id pass]

#__________________________________________________
#__________________________ Adding the activator functions 
proc L_methodes_get_CamNote_Examinator {} {return [list {get_id { }} {get_pass { }} {get_slide_viewer { }} {get_mode { }} {get_notes { }} ]}
proc L_methodes_set_CamNote_Examinator {} {return [list {set_id {v}} {set_pass {v}} {set_slide_viewer {c}} {set_mode {m}} {set_notes {L}} {Add_notes {L}} {Sub_notes {L}} ]}
