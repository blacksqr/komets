#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Specifyer_PM_P_BIGre_text PM_BIGre

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_BIGre_text constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Specifyer_basic_BIGre_textarea   
   this set_prim_handle [B_texte 200 30 27 [fonte_Arial] [B_sim_sds]]

   set this(rap_car) [B_rappel [Interp_TCL] "$objName prim_set_text \[[this get_prim_handle] TEXTE\]"]
   [this get_prim_handle] abonner_a_caractere_tape [$this(rap_car) Rappel]
   set root [this get_prim_handle] 
     $root Calculer_boites
     #puts "$objName size:\n  - L : [$root Largeur]\n  - H [$root Hauteur]"

 eval "$objName configure $args"
 return $objName
}
#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_BIGre_text dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters Specifyer_PM_P_BIGre_text [P_L_methodes_set_specifyer_COMET_RE]

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_BIGre_text set_text {{t {}}} {
 [this get_prim_handle] TEXTE $t
}

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_BIGre_text get_text {} {
 return [[this get_prim_handle] TEXTE]
}



