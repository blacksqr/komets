#_________________________________________________________________________________________________________
inherit PM_P_mickey_TK PM_TK

#_________________________________________________________________________________________________________
method PM_P_mickey_TK constructor {name descr args} {
    this inherited $name $descr
      this set_GDD_id CT_CometViewer_AUI_basic_CUI_bulles_TK
    set this(color,yellow) 		#ffff00
	set this(color,fill)		blue
	set this(color,selected)	#61bffa

	set this(color,text)       white

	set this(selected)			""

	set this(window_width) 		300
	set this(window_height)		400

        set this(canvas) {}
        
 eval "$objName configure $args"
 return $objName
}

#______________________________________________________ Adding the viewer functions _______________________________________________________
Methodes_set_LC PM_P_mickey_TK [L_methodes_set_CometViewer] {}          {}
Methodes_get_LC PM_P_mickey_TK [L_methodes_get_CometViewer] {$this(FC)}

#_________________________________________________________________________________________________________
method PM_P_mickey_TK Lister_prims {} {
 puts "canvas : $this(canvas)"
 puts "draw   : $this(canvasdraw)"
 puts "bouton : $this(buttonUpdate)"

}

#_________________________________________________________________________________________________________
method PM_P_mickey_TK get_or_create_prims { root } {
    set this(root) $root
#   set this(window_width)	[winfo width $this(root)]
#	set this(window_height) [winfo height $this(root)]
    
    if {[winfo exists $this(canvas)]} {return}

    set this(canvas)    [canvas $root.c -width $this(window_width) -height $this(window_height) -background white ]
    pack $this(canvas)

	set this(buttonUpdate) 	 [button $this(canvas).b -text maj]
	pack $this(buttonUpdate)
	bind $this(buttonUpdate) <ButtonPress> "$objName Refresh"

	set this(canvasdraw) 	[canvas $this(canvas).draw -width $this(window_width) -height [expr $this(window_height) - 100] -background "#E0FFE0"]
	pack $this(canvasdraw)

	set this(canvasdescr)	[canvas $this(canvas).descr -width $this(window_width) -height 100 -background  $this(color,selected)]
	pack $this(canvasdescr)
	set this(labeldescr)	[$this(canvas).descr create text [expr $this(window_width) / 2] 50 -text "descr"]

	set this(item2part_comet,0)	""

	this DisplayComet


	# this set_currents [$common_FC get_currents]
 	#this maj_choices

 	set L [list $this(canvas)]
 	return [this set_prim_handle $L]
}

#_____________________________________________________________________________
method PM_P_mickey_TK ChangeCometToDraw { newCometToDraw } {
 this DisplayComet
}

