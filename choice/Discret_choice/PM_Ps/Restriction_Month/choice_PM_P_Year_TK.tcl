inherit PM_P_Year_TK PM_TK

set PM_P_Year_TK_directory [pwd]

method PM_P_Year_TK constructor {name descr args} {
 this inherited $name $descr

    set side                                            left
    set this(side)					$side
    set this(colorFrame) 				grey
	if {$side == "left"} {
		set this(widthFrame)		 	700
		set this(heightFrame)		 	70
	} else {
		set this(widthFrame)		 	70
		set this(heightFrame)		 	700
	}
	set this(colorFrameMonth)	 		grey
	set this(widthFrameMonth)	 		70
	set this(heightFrameMonth)	 		48
	set this(listMonths)				[list jan feb mar apr mai jun jul aug sep oct nov dec]
	set this(listFrames)				[]
	set this(listImage)				[]

	set this(colorLabelImage)			white
	set this(colorLabelText)			white

	set this(prev_image)    	""
	set this(current_image) 	""
	set this(prev_text)    		""
	set this(current_text) 		""
			
	set this(frame)        		""
    
    this set_root_for_daughters NULL
    
 eval "$objName configure $args"
}

#___________________________________________________________________________________________________________________________________________
method PM_P_Year_TK dispose {} {
	destroy $this(frame)
	this inherited
}

#___________________________________________________________________________________________________________________________________________
method PM_P_Year_TK get_or_create_prims {root} {
 global PM_P_Year_TK_directory

 set common_FC [$this(LM) get_Common_FC]
 set this(root) $root

 set choiceLabel   [$common_FC get_label_name]
 set choiceOptions [$common_FC get_L_choices]

 set label_name "$root.tk_${objName}_label"
 set M_options [lrange $choiceOptions 0 [llength $choiceOptions]]
 set options_name "$root.tk_${objName}_options"
 
  if {[winfo exists $label_name]} {} else {
	label $label_name -text $choiceLabel
	set this(frame) [frame $options_name -background $this(colorFrame)]
									

									
	set LC           [$this(LM) get_LC]
 	set LC_daughters [$LC       get_daughters]
 	set pos 0
	
        foreach d $LC_daughters {
		set image_name "tk_${objName}_img_$d" 
    	        set file_name  [lindex $this(listMonths) $pos]
 		image create photo $image_name -file $PM_P_Year_TK_directory/imagesArbres/$file_name.gif
 		incr pos
		
		set frameMonth [frame $this(frame).tk_$d -bd 3 -background $this(colorFrameMonth)]
		lappend this(listFrames) $frameMonth
		pack $frameMonth -side $this(side) -fill both -expand 1

		set frame_img_imageMonth [label $frameMonth.l1 -image $image_name -background $this(colorLabelImage)]
		lappend this(listImage) $frame_img_imageMonth
		set m [$d get_name]

		
		set nameMonth [label $frameMonth.l2  -text $m -background $this(colorLabelText)]
		
		pack $frame_img_imageMonth -fill both -expand 1
		pack $nameMonth
				
		set space [frame $this(frame).space$m -width 3 \
  						      -height $this(heightFrameMonth) \
  						      -background $this(colorFrameMonth)]
		pack $space -side $this(side) -fill both -expand 1
		
		bind $frameMonth <ButtonPress> "$this(LM) Propagate \"set_currents  $d\""
		bind $frame_img_imageMonth <ButtonPress> "$this(LM) Propagate \"set_currents  $d\""	
		bind $nameMonth  <ButtonPress> "$this(LM) Propagate \"set_currents  $d\""
	
	
	
	}
  }
  
# Bindings
 this maj_choices
# this set_currents [$common_FC get_currents]

 set L [list $label_name $this(frame)]
 return [this set_prim_handle $L]
}


#___________________________________________________________________________________________________________________________________________
method PM_P_Year_TK maj_choices        {}   {
	 if {[winfo exists $this(frame)]} {} else {return}
	 set common_FC    [$this(LM) get_Common_FC]
	 set LC           [$this(LM) get_LC]
	
	 
	if {[winfo exists $this(current_image)]} {
		set LC           [$this(LM) get_LC]
        set LC_daughters [$LC       get_daughters]
        foreach d $LC_daughters {
          if {[string equal [$this(current_image) cget -text] [$d get_name]]} {
            $this(LM) Propagate "set_currents $d"
            break
           } 
         }
		
	}
	
	## Update
        this set_currents [$LC get_currents]
}
#___________________________________________________________________________________________________________________________________________
method PM_P_Year_TK get_currents       {}   {
    return $this(current_image)
}

#___________________________________________________________________________________________________________________________________________
method PM_P_Year_TK set_currents       {lc} {
	set frame_name  "$this(frame).tk_$lc"
	set image_name	"$this(frame).tk_$lc.l1"
	set text_name	"$this(frame).tk_$lc.l2"

	set this(prev_image)    $this(current_image)
	set this(current_image) $image_name
	set this(prev_text)    	$this(current_text)
	set this(current_text) 	$text_name
	
	if {[winfo exists $this(prev_image)] && [winfo exists $this(prev_text)]} {
	 	$this(prev_image) 	configure -background $this(colorLabelImage)
	 	$this(prev_text) 	configure -background $this(colorLabelText)
	 }
	if {[winfo exists $this(current_image)] && [winfo exists $this(current_text)] } {
		$this(current_image) 	configure -background red
		$this(current_text) 	configure -background red
	}
}
                                                               
#___________________________________________________________________________________________________________________________________________
method PM_P_Year_TK get_nb_max_choice  {}   {return 1}
method PM_P_Year_TK set_nb_max_choice  {nb} {return 1}

