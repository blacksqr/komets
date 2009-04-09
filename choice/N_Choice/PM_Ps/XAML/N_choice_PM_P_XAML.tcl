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
 append txt $dec {<Slider Name="Slider_} [$LC get_name] {" Maximum="} [this get_b_sup] {" Minimum="} [this get_b_inf] {" />} "\n"
   append txt [this get_text]
   this inherited txt $dec
}

#_______________________________________________________ Adding the choices functions _______________________________________________
Methodes_set_LC PM_P_XAML_discret_choice $L_methodes_set_choicesN {$this(FC)} {}
Methodes_get_LC PM_P_XAML_discret_choice $L_methodes_get_choicesN {$this(FC)}

