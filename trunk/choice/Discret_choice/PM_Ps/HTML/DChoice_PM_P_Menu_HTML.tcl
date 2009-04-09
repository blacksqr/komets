inherit DChoice_PM_P_Menu_HTML PM_Choice_HTML
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method DChoice_PM_P_Menu_HTML constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Choice_DropDown_HTML
   this set_nb_max_daughters 0
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method DChoice_PM_P_Menu_HTML maj_choices {} {}

#___________________________________________________________________________________________________________________________________________
method DChoice_PM_P_Menu_HTML Render {strm_name {dec {}}} {
 upvar $strm_name rep
 append rep $dec "<select [this Style_class] "
   if {[this get_nb_max_choices] > 1} {append rep {multiple="multiple" }}
   append rep {name="} ${objName}__XXX__prim_set_currents {">} "\n"
   this Render_daughters rep "$dec  "
 append rep $dec {</select>} "\n"
}

#___________________________________________________________________________________________________________________________________________
method DChoice_PM_P_Menu_HTML Render_daughters {strm_name {dec {}}} {
 upvar $strm_name rep

 set LC [this get_LC]
 foreach c [$LC get_daughters] {
   append rep $dec {<option  value="} $c {"}
     if {[lsearch [this get_currents] $c] != -1} {append rep  { selected="selected" }}
   append rep {>} [$c get_name]
  append rep { </option>} "\n"
  }
}

#___________________________________________________________________________________________________________________________________________
method DChoice_PM_P_interleaving_markers_HTML prim_set_currents {c} {
 if {[string equal [this get_currents] $c]} {return}
 [this get_LC] set_currents $c
}
