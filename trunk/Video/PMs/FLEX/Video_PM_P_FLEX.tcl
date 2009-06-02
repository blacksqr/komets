#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Video_PM_P_FLEX PM_FLEX
#___________________________________________________________________________________________________________________________________________
method Video_PM_P_FLEX constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Container_CUI_frame_FLEX

   this set_root_for_daughters $objName
   this set_prim_handle        $objName
   this Add_MetaData PRIM_STYLE_CLASS [list $objName "ROOT FRAME" \
                                      ]
									  
	set this(url) ""
 eval "$objName configure $args"
 return $objName
}

#_________________________________________________________________________________________________________________________________
Generate_accessors Video_PM_P_FLEX [list url]

#___________________________________________________________________________________________________________________________________________
method Video_PM_P_FLEX set_url {url} {
 set root   [this get_L_roots]
 set cmd   "$objName.source=$this($url);"

 if {[lsearch [gmlObject info classes $root] PhysicalHTML_root] != -1} {
	$root send_to_FLEX $cmd
	puts "commande : $cmd"
 }
}

#___________________________________________________________________________________________________________________________________________
method Video_PM_P_FLEX Play  {} {
 set root    [this get_L_roots] 
 set cmd     "$objName.play() ;\n"
 
 if {[lsearch [gmlObject info classes $root] Comet_root_PM_P_FLEX] != -1} {
	$root send_to_FLEX $cmd
	puts "commande : $cmd"
 }
}
#___________________________________________________________________________________________________________________________________________
method Video_PM_P_FLEX Pause {} {
 set root    [this get_L_roots] 
 set cmd     "$objName.pause() ;\n"
 
 if {[lsearch [gmlObject info classes $root] Comet_root_PM_P_FLEX] != -1} {
	$root send_to_FLEX $cmd
	puts "commande : $cmd"
 }
}
#___________________________________________________________________________________________________________________________________________
method Video_PM_P_FLEX Stop {} {
 set root    [this get_L_roots] 
 set cmd     "$objName.stop() ;\n"
 
 if {[lsearch [gmlObject info classes $root] Comet_root_PM_P_FLEX] != -1} {
	$root send_to_FLEX $cmd
	puts "commande : $cmd"
 }
}
#___________________________________________________________________________________________________________________________________________
method Video_PM_P_FLEX go_to_time {t} {
 set root    [this get_L_roots] 
 # t doit être en seconde
 set cmd     "$objName.playheadTime = $t;\n"
 
 if {[lsearch [gmlObject info classes $root] Comet_root_PM_P_FLEX] != -1} {
	$root send_to_FLEX $cmd
	puts "commande : $cmd"
 }
}
#___________________________________________________________________________________________________________________________________________
method Video_PM_P_FLEX go_to_frame {nb} {

}

#___________________________________________________________________________________________________________________________________________
method Video_PM_P_FLEX Render {strm_name {dec {}}} {
 upvar $strm_name strm
 append strm $dec " var $objName:VideoDisplay = new VideoDisplay(); \n"
 append strm $dec " $objName.width=330;$objName.height=250;$objName.x=50;$objName.y=50; \n"
 append strm $dec " $objName.addEventListener(MouseEvent.CLICK,$objName_play); \n"
 append strm $dec " function ${objName}_play(${objName}_evt:MouseEvent):void { \n"
 append strm $dec "		FLEX_to_TCL(\"$objName\", \"prim_play\", \"\") } \n"
 append strm $dec " Dyna_context.$objName = $objName; \n"
 
 this set_prim_handle        $objName
 this set_root_for_daughters $objName
}
