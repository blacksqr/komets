

#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Interleaving_PM_P_HTML_menu PM_HTML
#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_menu constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Interleaving_CUI_Menu_FUI_HTML
   
   set this(L_menu) [list]
   set this(internal_menu_id) ${objName}_internal_menu
   set this(pipo_C_container) [CPool get_a_comet CometContainer]
     $this(pipo_C_container)_LM_LP set_PM_active [CPool get_a_comet Container_PM_P_HTML]
   set this(L_pipo_cont_for_menu) [list]
   set this(L_pool_cont_for_menu) [list]
   
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors Interleaving_PM_P_HTML_menu [list pipo_C_container]

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_menu Render {strm_name {dec {}}} {
 upvar $strm_name strm
 
 append strm $dec {<link type="text/css" href="./Comets/interleaving/PM_Ps/HTML/multi-ddm/styles1.css"/>} "\n"
 append strm $dec "<script language=\"JavaScript\" type=\"text/javascript\" src=\"./Comets/interleaving/PM_Ps/HTML/multi-ddm/jquery.multi-ddm.pack.js\"></script>\n"
 
 append strm $dec <div [this Style_class] {> } "\n"
   set L_daughters_not_in_menu [this get_out_daughters]
   # Generate menu
   append strm $dec "  <div id=\"$this(internal_menu_id)\">\n"
     Sub_list L_daughters_not_in_menu [this Render_menu 1 this(L_menu) strm "$dec    "]
   append strm $dec "  </div>\n"
   append strm $dec "  <p>_</p>\n"
   append strm $dec "<div>    </div>\n"
   # For each daughter not present in the menu, plug it
   foreach d $L_daughters_not_in_menu {
     $d Render_all strm "$dec  "
    }
   
 append strm "$dec</div>\n"
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_menu Render_post_JS {strm_name {dec {}}} {
 upvar $strm_name strm
 
 append strm $dec "\$('#$this(internal_menu_id)').dropDownMenu({parentMO: 'parent-hover', childMO: 'child-hover1'});\n"
 
 this Render_daughters_post_JS strm $dec
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_menu maj_interleaved_daughters {} {}

#___________________________________________________________________________________________________________________________________________
# List of MENU : <Name, VAL, TYPE>
# where :
#   Name : Name of the entry
#    VAL : CSS_expr | list of MENU
#   TYPE : CSS | MENU
#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_menu set_L_menu_and_associated_comets {L_menu_sel} {
 set this(L_menu) $L_menu_sel
 $this(pipo_C_container) set_daughters_R ""
 foreach C $this(L_pipo_cont_for_menu) {this Release_a_pipo_container $C}
 this create_pipo_hierarchy $this(pipo_C_container) 1 this(L_menu)
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_menu create_pipo_hierarchy {C index L_menu_name} {
 upvar $L_menu_name L_menu
 set sub_index 0
 
   foreach M $this(L_menu) {
       incr sub_index
       switch [lindex $M 2] {
	      CSS {set css_expr [lindex $M 1]
		       foreach PM [CSS++ $objName "#$objName $css_expr"] {
			     set LC [$PM get_LC]
				 $C Add_daughter_R $LC
				 set new_PM [CSS++ $objName "#$this(pipo_C_container)->PMs.PM_HTML $C $LC"]
				 if {[string equal $new_PM ""]} {set new_PM [CSS++ $objName "#$this(pipo_C_container)->PMs.PM_HTML $LC"]}
				 #puts "  new_PM : $new_PM"
				 if {![string equal $new_PM ""]} {$new_PM set_style_class index_${index}_$sub_index}
			    }
		      }
	     MENU {set L_sub_menus [lindex $M 1]
		       set sub_C [this get_a_pipo_container -set_style_class index_$index]
			   this create_pipo_hierarchy $sub_C "${index}_$sub_index" L_sub_menus
	          }
	    }
    }

}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_menu Render_menu {index L_M_name strm_name dec} {
 upvar $L_M_name  L_M
 upvar $strm_name strm
 set sub_index 0
   set L_PM_in_menu [list]
   
   foreach M $this(L_menu) {
     incr sub_index
       switch [lindex $M 2] {
	      CSS {puts "CSS++ cr \"#$this(pipo_C_container)->PMs.PM_HTML index_${index}_$sub_index\""
		       append strm $dec "  <li>\n"
			   append strm $dec "    <a>[lindex $M 0]</a>\n"
			   append strm $dec "    <ul>\n"
			   foreach PM [CSS++ $objName "#$this(pipo_C_container)->PMs.PM_HTML index_${index}_$sub_index"] {
			     Add_list L_PM_in_menu [CSS++ $PM "#$PM->PMs"]
				 append strm $dec "      <li><div class=\"menu\">\n"
				   $PM Render_all strm "$dec        "
				   #append strm $dec index_${index}_$sub_index
				 append strm $dec "      </div></li>\n"
			    }
			   append strm $dec "    </ul>\n"
			   append strm $dec "  </li>\n"
		      }
	     MENU {append strm $dec {  <a>} [lindex $M 0] "</a>\n"
		       set L_sub_menus [lindex $M 1]
			   Add_list L_PM_in_menu [this Render_menu "${index}_$sub_index" L_sub_menus strm "$dec  "]
	          }
	    }
    }
	
 return $L_PM_in_menu
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_menu get_a_pipo_container {} {
 if {[llength $this(L_pool_cont_for_menu)]} {
   set C [lindex $this(L_pool_cont_for_menu) 0]
  } else {set C [CPool get_a_comet CometContainer]
         }
 Sub_list this(L_pool_cont_for_menu) $C
 Add_list this(L_pipo_cont_for_menu) $C
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_HTML_menu Release_a_pipo_container {C} {
 $C set_daughters_R ""
 $C set_mothers_R   ""

 Add_list this(L_pool_cont_for_menu) $C
 Sub_list this(L_pipo_cont_for_menu) $C
}


