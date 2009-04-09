#------------
inherit PM_P_mickey_GML PM_TK

#-------------------------------------------------------------
method PM_P_mickey_GML constructor { name descr } {
    this inherited $name $descr
    
    set this(color,yellow) 		#ffff00
	set this(color,fill)		blue
	set this(color,selected)	#61bffa
	
	set this(selected)			""
		
	set this(window_width) 		300
	set this(window_height)		400
	
	set this(font)             12
	set this(color_font)       white

    
   
}


#-------------------------------------------------------------
method PM_P_mickey_GML get_or_create_prims { root } {

    set this(root) $root
#    set this(window_width)	[winfo width $this(root)]
#	set this(window_height) [winfo height $this(root)]
    
    set this(canvas)    [canvas $root.canvasTK -width $this(window_width) -height $this(window_height) -background white]
    #pack $this(canvas)
	
	set this(buttonUpdate) 		[button $this(canvas).b -text maj]
	pack $this(buttonUpdate)
	bind $this(buttonUpdate) <ButtonPress> "$objName Refresh"
	
	set this(canvasdraw) 	[gmlCanvas $this(canvas).draw -width $this(window_width) -height [expr $this(window_height) - 100] -background "#E0FFE0" -highlightthickness 0]
	pack $this(canvasdraw)
	
	set this(canvasdescr)		[gmlCanvas $this(canvas).descr -width $this(window_width) -height 100 -background  $this(color,selected) -highlightthickness 0]
	pack $this(canvasdescr)
	set this(labeldescr)		[$this(canvas).descr create text -anchor c -text "descr" -transfo [list [expr $this(window_width)/2] 50 0 1 1]]
	
	
	set this(item2part_comet,0)	""
	
	this DisplayComet
	
	set L [list $this(canvas)]
 	return [this set_prim_handle $L]
	
	
}

#_____________________________________________________________________________
method PM_P_mickey_GML ChangeCometToDraw { newCometToDraw } {
 puts coucou
 this DisplayComet
}

#_____________________________________________________________________________
method PM_P_mickey_GML DisplayComet { } {
set PI 3.14159265	
	
	$this(canvasdraw) delete all
	$this(canvasdescr) itemconfigure $this(labeldescr) -text "descr"
	
	set LM                 [this get_LM]
	set this(common_FC)	   [$LM get_Common_FC]
	
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
	set xmiddle	[expr $this(window_width) / 2]
	set ymiddle	[expr ($this(window_height) - 100) / 2]
	set this(rayonLC) [expr $this(window_width)/5]
	set textLC	$this(comet_name)
	
	set this(itemLC) 	[$this(canvasdraw) create polygon -shape [gmlCircleShape $this(rayonLC) $this(rayonLC)]\
	 -transfo [list $xmiddle $ymiddle 0 1 1] -fill $this(color,fill)]
	set this(item2part_comet,$this(itemLC)) $this(cometToDraw)
	set this(labelLC)	[$this(canvasdraw) create text -parent $this(itemLC) -text $textLC -color $this(color_font) -font $this(font) -anchor c -width [expr 2 *$this(rayonLC)]]
		
	$this(canvasdraw) bind $this(itemLC)  <ButtonPress> "$objName set_currents $this(itemLC)"
	$this(canvasdraw) bind $this(labelLC) <ButtonPress> "$objName set_currents $this(itemLC)"
	
	
	### Display le(s) LM
	
#	set num_LM 1
	set num_LM 0
	set rayonLM [expr $this(rayonLC) * 2/3]
	set nb_LM [llength $this(listLM)]
	foreach LM $this(listLM) {
#		set angle [expr ($num_LM)*$PI/($nb_LM+1) -$PI/2]
		set angle [expr (0.5+$num_LM)*$PI/$nb_LM]
		set xLM [expr $this(rayonLC)*cos($angle)]
		set yLM [expr $this(rayonLC)*sin($angle)]
	
		set textLM				[$LM get_name]
		set this(itemLM,$num_LM)		[$this(canvasdraw) create polygon -shape  [gmlCircleShape $rayonLM $rayonLM]\
		-transfo [list $xLM $yLM 0 1 1] -fill $this(color,fill) -parent $this(itemLC)]
		set this(item2part_comet,$this(itemLM,$num_LM)) $LM
		set this(labelLM,$num_LM)	[$this(canvasdraw) create text -parent $this(itemLM,$num_LM) -text $textLM -color $this(color_font) -font $this(font) -anchor c -width [ expr 2 * $rayonLM]]
		
		$this(canvasdraw) bind $this(itemLM,$num_LM) <ButtonPress> "$objName set_currents $this(itemLM,$num_LM)"
		$this(canvasdraw) bind $this(labelLM,$num_LM) <ButtonPress> "$objName set_currents $this(itemLM,$num_LM)"
		
		
		### Display les PM de chaque LM
		set nb_PM [llength $this(listPM,$LM)]
#		#set num_PM 1
		set num_PM 0
		set rayonPM [expr $rayonLM * 2/3]
		foreach PM $this(listPM,$LM) {
#			#set angle_PM [expr ($num_PM)*$PI/($nb_PM+1) -$PI/2]
			set angle_PM [expr (0.5+$num_PM)*$PI/$nb_PM]
			set xPM [expr $rayonLM*cos($angle_PM)]
			set yPM [expr $rayonLM*sin($angle_PM)]
			
			set textPM [$PM get_name]
			set this(itemPM,${num_LM}_$num_PM) [$this(canvasdraw) create polygon -shape  [gmlCircleShape $rayonPM $rayonPM]\
		      -transfo [list $xPM $yPM 0 1 1] -fill $this(color,fill) -parent $this(itemLM,$num_LM)]
            set this(item2part_comet,$this(itemPM,${num_LM}_$num_PM)) $PM
			
			set this(labelPM,${num_LM}_$num_PM) [$this(canvasdraw) create text -parent $this(itemPM,${num_LM}_$num_PM) -text $textPM -color $this(color_font) -font $this(font) -anchor c -width [expr 2 * $rayonPM]]
			
			$this(canvasdraw) bind $this(itemPM,${num_LM}_$num_PM) <ButtonPress> "$objName set_currents $this(itemPM,${num_LM}_$num_PM)"
			$this(canvasdraw) bind $this(labelPM,${num_LM}_$num_PM) <ButtonPress> "$objName set_currents $this(itemPM,${num_LM}_$num_PM)"
			incr num_PM
		}
		
		incr num_LM
	}	
	
	set this(comet_descr)   [$this(cometToDraw) get_descr]
	$this(canvasdescr) itemconfigure $this(labeldescr) -text "Description de $this(cometToDraw) ($this(comet_name)) :\n  $this(comet_descr)" -font 11 -width $this(window_width)
	

}


