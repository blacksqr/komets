set debug_EE 0
#_________________________________________________________________________________________________
#_________________________________________________________________________________________________
#_________________________________________________________________________________________________
# Définissons les 3 catégories de noeud d'un moteur d'évolution; proposant, analysant, executant
#_________________________________________________________________________________________________
# Utilisation d'une classe commune. Va gérer :
#    - la manipulation des listes de propositions.
#    - le branchement des boîtes d'adaptation entre elles.
method adaptation_class constructor {} {
# Manage proposition generation
 set this(nb_proposition) 0
# Lists of propositions
 set this(L_prop_action) [list]
 set this(L_prop_ponder) [list]
 set this(L_prop_select) [list]
# Variables to manage plugs between adaptation moduls
 # last_num_simulation allow to know when (in logical time) the moduls was last called
 # this is usefull because each time the modul is recall, the list of propositions has
 # to be cleared.
 set this(last_num_simulation) 0
 set this(L_successor)   [list]
 set this(L_predecessor) [list]
# Errors manager
 set this(error_state)   ""
}

method adaptation_class dispose {} {
 set L $this(L_successor)
 foreach e $L {this Sub_successor   $e}
 set L $this(L_predecessor)
 foreach e $L {this Sub_predecessor $e}
 
 this inherited
}
#________________________________________________________
method adaptation_class get_last_error {} {return $this(error_state)}
#________________________________________________________
method adaptation_class Clear_propositions {} {
 set this(L_prop_action) [list]
 set this(L_prop_ponder) [list]
 set this(L_prop_select) [list]
}
#________________________________________________________
method adaptation_class get_All_propositions {} {
 set rep    "$objName->get_All_propositions\n"
 append rep " > Actions\n"
 foreach p $this(L_prop_action) {append rep "    *$p ([$p get_Fonction])\n"}
 append rep " > Ponderations\n"
 foreach p $this(L_prop_ponder) {append rep "    *$p ([$p get_Fonction])\n"}
 append rep " > Selections\n"
 foreach p $this(L_prop_select) {append rep "    *$p ([$p get_Fonction])\n"}
 return $rep
}
#________________________________________________________
method adaptation_class New_proposition {} {set p "prop_${objName}_$this(nb_proposition)"
                                            incr this(nb_proposition)
                                            alx_proposition $p
                                            return $p}
#________________________________________________________
method adaptation_class Add_action {p} {lappend this(L_prop_action) $p}
method adaptation_class Add_ponder {p} {lappend this(L_prop_ponder) $p}
method adaptation_class Add_select {p} {lappend this(L_prop_select) $p}
#________________________________________________________
#________________________________________________________
method adaptation_class get_L_prop_action {} {return $this(L_prop_action)}
method adaptation_class get_L_prop_ponder {} {return $this(L_prop_ponder)}
method adaptation_class get_L_prop_select {} {return $this(L_prop_select)}
#________________________________________________________
method adaptation_class Aggregate_propositions {m} {
 append this(L_prop_action) { } [$m get_L_prop_action]
 append this(L_prop_ponder) { } [$m get_L_prop_ponder]
 append this(L_prop_select) { } [$m get_L_prop_select]
}
#________________________________________________________
method adaptation_class get_L_successors {} {return $this(L_successor)}
#________________________________________________________
method adaptation_class get_L_predecessors {} {return $this(L_predecessor)}
#________________________________________________________
method adaptation_class Add_successor {s} {
 set pos [lsearch -exact $this(L_successor) $s]
 if {[expr $pos!=-1]} {return}
 lappend this(L_successor) $s
 $s Add_predecessor $objName
}
#________________________________________________________
method adaptation_class Sub_successor {s} {
 set pos [lsearch -exact $this(L_successor) $s]
 if {[expr $pos!=-1]} {return}
 set this(L_successor) [lreplace $this(L_successor) $pos $pos]
 $s Sub_predecessor $objName
}

#________________________________________________________
method adaptation_class Add_predecessor {p} {
 set pos [lsearch -exact $this(L_predecessor) $p]
 if {[expr $pos!=-1]} {return}
 lappend this(L_predecessor) $p
 $p Add_successor $objName
}
#________________________________________________________
method adaptation_class Sub_predecessor {p} {
 set pos [lsearch -exact $this(L_predecessor) $p]
 if {[expr $pos!=-1]} {return}
 set this(L_predecessor) [lreplace $this(L_predecessor) $pos $pos]
 $p Sub_successor $objName
}
#________________________________________________________
method adaptation_class Simulate {t} {
# 't' is a logical time (represented by an integer)
# The order to simulate is propagated among predecessors.
# Lists of propositions are updated with those of predecessors.
 # We do not do 2 time the same job...
 puts " > $objName->Simulate($t)"
 if {[expr $t==$this(last_num_simulation)]} {return}
 set this(last_num_simulation) $t
 # If it is the first call to the simulation for the logical time t...
 # then we clear lists of propositions
 this Clear_propositions
 foreach a $this(L_predecessor) {$a Simulate $t
                                 this Aggregate_propositions $a}
}

