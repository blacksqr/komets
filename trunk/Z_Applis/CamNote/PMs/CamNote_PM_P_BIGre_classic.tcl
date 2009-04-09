inherit CometCamNote_PM_P_BIGre_classic PM_U_Container

#___________________________________________________________________________________________________________________________________________
method CometCamNote_PM_P_BIGre_classic constructor {name descr args} {
 this inherited $name $descr

 if {[string length [info proc B_noeud]] > 0} {} else {return $objName}
   [$this(cou) get_ptf] maj Ptf_BIGre

 set this(node_created_inside) 1
 set poly [B_polygone]
 this set_prim_handle $poly
   $poly Ajouter_contour [ProcTabDouble {0 0 100 0 100 100 0 100}]
   $poly maj
   $poly Nom_IU $objName
 this set_root_for_daughters $poly
 
 # Camera viewer
 set this(visu_cam) [B_camera 320 240 [N_i_mere Prerendeur]]
   $this(visu_cam) Afficher_noeud 0
   $this(visu_cam) Gerer_contacts 0


 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method  CometCamNote_PM_P_BIGre_classic dispose {} {
 if {$this(node_created_inside)} {
   $this(primitives_handle) -delete
  }
 this inherited
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometCamNote_PM_P_BIGre_classic [L_methodes_set_CamNote] {}          {}
Methodes_get_LC CometCamNote_PM_P_BIGre_classic [L_methodes_get_CamNote] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method CometCamNote_PM_U Branch_to_user {u} {
 this inherited
}
