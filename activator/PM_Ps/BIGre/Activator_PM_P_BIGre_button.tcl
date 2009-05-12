#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Activator_PM_P_BIGre_button PM_BIGre

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_BIGre_button constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CT_Activator_AUI_basic_CUI_button_B207
   set this(inner_txt) [B_texte 100 30 27 [fonte_Arial] [B_sim_sds]]; $this(inner_txt) Editable 0
   this set_prim_handle [B_bouton 100 30 [N_i_mere] [N_i_mere Noeud_scene] 1]
   [N_i_mere Noeud_scene] Retirer_fils [this get_prim_handle]
   [[this get_prim_handle] Noeud_fen] Ajouter_fils $this(inner_txt)
   [this get_prim_handle] Mettre_a_jour
   [this get_prim_handle] Nom_IU $objName
   $this(inner_txt)       Nom_IU "Inner text of $objName"
   set this(rap_bt) [B_rappel [Interp_TCL] "$objName Trigger_prim_activate"]
   [this get_prim_handle] abonner_a_activation [$this(rap_bt) Rappel]

 eval "$objName configure $args"
 return $objName
}
#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_BIGre_button dispose {} {
 this inherited
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Activator_PM_P_BIGre_button $L_methodes_set_Activator {} {}
Methodes_get_LC Activator_PM_P_BIGre_button $L_methodes_get_Activator {$this(FC)}
Generate_PM_setters Activator_PM_P_BIGre_button [list {activate {{type {}}}}]
  Manage_CallbackList Activator_PM_P_BIGre_button prim_activate begin

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_BIGre_button Trigger_prim_activate {} {
 #puts "$objName Trigger_prim_activate"
 set cmd ""
 foreach {var val} [this get_Params] {append cmd " " $var " $val"}
 this prim_activate $cmd
}

#___________________________________________________________________________________________________________________________________________
Manage_CallbackList Activator_PM_P_BIGre_button Trigger_prim_activate begin

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_BIGre_button get_or_create_prims {root} {
 set r [this inherited $root]
   this set_text [[this get_Common_FC] get_text]
 return $r
}

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_BIGre_button set_text {{t {}}} {
 $this(inner_txt) TEXTE $t; $this(inner_txt) Calculer_boites
 $this(inner_txt) Optimiser_dimensions
 $this(inner_txt) Calculer_boites
 
 set box [$this(inner_txt) Boite_noeud_et_fils]
 $this(inner_txt) Origine [expr -[$box BG_X]] [expr -[$box BG_Y]]

 set B207_bt [this get_prim_handle]
   $B207_bt Longueur [$box Tx]
   $B207_bt Hauteur  [$box Ty]
 $B207_bt Mettre_a_jour
}

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_BIGre_button get_text {} {
 return [$this(inner_txt) TEXTE]
}
