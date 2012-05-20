#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometTexte_PM_P_basic_SVG PM_SVG

#___________________________________________________________________________________________________________________________________________
method CometTexte_PM_P_basic_SVG constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id TextDisplay_FUI_label_SVG
   
   this Add_MetaData PRIM_STYLE_CLASS [list $objName "ROOT TEXT OUT" \
                                      ]
   
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometTexte_PM_P_basic_SVG dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometTexte_PM_P_basic_SVG $L_methodes_set_Text {} {}
Methodes_get_LC CometTexte_PM_P_basic_SVG $L_methodes_get_Text {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method CometTexte_PM_P_basic_SVG set_text {v} {
 set root    [this get_L_roots] 
 set methode "replaceWith"

 set param [this Encode_param_for_JS $v]
 set cmd   "document.getElementById('$objName').html($param);"

 if {[lsearch [gmlObject info classes $root] PhysicalHTML_root] != -1} {
	$root Concat_update $objName $methode $cmd
 }
}
#___________________________________________________________________________________________________________________________________________
method CometTexte_PM_P_basic_SVG Render {strm_name {dec {}}} {
 upvar $strm_name strm
 append strm $dec <text [this Style_class] {x="20" y="20">} [this get_text] </text> "\n"
 this Render_daughters strm "$dec "
}

#___________________________________________________________________________________________________________________________________________
method CometTexte_PM_P_basic_SVG Draggable {} {
	this inherited ${objName} [list ${objName}]
}

#___________________________________________________________________________________________________________________________________________
method CometTexte_PM_P_basic_SVG RotoZoomable {} {
	this inherited ${objName} [list ${objName}]
}


