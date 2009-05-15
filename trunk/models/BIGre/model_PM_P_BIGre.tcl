#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit PM_BIGre Physical_model

#___________________________________________________________________________________________________________________________________________
method PM_BIGre constructor {name descr args} {
 this inherited $name $descr
 set this(root)              {}
 # XXX DEBUG 2009 02 16. Was : set this(cmd_deconnect)     "\[$objName get_prim_handle\] Retirer_fils \$p"
 set this(cmd_deconnect)     "\[$objName get_root_for_daughters\] Retirer_fils \$p"

 set ptf [$this(cou) get_ptf]
 $ptf maj Ptf_BIGre

 set this(rap_placement)    [B_rappel [Interp_TCL]]
 set this(rap_redirect_key) [B_rappel [Interp_TCL]]
 set this(nb_pointers_in) 0
 
 this set_cmd_placement {}
 this set_nb_max_mothers 1
 
 set this(L_Pool_B_point)            [list]
 set this(L_Pool_Liste_alx_repere2D) [list]
 
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre dispose {} {
 foreach PMM $this(L_mothers) {$PMM Sub_prim_daughter $objName [$objName get_prim_handle]}
 this inherited
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors PM_BIGre [list rap_placement nb_pointers_in]

#___________________________________________________________________________________________________________________________________________
method PM_BIGre Origine {x y} {[this get_prim_handle] Origine $x $y}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre Px {v} {[this get_prim_handle] Px $v}
method PM_BIGre Py {v} {[this get_prim_handle] Py $v}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre Rotation {v} {[this get_prim_handle] Rotation $v}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre get_a_B_point {} {
 if {[llength $this(L_Pool_B_point)] > 0} {
   set rep [lindex $this(L_Pool_B_point) 0]
   set this(L_Pool_B_point) [lrange $this(L_Pool_B_point) 1 end]
  } else {set rep [B_point]
         }
		 
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre release_a_B_point {pt} {
 Add_list this(L_Pool_B_point) $pt
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre get_a_Liste_alx_repere2D {} {
 if {[llength $this(L_Pool_Liste_alx_repere2D)] > 0} {
   set rep [lindex $this(L_Pool_Liste_alx_repere2D) 0]
   set this(L_Pool_Liste_alx_repere2D) [lrange $this(L_Pool_Liste_alx_repere2D) 1 end]
  } else {set rep [Liste_alx_repere2D]
         }
		 
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre release_a_Liste_alx_repere2D {r} {
 Add_list this(L_Pool_Liste_alx_repere2D) $r
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre Etirer_de {ex {ey ""}} {
 if {$ey == ""} {set ey $ex}
 [this get_prim_handle] Etirer_de $ex $ey
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre Etirement_interne {{infos {}} ex ey cx cy} {
 if {$infos != ""} {
   set node       [Real_class [$infos NOEUD]]
   set L_repere2D [this get_a_Liste_alx_repere2D] 
   set L_rep_tmp  [this get_a_Liste_alx_repere2D] 
   Lister_partie_noeud [$infos L_REPERES] \
					   [this get_prim_handle] \
					   $node \
                       $L_rep_tmp
   Ajouter_noeud_en_fin_de_liste_rep $L_rep_tmp $node
   Lister_partie_index $L_rep_tmp 1 9999 $L_repere2D
   set pt_tmp [this get_a_B_point]; $pt_tmp maj [$infos Point_au_contact]
   Repere_transformation_inverse $pt_tmp $L_repere2D
   set cx [$pt_tmp X]; set cy [$pt_tmp Y]
   #puts "New click coords are <$cx ; $cy>"
   
   this release_a_Liste_alx_repere2D $L_repere2D
   this release_a_Liste_alx_repere2D $L_rep_tmp
   this release_a_B_point            $pt_tmp
  }
 [this get_prim_handle] Etirement_interne $ex $ey $cx $cy
}
#Trace PM_BIGre Etirement_interne

#___________________________________________________________________________________________________________________________________________
method PM_BIGre Etirement {ex {ey ""}} {
 if {$ey == ""} {set ey $ex}
 [this get_prim_handle] Etirement $ex $ey
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre Show_elements_prims {b L_prims} {
 foreach p $L_prims {$p Afficher_noeud $b; $p Gerer_contacts $b; $p Ne_pas_pre_rendre [expr 1-$b]}
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre Incr_nb_pointers_in {} {incr this(nb_pointers_in)}
method PM_BIGre Decr_nb_pointers_in {} {incr this(nb_pointers_in) -1}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre get_rap_placement_txt { } {return [$this(rap_placement) Texte]}
method PM_BIGre set_rap_placement_txt {t} {
 set n [this get_prim_handle]
 $n desabonner_de_LR_parcours [$n LR_Av_pre_rendu] [$this(rap_placement) Rappel]
 if {$t != ""} {
   $n abonner_a_LR_parcours [$n LR_Av_pre_rendu] [$this(rap_placement) Rappel]
  }
 return [$this(rap_placement) Texte $t]
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre set_method_placement {m} {
 if {$m != ""} {
   this set_rap_placement_txt "$objName $m"
  } else {this set_rap_placement_txt ""}
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre On_wheel_down {cmd} {
 puts "$objName On_wheel_down {$cmd}"
 if {![info exists this(rap_on_wheel_down)]} {
   set this(rap_on_wheel_down) [B_rappel [Interp_TCL]]
   [this get_prim_handle] abonner_a_detection_pointeur [$this(rap_on_wheel_down) Rappel] [ALX_pointeur_enfonce]
  }
 $this(rap_on_wheel_down) Texte [list $objName Is_a_pointer_press $this(rap_on_wheel_down) 4 $cmd]
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre On_wheel_up {cmd} {
 puts "$objName On_wheel_up {$cmd}"
 if {![info exists this(rap_on_wheel_up)]} {
   set this(rap_on_wheel_up) [B_rappel [Interp_TCL]]
   [this get_prim_handle] abonner_a_detection_pointeur [$this(rap_on_wheel_up) Rappel] [ALX_pointeur_enfonce]
  }
 $this(rap_on_wheel_up) Texte [list $objName Is_a_pointer_press $this(rap_on_wheel_up) 8 $cmd]
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre Is_a_pointer_press {rap appuie cmd} {
 set infos [Void_vers_info [$rap Param]]
 set ptr   [$infos Ptr]
 set X     [$infos X_au_contact]
 set Y     [$infos Y_au_contact]
 
 if {[$ptr Appuie] & $appuie} {
   if {[catch {eval $cmd} err]} {
     puts "ERROR in $objName Is_a_pointer_press $rap $appuie {$cmd}:\n$err"
    }
  }
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre get_rap_one_pointer_Enter  {} {return $this(rap_on_enter)}
method PM_BIGre get_rap_all_pointers_Leave {} {return $this(rap_on_leave)}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre On_one_pointer_Enter {cmd} {
 #puts "$objName On_one_pointer_Enter {$cmd}"
 if {![info exists this(rap_on_enter)]} {
   set this(rap_on_enter) [B_rappel [Interp_TCL]]
   [this get_prim_handle] abonner_a_detection_pointeur [$this(rap_on_enter) Rappel] [ALX_pointeur_apparition]
  }
 $this(rap_on_enter) Texte "$objName Incr_nb_pointers_in; if {\[$objName get_nb_pointers_in\] == 1} {set obj $objName; $cmd}"
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre On_all_pointers_Leave {cmd} {
 if {![info exists this(rap_on_leave)]} {
   set this(rap_on_leave) [B_rappel [Interp_TCL]]
     [this get_prim_handle] abonner_a_detection_pointeur [$this(rap_on_leave) Rappel] [expr [Pas_rappel_si_fils_contient]+[ALX_pointeur_disparition]]
   set this(rap_on_disappear) [B_rappel [Interp_TCL]]
     [this get_prim_handle] abonner_a_detection_pointeur [$this(rap_on_disappear) Rappel] [ALX_pointeur_disparition]
  }
 $this(rap_on_leave)     Texte "$objName Decr_nb_pointers_in; if {\[$objName get_nb_pointers_in\] == 0} {set obj $objName; $cmd}"
 $this(rap_on_disappear) Texte "$objName Is_the_pointer_disappearing $this(rap_on_disappear)"
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre Is_the_pointer_disappearing {rap} {
 set p [$rap Param]
 set infos [Void_vers_info $p]
 set ptr [$infos Ptr]
 if {[string equal [$ptr Val_MetaData "alx_simulateur_pointeurs::Retirer_pointeur"] 1]} {
   set L_applied [$ptr Val_MetaData "alx_simulateur_pointeurs::Retirer_pointeur::Applied_to"]
   if {[lsearch $L_applied "${objName}::Is_the_pointer_disappearing"] == -1} {
     #puts "$objName Is_the_pointer_disappearing : YES !!!"
     eval [$this(rap_on_leave) Texte]
	 lappend L_applied "${objName}::Is_the_pointer_disappearing"
	 $ptr Add_MetaData "alx_simulateur_pointeurs::Retirer_pointeur::Applied_to" $L_applied
	}
  }
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre set_prim_handle {L_p} {
 this inherited $L_p
 foreach p $L_p {
   $p Ajouter_MetaData_T  CometPM $objName
   $p Ajouter_au_contexte CometPM $objName
  }
 if {[this Has_MetaData PRIM_STYLE_CLASS]} {set L [this Val_MetaData PRIM_STYLE_CLASS]} else {set L ""}
 lappend L $L_p PRIM_HANDLE
 this Add_MetaData PRIM_STYLE_CLASS $L 
}

#___________________________________________________________________________________________________________________________________________
#method PM_BIGre Add_daughter {m {index -1}} {
# set rep [this inherited $m $index]
# if {$index != -1} {
#   foreach PM [this get_daughters] {this Reconnect $PM}
#  }
# return $rep
#}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre Is_still_branched_to {prim} {
 set rfd [this get_root_for_daughters]
 if {[string equal $rfd ""] || [string equal $rfd NULL]} {return 0}
 if {[catch "set rep \[$rfd A_pour_fils $prim\]" err]} {
   puts "ERROR !!! $objName Is_still_branched_to $prim\n  | $err"
   set rep 0
  } 
 return $rep 
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre Reconnect {PMD} {
# XXX Prendre en compte les index des PMs pour les rebrancher au bon endroit !
 set L_index {}
 foreach PM $PMD {
   set index [lsearch [this get_out_daughters] $PM]
   if {$index == -1} {set index [lsearch [this get_daughters] $PM]}
   lappend L_index $index
  }
 
 set i 0
 foreach PM $PMD {
   foreach p [$PM get_prim_handle] {
     eval [this get_cmd_deconnect]
    }
   $PM  Add_prim_mother   $objName [this get_root_for_daughters]
   this Add_prim_daughter $PM      [$PM get_prim_handle] [lindex $L_index $i]
  }
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre get_width  {{PM {}}} {return [[$this(primitives_handle) Boite_noeud_et_fils] Tx]}
method PM_BIGre get_height {{PM {}}} {return [[$this(primitives_handle) Boite_noeud_et_fils] Ty]}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre Add_prim_daughter {c Lprims {index -1}} {
 #puts "$objName Add_prim_daughter $c {$Lprims}"
 if {$index == -1} {set index 999999}
 set p_mother [this get_root_for_daughters]
 foreach p $Lprims {$p_mother Retirer_fils $p
                    $p Calculer_boites
                    $p_mother Ajouter_fils_a_pos $p $index
					#$p_mother Ajouter_fils $p
                   }
 return 1
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre get_or_create_prims {root} {
 return $this(primitives_handle)
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre get_prim_handle {{index -1}}  {
 return $this(primitives_handle)
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre Sub_prim_daughter {c Lprims {index -1}} {
 #puts "$objName Sub_prim_daughter $c {$Lprims}"
 foreach p $Lprims {
   if {[catch "[$objName get_root_for_daughters] Retirer_fils $p" err]} {puts "BIGre ERROR in \"\[$objName get_root_for_daughters\] Retirer_fils $p\"\n$err"}
  }
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre get_root_for_daughters {{index -1}} {
 return [this inherited]
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre Do_prims_still_exist {} {
 if {[string equal $this(primitives_handle) {}]} {return 0} else {return 1}
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre Redirect_key_events_to_LM {LM {LM_root {}}} {
 if {[string equal $LM_root {}]} {

  }
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre Fit_PM_pointed_by_CSS {args} {
 #puts "$objName Fit_PM_pointed_by_CSS {$args}"
 if {[llength $args] == 1} {set args [lindex $args 0]}
 set PM [CSS++ $objName $args]
 this Fit $PM
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre Fit {PM} {
 #puts "$objName Fit {$PM}"
 set prim_PM [$PM get_prim_handle]; set box_PM [$prim_PM Boite_noeud_et_fils]
 set p [this get_prim_handle];      set box    [$p       Boite_noeud_et_fils]
 $p Origine   [$prim_PM Origine]
 $p Rotation  [$prim_PM Rotation]
 $p Etirement [expr [$box_PM Tx]/[$box Tx]] [expr [$box_PM Ty]/[$box Ty]]
 #puts "End Fit"
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre Stretch {ex ey} {
 set p [this get_prim_handle]
 $p Etirement $ex $ey
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre Raise {args} {
 #puts "$objName Raise {$args}"
 if {$args == "low"} {set mtd Ajouter_fils} else {set mtd Ajouter_fils_au_debut}
 set L {}
 set p [this get_prim_handle]
 set it [$p Init_parcours_peres]
 while {![$p Est_parcours_peres_fini $it]} {
   set pere [$p Courant_dans_parcours_peres $it]
   lappend L $pere
   set it [$p Suivant_dans_parcours_peres $it]
  }
 $p Terminer_parcours_peres $it
 
 foreach pere $L {
   $pere Retirer_fils $p
   $pere $mtd         $p
  }
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre Redirect_key_events_to_PM {PM} {
 set    cmd "set prim \[$PM get_prim_handle\];\n"
 append cmd {set evt [B_sim_couche Evt_courant];} "\n"
 append cmd {set ptr [$evt Ptr]; set pt [$ptr P_Point];} "\n"
 append cmd {set res ""; catch "B_sim_sds Prendre_evennements_lies_a $pt [$prim Liant]" res; }

 $this(rap_redirect_key) Texte $cmd
 [this get_prim_handle] desabonner_de_detection_pointeur [$this(rap_redirect_key) Rappel]
 [this get_prim_handle] abonner_a_detection_pointeur     [$this(rap_redirect_key) Rappel]
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre Stop_Redirect_key_events_to_PM {} {
 $this(rap_redirect_key) Texte ""

 [this get_prim_handle] desabonner_de_detection_pointeur [$this(rap_redirect_key) Rappel]
 [this get_prim_handle] abonner_a_detection_pointeur     [$this(rap_redirect_key) Rappel]
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
# Methods usefull for layout                                                                                                               _
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
proc B207_Line_v {n {align left}} {
 #if {![$n A_changer]} {return}
 
 set y 0
 set it [$n Init_parcours_inverse_fils]
 while {![$n Est_parcours_inverse_fils_fini $it]} {
   set nf [$n Courant_dans_parcours_inverse_fils $it]
     $nf Calculer_boites
     #$nf Afficher_boites 1
     set boite_out [$nf Boite_noeud_et_fils_glob]
     set boite_in  [$nf Boite_noeud_et_fils]
       $nf Py [expr $y - [$boite_in BG_Y]]
	   switch $align {
	     left   {$nf Px [expr -[$boite_in BG_X]]}
		 right  {$nf Px [expr -[$boite_in BG_X] - [$boite_in Tx]]}
		 center {$nf Px [expr -[$boite_in Cx]]}
	    }
     set y [expr $y + [$boite_out Ty]]
	 $nf Calculer_boites
   set it [$n Suivant_dans_parcours_inverse_fils $it]
  }
 $n Terminer_parcours_inverse_fils $it
 
 $n Calculer_boites
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre Substitute_by {PM} {
 set p [this get_prim_handle]
   set x [$p Px]
   set y [$p Py]
   set r [$p Rotation]
 this inherited $PM
 set p [$PM get_prim_handle]
 if {![string equal $p {}]} {
   $p Origine $x $y
   $p Rotation $r
  }
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre Line_v {} {
 set n [this get_root_for_daughters]
 B207_Line_v $n
}

#___________________________________________________________________________________________________________________________________________
proc B207_Line_h {n} {
 #if {![$n A_changer]} {return}
 
 set x 0

 set it [$n Init_parcours_fils]
 while {![$n Est_parcours_fils_fini $it]} {
   set nf [$n Courant_dans_parcours_fils $it]
     set boite_out [$nf Boite_noeud_et_fils_glob]
     set boite_in  [$nf Boite_noeud_et_fils]
     $nf Origine [expr $x - [$boite_in BG_X]] [expr - [$boite_in BG_Y]]
	 $nf Calculer_boites
     set x [expr $x + [$boite_out Tx]]
   set it [$n Suivant_dans_parcours_fils $it]
  }
 $n Terminer_parcours_fils $it
 
 $n Calculer_boites
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre Line_h {} {
 set n [this get_root_for_daughters]
 B207_Line_h $n
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre Window_fit_daughters {} {
 set n $this(primitives_handle)
 set f [$n Noeud_repere_fils]

 $f Calculer_boites
   set bt [$f Boite_noeud_et_fils]
   $f Origine [expr -[$bt BG_X]] [expr -[$bt BG_Y]]
 $n Dimension_corp [expr [$bt Tx]] [expr [$bt Ty]]
 $n Mettre_a_jour
 $n Gerer_bordure 0
 $n Rendu_ecran_direct 0
}

#___________________________________________________________________________________________________________________________________________
method PM_BIGre C_B_Eval {args} {
 set n [this get_prim_handle]
 set args [string map [list $objName $n] $args]
 eval $args
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
# Functions udefull for ECA                                                                                                                _
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
proc C_B_Transfo {transfo avt pdt apr} {
#puts "C_B_Transfo\n__transfo : $transfo\n__avt : $avt\n__pdt : $pdt\n__apr : $apr"
 eval $avt
 set rap_pdt [B_rappel [Interp_TCL] $pdt]
 set rap_apr [B_rappel [Interp_TCL] $apr]

 eval "$transfo abonner_a_rappel_pendant [$rap_pdt Rappel]"
 eval "$transfo abonner_a_rappel_fin     [$rap_apr Rappel]"
 eval "$transfo Demarrer"
 eval "N_i_mere Ajouter_deformation_dynamique $transfo"
}

#___________________________________________________________________________________________________________________________________________
proc C_B_SVG_rep {C_src B_tgt} {
#puts "C_B_SVG_rep $C_src $B_tgt"
 eval "set p \[$C_src get_prim_handle\]"
 eval "$B_tgt maj $p"
#puts "C_B_SVG_rep______________"
}

#___________________________________________________________________________________________________________________________________________
proc C_B_splash {C_tgt B_src t} {
 eval "set C_tgt $C_tgt"
 eval "set   src $B_src"
 eval "set transfo [B_transfo $t]"
 set tgt [$C_tgt get_prim_handle]

 $tgt Ajouter_fils_au_debut $src
 C_B_new_fade $C_tgt $B_src $t "C_B_new_fade $C_tgt $B_src $t \{$tgt Retirer_fils $src\} 1 0" 0 1
}

#___________________________________________________________________________________________________________________________________________
proc C_B_new_fade {C_tgt B_src t nxt bgn end} {
#puts "C_B_new_fade $C_tgt $B_src $t {$nxt} $bgn $end"
 eval "set C_tgt $C_tgt"
 eval "set   src $B_src"
 eval "set transfo [B_transfo $t]"
 eval "set bgn $bgn"
 eval "set end $end"
 set tgt [$C_tgt get_prim_handle]

 $tgt Calculer_boites; $src Calculer_boites
 set boite_src [$src Boite_noeud_et_fils]
 set boite_tgt [$tgt Boite_noeud_et_fils]
#puts "boite_src : $boite_src\nboite_tgt : $boite_tgt"
 set rap_pdt [B_rappel [Interp_TCL] "$src Etirement \[expr \[$boite_tgt Tx\]/\[$boite_src Tx\]\] \[expr \[$boite_tgt Ty\]/\[$boite_src Ty\]\]; C_B_fade $transfo $src $bgn $end"]
 set rap_apr [B_rappel [Interp_TCL] $nxt]
 $transfo abonner_a_rappel_pendant [$rap_pdt Rappel]
 $transfo abonner_a_rappel_fin     [$rap_apr Rappel]
 $transfo Demarrer
 N_i_mere Ajouter_deformation_dynamique $transfo
 C_B_fade $transfo $src $bgn $end
}

#___________________________________________________________________________________________________________________________________________
proc C_B_get_or_create_in {name C_tgt cmd} {
 eval "set C_tgt $C_tgt"
 eval "set name $name"
 set  prim [C_B_get $C_tgt "Val_MetaData $name"]
 if {[string equal $prim {}]} {
   set prim [eval "$cmd"]
   C_B_configure $C_tgt "-Ajouter_MetaData_T $name $prim"
  }
 return $prim
}

#___________________________________________________________________________________________________________________________________________
proc C_B_Morph {transfo original C_src C_tgt} {
#puts "C_B_Morph $transfo $original $C_src $C_tgt"
 eval "set transfo $transfo"
 eval "set original $original"
 eval "set C_src $C_src"
 eval "set C_tgt $C_tgt"
 eval "set tgt \[$C_tgt get_prim_handle\]"
 C_B_Morph_B $transfo $original $C_src $tgt fade_out
}

#___________________________________________________________________________________________________________________________________________
proc C_B_Morph_B {transfo original C_src tgt {fade fade_in}} {
# puts "C_B_Morph_B {$transfo} {$original} {$C_src} {$tgt} {$fade}"
 eval "set v \[$transfo V_courant\]"
 eval "set original $original"
# puts $v
 C_B_Morph_B_v $v $original $C_src $tgt $fade
}

#___________________________________________________________________________________________________________________________________________
proc C_B_Morph_B_v {v original C_src tgt {fade fade_in}} {
# puts "C_B_Morph_B_v from [$original Px] \; [$original Py]"
 eval "set v $v"
 eval "set src \[$C_src get_prim_handle\]"
 eval "set tgt $tgt"
 eval "set original $original"
 set boite_src [$src Boite_noeud_et_fils]
 set boite_tgt [$tgt Boite_noeud_et_fils]

# Let's compute for stretching 
 set ex 1; set ey 1
 if {[$boite_src Tx] != 0 && [$boite_src Ty] != 0 && [$boite_tgt Tx] != 0 && [$boite_tgt Ty] != 0} {
   set ex [expr ([$tgt Ex]*[$boite_tgt Tx])/([$boite_src Tx])]
   set ey [expr ([$tgt Ey]*[$boite_tgt Ty])/([$boite_src Ty])]
  } else {set ex [$tgt Ex]
          set ey [$tgt Ey]
         }
# Let's compute for position
 set dest_x [$tgt Px]
 set dest_y [$tgt Py]
 if {[$boite_tgt Tx] != 0 && [$boite_tgt Ty] != 0} {
   set dest_x [expr $dest_x + [$boite_tgt BG_X]]
   set dest_y [expr $dest_y + [$boite_tgt BG_Y]]
  }
 if {[$boite_src Tx] != 0 && [$boite_src Ty] != 0} {
   set dest_x [expr $dest_x - [$boite_src BG_X]]
   set dest_y [expr $dest_y - [$boite_src BG_Y]]
  }
 
# Let's do the interpolation
# $src maj [expr (1-$v)*[$original Px] + $v*$dest_x*$ex/[$original Ex]] \
#          [expr (1-$v)*[$original Py] + $v*$dest_y*$ey/[$original Ey]] \
#          [expr (1-$v)*[$original Rotation] + $v*[$tgt Rotation]] \
#          [expr (1-$v)*[$original Ex] + $v*$ex] \
#          [expr (1-$v)*[$original Ey] + $v*$ey]
 $src maj [expr (1-$v)*[$original Px] + $v*$dest_x*$ex] \
          [expr (1-$v)*[$original Py] + $v*$dest_y*$ey] \
          [expr (1-$v)*[$original Rotation] + $v*[$tgt Rotation]] \
          [expr (1-$v)*[$original Ex] + $v*$ex] \
          [expr (1-$v)*[$original Ey] + $v*$ey]

# Let's fade in or out 
 if {[string equal $fade fade_out]} {
   catch "B_configure $src -Bord_translucide 1 -Corp_translucide 1 -Translucidite_bord [expr 1-$v] -Translucidite_corp [expr 1-$v]" res
   catch "B_configure $src -Translucidite 1 -Couleur 3 [expr 1-$v]"
   catch "B_configure $src -Composante_couleur_masque_texture 3 [expr 1-$v]"
  } else {catch "B_configure $src -Bord_translucide 1 -Corp_translucide 1 -Translucidite_bord $v -Translucidite_corp $v" res
          catch "B_configure $src -Translucidite 1 -Couleur 3 $v"
		  catch "B_configure $src -Composante_couleur_masque_texture 3 $v"
         }
}

#___________________________________________________________________________________________________________________________________________
proc C_B_fade_bt {transfo bt bgn end} {
 set bt [eval "$bt get_prim_handle"]
 set f [eval "$bt Noeud_fen"]
 eval "set v \[$transfo V_courant\]"
 set v [eval "expr $bgn*(1-$v) + $end*$v"]
 B_configure $f -Bord_translucide 1 -Corp_translucide 1 -Translucidite_bord $v -Translucidite_corp $v -Mettre_a_jour
}

#___________________________________________________________________________________________________________________________________________
proc C_B_fade {transfo B_src bgn end} {
 eval "set src $B_src"
 eval "set transfo $transfo"
 eval "set bgn $bgn"
 eval "set end $end"
 eval "set v \[$transfo V_courant\]"

 set t [expr (1-$v)*$bgn + $v*$end]
# puts "$v -> $t deb = [$transfo Temps_debut] ; fin = [$transfo Temps_fin]"
 catch "B_configure $src -Translucidite 1 -Couleur 3 $t"
 catch "B_configure $src -Translucidite 1 -Composante_couleur_masque_texture 3 $t"
}

#___________________________________________________________________________________________________________________________________________
proc C_B_configure {comet args} {
 set L_args {}; foreach a $args {append L_args { } $a}
 eval "set comet $comet"
#puts "B_configure \[$comet get_prim_handle\] $L_args"
 eval "B_configure \[$comet get_prim_handle\] $L_args"
}

#___________________________________________________________________________________________________________________________________________
proc C_B_get {comet args} {
 set L_args {}; foreach a $args {append L_args { } $a}
#puts "C_B_get $comet $L_args"
 return [eval "\[$comet get_prim_handle\] $L_args"]
}

#___________________________________________________________________________________________________________________________________________
proc C_B_SAVE_DATA  {c var cmd} {
# puts "C_B_SAVE_DATA $c $var {$cmd}"
 C_B_configure $c "Ajouter_MetaData_T $var [C_B_get $c $cmd]"
}
#___________________________________________________________________________________________________________________________________________
proc C_B_LOAD_DATA {c var cmd} {
#puts "C_B_LOAD_DATA $c $var {$cmd}"
 C_B_configure $c "$cmd [C_B_get $c Val_MetaData $var]"
}

#___________________________________________________________________________________________________________________________________________
proc C_Substitute_PM_with_type {PM GDD_type} {
 #puts "C_Substitute_PM_with_type $PM $GDD_type"
 if {[catch "$PM Update_factories $GDD_type" res]} {puts "ERROR IN \"C_Substitute_PM_with_type $PM $GDD_type\"\n  $res"}
}

#___________________________________________________________________________________________________________________________________________
proc C_GDD {L_comet fct root} {
# puts "C_GDD \{$L_comet\} $fct $root"
 set Implem {NODE()<-REL(type~=GDD_inheritance && type!=GDD_restriction)*<REL(type~=GDD_implementation)<-$n()}
 eval "set L_comet $L_comet"
 eval "set fct $fct"
 eval "set root $root"

 set dsl_GDD [[lindex $L_comet 0] get_DSL_GDD_QUERY]
 $dsl_GDD QUERY "?n : $root : [subst $$fct]"
 #puts "Resultat provisoire : \{[$dsl_GDD get_Result]\}"
 set L_nodes {}
 foreach n [$dsl_GDD get_Result] {
   Add_list L_nodes [lindex $n 1]
  }

 foreach c $L_comet {
   if {[catch "$c Update_factories \{$L_nodes\}" res]} {
     #puts "STYLE ERROR ($c Update_factories \{$L_nodes\}):\n$res"
    } else {
           #puts "$c Update_factories \{$L_nodes\} => OK"
           }
  }

}

