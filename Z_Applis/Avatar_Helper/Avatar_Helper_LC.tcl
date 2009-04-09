inherit Avatar_Helper_LC Logical_consistency

#___________________________________________________________________________________________________________________________________________
method Avatar_Helper_LC constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Avatar_Helper
 set CFC "${objName}_CFC"; Avatar_Helper_CFC $CFC
   this set_Common_FC $CFC

 set this(LM_LP) "${objName}_LM_LP";
   Avatar_Helper_LM_P  $this(LM_LP) $this(LM_LP) "The logical presentation of $name"
   this Add_LM $this(LM_LP);

# Finish construction process
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method Avatar_Helper_LC dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
Generate_accessors Avatar_Helper_LC [list ]

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Avatar_Helper_LC [L_methodes_set_Avatar_Helper] {$this(FC)} {$this(L_LM)}
Methodes_get_LC Avatar_Helper_LC [L_methodes_get_Avatar_Helper] {$this(FC)}

