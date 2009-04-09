#__________________________________________________
inherit CommonFC_CometComposer_LC CommonFC

#__________________________________________________
method CommonFC_CometComposer_LC constructor {} {
 this inherited
 
 set this(spaces)      ""
 set this(redundancy)  1
 set this(composition) ""
 set this(L_relations) [list]
}

#______________________________________________________
Generate_accessors     CommonFC_CometComposer_LC [list composition spaces redundancy]
Generate_List_accessor CommonFC_CometComposer_LC L_relations L_relations

#__________________________________________________
#__________________________ Adding the activator functions 
proc L_methodes_get_CommonFC_CometComposer_LC {} {return [list {get_redundancy { }} {get_composition { }} {get_spaces { }} {get_L_relations { }} ]}
proc L_methodes_set_CommonFC_CometComposer_LC {} {return [list {set_redundancy {v}} {set_composition {v}} {set_spaces {v}} {set_L_relations {v}} {Add_L_relations {v}} {Sub_L_relations {v}} ]}
