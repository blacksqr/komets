inherit PM_Choice_HTML PM_HTML

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method PM_Choice_HTML constructor {name descr args} {
 this inherited $name $descr
 
   this Add_MetaData PRIM_STYLE_CLASS [list $objName "ROOT CHOICE IN OUT" \
                                      ]

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC PM_Choice_HTML $L_methodes_set_choices {$this(FC)} {}
Methodes_get_LC PM_Choice_HTML $L_methodes_get_choices {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method PM_Choice_HTML prim_set_currents {c} {
 if {[string equal [this get_currents] $c]} {return}
 [this get_LC] set_currents $c
}
