

#___________________________________________ Définition of Logical Model of présentation ___________________________________________________
inherit CometClock_LM_P Logical_presentation

method CometClock_LM_P constructor {name descr args} {
 this inherited $name $descr
 
 set this(init_ok) 0
  
# Adding some physical presentations
# if {[regexp "^(.*)_LM_LP" $objName rep comet_name]} {} else {set comet_name $objName}
#   set name ${comet_name}_PM_P_basic_[this get_a_unique_id]
##   CometClock_PM_P_basic_TK $name "Computer clock" {A very basic clock}
#   CometClock_PM_P_graph_canvas_TK $name "Computer clock" {A very basic clock}
#   this Add_PM $name

# Factories
 this Add_PM_factories [Generate_factories_for_PM_type [list {CometClock_PM_P_graph_canvas_TK Ptf_TK} \
                                                             {CometClock_PM_P_basic_TK Ptf_TK}        \
                                                             {Clock_PM_P_ALX_TXT Ptf_ALX_TXT}      \
                                                       ] $objName]

 set this(init_ok) 1

 eval "$objName configure $args"
 return $objName
}


#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometClock_LM_P [L_methodes_set_Clock] {}          {$this(L_actives_PM)}
Methodes_get_LC CometClock_LM_P [L_methodes_get_Clock] {$this(FC)}

