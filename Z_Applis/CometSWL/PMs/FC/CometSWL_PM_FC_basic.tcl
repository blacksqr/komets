#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometSWL_PM_FC_basic Physical_model
#___________________________________________________________________________________________________________________________________________
method CometSWL_PM_FC_basic constructor {name descr args} {
 this inherited $name $descr
   this set_nb_max_mothers   1
   this set_cmd_placement {}
   
   set this(ms) 10
   set this(dt) 0.1
   
   set this(svg_place_visu)  ""

   set this(is_computing) 0
   
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometSWL_PM_FC_basic [P_L_methodes_set_CometSWL] {} {}
Methodes_get_LC CometSWL_PM_FC_basic [P_L_methodes_get_CometSWL] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters CometSWL_PM_FC_basic [P_L_methodes_set_CometSWL_COMET_RE]

#___________________________________________________________________________________________________________________________________________
Generate_accessors CometSWL_PM_FC_basic [list ms dt]

#___________________________________________________________________________________________________________________________________________
method CometSWL_PM_FC_basic Fire {} {
# On efface les missilles déja présents
 foreach M [this get_L_missiles] {[this get_LC] Sub_a_missile $M}

# On s'abonne à B207 pour effectuer les calculs
 #N_i_mere abonner_a_fin_simulation [$this(rap_Calculer_deplacements) Rappel]
 
# Pour chaque vaisseau de chaque joueur, on initialise un missille
 foreach j [this get_L_players] {
   foreach vaisseau [$j get_L_ships] {
     set rayon      [$vaisseau get_R]
	 set angle      [$vaisseau get_angle]
	 set puissance  [expr [$vaisseau get_power]/10.0]
     set vaisseau_x [$vaisseau get_X]
	 set vaisseau_y [$vaisseau get_Y]
	 
	 set x          [expr $vaisseau_x + cos($angle)*1.01*$rayon]
	 set y          [expr $vaisseau_y + sin($angle)*1.01*$rayon]
	 set vx         [expr cos($angle)*$puissance]
	 set vy         [expr sin($angle)*$puissance]
	 
	 [this get_LC] Add_a_missile [CPool get_a_comet CometSWL_Missile -set_X $x -set_Y $y -set_VX $vx -set_VY $vy]
    }
  }
  
 # Start the loop
 after $this(ms) "$objName Compute_a_step $this(dt)"
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_PM_FC_basic pipo {} {set this(is_computing) 0}

#___________________________________________________________________________________________________________________________________________
method CometSWL_PM_FC_basic Compute_a_step {dt} {
 if {$this(is_computing)} {
   after $this(ms) "$objName Compute_a_step $this(dt)"
   return
  }
 set this(is_computing) 1
 
 set LM [this get_L_missiles]
 if {$LM == ""} {
   puts "Plus de missilles!"
   #N_i_mere desabonner_de_fin_simulation [$this(rap_Calculer_deplacements) Rappel]
   puts "  Fin de l'abonnement"
  }
  
 foreach M $LM {
   #puts "Missille $M\n  - P : <[$M get_x] ; [$M get_y]>\n  - V : <[$M get_vx] ; [$M get_vy]>"
   set ax 0
   set ay 0
   set break_M 0
   foreach P [this get_L_planets] {
     set dx [expr [$P get_X]-[$M get_X]]
	 set dy [expr [$P get_Y]-[$M get_Y]]
	 set d  [expr sqrt($dx*$dx + $dy*$dy)]
	 if {$d < [$P get_R]} {
	   puts "Le missille s'est écrasé sur la planète $P, on le retire de la liste"
	   [this get_LC] Sub_a_missile $M
	   set break_M 1
	   break
	  }
	 
	 set ux [expr $dx / $d]
	 set uy [expr $dy / $d]
	 
	 set ax [expr $ax + $ux * [this get_G] * [$P get_mass] / ($d*$d)]
	 set ay [expr $ay + $uy * [this get_G] * [$P get_mass] / ($d*$d)]
	 
    }
	
   if {!$break_M && abs($ax) < 0.001 && abs($ay) < 0.003} {
	 puts "Le missille est trop loin, on le détruit"
	 [this get_LC] Sub_a_missile $M
	 set break_M 1
	 break
	}
   
   if {$break_M} {continue}
   
   $M set_VX [expr [$M get_VX] + $dt*$ax]
   $M set_VY [expr [$M get_VY] + $dt*$ay]
   
   $M set_X  [expr [$M get_X] + [$M get_VX]*$dt]
   $M set_Y  [expr [$M get_Y] + [$M get_VY]*$dt]
   
  # Calcul des collisions avec les vaisseaux
   foreach J [this get_L_players] {
     set LV [$J get_L_ships]
	 set break_V 0
     foreach V $LV {
	   set dx [expr [$M get_X] - [$V get_X]]
	   set dy [expr [$M get_Y] - [$V get_Y]]
	   #set d  [expr sqrt($dx*$dx + $dy*$dy)]
	   set d  [expr $dx*$dx + $dy*$dy]
	   if {$d < [$V get_R]*[$V get_R]} {
	     puts "$M a touché le vaisseau $V"
	     [this get_LC] Sub_a_ship    $V
		 [this get_LC] Sub_a_missile $M
		 set break_V 1
		 break
	    }
	  }
	 if {$break_V} {break}
    }
  }
 
 set this(is_computing) 0
 if {[this get_L_missiles] != ""} {after $this(ms) "$objName Compute_a_step $this(dt)"}
 
}

