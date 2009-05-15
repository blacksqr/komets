#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit DChoice_PM_P_interleaving_markers_HTML PM_Choice_HTML

#___________________________________________________________________________________________________________________________________________
method DChoice_PM_P_interleaving_markers_HTML constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Choice_InterleavedMarkers_HTML
   
   this Add_MetaData PRIM_STYLE_CLASS [list $objName "ROOT CHOICE IN OUT" \
                                      ]

 eval "$objName configure $args"
 return $objName
}
#___________________________________________________________________________________________________________________________________________
method DChoice_PM_P_interleaving_markers_HTML dispose {} {
 this inherited
}
#___________________________________________________________________________________________________________________________________________
method DChoice_PM_P_interleaving_markers_HTML maj_choices {} {}

#___________________________________________________________________________________________________________________________________________
method DChoice_PM_P_interleaving_markers_HTML get_L_PM_marker {} {
 set L_PM {}
 set L_markers_LM [eval [this get_LM] get_handle_comet_daughters]
 foreach marker_LM $L_markers_LM {
   foreach PM [$marker_LM get_L_actives_PM] {
     if {[${PM}_cou_ptf Accept_for_daughter Ptf_HTML]} {
       lappend L_PM $PM
      }
    }
  }
 return $L_PM
}

#___________________________________________________________________________________________________________________________________________
method DChoice_PM_P_interleaving_markers_HTML Render {strm_name {dec {}}} {
 upvar $strm_name rep

 set L_PM [this get_L_PM_marker]
 if {[this get_nb_max_choices] == 1} {
   foreach PM $L_PM {[$PM get_LM] Ptf_style {{Ptf_HTML Marker_PM_P_Radio_HTML}}}
   set cmd "\$PM set_HTML_var ${objName}__XXX__prim_set_currents; \$PM set_HTML_val \[eval \[\$PM get_daughters\] get_LC\];"
  } else {
      foreach PM $L_PM {[$PM get_LM] Ptf_style {{Ptf_HTML Marker_PM_P_CheckBox_HTML}}}
      #set cmd "\$PM set_HTML_var \$\{PM\}__XXX__prim_set_mark; \$PM set_HTML_val 1;"
      set cmd {}
     }

 set L_PM [this get_L_PM_marker]
 foreach PM $L_PM {
   if {[catch $cmd res]} {
     puts "Problème de marker pour $objName:\n |-> cmd : $cmd\n |-> res : $res"
    }
  }

 append rep $dec <div [this Style_class] > "\n"
   this inherited rep $dec
 append rep $dec </div> "\n"
}

