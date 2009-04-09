#__________________________________________________
inherit WizardOfOz_Helper_CFC CommonFC

#______________________________________________________
method WizardOfOz_Helper_CFC constructor {} {
 this inherited
 set this(L_traces)          ""
   this Subscribe_to_set_interupt_strategy $objName "$objName Add_trace_for set_interupt_strategy \$v" UNIQUE
   this Subscribe_to_set_trigger_strategy  $objName "$objName Add_trace_for set_trigger_strategy  \$v" UNIQUE
   this Subscribe_to_set_initiative_type   $objName "$objName Add_trace_for set_initiative_type   \$v" UNIQUE
   this Subscribe_to_set_presentation_type $objName "$objName Add_trace_for set_presentation_type \$v" UNIQUE
   this Subscribe_to_Add_L_notes           $objName "$objName Add_trace_for Add_L_notes           \$L" UNIQUE
   this Subscribe_to_Add_L_notes           $objName "$objName Add_trace_for Add_L_notes           \$L" UNIQUE
   
 set this(presentation_type) ""
 set this(initiative_type)   ""
 set this(L_notes)           ""
 set this(current_note)      ""
 set this(L_topics)          ""
 set this(trigger_strategy)  ""
 set this(interupt_strategy) ""
}

#______________________________________________________
method WizardOfOz_Helper_CFC Add_trace_for {args} {
 lappend this(L_traces) [clock clicks -milliseconds] $args
}

#______________________________________________________
Generate_accessors     WizardOfOz_Helper_CFC [list current_note L_traces interupt_strategy trigger_strategy initiative_type presentation_type]
Generate_List_accessor WizardOfOz_Helper_CFC L_topics L_topics
Generate_List_accessor WizardOfOz_Helper_CFC L_notes  L_notes

set L_mtd_to_subscribe [list set_interupt_strategy set_trigger_strategy set_initiative_type set_presentation_type Add_L_notes Add_L_topics]
Manage_CallbackList WizardOfOz_Helper_CFC $L_mtd_to_subscribe end

#____________________________________________________________________________________
#__________________________ Adding the activator functions __________________________
#____________________________________________________________________________________
proc L_methodes_get_WizardOfOz_Helper {} {return [list {get_current_note { }} {get_interupt_strategy { }} {get_trigger_strategy { }} {get_initiative_type { }} {get_presentation_type { }} {get_L_notes { }} {get_L_topics { }} {get_L_traces { }} ]}
proc L_methodes_set_WizardOfOz_Helper {} {return [list {set_current_note {v}} {set_interupt_strategy {t}} {set_trigger_strategy {t}} {set_initiative_type {t}} {set_presentation_type {t}} {set_L_notes {L}} {Sub_L_notes {L}} {Add_L_notes {L}} {set_L_topics {L}} {Sub_L_topics {L}} {Add_L_topics {L}} ]}


