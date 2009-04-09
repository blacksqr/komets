# COMET RE pour les PM
proc Generate_PM_setters {classe L_methodes} {
 Add_Semantic_API_infos_to_contructor prim_set $classe $L_methodes

# Add methods to the class 
 foreach methode $L_methodes {
  set methode_name [lindex $methode 0]
  set params       [lindex $methode 1]
  # prim_METHOD
   set cmd "method $classe prim_$methode_name \{"
    # Adding parameters
     foreach param $params {
       if {[llength $param] > 1} {append cmd "{$param} "} else {append cmd "$param "}
      }
     append cmd "\} \{\n"
    # Adding body
     append cmd { [this get_LM] } prim_$methode_name { $objName}
     foreach param $params {append cmd { $} [lindex $param 0]}
   append cmd "\n\}\n"
   puts "Eval :\n$cmd";
   eval $cmd
  }
}

# COMET RE pour les LM
proc Generate_LM_setters {classe L_methodes} {
 foreach methode $L_methodes {
  set methode_name [lindex $methode 0]
  set params       [lindex $methode 1]
  # prim_METHOD
   set param_call {}; foreach param $params {append param_call { $} [lindex $param 0]}
   set call {[this get_LC] }; append call "$methode_name$param_call";
   set cmd "method $classe prim_$methode_name \{PM_prim "
    # Adding parameters
     foreach param $params {
       if {[llength $param] > 1} {append cmd "{$param} "} else {append cmd "$param "}
      }
     append cmd "\} \{\n"
    # Adding body
     append cmd " if {!\[this do_exists_COMET_RE_expr $methode_name\]} {$call; return}\n"
     append cmd " this Add_COMET_RE_event $methode_name \"\$PM_prim $methode_name$param_call\"\n"
     append cmd " set rep \[this Eval_COMET_RE $methode_name\]\n"
     append cmd " if {\[lindex \$rep 1\]} {$call; this set_COMET_RE_state $methode_name {}}\n"
   append cmd "\}\n"
   puts "Eval :\n$cmd";
   eval $cmd
  }
}

#______________________________________________________________________________________________________________________________
#                                               Langage COMET/RE                                                              _
#______________________________________________________________________________________________________________________________
proc L_evt_and_L_PM_to_process {state_name tps op_tps} {
 upvar $state_name   state

 set L_PM  {}
 set L_evt {}
 foreach evt $state {
   #puts "Filtre de \{$evt\}"
   if {([lindex $evt 0] + $op_tps) >= $tps} {
     lappend L_evt $evt
     lappend L_PM  [lindex [lindex $evt 1] 0]
    }
  }
 return [list $L_evt $L_PM]
}

#______________________________________________________________________________________________________________________________
proc Eval_COMET_RE {LM tps expr_RE_name state_name} {
 upvar $state_name   state
 upvar $expr_RE_name expr_RE

 if {[regexp {^ *([ER]) *\((.*) *$} $expr_RE reco OP expr_RE]} {
  # Un temps est il précisé?
   set OP_tps 2000
   regexp {^ *([0-9]*) *, *(.*)$} $expr_RE reco OP_tps expr_RE
   set L_evt_and_PM [L_evt_and_L_PM_to_process state $tps $OP_tps]
     set state_to_process [lindex $L_evt_and_PM 0]
     set L_PM_to_process  [lindex $L_evt_and_PM 1]
   if {[string equal $OP E]} {set op ||; set rep 0} else {set op &&; set rep 1}
  # Si il n'y a pas de parenthèse, on considère que c'est un nom ou un type de BàO => Evaluation immédiate
   set pos_ouv [string first ( $expr_RE]
   set pos_fer [string first ) $expr_RE]
   if { ($pos_ouv == -1) || ($pos_fer < $pos_ouv) } {
     set arg     [string range $expr_RE 0 [expr $pos_fer - 1]]
     set expr_RE [string range $expr_RE [expr $pos_fer + 1] end]
     eval "set arg $arg"
     set L_PM {}; set L_actives_PM [$LM get_L_actives_PM]
     catch "eval {set arg $arg}"
     #puts "_______Expression simple : $OP\($arg)"
     switch $arg {
       *     {set L_PM $L_actives_PM}
       gfx   {set L_PM [Select_PM_from_where_style $L_actives_PM gfx  ]}
       vocal {set L_PM [Select_PM_from_where_style $L_actives_PM vocal]}
       default {set L_PM [Select_PM_from_where_ptf   $L_actives_PM $arg]
               }
      }
    # Si vide alors c'est faut dans tous les cas
     if {[llength $L_PM] == 0} {return [list 1 0]}
    # Sinon, recouper avec la liste des évennements, chaque PM de L_PM soit s'y retrouver
     #puts "On recoupe avec :\n  L_PM : \{$L_PM\}\n  L_PM_to_process : \{$L_PM_to_process\}\n  rep : $rep\n   op : $op"
     foreach PM $L_PM {
       set pos [lsearch $L_PM_to_process $PM]
       #puts "$PM est dans L_PM_to_process => $pos"
       set rep  [expr $rep $op ($pos >= 0)]
      }
     return [list 1 $rep]
    } else {#puts "Expression complexe : \"$expr_RE\""
           # Sinon c'est une expression plus complexe
              set reco 1
              while {$reco} {
                set res [Eval_COMET_RE $LM $tps expr_RE state_to_process]; regexp {^ *, *(.*)$} $expr_RE reco expr_RE
                set reco [lindex $res 0]
                if {$reco} {
                  set rep [expr $rep $op [lindex $res 1]]
                 }
               }
              regexp {^ *\) *(.*)$} $expr_RE reco expr_RE
              #puts "Après expression complexe, reste : \"$expr_RE\", réponse : $rep"
              return [list 1 $rep]
           }
  }

# Pas reconnu
 return "0 0"
}



