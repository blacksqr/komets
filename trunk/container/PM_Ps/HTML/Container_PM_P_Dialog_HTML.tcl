#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Container_PM_P_Dialog_HTML PM_HTML
#___________________________________________________________________________________________________________________________________________
method Container_PM_P_Dialog_HTML constructor {name descr args} {
 this inherited $name $descr
 set this(x) 10
 set this(y) 10
 set this(w) -1
 set this(h) -1
   this set_GDD_id Container_CUI_frame_HTML
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_Dialog_HTML Resize {w h} {
 set root    [this get_L_roots]
 set this(w) w
 set this(h) h
 set methode "resize"
 
 set cmd ""
 if {$this(h) != -1} { append cmd "\$(\"#$objName\").height(" $this(h) ");" "\n"; }
 if {$this(w) != -1} { append cmd "\$(\"#$objName\").width(" $this(w) ");" "\n"; }

 if {[lsearch [gmlObject info classes $root] PhysicalHTML_root] != -1} {
	$root Concat_update $objName $methode $cmd
 }
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_Dialog_HTML Origine {x y} {
 set root    [this get_L_roots]
 set this(x) x
 set this(y) y
 set methode "origine"
 
 set cmd "\$(\"#$objName\").position([" $this(x) "," $this(y) "]);" "\n"

 if {[lsearch [gmlObject info classes $root] PhysicalHTML_root] != -1} {
	$root Concat_update $objName $methode $cmd
 }
}
#___________________________________________________________________________________________________________________________________________
method Container_PM_P_Dialog_HTML Render_JS {strm_name mark {dec {}}} {
 upvar $strm_name strm

 append strm $dec "\$(function() {" "\n"
 append strm $dec "var options = {position : [" $this(x) "," $this(y) "]}" "\n" 
 if {$this(y) != -1} { append strm $dec "options = {height: '$this(y)'}" "\n"; }
 if {$this(x) != -1} { append strm $dec "options = {width: '$this(x)'}" "\n"; }
 append strm $dec "	\$(\"#$objName\").dialog(options); "  "\n"
 append strm $dec "});" "\n"

 this set_mark $mark
 this Render_daughters_JS strm $mark $dec  
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_Dialog_HTML Render {strm_name {dec {}}} {
 upvar $strm_name strm
 
 append strm $dec <div  [this Style_class] > "\n"
   this Render_daughters strm "$dec  "
 append strm $dec </div> "\n"
}