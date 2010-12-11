inherit CometUPNP Logical_consistency

#___________________________________________________________________________________________________________________________________________
method CometUPNP constructor {name descr args} {
 this inherited $name $descr
 this set_GDD_id CT_CometUPNP

 set CFC ${objName}_CFC; CometUPNP_CFC $CFC; this set_Common_FC $CFC

 set this(LM_FC) ${objName}_LM_FC
 CometUPNP_LM_FC $this(LM_FC) $this(LM_FC) "The LM FC of $name"
   this Add_LM $this(LM_FC)
 set this(LM_LP) ${objName}_LM_LP
 CometUPNP_LM_LP $this(LM_LP) $this(LM_LP) "The LM PM of $name"
   this Add_LM $this(LM_LP)

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometUPNP dispose {} {this inherited}
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometUPNP [P_L_methodes_set_CometUPNP] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometUPNP [P_L_methodes_get_CometUPNP] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Manage_CallbackList CometUPNP [list set_item_of_dict_devices remove_item_of_dict_devices] end