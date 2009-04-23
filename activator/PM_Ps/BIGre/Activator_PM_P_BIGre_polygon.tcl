#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Activator_PM_P_BIGre_polygon PM_BIGre

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_BIGre_polygon constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id FUI_Activator_PM_P_BIGre_polygon
   set this(root) [B_noeud]
     this set_prim_handle $this(root)
   set this(polygon) [B_polygone]
   set contour [ProcOvale 0 0 16 16 60]
     $this(polygon) Ajouter_contour $contour
   Detruire $contour

   $this(root) Ajouter_fils $this(polygon)
   Update_boites_rec $this(root)
   
   this Add_MetaData PRIM_STYLE_CLASS [concat [this Val_MetaData PRIM_STYLE_CLASS] [list $this(polygon) "DECORATION POLYGON BACKGROUND"]]
   
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_BIGre_polygon dispose {} {
 this inherited
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors Activator_PM_P_BIGre_polygon [list polygon]

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Activator_PM_P_BIGre_polygon $L_methodes_set_Activator {} {}
Methodes_get_LC Activator_PM_P_BIGre_polygon $L_methodes_get_Activator {$this(FC)}
Generate_PM_setters Activator_PM_P_BIGre_polygon [list {activate {{type {}}}}]
  Manage_CallbackList Activator_PM_P_BIGre_polygon prim_activate begin

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_BIGre_polygon Color {args} {
 eval "$this(polygon) Couleur [join $args]"
}

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_BIGre_polygon Shape {L_pt} {
 $this(polygon) Vider
 set cmd_add_sub {Ajouter_contour}
 set cmd_contour {ProcTabDouble}
 set cmd "if {\$L != \"\"} {if {\[catch \"set contour \\\[eval \\\"\$cmd_contour \$L\\\"\\\]\"\]} {set contour \[eval \"\$cmd_contour {\$L}\"\]}; $this(polygon) \$cmd_add_sub \$contour; Detruire \$contour; set L {}}"
 set L   {}
 foreach pt $L_pt {
   switch $pt {
     poly  {eval $cmd; set cmd_contour ProcTabDouble}
	 oval  {eval $cmd; set cmd_contour ProcOvale}
	 rect  {eval $cmd; set cmd_contour ProcRect}
	 minus {eval $cmd; set cmd_add_sub Retirer_contour}
	 plus  {eval $cmd; set cmd_add_sub Ajouter_contour}
	 default {lappend L $pt}
    }
  }
 #puts $cmd
 eval $cmd
 
# set contour [ProcTabDouble $L_pt]
#   $this(polygon) Vider
#   $this(polygon) Ajouter_contour $contour
# Detruire $contour
}

#___________________________________________________________________________________________________________________________________________
method Activator_PM_P_BIGre_polygon Trigger_prim_activate {} {
 set cmd ""
 foreach {var val} [this get_Params] {append cmd " " $var " $val"}
 this prim_activate $cmd
}

#___________________________________________________________________________________________________________________________________________
Manage_CallbackList Activator_PM_P_BIGre_polygon Trigger_prim_activate begin
