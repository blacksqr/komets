
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Image_PM_P_BIGre PM_BIGre

#___________________________________________________________________________________________________________________________________________
method Image_PM_P_BIGre constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CT_Image_AUI_CUI_basic_B207

   set this(primitives_handle) [B_image]

 this set_prim_handle        $this(primitives_handle)
 this set_root_for_daughters $this(primitives_handle)

 this Add_MetaData PRIM_STYLE_CLASS [list $this(primitives_handle) "PARAM RESULT OUT image IMAGE"]
 
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method Image_PM_P_BIGre get_or_create_prims {root} {
 $this(primitives_handle) Nom_IU [this get_LC]_PM_P_BIGre_img
 return [this inherited $root]
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Image_PM_P_BIGre [P_L_methodes_set_Image] {} {}
Methodes_get_LC Image_PM_P_BIGre [P_L_methodes_get_Image] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method Image_PM_P_BIGre load_img {url}  {
 if {[string equal [string index $url 1] :]} {set img_path $url} else {set img_path [Comet_files_root]$url}
 [$this(primitives_handle) Img] maj $img_path
 if {[string equal -nocase [string range $url end-2 end] png]} {$this(primitives_handle) Translucidite 1} else {$this(primitives_handle) Translucidite 0}
}
