#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit ChoiceN_PM_P_menu_HTML PM_P_ChoiceN_HTML
#___________________________________________________________________________________________________________________________________________
method ChoiceN_PM_P_menu_HTML constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id N_Choice_AUI_basic_CUI_menu_HTML
 eval "$objName configure $args"
}
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC ChoiceN_PM_P_menu_HTML $L_methodes_set_choicesN {}         {}
Methodes_get_LC ChoiceN_PM_P_menu_HTML $L_methodes_get_choicesN {$this(FC)}
#___________________________________________________________________________________________________________________________________________
method ChoiceN_PM_P_menu_HTML Render {strm_name {dec {}}} {
 upvar $strm_name rep
  set CFC [this get_Common_FC]
 append rep $dec <select [this Style_class] {name="} ${objName}__XXX__prim_set_val {" value="} [this get_val] {">} "\n"
	  for {set i [$CFC get_b_inf]} {$i <= [$CFC get_b_sup]} {incr i [$CFC get_step]} {
			append rep $dec {  <option value="} $i {"}
                          if {$i == [this get_val]} {append rep { selected="selected"} }
                        append rep {>} $i { </option>} "\n"
		}
 append rep $dec {</select>} "\n"
}
#___________________________________________________________________________________________________________________________________________


