
#___________________________________________________________________________________________________________________________________________
inherit CometRoot Logical_consistency
#___________________________________________________________________________________________________________________________________________
method CometRoot constructor {name descr {toplevel {}} args} {
 this inherited $name $descr
   this set_GDD_id CT_Comet_Root
 set this(primitives_handle) {}
# set this(LM_FC) "${objName}_LM_FC";
#   Logical_model $this(LM_FC) $this(LM_FC) "The logical functionnal core of $name"; this Add_LM $this(LM_FC);
 set this(LM_LP) "${objName}_LM_LP";
   CometRoot_LM_P $this(LM_LP) $this(LM_LP) "The logical presentation of $name"; 
   this Add_LM $this(LM_LP)
   
 if {[string equal $toplevel {}]} {} else {
   set TK_root "${objName}_TK_root"
   PhysicalRootTK_root $TK_root $TK_root "A TK presentation of $name" $toplevel
   set this(TK_root) $TK_root
   $this(LM_LP) Add_PM $TK_root
   $this(LM_LP) set_PM_active $TK_root
  }
 #set this(handle_EE) [$this(LM_LP) get_Handle_EE]
 

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
proc L_methodes_set_CometRoot {} {return [list {Stop_Enlight {}} {Enlight {L}} ]}
proc L_methodes_get_CometRoot {} {return [list ]}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometRoot [L_methodes_set_CometRoot] {} {$this(L_LM)}

#_________________________________________________________________________________________________________
method CometRoot Enlight_with_CSS++ {css_expr} {
 set L_nodes  [CSS++ [this get_L_roots] $css_expr]
 this Enlight $L_nodes
}


#___________________________________________________________________________________________________________________________________________
#________________________________________________________ Définition of the logical model __________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometRoot_LM_P Logical_presentation
method CometRoot_LM_P constructor {name descr args} {
 this inherited $name $descr

 this Add_PM_factories [Generate_factories_for_PM_type [list {PhysicalHTML_root Ptf_HTML} \
                                                             {Root_PM_P_BIGre Ptf_BIGre}] \
                                                       $objName]

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometRoot_LM_P [L_methodes_set_CometRoot] {} {$this(L_actives_PM)}


#___________________________________________________________________________________________________________________________________________
#________________________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit PhysicalRootTK_root PM_TK
#___________________________________________________________________________________________________________________________________________
method PhysicalRootTK_root constructor {name descr root args} {
 this inherited $name $descr
   this set_GDD_id CT_Comet_Root_FUI_TK
   this get_or_create_prims $root
 
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC PhysicalRootTK_root [L_methodes_set_CometRoot] {} {}

#___________________________________________________________________________________________________________________________________________
method PhysicalRootTK_root get_root_for_daughters {} {return $this(primitives_handle)}

#___________________________________________________________________________________________________________________________________________
method PhysicalRootTK_root get_or_create_prims {root} {
 set this(root) $root
 this set_root_for_daughters $this(root)
 if {[string equal $root ""]} {set this(primitives_handle) "."} else {
   if {[winfo exists $root]} {
    } else {toplevel $root -width 10 -height 10}
   set this(primitives_handle) $root
  }
 this set_root_for_daughters $root
 return [this set_prim_handle $root]
}

#___________________________________________________________________________________________________________________________________________

#___________________________________________________________________________________________________________________________________________
method PhysicalRootTK_root get_prim_handle {{index -1}}  {
 set rep $this(primitives_handle)
 if {[winfo exists $rep]} {
   return $rep
  } else {if {[expr $index<[llength $this(L_daughters)]]} {return ""}}
 return NULL
}
#_________________________________________________________________________________________________________
method PhysicalRootTK_root get_width  {{PM {}}} {return [winfo width  .$this(root)]}
method PhysicalRootTK_root get_height {{PM {}}} {return [winfo height .$this(root)]}


