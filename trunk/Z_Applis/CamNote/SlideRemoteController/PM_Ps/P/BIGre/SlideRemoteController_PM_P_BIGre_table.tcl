inherit SlideRemoteController_PM_P_BIGre_table PM_BIGre

if {[file exists [get_B207_files_root]]} {source [get_B207_files_root]test_fisheyes.tcl}
# ccn_speaker_telec_PM_P_3 Substitute_by_PM_type SlideRemoteController_PM_P_BIGre_table

#___________________________________________________________________________________________________________________________________________
method SlideRemoteController_PM_P_BIGre_table constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id N_controller_CUI_basic_gfx_Fish_Eye_B207
 if {[string length [info proc B_noeud]] > 0} {} else {return $objName}

 set this(fish_eye) FishEye_$objName
   FishEye_on_Images $this(fish_eye) ""
   $this(fish_eye) set_dims 1024 768
   set root [$this(fish_eye) get_root]
     $root Couleur 0 0 0 0.4
 set this(ptr) ""
 
# Set up some callbacks
  set this(pt_tmp) [B_point]
 #B_configure $root -Contenu_dans_fils_ssi_contenu_dans_noeud 1 -Contenu_dans_fils_ssi_pas_contenu_dans_noeud 1
 set this(rap_root_mvt) [B_rappel [Interp_TCL]]
   $this(rap_root_mvt) Texte "if {\[catch {$objName Change_fish $this(rap_root_mvt) $root $this(pt_tmp)} err\]} {puts \"Change_fish ERROR\\n\$err\"}"
   $root abonner_a_detection_pointeur [$this(rap_root_mvt) Rappel] [ALX_pointeur_mouvement]
 set this(rap_root_press) [B_rappel [Interp_TCL]]
   $this(rap_root_press) Texte "if {\[catch {$objName B207_Press $this(rap_root_press)} err\]} {puts \"Change_fish ERROR\\n\$err\"}"
   $root abonner_a_detection_pointeur [$this(rap_root_press) Rappel] [ALX_pointeur_enfonce]
 set this(rap_root_release) [B_rappel [Interp_TCL]]
   $this(rap_root_release) Texte "if {\[catch {$objName B207_Release $this(rap_root_release)} err\]} {puts \"Change_fish ERROR\\n\$err\"}"
   $root abonner_a_detection_pointeur [$this(rap_root_release) Rappel] [ALX_pointeur_relache]

 set this(FishEye_E)      0.25
 set this(FishEye_Factor) 10
 $this(fish_eye) set_rap_aff_roo_txt "$this(fish_eye) set_E_for_daughters \[$objName get_FishEye_E\]; B207_flow $root; B207_position_fisheye $root \[$objName get_FishEye_Factor\]"

# Set up primitives
 this set_prim_handle $root
 this set_root_for_daughters [this get_prim_handle]

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method SlideRemoteController_PM_P_BIGre_table B207_Release {rap} {
 set infos [Void_vers_info [$rap Param]]
 set ptr [$infos Ptr]
 if {[string equal $this(ptr) $ptr] && ([$ptr Appuie] == 0)} {
   set this(ptr) ""
   B_configure [this get_prim_handle] Retirer_MetaData_T L_ptr -Mode_texture 1 -Mode_texture_fils 1
  }
}

#___________________________________________________________________________________________________________________________________________
method SlideRemoteController_PM_P_BIGre_table B207_Press {rap} {
 set infos [Void_vers_info [$rap Param]]
 set ptr [$infos Ptr]
 if {[string equal $this(ptr) ""]} {
   set this(ptr) $ptr
   this Change_fish $rap [this get_prim_handle] $this(pt_tmp)
   B_configure [this get_prim_handle] -Mode_texture 0 -Mode_texture_fils 0
  } else {set n [Real_class [$infos NOEUD]]
          set pos [lsearch [this get_L_slides] [$n Val_MetaData src]]
		  if {$pos != -1} {this prim_set_current [expr $pos + 1]
		                  }
         }
}

#___________________________________________________________________________________________________________________________________________
method SlideRemoteController_PM_P_BIGre_table Change_fish {rap root pt_tmp} {
 set infos [Void_vers_info [$rap Param]]
 set ptr [$infos Ptr]
 if {![string equal $ptr $this(ptr)]} {return}
 Change_fish $rap $root $pt_tmp
}

#___________________________________________________________________________________________________________________________________________
method SlideRemoteController_PM_P_BIGre_table dispose {} {
 if {$this(node_created_inside)} {
   $this(primitives_handle) -delete
  }
 this inherited
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC SlideRemoteController_PM_P_BIGre_table $L_methodes_set_choicesN {$this(FC)} {}
Methodes_get_LC SlideRemoteController_PM_P_BIGre_table $L_methodes_get_choicesN {$this(FC)}
Methodes_set_LC SlideRemoteController_PM_P_BIGre_table [L_methodes_set_SlideRemoteController] {$this(FC)} {}
Methodes_get_LC SlideRemoteController_PM_P_BIGre_table [L_methodes_get_SlideRemoteController] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters SlideRemoteController_PM_P_BIGre_table [L_methodes_set_SlideRemoteController]

#___________________________________________________________________________________________________________________________________________
Generate_accessors SlideRemoteController_PM_P_BIGre_table [list fish_eye FishEye_E FishEye_Factor]

#___________________________________________________________________________________________________________________________________________
method SlideRemoteController_PM_P_BIGre_table get_rap_txt {} {
 return [$this(fish_eye) get_rap_aff_roo_txt]
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method SlideRemoteController_PM_P_BIGre_table set_L_slides {L} {
 $this(fish_eye) set_L_images $L
 foreach img [$this(fish_eye) get_L_images] {
   $img Ajouter_MetaData_T nb_clics 0
  }
}

#___________________________________________________________________________________________________________________________________________
method SlideRemoteController_PM_P_BIGre_table set_E {v} {
 $this(fish_eye) set_E_for_daughters $v
}

#___________________________________________________________________________________________________________________________________________





