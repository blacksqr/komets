#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Specifyer_PM_P_text_TK PM_TK

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_text_TK constructor {name descr args} {
 set this(tk_text)      ""
 set this(is_being_set) 0
 this inherited $name $descr

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_text_TK dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_text_TK get_or_create_prims {root} {
 set this(tk_text) "$root.tk_${objName}_text"
 if {[winfo exists $this(tk_text)]} {} else {
   text $this(tk_text) -height 10 -width 40
  }
 this set_root_for_daughters $root
 this set_text [[this get_Common_FC] get_text]
 bind $this(tk_text) <KeyRelease> "$objName set_is_being_set 1;\n\
                                   \[$objName get_LC\] set_text \[$objName get_text\]\n\
                                   $objName set_is_being_set 0"

 return [this set_prim_handle $this(tk_text)]
}

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_text_TK get_is_being_set { } {return $this(is_being_set)}
method Specifyer_PM_P_text_TK set_is_being_set {v} {set this(is_being_set) $v}

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_text_TK set_text {{t {}}} {
 if {[this get_is_being_set]} {return}
 if {[winfo exists $this(tk_text)]} {
   $this(tk_text) delete 0.0 end
   $this(tk_text) insert 0.0 $t
  }
}

#___________________________________________________________________________________________________________________________________________
method Specifyer_PM_P_text_TK get_text {} {
 if {[winfo exists $this(tk_text)]} {
   set txt [$this(tk_text) get 0.0 end]
   return [string range $txt 0 end-1]
  }
 return [eval [this get_Common_FC] get_text]
}

