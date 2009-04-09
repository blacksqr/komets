inherit PM_P_XAML_discret_choice PM_PM_XAML
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method PM_P_XAML_discret_choice constructor {name descr args} {
 this inherited $name $descr

 eval "$objName configure $args"
}
#___________________________________________________________________________________________________________________________________________
method PM_P_XAML_discret_choice Render {txt_name {dec {}}} {
 upvar $txt_name txt
 set LC [this get_LC]
 append txt $dec {<ComboBox  Name="ComboBox} [$LC get_name] {">} "\n"
   this inherited txt $dec
 append txt $dec {</ComboBox>} "\n"
}

