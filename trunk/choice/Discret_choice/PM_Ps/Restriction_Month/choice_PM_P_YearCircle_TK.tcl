inherit PM_P_YearCircle_TK PM_TK

set PM_P_YearCircle_TK_directory [pwd]

method PM_P_YearCircle_TK constructor {name descr args} {
	this inherited $name $descr
        set this(current_rep) [pwd]
        this set_GDD_id TorusMonthChooserTK
	set this(listMonths) [list jan feb mar apr mai jun jul aug sep oct nov dec]
	
	

	set this(prev_image)    ""
	set this(current_image) ""
	
	set this(label)        ""

	set this(L_image_files) [list jan.gif feb.gif mar.gif apr.gif mai.gif jun.gif jul.gif aug.gif sep.gif oct.gif nov.gif dec.gif]
        set this(current_month)	0
    
    this set_root_for_daughters NULL

 this set_nb_max_daughters 0
 
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method PM_P_YearCircle_TK dispose {} {
	this inherited
	destroy $this(label)
}

#___________________________________________________________________________________________________________________________________________
method PM_P_YearCircle_TK get_or_create_prims {root} {
 global PM_P_YearCircle_TK_directory

 set common_FC [$this(LM) get_Common_FC]

# set choiceLabel   [$common_FC get_label_name]

# set label_name "$root.tk_${objName}_label"
 set this(label) "$root.tk_${objName}_lab_img"

  if {[winfo exists $this(label)]} {} else {
#	label $label_name -text $choiceLabel
	
	set LC           [$this(LM) get_LC]
 	set LC_daughters [$LC       get_daughters]
 	set pos 0
	
    foreach d $LC_daughters {
		set image_name  [lindex $this(listMonths) $pos]
    	        set file_name  	[lindex $this(listMonths) $pos]
 		image create photo $image_name -file "$PM_P_YearCircle_TK_directory/imagesCercleMois/[lindex $this(L_image_files) $pos]"
 		incr pos
		
	}
	
	label $this(label) -image jan
	bind $this(label) <ButtonPress> "$objName calculate_month %x %y"

  }

# Bindings
 this set_root_for_daughters $root
 this maj_choices

 set L [list $this(label)]
 return [this set_prim_handle $L]
}
#___________________________________________________________________________________________________________________________________________
method PM_P_YearCircle_TK calculate_month { x y } {
set pi 3.14159265
	
	set width		[winfo width $this(label)]
	set height		[winfo height $this(label)]
	
	set xMiddle		[expr double($width) / 2]
	set yMiddle		[expr double($height) / 2]
	
	
	set hyp			[expr sqrt(pow($x-$xMiddle, 2) + pow($y-$yMiddle, 2))]
	set adj			[expr $y - $yMiddle]
	
	if {[expr $hyp < 10]} {return}
	set alpha		[expr acos(double($adj)/$hyp)]
	puts "alpha : $alpha"
	if {[expr ($x-$xMiddle) < 0]} {set alpha [expr 2* $pi - $alpha]}
	
	set num_month		[expr abs(int($alpha * 6 / $pi) - 11)]
	set month		[lindex $this(listMonths) $num_month]
	
	set LC           [$this(LM) get_LC]
        set LC_daughters [$LC get_daughters]

        $this(LM) Propagate "set_currents [lindex [$LC get_out_daughters] $num_month]"
}

#___________________________________________________________________________________________________________________________________________
method PM_P_YearCircle_TK maj_choices        {}   {
	 if {[winfo exists $this(label)]} {} else {return}
	 set common_FC    [$this(LM) get_Common_FC]
	 set LC           [$this(LM) get_LC]
	
	 
	if {[winfo exists $this(current_month)]} {
	  set LC           [$this(LM) get_LC]
          set LC_daughters [$LC       get_daughters]
          foreach d $LC_daughters {
            if {[string equal [$this(current_month)] [$d get_name]]} {
              $this(LM) Propagate "set_currents $d"
              break
             }
           }
	}

	## Update
	this set_currents [$LC get_currents]
}
#___________________________________________________________________________________________________________________________________________
method PM_P_YearCircle_TK get_currents       {}   {
    return $this(current_month)
}

#___________________________________________________________________________________________________________________________________________
method PM_P_YearCircle_TK set_currents {lc} {
  if {[string equal $lc {}]} {return}
  set LC [this get_LC]
  set pos [lsearch [$LC get_out_daughters] $lc]
  if {$pos == -1} {return}
  set month_name [lindex $this(listMonths) $pos]
	
  set this(prev_month)    $this(current_month)
  set this(current_month) $month_name
	                                                             
  if {[winfo exists $this(label)]} {
    $this(label) configure -image $this(current_month)
   }
}

#___________________________________________________________________________________________________________________________________________
method PM_P_YearCircle_TK get_nb_max_choice  {}   {return 1}
method PM_P_YearCircle_TK set_nb_max_choice  {nb} {return 1}

