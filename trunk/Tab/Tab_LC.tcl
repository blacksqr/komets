#___________________________________________________________________________________________________________________________________________
inherit CometTab Logical_consistency

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometTab constructor {name descr args} {
 this inherited $name $descr
  #this set_GDD_id CT_Image
# CFC
 set CFC_name "${objName}_CFC"
   Tab_CFC $CFC_name
   this set_Common_FC $CFC_name
# LMs
 set this(LM_LP) "${objName}_LM_LP";
   Tab_LM_P $this(LM_LP) $this(LM_LP) "The logical presentation of $objName";
   this Add_LM $this(LM_LP)

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometTab dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometTab [P_L_methodes_set_Tab] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometTab [P_L_methodes_get_Tab] {$this(FC)}

Manage_CallbackList CometTab set_case    end
Manage_CallbackList CometTab Insert_col  end
Manage_CallbackList CometTab Delete_col  begin
Manage_CallbackList CometTab Insert_line end
Manage_CallbackList CometTab Delete_line begin


proc Fill_tab {tab} {
 set L [$tab get_nb_L]; set C [$tab get_nb_C]
 for {set i 0} {$i<$L} {incr i} {
   for {set j 0} {$j<$C} {incr j} {
     $tab set_case $i $j "$i,$j"
    }
  }
}
