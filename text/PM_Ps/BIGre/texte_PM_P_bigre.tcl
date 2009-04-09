#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometText_PM_P_BIGre PM_BIGre

#___________________________________________________________________________________________________________________________________________
method CometText_PM_P_BIGre constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id TextDisplay_CUI_label_B207
 set this(primitives_handle) [B_texte 200 30 27 [fonte_Arial] [B_sim_sds]]
 $this(primitives_handle) Nom_IU $objName
 $this(primitives_handle) Editable 0

 this set_prim_handle        $this(primitives_handle)
 this set_root_for_daughters $this(primitives_handle)

 this Add_MetaData PRIM_STYLE_CLASS [list $this(primitives_handle) "PARAM RESULT OUT text TEXT"]
 
 eval "$objName configure $args"
 return $objName
}


#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometText_PM_P_BIGre $L_methodes_set_Text {}          {}
Methodes_get_LC CometText_PM_P_BIGre $L_methodes_get_Text {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method CometText_PM_P_BIGre get_text {}  {
 return [$this(primitives_handle) TEXTE]
}

#___________________________________________________________________________________________________________________________________________
method CometText_PM_P_BIGre set_text {t} {
 $this(primitives_handle) TEXTE $t
}