#_________________________________________________________________________________________________
# Le proposant (proposer en anglais)
# A proposer manage a set of automats. Three kind of propositions are emited;
#   - proposition of action.        (if accepted, will do an action)
#   - proposition of reponderation. (Recompute the weight of propositions)
#   - proposition of selection.     (Make a cut among the propositions)
inherit proposer adaptation_class
set nb_proposer 0
proc New_proposer {} {
 global nb_proposer
 set    name proposer_
 append name $nb_proposer
 inherit $name proposer
   set    txt_constructor {method }
   append txt_constructor $name " constructor \{\} \{" {this inherited} "\}"
   eval $txt_constructor
 incr nb_proposer
 return $name
}
#________________________________________________________
method proposer constructor {} {
 this inherited
 set this(current_state) ""
}
#________________________________________________________
method proposer get_current_state {}  {return $this(current_state)}
method proposer set_current_state {s} {set this(current_state) $s}
#________________________________________________________
method proposer Simulate {t} {
 # Aggregate propositions of preceding adaptation moduls
 this inherited $t
 # Faire tourner l'automate
 if {[string equal $this(current_state) {}]} {return}
 if {[catch {set this(current_state) [eval $this(current_state)]} res]} {set this(error_state) $res; puts "  ERREUR : $res\n  DANS \"$this(current_state)\""}
}

#_________________________________________________________________________________________________
#_________________________________________________________________________________________________
#_________________________________________________________________________________________________
inherit analyser adaptation_class
set nb_analyser 0
proc New_analyser {} {
 global nb_analyser
 set    name analyser_
 append name $nb_analyser
 inherit $name analyser
   set    txt_constructor {method }
   append txt_constructor $name " constructor \{\} \{" {this inherited} "\}"
   eval $txt_constructor
 incr nb_analyser
 return $name
}
#________________________________________________________
# L'analysant (analyser)
method analyser constructor {} {
 this inherited
 set this(current_state) ""
}
#________________________________________________________
method proposer get_current_state {}  {return $this(current_state)}
method proposer set_current_state {s} {set this(current_state) $s}
#________________________________________________________
method analyser Simulate {t} {
 # Aggregate propositions of preceding adaptation moduls
 this inherited $t
 # Apply the automat which aim to analyse propositions
 if {[string equal $this(current_state) {}]} {return}
 if {[catch {set this(current_state) [eval $this(current_state)]} res]} {set this(error_state) $res; puts " $objName ERROR : \"$res\""}
}

#_________________________________________________________________________________________________
#_________________________________________________________________________________________________
#_________________________________________________________________________________________________
inherit executer adaptation_class
set nb_executer 0
proc New_executer {} {
 global nb_executer
 set    name executer_
 append name $nb_executer
 inherit $name executer
   set    txt_constructor {method }
   append txt_constructor $name " constructor \{\} \{" {this inherited} "\}"
   eval $txt_constructor
 incr nb_executer
 return $name
}
#________________________________________________________
# L'exécutant (executer)
method executer constructor {} {
 this inherited
 set this(L_prop_applicated) [list]
}
#________________________________________________________
method executer Simulate {t} {
 # Aggregate propositions of preceding adaptation moduls
 this inherited $t
 #puts "<!!!!>*****************************************************<!!!!>"
 # Aggregate actions of action propositions in the list of applicated proposition
 set this(L_prop_applicated) [list]
 puts "Liste des propositions à appliquer par \"$objName\":"
 foreach p $this(L_prop_action) {
   set fct [$p get_Fonction]
   lappend this(L_prop_applicated) [$p get_Fonction]
   puts "  *$fct*"
   $p dispose}
 #puts "<!!!!> this(L_prop_applicated) = \"$this(L_prop_applicated)\""
 foreach p $this(L_prop_ponder) {$p dispose}
 foreach p $this(L_prop_select) {$p dispose}
 set this(L_prop_action) [list]; set this(L_prop_ponder) [list]; set this(L_prop_select) [list]
 # Applicate the functions of the propositions.
 # Each function as to return the next command of the action.
 set NL_actions [list]
 foreach a $this(L_prop_applicated) {
   puts "______________________ $objName évalue :"
   puts "__________________________*$a*"
   if {[catch {set next_action [eval $a]} res]} {puts "__________________________ERREUR"
                                                 puts "__________$objName->Simulate($t) ERROR : $res\n  DANS \"$a\"";
                                                 puts "__________________________\n"
                                                 return
                                                 continue}
   puts "__________________________OK\n"
   if {[string equal $next_action ""]} {continue}
   lappend NL_actions $next_action}
 set this(L_prop_applicated) $NL_actions
 #puts "<!!!!>*****************************************************<!!!!>"
}

#_________________________________________________________________________________________________
#_________________________________________________________________________________________________
#_________________________________________________________________________________________________
# Les propositions en TCL
method alx_proposition constructor {} {
 set this(conviction) 0
 set this(author)    user
 set this(nature)    user_suitability
 set this(fonction)  {}
 set this(lg_fr)     {pas de description fournit en français}
 set this(lg_uk)     {No english description has been given}
}
method alx_proposition set_Conviction {c} {set this(conviction) $c}
method alx_proposition get_Conviction {}  {return $this(conviction)}
method alx_proposition set_Author {a}     {set this(author) $a}
method alx_proposition get_Author {}      {return $this(author)}
method alx_proposition set_Nature {n}     {set this(nature) $n}
method alx_proposition get_Nature {}      {return $this(nature)}
method alx_proposition set_Fonction {f}   {set this(fonction) $f}
method alx_proposition get_Fonction {}    {return $this(fonction)}
method alx_proposition set_Lg_fr {l}      {set this(lg_fr) $l}
method alx_proposition get_Lg_fr {}       {return $this(lg_fr)}
method alx_proposition set_Lg_uk {l}      {set this(lg_uk) $l}
method alx_proposition get_Lg_uk {}       {return $this(lg_uk)}
method alx_proposition DoIt {}            {return [$this(fonction)]}


