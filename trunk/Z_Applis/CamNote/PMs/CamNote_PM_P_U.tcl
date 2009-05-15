
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometCamNote_PM_U PM_U_Container

#___________________________________________________________________________________________________________________________________________
method CometCamNote_PM_U constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CT_CamNote_AUI_basic_CUI_basic_Universal
   this set_nb_max_mothers 1
   set this(internal_log) {}
 eval "$objName configure $args"
 return $objName
}
#___________________________________________________________________________________________________________________________________________
method CometCamNote_PM_U dispose {} {
 if {$this(internal_log) != ""} {
   catch "$this(internal_log) dispose"
  }
 this inherited
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometCamNote_PM_U [L_methodes_set_CamNote] {}          {}
Methodes_get_LC CometCamNote_PM_U [L_methodes_get_CamNote] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method CometCamNote_PM_U Add_Examinator {n p id} {this maj_users}

#___________________________________________________________________________________________________________________________________________
method CometCamNote_PM_U Sub_Examinator {n p id} {this maj_users}

#___________________________________________________________________________________________________________________________________________
method CometCamNote_PM_U maj_users {} {
 if {$this(internal_log) != ""} {
   $this(internal_log) set_L_valid_id_pass [[this get_Common_FC] get_L_valid_id_pass]
  }
}

#___________________________________________________________________________________________________________________________________________
method CometCamNote_PM_U set_LM {LM} {
 if {$LM != ""} {
   this inherited $LM
   set this(internal_log) ${objName}_C_log
   if {![gmlObject info exists object $this(internal_log)]} {
     set this(cont) [CPool get_a_comet CometContainer]
	 CometLog $this(internal_log) "Log to [this get_LC]" {}
	 $this(cont) Add_daughter_R $this(internal_log)
	}
   set L $this(cont)_LM_LP
   this set_L_nested_handle_LM    $L
   this set_L_nested_daughters_LM $L
  } else {this inherited $LM}
}

#___________________________________________________________________________________________________________________________________________
method CometCamNote_PM_U Add_mother {m {index -1}} {
 set rep [this inherited $m $index]
 if {$rep == 1} {
   this maj_users
   $this(internal_log) Subscribe_to_Task_is_completed $objName "$objName Branch_to_user \[$this(internal_log) get_id\]"
  }
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method CometCamNote_PM_U Branch_to_user {u} {
 puts "______________$objName Branch_to_user \"$u\""
 if {$u == ""} {return}
 set CU [[this get_Common_FC] get_user_comet_from_id $u]
 if {$CU == ""} {return}
 puts "$this(cont) set_daughters_R $CU"
 $this(cont) set_daughters_R $CU
 puts "______________________________"

if {![string equal [${objName}_cou_ptf get_soft_type] BIGre]} {return}
# Cas d'un PM BIGre, appliquer des styles prédéfinis
 # Container de l'image => en fenêtre
 set n [CSS++ $objName "$objName ~ CometContainer \\\>CometImage/"]
 if {[llength $n] != 1} {puts "!!!!!!!!ERROR in $objName Branch_to_user"
  } else {set new_n [$n Substitute_by_PM_type Container_PM_P_BIGre_window]
          $new_n set_method_placement Etirer_contenu
          [$new_n get_prim_handle] Rendu_ecran_direct 1
         }

 # Télécommande => Adapter
 set n [CSS++ $objName "\#$objName ~ CometSlideRemoteController(>CometContainer)"]
 foreach PM $n {$PM set_method_placement Line_h}
}
