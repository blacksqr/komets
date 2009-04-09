#___________________________________________________________________________________________________________________________________________
inherit CometMarker Logical_consistency

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometMarker constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Marker
# CFC
 set CFC_name "${objName}_CFC"
   Marker_CFC $CFC_name
   this set_Common_FC $CFC_name
# LMs
 set this(LM_LP) "${objName}_LM_LP";
   LogicalMarker $this(LM_LP) $this(LM_LP) "The logical presentation of $objName";
   this Add_LM $this(LM_LP)
   
 eval "$objName configure $args"
 return $objName
}
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometMarker [L_methodes_set_Marker] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometMarker [L_methodes_get_Marker] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method CometMarker dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
Manage_CallbackList CometMarker set_mark end
