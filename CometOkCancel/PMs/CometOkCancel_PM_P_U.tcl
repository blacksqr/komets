inherit CometOkCancel_PM_P_U PM_Universal

#___________________________________________________________________________________________________________________________________________
method CometOkCancel_PM_P_U constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CT_OkCancel_AUI_basic_CUI_composite_Universal
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometOkCancel_PM_P_U [L_methodes_set_CometOkCancel] {$this(FC)} {$this(L_actives_PM)}
Methodes_get_LC CometOkCancel_PM_P_U [L_methodes_get_CometOkCancel] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
