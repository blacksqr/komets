inherit CometClock_LM_FC Logical_model

#______________________________________________________
method CometClock_LM_FC constructor {name descr args} {
 this inherited $name $descr

 set this(init_ok) 0
  
# Adding some physical presentations
 if {[regexp "^(.*)_LM_FC" $objName rep comet_name]} {} else {set comet_name $objName}
   set name ${comet_name}_PM_FC_local_[this get_a_unique_id]
   CometClock_PM_FC_local $name "Computer clock" {Clock of the computer, time is the one of computer}
   this Add_PM $name

 set this(init_ok) 1

 eval "$objName configure $args"
 return $objName
}

#______________________________________________________
method CometClock_LM_FC dispose {} {this inherited}


#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometClock_LM_FC [L_methodes_set_Clock] {}          {$this(L_actives_PM)}
Methodes_get_LC CometClock_LM_FC [L_methodes_get_Clock] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometClock_LM_FC set_time {t} {}

#___________________________________________________________________________________________________________________________________________
method CometClock_LM_FC update_time {t} {
# Manage different times
 [this get_LC] set_time $t
}
