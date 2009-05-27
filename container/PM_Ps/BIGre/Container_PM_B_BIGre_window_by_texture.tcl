#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Container_PM_P_BIGre_window_by_texture PM_BIGre

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_BIGre_window_by_texture constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Container_FUI_window_by_texture

   if {![info exists class(img_right_arrow)]} {set class(img_right_arrow) [B_image [get_B207_files_root]BInc.bmp]
	                                          }
   
 set this(root)         [B_noeud]   ; $this(root) Position_des_fils_changeable 0
 set this(body)         [B_polygone]; $this(body) Position_des_fils_changeable 0; $this(body) Mode_texture  1; $this(body) Mode_texture_fils   1; $this(body) Mode_texture2 1; 
                                                                                  $this(body) Translucidite 0; $this(body) Texture_translucide 0; 
 set this(head)         [B_polygone]; $this(head) Position_des_fils_changeable 0
 set this(redim)        [B_polygone]; set contour [ProcTabDouble "0 0 0 32 16 32 16 -16 -32 -16 -32 0"]
                                        $this(redim) Ajouter_contour $contour
									  Detruire $contour
 set this(head_up_down) [B_polygone]; set contour [ProcOvale 0 0 10 10 60]
                                        $this(head_up_down) Ajouter_contour $contour
										$this(head_up_down) Info_texture    [$class(img_right_arrow) Info_texture]
										$this(head_up_down) Rotation [expr 3.14156592/2.0]
									  Detruire $contour
 
 this set_prim_handle        $this(root)
 this set_root_for_daughters $this(body)
 $this(root) Nom_IU $objName


   B_configure $this(root) -Ajouter_fils $this(body) \
                           -Ajouter_fils $this(head) \
						   -Ajouter_fils $this(redim)

   B_configure $this(head) -Ajouter_fils $this(head_up_down)
   

 
# $this(rap_placement) Texte "$objName Line_h"
   #$n abonner_a_LR_parcours [$n LR_Av_pre_rendu] [$this(rap_placement) Rappel]

# set up head zone
 set this(ctc_head) ${objName}_B_contact_head; B_contact $this(ctc_head) "$this(root) 0" -add "$this(head) 11"; $this(ctc_head) pt_rot_actif 0

# set up the redim zone
 set this(ctc_redim) ${objName}_B_contact_redim; B_contact $this(ctc_redim) "$this(redim) 1"
 set this(rap_move_redim) [B_rappel [Interp_TCL] "$objName redim_zone_has_moved"]
 $this(ctc_redim) abonner $this(rap_move_redim)

# set up dimensions and colors 
 set this(L_prim_layout) [list]
 set this(width)  640
 set this(height) 480
 this set_head_height 20
 this set_body_color  "0.2 0.5 0.2 1"
 this set_head_color  "0.2 0.2 0.5 1"
 this set_redim_color "0.2 0.2 0.5 1"
 this Redim $this(width) $this(height)

# Finishing
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors Container_PM_P_BIGre_window_by_texture [list head_height body_color head_color redim_color]

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_BIGre_window_by_texture Redim {width height {triggered_by_redim_zone 0}} {
 set this(width)  $width
 set this(height) $height
 
# set up body
 set contour [ProcRect 0 0 $width $height]
   $this(body) Vider
   $this(body) Ajouter_contour $contour
 Detruire $contour
 
# set up header
 set contour [ProcRect 0 0 $width [this get_head_height]]
   $this(head) Vider
   $this(head) Ajouter_contour $contour
   $this(head) Origine 0 $height
 Detruire $contour
 
# set up header up down arrow
 set box_local  [$this(head_up_down) Boite_noeud_et_fils]
 $this(head_up_down) Origine [expr $width - [$box_local BG_X] - [$box_local Tx]] [expr -[$box_local BG_Y]]
 
# set up redim zone
 $this(redim) Origine $width 0

# Deal with layout
 this Win_layout
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_BIGre_window_by_texture set_head_height {v} {
 set this(head_height) $v
 this Redim $this(width) $this(height)
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_BIGre_window_by_texture set_body_color {v} {
 set this(body_color) $v
 eval "$this(body) Couleur $v"
 eval "$this(body) Couleur_fond_texture $v"
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_BIGre_window_by_texture set_head_color {v} {
 set this(head_color) $v
 eval "$this(head) Couleur $v"
}
#___________________________________________________________________________________________________________________________________________
method Container_PM_P_BIGre_window_by_texture set_redim_color {v} {
 set this(redim_color) $v
 eval "$this(redim) Couleur $v"
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method Container_PM_P_BIGre_window_by_texture redim_zone_has_moved {} {
 $this(root) Translation 0 [$this(redim) Py]
 this Redim [$this(redim) Px] [expr [$this(head) Py] - [$this(redim) Py]] 1
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_BIGre_window_by_texture Layout {L_prim_layout} {
 set new_L [list]
 foreach {prim layout} $L_prim_layout {
   set found 0
   foreach {this_prim this_layout} $this(L_prim_layout) {
     if {$prim == $this_prim} {set found 1; break}
    }
   if {$found} {lappend nL $prim $this_layout} else {lappend nL $prim $layout}
  }
  
 set this(L_prim_layout) $nL
 this Win_layout
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_BIGre_window_by_texture Win_layout {} {
 foreach {PM_prim layout} $this(L_prim_layout) {
   $PM_prim Maj_boites_recursif; $PM_prim Afficher; $PM_prim Maj_boites_recursif;
   set box  [$PM_prim Boite_noeud_et_fils]
   set L $this(width); set H $this(height)
   switch $layout {
     top-left {set x [expr -[$box BG_X]] 
			   set y [expr $H - [$box Ty] - [$box BG_Y]]
			   $PM_prim Origine $x $y
			  }
    }
  }
  
}

