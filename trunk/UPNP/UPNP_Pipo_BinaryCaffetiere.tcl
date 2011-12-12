#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Pipo_UPNP_BinaryCaffetiere Pipo_UPNP_Binary
method Pipo_UPNP_BinaryCaffetiere constructor {t metadata canvas x y {f_image Comets/UPNP/Caffetiere.GIF}} {
	image create photo photo_of_$objName -file $::env(ROOT_COMETS)$f_image
	set this(is_on) 2
	set this(canvas) $canvas
		$this(canvas) create image $x $y -image photo_of_$objName -tags [list $objName]
	
	this inherited $t $metadata
	this update_presentation
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_BinaryCaffetiere SetTarget {args} {
	set rep [eval "this inherited $args"]
	this update_presentation
	return $rep
}

#___________________________________________________________________________________________________________________________________________
method Pipo_UPNP_BinaryCaffetiere update_presentation {} {
	if {$this(Status) == $this(is_on)} {return}
	set this(is_on) $this(Status)
	if {!$this(is_on)} {
		 lassign [$this(canvas) bbox $objName] x1 y1 x2 y2
		 $this(canvas) create line $x1 $y1 $x2 $y2 -width 10 -tags [list $objName ISOFF_$objName]
		 $this(canvas) create line $x2 $y1 $x1 $y2 -width 10 -tags [list $objName ISOFF_$objName]
		} else {$this(canvas) delete ISOFF_$objName}
}


