#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Proxy_Pipo_Sonos Proxy_UPNP_Sonos
method Proxy_Pipo_Sonos constructor {L_tag_value t metadata canvas x y} {
	this inherited $L_tag_value $t PIPO_SONOS $metadata 
	image create photo photo_of_$objName -file $::env(ROOT_COMETS)Comets/UPNP/caissonsRCF.gif
	set this(no_sound) 2
	set this(canvas) $canvas
		$this(canvas) create image $x $y -image photo_of_$objName -tags [list $objName]
	this update_presentation
}

#___________________________________________________________________________________________________________________________________________
method Proxy_Pipo_Sonos SetMute {args} {
	set rep [eval "this inherited $args"]
	this update_presentation
	return $rep
}
Trace Proxy_Pipo_Sonos SetMute

#___________________________________________________________________________________________________________________________________________
method Proxy_Pipo_Sonos SetVolume {args} {
	set rep [eval "this inherited $args"]
	this update_presentation
	return $rep
}

#___________________________________________________________________________________________________________________________________________
method Proxy_Pipo_Sonos update_presentation {} {
	if {$this(CurrentMute) == $this(no_sound)} {return}
	set this(no_sound) $this(CurrentMute)
	if {$this(no_sound)} {
		 lassign [$this(canvas) bbox $objName] x1 y1 x2 y2
		 $this(canvas) create line $x1 $y1 $x2 $y2 -width 10 -tags [list NOSOUND_$objName]
		 $this(canvas) create line $x2 $y1 $x1 $y2 -width 10 -tags [list NOSOUND_$objName]
		} else {$this(canvas) delete NOSOUND_$objName}
}