# en cas de redimensionnement
method PM_P_mickey_GML Refresh {} {
set PI 3.14159265	

	set this(window_width)	[winfo width $this(canvas)]
	set this(window_height) [winfo height $this(canvas)]
	
	$this(canvasdraw) configure -width $this(window_width) -height [expr $this(window_height) - 100 - [$this(buttonUpdate) cget -height]]
	
	set xmiddle		[expr $this(window_width) / 2]
	set ymiddle		[expr ($this(window_height) - 50) / 2]
	set nveau_rayonLC 	[expr $this(window_width)/5]
	set ancien_rayonLC $this(rayonLC)
	set scale [expr $nveau_rayonLC.0 / $ancien_rayonLC]
	puts "scale : $scale"
	set this(rayonLC) $nveau_rayonLC
	$this(canvasdraw) itemconfigure $this(itemLC) -transfo [list $xmiddle $ymiddle 0 $scale $scale]
	
		
	$this(canvasdescr) configure -width $this(window_width) -height 100
	$this(canvasdescr) itemconfigure $this(labeldescr) -transfo [list $xmiddle 50 0 1 1] -width $this(window_width) -font 11	

}

#------------
method PM_P_mickey_GML get_currents {} {
	return $this(selected)
}

# ---------------------------------------

method PM_P_mickey_GML set_currents { item } {

	if { $item == $this(selected) } {
		return
	}
	
	if { $item == 0 } {
		$this(canvasdraw) itemconfigure $this(selected) -fill $this(color,fill)
		set this(selected) 0
	}
	
	$this(canvasdraw) itemconfigure $this(selected) -fill $this(color,fill)
	$this(canvasdraw) itemconfigure $item -fill #61bffa
	
	set this(selected) $item
	
	set part_comet 			$this(item2part_comet,$item)
	set name_part_comet 	[$part_comet get_name]
	set descr_part_comet 	[$part_comet get_descr]
	
	$this(canvasdescr) itemconfigure $this(labeldescr) -text "Description de $name_part_comet ($part_comet) :\n  $descr_part_comet" -width $this(window_width) -font 11

}
