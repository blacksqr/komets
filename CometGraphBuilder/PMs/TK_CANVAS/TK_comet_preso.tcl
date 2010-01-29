#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method TK_comet_preso constructor {id_comet_represented comet_represented C_canvas tags GraphBuilder} {
 set this(id_comet_represented) $id_comet_represented
 set this(comet_represented)    $comet_represented
 set this(C_canvas)             $C_canvas
 set this(tags)                 $tags
 set this(GraphBuilder)         $GraphBuilder
 
 set this(x) 0
 set this(y) 0
 
# Initialization of the TK elements
 this Init_drawing

 return $objName
}

#___________________________________________________________________________________________________________________________________________
method TK_comet_preso dispose {} {
 set canvas [$this(C_canvas) get_canvas]
 $canvas delete $objName
 catch "destroy ._toplevel_${objName}"
 
 return [this inherited]
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors TK_comet_preso [list id_comet_represented comet_represented C_canvas tags GraphBuilder]

#___________________________________________________________________________________________________________________________________________
method TK_comet_preso Init_drawing {} {
 set canvas [$this(C_canvas) get_canvas]; set this(canvas) $canvas
 $canvas create oval 0 0 20 20 -fill black -tags [concat $this(tags) [list $objName MOTHERS_$objName]]
 $canvas create oval 0 0 20 20 -fill black -tags [concat $this(tags) [list $objName DAUGTHERS_$objName]]
 $canvas create rectangle 0 0 50 30 -fill white                -tags [concat $this(tags) [list $objName DRAG_$objName TK_comet_preso TK_comet_preso_$objName RECTANGLE_$objName]]
 $canvas create text 5 5 -font {Times 12 normal} -text $this(comet_represented) -anchor nw -tags [concat $this(tags) [list TEXT_$this(GraphBuilder) TK_comet_preso_$objName $objName DRAG_$objName TK_comet_preso $this(tags) TEXT_$objName]]
 
 lassign [$canvas bbox TEXT_$objName] x1 y1 x2 y2
 set cx [expr ($x1 + $x2) / 2.0]; set cy [expr ($y1 + $y2) / 2.0]
 $canvas coords RECTANGLE_$objName [expr $x1 - 5]  [expr $y1 - 5]  [expr $x2 + 5]  [expr $y2 + 5]
 $canvas coords MOTHERS_$objName   [expr $cx - 10] [expr $y1 - 15] [expr $cx + 10] [expr $y1 + 5]
 $canvas coords DAUGTHERS_$objName [expr $cx - 10] [expr $y2 - 5]  [expr $cx + 10] [expr $y2 + 15]
 
 $canvas bind DRAG_$objName <ButtonPress>   "$objName Button_press   %b %x %y"
 $canvas bind DRAG_$objName <ButtonRelease> "$objName Button_release %b %x %y"

 $canvas bind MOTHERS_$objName   <ButtonPress>   "$objName Press_on_poly_mothers   %b %x %y"
 $canvas bind MOTHERS_$objName   <ButtonRelease> "$objName Release_on_poly_mothers %b %x %y"
 $canvas bind DAUGTHERS_$objName <ButtonPress>   "$objName Press_on_poly_daugthers   %b %x %y"
 $canvas bind DAUGTHERS_$objName <ButtonRelease> "$objName Release_on_poly_daugthers %b %x %y"

}

#___________________________________________________________________________________________________________________________________________
method TK_comet_preso get_daughters_connection_point {} {
 lassign [$this(canvas) bbox DAUGTHERS_$objName] x1 y1 x2 y2
 
 return [list [expr ($x1+$x2)/2.0] $y2]
}

#___________________________________________________________________________________________________________________________________________
method TK_comet_preso get_mothers_connection_point   {} {
 lassign [$this(canvas) bbox MOTHERS_$objName  ] x1 y1 x2 y2
 
 return [list [expr ($x1+$x2)/2.0] $y1]
}

#___________________________________________________________________________________________________________________________________________
method TK_comet_preso Press_on_poly_mothers     {b x y} {}
method TK_comet_preso Release_on_poly_mothers   {b x y} {}
method TK_comet_preso Press_on_poly_daugthers   {b x y} {}
method TK_comet_preso Release_on_poly_daugthers {b x y} {}

Manage_CallbackList TK_comet_preso [list Press_on_poly_mothers Release_on_poly_mothers Press_on_poly_daugthers Release_on_poly_daugthers] end

#___________________________________________________________________________________________________________________________________________
method TK_comet_preso Button_press   {b x y} {
 set C_canvas $this(C_canvas)
 
 switch $b {
   1 {$C_canvas set_current_element $objName $x $y}
  }
  
 set canvas [$this(C_canvas) get_canvas]
 set item [lindex [$canvas find overlapping $x $y $x $y] end]
 if {$item != ""} {
   if {[lsearch [$canvas gettags $item] DRAG_$objName] >= 0} {
		switch $b {
		        1 {}
		  default {this Display_drop_down_menu $x $y}
		 }
    }
  }
}

#___________________________________________________________________________________________________________________________________________
method TK_comet_preso Button_release {b x y} {
 if {$b == 1} {$this(C_canvas) set_current_element "" $x $y}
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method TK_comet_preso Translate {x y} {
 set canvas [$this(C_canvas) get_canvas]
 
 set x [expr int($x)]; set y [expr int($y)]
 incr this(x) $x; incr this(y) $y
 $canvas move $objName $x $y
}

#___________________________________________________________________________________________________________________________________________
method TK_comet_preso Display_drop_down_menu {x y} {
 set canvas [$this(C_canvas) get_canvas]

 set top ._toplevel_${objName}
 if {![winfo exists $top]} {
   lassign [winfo pointerxy $canvas] x y

   toplevel $top; 
   set b $top.destroy
   button $b -text "Destroy component" -command "$objName Ask_destroy"
     pack $b -side top -fill x
   
   
   set    cmd "lassign \[split \[wm geometry $top\] +\] dim tmp tmp; lassign \[split \$dim x\] tx ty; "
   append cmd "wm geometry $top \$dim+\[expr $x - \$tx / 2\]+$y"
   after 10 $cmd
  }
}

#___________________________________________________________________________________________________________________________________________
method TK_comet_preso Ask_destroy {} {}

Manage_CallbackList TK_comet_preso [list Translate Ask_destroy] end

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Manage_CallbackList TK_comet_preso [list dispose Translate] begin

