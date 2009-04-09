#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Text_PM_P_zone_TK PhysicalText_TK

#___________________________________________________________________________________________________________________________________________
method Text_PM_P_zone_TK constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id TextDisplay_CUI_area_TK
 eval "$objName configure $args"
 return $objName
}
#___________________________________________________________________________________________________________________________________________
method Text_PM_P_zone_TK dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Text_PM_P_zone_TK $L_methodes_set_Text {}          {}
Methodes_get_LC Text_PM_P_zone_TK $L_methodes_get_Text {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method Text_PM_P_zone_TK get_or_create_prims {root} {
 set this(lab) "$root.tk_${objName}_zone_text"
 if {[winfo exists $this(lab)]} {} else {
   text $this(lab) -height 4 -width 40 -state disabled
   this Add_MetaData PRIM_STYLE_CLASS [list $this(lab) "PARAM RESULT OUT text TEXT"]
  }
 this set_root_for_daughters $root
 this set_text [this get_text]

 return [this set_prim_handle $this(lab)]
}

#___________________________________________________________________________________________________________________________________________
method Text_PM_P_zone_TK set_text {t} {
 if {[winfo exists $this(lab)]} {
   $this(lab) configure -state normal
     $this(lab) delete 0.0 end
     $this(lab) insert 0.0 $t
   $this(lab) configure -state disabled
  }
}

