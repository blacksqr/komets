#___________________________________________ Définition of Logical Model of présentation ___________________________________________________
inherit LogicalImage Logical_presentation

method LogicalImage constructor {name descr args} {
 this inherited $name $descr

 this Add_PM_factories [Generate_factories_for_PM_type [list {Image_PM_P_TK Ptf_TK} 	   \
															 {Image_PM_P_BIGre Ptf_BIGre}  \
                                                             {Image_PM_P_HTML Ptf_HTML}    \
															 {Image_PM_P_FLEX Ptf_FLEX}	   \
                                                       ] $objName]

 eval "$objName configure $args"
 return $objName
}


#___________________________________________________________________________________________________________________________________________
Methodes_set_LC LogicalImage [P_L_methodes_set_Image] {} 		  {$this(L_actives_PM)}
Methodes_get_LC LogicalImage [P_L_methodes_get_Image] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method LogicalImage set_PM_active {PM} {
 set rep [this inherited $PM]
 if {[this get_LC] != ""} {
   set f [this get_img_file_name]
   if {$f != ""} {puts "$PM load_img $f"; $PM load_img $f}
  }
  
 return $rep
}

Trace LogicalImage set_PM_active