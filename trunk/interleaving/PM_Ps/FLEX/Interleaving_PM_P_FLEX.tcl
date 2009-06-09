#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Interleaving_PM_P_FLEX PM_FLEX
#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_FLEX constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Interleaving_HTML
 eval "$objName configure $args"
}
#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_FLEX Render {strm_name {dec {}}} {
 upvar $strm_name strm
 append strm $dec "var $objName:TabNavigator = new TabNavigator(); \n"
   this Render_daughters strm ""
   
 append strm $dec " Dyna_context.$objName = $objName; \n"
 
 this set_prim_handle        $objName
 this set_root_for_daughters $objName
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_FLEX maj_interleaved_daughters {} {}
