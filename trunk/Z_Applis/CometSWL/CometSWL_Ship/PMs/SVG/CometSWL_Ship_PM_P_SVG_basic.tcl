#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometSWL_Ship_PM_P_SVG_basic PM_SVG

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_SVG_basic constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id FUI_CometSWL_Ship_PM_P_SVG_basic
 
 this Add_MetaData PRIM_STYLE_CLASS [list $objName "SHIP PARAM RESULT IN OUT"]
 
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometSWL_Ship_PM_P_SVG_basic [P_L_methodes_set_CometSWL_Ship] {} {}
Methodes_get_LC CometSWL_Ship_PM_P_SVG_basic [P_L_methodes_get_CometSWL_Ship] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters CometSWL_Ship_PM_P_SVG_basic [P_L_methodes_set_CometSWL_Ship_COMET_RE]

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_SVG_basic Update_datas {} {}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_SVG_basic set_mode    {m}  {
 if {$m == "game"} {set v 0} else {set v 1}

}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_SVG_basic set_X       {v}  {
 
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_SVG_basic set_Y       {v}  {
 
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_SVG_basic Update_color {} {
 set color [$this(current_player) get_player_color]
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_SVG_basic Render {strm_name {dec {}}} {
 upvar $strm_name strm
 
 append strm "<circle id=\"${objName}\" cx=\"[this get_X]\" cy=\"[this get_Y]\" r=\"10\" fill=\"yellow\" />\n"
 
 this Render_daughters strm "$dec  "
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_PM_P_SVG_basic Render_post_JS {strm_name {dec ""}} {
 upvar $strm_name strm
 this inherited strm
 
 this Render_daughters_post_JS strm $dec

 # draggable?
 # append strm "\$(this).get(0).setAttribute('cx',e.pageX);"
 # append strm "\$(this).get(0).setAttribute('cy',e.pageY);"
}
