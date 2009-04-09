inherit CometClock_PM_P_graph_canvas_TK PM_TK

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometClock_PM_P_graph_canvas_TK constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Clock_CUI_standard_analogic_TK
   set this(clock_TK_root) {}
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometClock_PM_P_graph_canvas_TK dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
method CometClock_PM_P_graph_canvas_TK get_or_create_prims {root} {
 set this(clock_TK_root) "$root.tk_${objName}_canvasclock"
 if {[winfo exists $this(clock_TK_root)]} {} else {
   canvas $this(clock_TK_root) -bg ivory -borderwidth 0
  }
 this set_root_for_daughters $root
 
 this set_time [this get_time]

 return [this set_prim_handle $this(clock_TK_root)]
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometClock_PM_P_graph_canvas_TK [L_methodes_set_Clock] {$this(FC)} {}
Methodes_get_LC CometClock_PM_P_graph_canvas_TK [L_methodes_get_Clock] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometClock_PM_P_graph_canvas_TK set_time {t} {
 if {[winfo exists $this(clock_TK_root)]} {
   set c $this(clock_TK_root)
   set secs   [expr $t % 60]
   set mins   [expr ($t % 3600) / 60]
   set heures [clock format $t -format %k]

   set xcentre [expr [winfo width  $c] /2 + 2]
   set ycentre [expr [winfo height $c] /2 + 2]
   set rayon    [expr (($xcentre<$ycentre)?$xcentre:$ycentre)*0.85]
   set pi 3.14159265
   set largeurCanvas [winfo width  $c]
   set hauteurCanvas [winfo height $c]
   set taille [expr (($largeurCanvas<$hauteurCanvas)?$largeurCanvas:$hauteurCanvas)/100 + 1]

  $c addtag c_item all
  $c delete c_item
  # Cadran
   $c create oval [expr $xcentre-$rayon] [expr $ycentre-$rayon] [expr $xcentre+$rayon] [expr $ycentre+$rayon] -width 1 -fill "light grey"
   $c create oval [expr $xcentre-($taille+1)] [expr $ycentre-($taille+1)] [expr $xcentre+($taille+1)] [expr $ycentre+($taille+1)] -fill black
   $c create line 2 [expr $hauteurCanvas+1] [expr $largeurCanvas+1] [expr $hauteurCanvas+1]
   $c create line 2 2 2 [expr $hauteurCanvas+1]
   $c create line [expr $largeurCanvas+1] 2 [expr $largeurCanvas+1] [expr $hauteurCanvas+1]
   $c create line 2 2 [expr $largeurCanvas+1] 2
  # Marquage
	for {set i 0} {$i < 12} {incr i} {
		if {$taille < 4 && ($i % 3 == 0 || $taille >= 2)} {
			set width 0
			if {$i % 3 == 0} {
				set width [expr $taille+1]
			}
			$c create line [expr $xcentre+cos($i*$pi/6)*($rayon*0.95)] \
							[expr $ycentre+sin($i*$pi/6)*($rayon*0.95)] \
							[expr $xcentre+cos($i*$pi/6)*($rayon*1.05)] \
							[expr $ycentre+sin($i*$pi/6)*($rayon*1.05)] \
							-width $width
			
		}
		if {$taille > 3} {
				$c create oval [expr $xcentre+cos($i*$pi/6)*($rayon)+($rayon*0.1)] \
							[expr $ycentre-sin($i*$pi/6)*($rayon)+($rayon*0.1)] \
							[expr $xcentre+cos($i*$pi/6)*($rayon)-($rayon*0.1)] \
							[expr $ycentre-sin($i*$pi/6)*($rayon)-($rayon*0.1)] \
							-fill grey
				eval "set font \"-misc-fixed-medium-r-normal--[expr $rayon/11]-100-100-100-c-70-iso8859-1\""
				eval "$c create text [expr $xcentre+cos($i*$pi/6)*($rayon)] [expr $ycentre-sin($i*$pi/6)*($rayon)] \
								-text [expr ((14 - $i) % 12) +1 ] \
								-font $font"
		}
	}
  # Les aiguilles
   # secondes
   set angle [expr ($secs-15)*$pi/30]
   $c create line $xcentre                                   $ycentre \
                  [expr $xcentre + ($rayon*0.9)*cos($angle)] [expr $ycentre + ($rayon*0.9)*sin($angle)]
   # Minutes
   set angle [expr ($mins-15)*$pi/30]
   $c create line $xcentre $ycentre [expr $xcentre + ($rayon*0.8)*cos($angle)] \
									[expr $ycentre + ($rayon*0.8)*sin($angle)] \
									-width [expr $taille+1]
   # Heures
   set angle [expr (($heures-3)+($mins*0.0166667))*$pi/6]
   $c create line $xcentre $ycentre [expr $xcentre + ($rayon*0.5)*cos($angle)] \
									[expr $ycentre + ($rayon*0.5)*sin($angle)] \
									-width [expr $taille+2]
  }
}
