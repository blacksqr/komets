#__________________________________________________
inherit CommonFC_Clock CommonFC

method CommonFC_Clock constructor {} {
 this inherited
 set this(t) {}
}

#______________________________________________________
method CommonFC_Clock get_time {}  {
    return $this(t)
}
method CommonFC_Clock set_time {t} {
    set this(t) $t
}
#__________________________________________________
#__________________________ Adding the activator functions 
proc L_methodes_get_Clock {} {return [list {get_time { }} ]}
proc L_methodes_set_Clock {} {return [list {set_time {t}} ]}
