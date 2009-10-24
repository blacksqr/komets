#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
inherit Sequence_PM_P_U PM_U_Container
#_________________________________________________________________________________________________________________________________
method Sequence_PM_P_U constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id GDD_Sequence_PM_P_U

   this set_default_op_gdd_file    [Comet_files_root]Comets/CSS_STYLESHEETS/GDD/Common_GDD_requests.css++
   this set_default_css_style_file [Comet_files_root]Comets/CSS_STYLESHEETS/Sequence/Sequence_U.css++


 eval "$objName configure $args"
 return $objName
}

#__________________________________________________
Methodes_set_LC Sequence_PM_P_U [L_methodes_set_sequence] {} {}
Methodes_get_LC Sequence_PM_P_U [L_methodes_get_sequence] {$this(FC)}

#_________________________________________________________________________________________________________________________________
Generate_PM_setters Sequence_PM_P_U [L_methodes_set_sequence]

#___________________________________________________________________________________________________________________________________________
method Sequence_PM_P_U Previous {} {puts "testprev"; this Display_current_step}
method Sequence_PM_P_U Next     {} {puts "testnext"; this Display_current_step}

#_________________________________________________________________________________________________________________________________
method Sequence_PM_P_U Display_current_step {} {
     set LC [this get_real_LC]
	 set C_current [lindex [$LC get_out_daughters] [this get_step]]
	 $this(commande_text) set_text "Step [expr [this get_step]+1]/[llength [$LC get_out_daughters]]"

	 foreach PM_not_current [CSS++ $objName "#$LC > !$C_current->PMs \\<--<  > $this(sequence_content)/"] {
	   #puts "  hiding $PM_not_current ([[$PM_not_current get_LC] get_name])"
	   $PM_not_current Show_elements 0 *
	  }

	 foreach PM_not_current [CSS++ $objName "#$LC > $C_current->PMs \\<--<  > $this(sequence_content)/"] {
	   #puts "  showing $PM_not_current"
	   $PM_not_current Show_elements 1 *
	  }
}

#_________________________________________________________________________________________________________________________________
method Sequence_PM_P_U set_LM {LM} {
 set rep [this inherited $LM]
 
   set this(top_container)       [CPool get_a_comet CometContainer -Add_style_class "TOP"]
     set this(sequence_content)  [CPool get_a_comet CometContainer -Add_style_class "CONTENT"]
     set this(sequence_commande) [CPool get_a_comet CometContainer -Add_style_class "COMMANDE"]
	   set this(commande_prev)   [CPool get_a_comet CometActivator -Add_style_class "PREVIOUS" -set_text "PREVIOUS"]
	   set this(commande_text)   [CPool get_a_comet CometText -Add_style_class "STEPTEXT"]
       set this(commande_next)   [CPool get_a_comet CometActivator -Add_style_class "NEXT" -set_text "NEXT"]
	   $this(commande_prev) Subscribe_to_activate $objName "$objName prim_Previous " UNIQUE
	   $this(commande_next) Subscribe_to_activate $objName "$objName prim_Next" UNIQUE
	   $this(sequence_commande) Add_daughters_R [list $this(commande_prev) $this(commande_text) $this(commande_next)]
	 $this(top_container) Add_daughters_R [list $this(sequence_content) $this(sequence_commande)]

   this set_L_nested_handle_LM    $this(top_container)_LM_LP
   this set_L_nested_daughters_LM $this(sequence_content)_LM_LP

 return $rep
}

#_________________________________________________________________________________________________________________________________
method Sequence_PM_P_U Add_daughter {PM {index -1}} {
 # Is it necessary to add a container for PM?

 set rep [this inherited $PM $index]
   if {$rep > 0 && [$PM get_real_LC] != $this(top_container)} {
     if {[catch "$objName Display_current_step" err]} {puts "Error in $objName Display_current_step\n  -err : $err"}
	} 

 return $rep		   
}