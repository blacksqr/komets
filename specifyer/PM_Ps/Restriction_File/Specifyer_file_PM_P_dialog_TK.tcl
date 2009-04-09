inherit Specifyer_file_PM_P_dialog_TK PM_TK

#___________________________________________________________________________________________________________________________________________
method Specifyer_file_PM_P_dialog_TK constructor {name descr args} {
 this inherited $name $descr
 this set_root_for_daughters NULL
   this set_nb_max_daughters 0
   set this(direct_plug) 0
   set this(root_of_prim) ""
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method Specifyer_file_PM_P_dialog_TK dispose {} {this inherited}

#______________________________________________________ Adding the choices functions _______________________________________________________
Methodes_set_LC Specifyer_file_PM_P_dialog_TK $L_methodes_set_Specifyer {$this(FC)} {}
Methodes_get_LC Specifyer_file_PM_P_dialog_TK $L_methodes_get_Specifyer {$this(FC)}

Generate_accessors Specifyer_file_PM_P_dialog_TK [list direct_plug]

#___________________________________________________________________________________________________________________________________________
method Specifyer_file_PM_P_dialog_TK get_or_create_prims {root} {
 set this(root_of_prim) $root
 set LC  [this get_LC]
 set txt [$LC get_name]
 if {$this(direct_plug)} {
   $LC set_text [tk_getSaveFile -title [$LC get_name] -parent $root]
   return
  }
 set this(b) $root.tk_${objName}_bt
 if {[winfo exists $this(b)]} {} else {
   button $this(b)
  }
 $this(b) configure -text $txt -command "$LC set_text \[tk_getSaveFile -title \{$txt\} -parent $root\]"

# Bindings
 set L [list $this(b)]
 this set_prim_handle $L

 return [this set_prim_handle $L]
}

#___________________________________________________________________________________________________________________________________________
method Specifyer_file_PM_P_dialog_TK activate {} {
 if {![winfo exists $this(root_of_prim)]} {return}
 set LC  [this get_LC]
 set txt [$LC get_name]
 $LC set_text [tk_getSaveFile -title $txt -parent $this(root_of_prim)]
}
