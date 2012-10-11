#__________________________________________________
inherit CommonFC_Activator CommonFC

method CommonFC_Activator constructor {} {
 set this(txt) OK
}
#______________________________________________________
method CommonFC_Activator get_text {}  {
    return $this(txt)
}
method CommonFC_Activator set_text {t} {
    set this(txt) $t
}
#__________________________________________________
method CommonFC_Activator activate { {type {}} } {}

#__________________________________________________
set L_methodes_get_Activator [list {get_text { }} ]
set L_methodes_set_Activator [list {set_text {t}} {activate {{type {}}}}]

#___________________________________________________________________________________________________________________________________________