#_____________________________________________________________________________
method PM_P_mickey_TK DisplayComet { } {
set PI 3.14159265

	set LC [this get_LC]

        $this(canvasdraw) delete all
	$this(canvasdescr) itemconfigure $this(labeldescr) -text "descr"

	set LM                 [this get_LM]
	set this(common_FC)    [$LM get_Common_FC]

	set this(cometToDraw)  [$this(common_FC) get_cometToDraw]
	set this(comet_name)   [$this(cometToDraw) get_name]

	set this(listLM)		[$this(common_FC) get_listLM]
	set this(nb_LM)			[$this(common_FC) get_nb_LM]

	set this(nb_PM) 		0

	foreach LM $this(listLM) {
		set this(listPM,$LM)  [$this(common_FC) get_listPM $LM]
		set this(nb_PM,$LM)	  [llength $this(listPM,$LM)]
	}
	set this(nb_PM) [$this(common_FC) get_nb_PM]


	### display LC
	set xmiddle	  [expr $this(window_width) / 2]
	set ymiddle	  [expr ($this(window_height) - 100) / 2]
	set this(rayonLC) [expr $this(window_width)/5]
	set textLC	  $this(comet_name)

	set this(itemLC) 	[$this(canvasdraw) create oval [expr $xmiddle - $this(rayonLC)] [expr $ymiddle - $this(rayonLC)] [expr $xmiddle + $this(rayonLC)] [expr $ymiddle + $this(rayonLC)] -fill $this(color,fill)]
	set this(item2part_comet,$this(itemLC)) $this(cometToDraw)
	set this(labelLC)	[$this(canvasdraw) create text $xmiddle $ymiddle -text $textLC -width [expr 2 * $this(rayonLC)] -fill $this(color,text)]

        set LC_to_draw [this get_cometToDraw]
	$this(canvasdraw) bind $this(itemLC)  <ButtonPress> "$LC set_currents $this(itemLC); $LC set_current_part $LC_to_draw"
	$this(canvasdraw) bind $this(labelLC) <ButtonPress> "$LC set_currents $this(itemLC); $LC set_current_part $LC_to_draw"

#	### Display le(s) LM
	set num_LM 0
	set rayonLM [expr $this(rayonLC) * 2/3]
	set nb_LM [llength $this(listLM)]
	foreach LM $this(listLM) {
		set angle [expr (0.5+$num_LM)*$PI/$nb_LM]
		set xLM [expr $xmiddle + $this(rayonLC)*cos($angle)]
		set yLM [expr $ymiddle + $this(rayonLC)*sin($angle)]

		set textLM				[$LM get_name]
		set this(itemLM,$num_LM)		[$this(canvasdraw) create oval [expr $xLM - $rayonLM] [expr $yLM - $rayonLM]  [expr $xLM + $rayonLM] [expr $yLM + $rayonLM] -fill $this(color,fill)]
		set this(item2part_comet,$this(itemLM,$num_LM)) $LM
		set this(labelLM,$num_LM)	[$this(canvasdraw) create text $xLM $yLM -text $textLM -width [expr 2 * $rayonLM] -fill $this(color,text)]

		$this(canvasdraw) bind $this(itemLM,$num_LM)  <ButtonPress> "$LC set_currents $this(itemLM,$num_LM); $LC set_current_part $LM"
		$this(canvasdraw) bind $this(labelLM,$num_LM) <ButtonPress> "$LC set_currents $this(itemLM,$num_LM); $LC set_current_part $LM"
#		### Display les PM de chaque LM
		set nb_PM [llength $this(listPM,$LM)]
		set num_PM 0
		set rayonPM [expr $rayonLM * 2/3]
		foreach PM $this(listPM,$LM) {
			set angle_PM [expr (0.5+$num_PM)*$PI/$nb_PM]
			set xPM [expr $xLM + $rayonLM*cos($angle_PM)]
			set yPM [expr $yLM + $rayonLM*sin($angle_PM)]

			set textPM [$PM get_name]
			set this(itemPM,${num_LM}_$num_PM) [$this(canvasdraw) create oval [expr $xPM - $rayonPM] [expr $yPM - $rayonPM] [expr $xPM + $rayonPM] [expr $yPM + $rayonPM] -fill $this(color,fill)]
			set this(item2part_comet,$this(itemPM,${num_LM}_$num_PM)) $PM

			set this(labelPM,${num_LM}_$num_PM) [$this(canvasdraw) create text $xPM $yPM -text $textPM -width [expr 2 * $rayonPM] -fill $this(color,text)]

			$this(canvasdraw) bind $this(itemPM,${num_LM}_$num_PM)  <ButtonPress> "$LC set_currents $this(itemPM,${num_LM}_$num_PM); $LC set_current_part $PM"
			$this(canvasdraw) bind $this(labelPM,${num_LM}_$num_PM) <ButtonPress> "$LC set_currents $this(itemPM,${num_LM}_$num_PM); $LC set_current_part $PM"
			incr num_PM
		}

		incr num_LM
	}

#	$this(canvasdescr) itemconfigure $this(labeldescr) -text "Description de $name_part_comet ($part_comet) :\n  $descr_part_comet"
	set this(comet_descr)   [$this(cometToDraw) get_descr]
	$this(canvasdescr) itemconfigure $this(labeldescr) -text "Description de $this(cometToDraw) ($this(comet_name)) :\n  $this(comet_descr)"  -width $this(window_width)
}

