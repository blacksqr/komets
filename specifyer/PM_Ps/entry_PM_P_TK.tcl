#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Specifyer_PM_P_entry_TK PM_TK

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_entry_TK constructor {name descr args} {
    global ${objName}_var_txt
    set this(tk_entry) ""
    set this(var_name) "${objName}_var_txt"
    this inherited $name $descr
    set this(show) 1

 eval "$objName configure $args"   
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters Specifyer_PM_P_entry_TK [P_L_methodes_set_specifyer_COMET_RE]

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_entry_TK dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_entry_TK get_or_create_prims {root} {
 set this(tk_entry) "$root.tk_${objName}_entry"
 if {[winfo exists $this(tk_entry)]} {} else {
   entry $this(tk_entry) -textvariable $this(var_name)
  }
 this set_root_for_daughters $root
 this set_text [[this get_Common_FC] get_text]
 $this(tk_entry) configure -validate key -validatecommand "after 5 \"$objName prim_set_text \\\[$objName get_text\\\]\"; return 1"
 
 this Show $this(show)
 
 return [this set_prim_handle $this(tk_entry)]
}

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_entry_TK set_text {{t {}}} {
 global $this(var_name)
 if {[winfo exists $this(tk_entry)]} {
   set $this(var_name) $t
  }
}

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_entry_TK get_text {} {
 if {[winfo exists $this(tk_entry)]} {
   return [$this(tk_entry) get]
  }
 return [eval [this get_Common_FC] get_text]
}

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_entry_TK Show {v} {
 set this(show) $v
 set cmd {}
 if {$v==0 && [winfo exists $this(tk_entry)]} {
   set cmd -
  }
 $this(tk_entry) configure -show $cmd
}

