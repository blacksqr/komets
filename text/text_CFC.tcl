inherit CommonFC_Text CommonFC

method CommonFC_Text constructor {} {
 set this(txt)      0
 set this(editable) true
}


#___________________________________________________________________________________________________________________________________________
method CommonFC_Text get_text {}  {return $this(txt)}
method CommonFC_Text set_text {t} {set this(txt) $t}

#___________________________________________________________________________________________________________________________________________
#_______________________________________________________ Adding the text functions _______________________________________________
set L_methodes_get_Text [list {get_text {}}  ]
set L_methodes_set_Text [list {set_text {t}} ]
