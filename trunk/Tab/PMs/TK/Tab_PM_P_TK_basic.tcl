package require Tktable
inherit Tab_PM_P_TK_basic PM_TK

#___________________________________________________________________________________________________________________________________________
method Tab_PM_P_TK_basic constructor {name descr args} {
 this inherited $name $descr

# Control with a tktable
 set this(tk_table_var) "${objName}_tk_table_var"

# Call of the extra constructor parameters
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method Tab_PM_P_TK_basic get_or_create_prims {root} {
 global $this(tk_table_var)
 set this(root_frame) "$root._${objName}_root"
 set this(tk_table)   "$this(root_frame).tk_table"
 set this(op_frame)   "$this(root_frame).ops"
 set this(op)         "$this(op_frame).op"
 set this(linecol)    "$this(op_frame).linecol"
 set this(num)        "$this(op_frame).num"
 set this(apply)      "$this(op_frame).bt_apply"
   if {![winfo exists $this(tk_table)]} {
     frame $this(root_frame)
	   frame $this(op_frame)
	     pack $this(op_frame) -side top 
		 set this(op_var) ${objName}_op_var; global $this(op_var) 
		   tk_optionMenu $this(op) $this(op_var) Insert Delete;      ; pack $this(op) -expand 1 -side left
		 set this(linecol_var) ${objName}_linecol_var; global $this(linecol_var)
		   tk_optionMenu $this(linecol) $this(linecol_var) line col  ; pack $this(linecol) -expand 1 -side left
		 set this(num_var) ${objName}_num_var; global $this(num_var)
		   tk_optionMenu $this(num) $this(num_var) 0                 ; pack $this(num)   -expand 1 -side left
		 button $this(apply) -text Apply -command "$objName Apply_op"; pack $this(apply) -expand 1 -side left
	   table $this(tk_table)
	     pack $this(tk_table) -side top -expand 1 -fill both
    }
 $this(tk_table) configure -variable $this(tk_table_var)
 this set_prim_handle [list $this(root_frame)]
}

#____________________________________________________________________________________________________________________________________________
method Tab_PM_P_TK_basic Apply_op {} {
 global $this(num_var)    ; set num_var     [subst $$this(num_var)]
 global $this(linecol_var); set linecol_var [subst $$this(linecol_var)]
 global $this(op_var)     ; set op_var      [subst $$this(op_var)]
 set cmd "$objName prim_${op_var}_${linecol_var} $num_var"
 puts $cmd
 eval $cmd
}

#____________________________________________________________________________________________________________________________________________
Methodes_set_LC Tab_PM_P_TK_basic [P_L_methodes_set_Tab] {$this(FC)} {}
Methodes_get_LC Tab_PM_P_TK_basic [P_L_methodes_get_Tab] {$this(FC)}
Generate_PM_setters Tab_PM_P_TK_basic [P_L_methodes_set_Tab_CARE]

#___________________________________________________________________________________________________________________________________________
method Tab_PM_P_TK_basic Maj_tab {} {
 global $this(tk_table_var)
 global $this(num_var)
 set L [this get_nb_L]; set C [this get_nb_C]
 for {set i 0} {$i<$L} {incr i} {
   for {set j 0} {$j<$C} {incr j} {
     trace remove variable $this(tk_table_var)($i,$j) write "$objName maj_internal_var $i $j "
	 set $this(tk_table_var)($i,$j) [this get_case $i $j]
	 trace add    variable $this(tk_table_var)($i,$j) write "$objName maj_internal_var $i $j "
	}
  }
# Update the numbers
 set nb_C [this get_nb_C]
 set nb_L [this get_nb_L]
 set nb_max [expr $nb_C>$nb_L?$nb_C:$nb_L]
 $this(num).menu delete 0 last
 set type radiobutton
 for {set i 0} {$i<$nb_max} {incr i} {
   $this(num).menu add $type -label $i -command "set $this(num_var) $i"
  }
}

#___________________________________________________________________________________________________________________________________________
method Tab_PM_P_TK_basic maj_internal_var {i j T indice op} {
 global $this(tk_table_var)
#puts "$objName maj_internal_var $i $j $T $indice $op"
 set v [subst $${T}($indice)]
 if {![string equal [this get_case $i $j] $v]} {
   this prim_set_case $i $j $v
  }
}

#___________________________________________________________________________________________________________________________________________
method Tab_PM_P_TK_basic set_dims {L C} {
 global $this(tk_table_var)
 $this(tk_table) configure -rows $L -cols $C
 this Maj_tab
}

#___________________________________________________________________________________________________________________________________________
method Tab_PM_P_TK_basic Init_col {j} {
 global $this(tk_table_var)
 for {set i 0} {$i<[this get_nb_L]} {incr i} {
   set $this(tk_table_var)($i,$j) {}
  }
}

#___________________________________________________________________________________________________________________________________________
method Tab_PM_P_TK_basic Insert_col {pos} {
 this set_dims [this get_nb_L] [this get_nb_C]
 this Maj_tab
}

#___________________________________________________________________________________________________________________________________________
method Tab_PM_P_TK_basic set_case {i j v} {
 global $this(tk_table_var)
 set $this(tk_table_var)($i,$j) $v
}

#___________________________________________________________________________________________________________________________________________
method Tab_PM_P_TK_basic Delete_col {pos} {
 this set_dims [this get_nb_L] [this get_nb_C]
 this Maj_tab
}

#___________________________________________________________________________________________________________________________________________
method Tab_PM_P_TK_basic Insert_line {pos} {
 this set_dims [this get_nb_L] [this get_nb_C]
 this Maj_tab
}

#___________________________________________________________________________________________________________________________________________
method Tab_PM_P_TK_basic Delete_line {pos} {
 this set_dims [this get_nb_L] [this get_nb_C]
 this Maj_tab
}

#___________________________________________________________________________________________________________________________________________
method Tab_PM_P_TK_basic Add_MetaData {i j var val} {
}

#___________________________________________________________________________________________________________________________________________
method Tab_PM_P_TK_basic Sub_MetaData {i j var} {

}

#___________________________________________________________________________________________________________________________________________
method Tab_PM_P_TK_basic Init_MetaData {i j} {

}

#___________________________________________________________________________________________________________________________________________
method Tab_PM_P_TK_basic set_MetaDatas {i j L} {

}

