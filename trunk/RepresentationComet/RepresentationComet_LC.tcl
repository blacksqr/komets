#___________________________________________________________________________________________________________________________________________
inherit Comet_RepresentationComet Logical_consistency

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method Comet_RepresentationComet constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id N_Choice
 this set_nb_max_daughters 0

# Specfic choice datas
 set CFC "${objName}_CFC"
   RepresentationComet_CFC $CFC 
   this set_Common_FC $CFC

# Classicals comet model parts
 set this(LM_LP) "${objName}_LM_LP";
 RepresentationComet_LM_LP $this(LM_LP) "${name}_LM_LP" "The logical presentation of $name";
 this Add_LM $this(LM_LP);

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method Comet_RepresentationComet dispose {} {this inherited}

#_______________________________________________ Adding the choices functions _______________________________________________
Methodes_set_LC Comet_RepresentationComet [P_L_methodes_set_RepresentationComet] {$this(FC)} {$this(L_LM)}
Methodes_get_LC Comet_RepresentationComet [P_L_methodes_get_RepresentationComet] {$this(FC)}
