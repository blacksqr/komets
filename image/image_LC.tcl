#___________________________________________________________________________________________________________________________________________
inherit CometImage Logical_consistency

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometImage constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CT_Image
# CFC
 set CFC_name "${objName}_CFC"
   Image_CFC $CFC_name
   this set_Common_FC $CFC_name
# LMs
 set this(LM_LP) "${objName}_LM_LP";
   LogicalImage $this(LM_LP) $this(LM_LP) "The logical presentation of $objName";
   this Add_LM $this(LM_LP)

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometImage dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometImage [P_L_methodes_set_Image] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometImage [P_L_methodes_get_Image] {$this(FC)}