#____________________________________________________________________________________________________________________
method PM_P_mickey_TK Refresh {} {
set PI 3.14159265

	set this(window_width)	[winfo width $this(root)]
	set this(window_height) [winfo height $this(root)]

	$this(canvasdraw) configure -width $this(window_width) -height [expr $this(window_height) - 100]

	set xmiddle		[expr $this(window_width) / 2]
	set ymiddle		[expr ($this(window_height) - 100) / 2]
	set rayonLC 	[expr $this(window_width)/5]
	$this(canvasdraw) 	coords $this(itemLC) [expr $xmiddle - $rayonLC] [expr $ymiddle - $rayonLC] [expr $xmiddle + $rayonLC] [expr $ymiddle + $rayonLC]
	$this(canvasdraw)   coords $this(labelLC)  $xmiddle $ymiddle
	$this(canvasdraw) itemconfigure $this(labelLC) -width [expr 2 * $rayonLC]

	### Display le(s) LM

	set num_LM 0
	set rayonLM [expr $this(rayonLC) * 2/3]
	set nb_LM [llength $this(listLM)]
	foreach LM $this(listLM) {
		set angle [expr (0.5+$num_LM)*$PI/$nb_LM]
		set xLM [expr $xmiddle + $rayonLC*cos($angle)]
		set yLM [expr $ymiddle + $rayonLC*sin($angle)]

		$this(canvasdraw) coords $this(itemLM,$num_LM)  [expr $xLM - $rayonLM] [expr $yLM - $rayonLM]  [expr $xLM + $rayonLM] [expr $yLM + $rayonLM]
		$this(canvasdraw) coords $this(labelLM,$num_LM)  $xLM $yLM
		$this(canvasdraw) itemconfigure $this(labelLC) -width [expr 2 * $rayonLM]


		### Display les PM de chaque LM
		set nb_PM [llength $this(listPM,$LM)]
		set num_PM 0
		set rayonPM [expr $rayonLM * 2/3]
		foreach PM $this(listPM,$LM) {
			set angle_PM [expr (0.5+$num_PM)*$PI/$nb_PM]
			set xPM [expr $xLM + $rayonLM*cos($angle_PM)]
			set yPM [expr $yLM + $rayonLM*sin($angle_PM)]

			$this(canvasdraw) coords $this(itemPM,${num_LM}_$num_PM)  [expr $xPM - $rayonPM] [expr $yPM - $rayonPM] [expr $xPM + $rayonPM] [expr $yPM + $rayonPM]
			$this(canvasdraw) coords $this(labelPM,${num_LM}_$num_PM)  $xPM $yPM
			$this(canvasdraw) itemconfigure $this(labelLC) -width [expr 2 * $rayonPM]

			incr num_PM
		}

		incr num_LM
	}

	$this(canvasdescr) configure -width $this(window_width)
	$this(canvasdescr) coords $this(labeldescr) $xmiddle 50
	$this(canvasdescr) itemconfigure $this(labeldescr) -width $this(window_width)



}

#____________________________________________________________________________________________________________________
method PM_P_mickey_GML get_currents {} {
 return $this(selected)
}


#____________________________________________________________________________________________________________________
method PM_P_mickey_TK set_currents { item } {
        puts "$objName set_currents $item"
	if { $item == $this(selected) } {
	  return
	 }

	if { $item == 0 } {
	  $this(canvasdraw) itemconfigure $this(selected) -fill $this(color,fill)
	  set this(selected) 0
	 }

	$this(canvasdraw) itemconfigure $this(selected) -fill $this(color,fill)
#	$this(canvasdraw) itemconfigure $item -fill $this(color,selected)
	$this(canvasdraw) itemconfigure $item -fill #61bffa

	set this(selected) $item

	set part_comet 		$this(item2part_comet,$item)
	set name_part_comet 	[$part_comet get_name]
	set descr_part_comet 	[$part_comet get_descr]

	$this(canvasdescr) itemconfigure $this(labeldescr) -text "Description de $name_part_comet ($part_comet) :\n  $descr_part_comet" -width $this(window_width)
}

