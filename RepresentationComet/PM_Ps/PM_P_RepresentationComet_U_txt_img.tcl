#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit PM_P_RepresentationComet_U_txt_img PM_U_Container

#___________________________________________________________________________________________________________________________________________
method PM_P_RepresentationComet_U_txt_img constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id PM_P_RepresentationComet_U_txt_img
   this set_nb_max_mothers 1
   set this(garde_set_RepresentedComet) 0
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method PM_P_RepresentationComet_U_txt_img dispose {} {
 this inherited
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC PM_P_RepresentationComet_U_txt_img [P_L_methodes_set_RepresentationComet] {} {}
Methodes_get_LC PM_P_RepresentationComet_U_txt_img [P_L_methodes_get_RepresentationComet] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method PM_P_RepresentationComet_U_txt_img set_LM {LM} {
 if {[string equal [this get_LM] {}]} {
   this inherited $LM
   set name_txt ${LM}_PM_P_RepresentationComet_U_txt
   set name_img ${LM}_PM_P_RepresentationComet_U_img
   if {![gmlObject info exists object $name_txt]} {
     CometText $name_txt "Textual representation of a COMET" ""
    }
   if {![gmlObject info exists object $name_img]} {
     CometImage $name_img "Image representation of a COMET" ""
    }
   set L [list ${name_txt}_LM_LP ${name_img}_LM_LP]
   this set_L_nested_handle_LM $L
  } else {this inherited $LM}
}

#___________________________________________________________________________________________________________________________________________
method PM_P_RepresentationComet_U_txt_img set_RepresentedComet {c} {
 if {$this(garde_set_RepresentedComet)} {return}
 set this(garde_set_RepresentedComet) 1
 
# puts "$objName set_RepresentedComet $c"
 set img_path [Comet_files_root]Comets/RepresentationComet/PM_Ps/Icones/${c}.png
   set name_txt [this get_LM]_PM_P_RepresentationComet_U_txt
   set name_img [this get_LM]_PM_P_RepresentationComet_U_img
 if {![gmlObject info exists object $name_txt]} {puts "$name_txt do not exists!!!"; return}
 if {[file exists $img_path]} {
  # There is an image...
   $name_img load_img $img_path
   this set_L_nested_handle_LM ${name_img}_LM_LP
  } else {$name_txt set_text $c
          this set_L_nested_handle_LM ${name_txt}_LM_LP
         }
 this Update
 
 set this(garde_set_RepresentedComet) 0
}
