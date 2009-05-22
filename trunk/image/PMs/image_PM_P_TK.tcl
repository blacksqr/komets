package require Img

#___________________________________________________________________________________________________________________________________________
inherit Image_PM_P_TK PM_TK
#___________________________________________________________________________________________________________________________________________
method Image_PM_P_TK constructor {name descr args} {
 set this(var_name) "${objName}_var_rb"
 this inherited $name $descr
   this set_GDD_id CT_Image_AUI_CUI_basic_TK
   set this(img_tk_name) ""
   image create photo $this(img_tk_name)
 eval "$objName configure $args"
}

#___________________________________________________________________________________________________________________________________________
method Image_PM_P_TK get_img_ressource {} {return $this(img_tk_name)}
#___________________________________________________________________________________________________________________________________________
method Image_PM_P_TK get_or_create_prims {root} {
# Define the handle
 set img $root.tk_${objName}_img
 if {[winfo exists $img]} {
  } else {label $img
          this set_prim_handle $img
          if {[string length $this(img_tk_name)] == 0} {
            set this(img_tk_name) "[this get_LM]_TK_img_ressource"
            set f [this get_img_file_name]
            if {$f != ""} {
              image create photo $this(img_tk_name)
             }
			this load_img $f
           }
          $img configure -image $this(img_tk_name)
		  this Add_MetaData PRIM_STYLE_CLASS [list $img "PARAM RESULT OUT image IMAGE"]
         }

 this set_root_for_daughters $root

 return [this set_prim_handle $img]
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Image_PM_P_TK [P_L_methodes_set_Image] {} {}
Methodes_get_LC Image_PM_P_TK [P_L_methodes_get_Image] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method Image_PM_P_TK load_img {f} {
 if {[winfo exists [this get_prim_handle]]} {
   [this get_Common_FC] load_img $f
   set this(img_tk_name) "[this get_LM]_TK_img_ressource"
   if {[catch "image create photo $this(img_tk_name) -file {$f}" res]} {
     puts "Error while loading image in $objName :\n    $res"
    }
  }   
}

