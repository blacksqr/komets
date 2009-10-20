#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Container_PM_P_BIGre_normal PM_BIGre

if {[file exists [get_B207_files_root]]} {source [get_B207_files_root]B_Panel.tcl}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_BIGre_normal constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Container_CUI_frame_BIGre
   
 set n [B_noeud]; $n Position_des_fils_changeable 0
 $n Nom_IU $objName
   set this(poly_background) [B_polygone]
   B_configure $this(poly_background) -Etirement 1 1            \
									  -Position_des_fils_changeable 0

   B_configure $n -Ajouter_fils_au_debut $this(poly_background)    \
                  -Position_des_fils_changeable 0
   
 this set_prim_handle        $n
 this set_root_for_daughters $this(poly_background)

   if {![info exists class(img_bt_left)]} {
     set class(img_bt_left)  [B_image [get_B207_files_root]BDec.bmp]
     set class(img_bt_right) [B_image [get_B207_files_root]BInc.bmp]
	}
 
# $this(rap_placement) Texte "$objName Line_h"
   #$n abonner_a_LR_parcours [$n LR_Av_pre_rendu] [$this(rap_placement) Rappel]

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors Container_PM_P_BIGre_normal [list poly_background panel]

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_BIGre_normal set_panel_button_side {v} {$this(panel) set_side $v}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_BIGre_normal Panel_mode {v} {
 if {$v} {
   if {![info exists this(panel)]} {
     set this(panel) ${objName}_B207_panel
     Panel $this(panel) [this get_prim_handle] $this(poly_background) [list $class(img_bt_right) $class(img_bt_left)]
	}
  }
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_BIGre_normal Toggle_extension {} {
 $this(panel) toggle_extension
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_BIGre_normal Redim_background {x1 y1 x2 y2} {
 set contour [ProcRect $x1 $y1 $x2 $y2]
   $this(poly_background) Vider
   $this(poly_background) Ajouter_contour $contour
   if {[info exists this(panel)]} { [$this(panel) get_button] Origine $x2 [expr $y2/2.0] }
 Detruire $contour
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_BIGre_normal background_color {r g b a} {
 $this(poly_background) Couleur $r $g $b $a
}
