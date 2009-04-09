

#__________________________________________________
inherit CommonFC_Specifyer CommonFC

method CommonFC_Specifyer constructor {} {
 set this(txt)      {}
}
#______________________________________________________
method CommonFC_Specifyer get_text {}  {
    return $this(txt)
}
method CommonFC_Specifyer set_text {t} {
    set this(txt) $t
}
#__________________________________________________
#__________________________ Adding the activator functions 
set L_methodes_get_Specifyer [list {get_text { }} ]
set L_methodes_set_Specifyer [list {set_text {t}} ]

#___________________________________________________________________________________________________________________________________________
