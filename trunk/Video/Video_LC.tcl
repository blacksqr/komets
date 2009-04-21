#___________________________________________________________________________________________________________________________________________
inherit CometVideo Logical_consistency

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometVideo constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CT_Video
# CFC
 set CFC_name "${objName}_CFC"
   Video_CFC $CFC_name
   this set_Common_FC $CFC_name
# LMs
 set this(LM_LP) "${objName}_LM_LP";
   LogicalVideo $this(LM_LP) $this(LM_LP) "The logical presentation of $objName";
   this Add_LM $this(LM_LP)

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometVideo dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometVideo [P_L_methodes_set_Video] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometVideo [P_L_methodes_get_Video] {$this(FC)}
