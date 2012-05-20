#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometInterleaving_PM_P_basic_SVG PM_SVG
#___________________________________________________________________________________________________________________________________________
method CometInterleaving_PM_P_basic_SVG constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Interleaving_FUI_basic_SVG
 eval "$objName configure $args"
 return $objName
}
#___________________________________________________________________________________________________________________________________________
method CometInterleaving_PM_P_basic_SVG Render {strm_name {dec {}}} {
 upvar $strm_name strm
 append strm $dec "<g [this Style_class]>\n"
   this Render_daughters strm "$dec  "
 append strm $dec "</g>\n"
}

#___________________________________________________________________________________________________________________________________________
method CometInterleaving_PM_P_basic_SVG maj_interleaved_daughters {} {}
