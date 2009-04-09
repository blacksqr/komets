#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Container_PM_P_BIGre_Scrollable PM_BIGre

source [get_B207_files_root]B_ScrollList.tcl

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_BIGre_Scrollable constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Container_FUI_Scrollable_B207
   
 set this(scroll_list) ${objName}_B207_scroll_list
 B_ScrollList $this(scroll_list)
 
 this set_prim_handle        [$this(scroll_list) get_root]
 this set_root_for_daughters [$this(scroll_list) get_inner_root]

# $this(rap_placement) Texte "$objName Line_h"
#   $n abonner_a_LR_parcours [$n LR_Av_pre_rendu] [$this(rap_placement) Rappel]

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors Container_PM_P_BIGre_Scrollable [list poly_background]

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_BIGre_Scrollable Add_daughter    {m {index -1}} {
 set rep [this inherited $m $index]
   if {$rep} {$this(scroll_list) Layout_elements}
   #puts "______ $rep"
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_BIGre_Scrollable Sub_daughter    {m} {
 set rep [this inherited $m]
   $this(scroll_list) Layout_elements
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_BIGre_Scrollable Resize {X Y {sb_X 32}} {
 $this(scroll_list) Resize $X $Y $sb_X
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_BIGre_Scrollable get_poly_panel {} {return [$this(scroll_list) get_panel]}