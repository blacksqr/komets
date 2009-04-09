inherit CometComposer Logical_consistency


#___________________________________________________________________________________________________________________________________________
method CometComposer constructor {name descr args} {
 this inherited $name $descr
 
 set this(adding_New_composing_PM_plugged) 0
 
 set this(C_composition)  ""
 set this(L_compo_comets) ""
   
 set CFC "${objName}_CFC"; CommonFC_CometComposer_LC $CFC
   this set_Common_FC $CFC

 set this(LM_LP) "${objName}_LM_LP";
   CometComposer_LM_P  $this(LM_LP) $this(LM_LP) "The logical presentation of $name"
   this Add_LM $this(LM_LP);

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometComposer dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
Generate_accessors CometComposer [list C_composition L_compo_comets]

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometComposer [L_methodes_set_CommonFC_CometComposer_LC] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometComposer [L_methodes_get_CommonFC_CometComposer_LC] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method CometComposer Recompose {composition L_Comets links ID_prefixe {destroy_L_comets 0}} {
 puts "$objName Recompose $composition {$L_Comets}"
 this set_handle_composing_comet "" ""
 if { $this(C_composition) != "" } {$this(C_composition) dispose; set this(C_composition) ""}
 if {$destroy_L_comets} {
   foreach C $this(L_compo_comets) {$C dispose}
  }
 set this(L_compo_comets) ""
 
 set this(C_composition) [CPool get_a_comet $composition]
 this set_handle_composing_comet $this(C_composition) ""
 $this(C_composition) Add_daughters_R $L_Comets
 set this(L_compo_comets) $L_Comets

# Subscribe to the creation of new PM
 foreach C $L_Comets {
   puts "  ${C}_LM_LP Subscribe_to_set_PM_active $objName {$objName New_PM_active_for $C \$PM}"
   ${C}_LM_LP Subscribe_to_set_PM_active $objName "$objName New_PM_active_for $C \$PM"
  }
  
 $this(LM_LP) Add_daughters $this(C_composition)_LM_LP 0
 $this(LM_LP) Connect_PM_descendants
 
# Establish links
 set L_links [split $links "\;"]
 foreach link $L_links {
  # Lien sous la forme : F COMET1.Concept1 COMET2.Concept2
   set L_CC   [split  $link "="]
   set arg1   [lindex $L_CC 0]; set L [split $arg1 "."]; set C1 ${ID_prefixe}_[lindex [lindex $L 0] 0]; set Concept1 [lindex [lindex $L 1] 0]
   set arg2   [lindex $L_CC 1]; set L [split $arg2 "."]; set C2 ${ID_prefixe}_[lindex [lindex $L 0] 0]; set Concept2 [lindex [lindex $L 1] 0]
   $C1 Subscribe_to_set_$Concept1 $objName "$objName Propagate_change_from_to \$[lindex [gmlObject info args [lindex [gmlObject info classes $C1] 0] set_$Concept1] 0] $C1 $Concept1 $C2 $Concept2" UNIQUE
   $C2 Subscribe_to_set_$Concept2 $objName "$objName Propagate_change_from_to \$[lindex [gmlObject info args [lindex [gmlObject info classes $C2] 0] set_$Concept2] 0] $C2 $Concept2 $C1 $Concept1" UNIQUE
  }
}

#___________________________________________________________________________________________________________________________________________
method CometComposer Propagate_change_from_to {v Comet1 Concept1 Comet2 Concept2} {
 set propagate 1
 if {[$Comet2 Has_MetaData ${objName}_$Concept1]} {
   if {[$Comet2 Val_MetaData ${objName}_$Concept1] == $v} {
     set propagate 0
    }
  }

 if {$propagate} {
   $Comet2 Add_MetaData  ${objName}_$Concept1 $v
   $Comet2 set_$Concept2 $v
  }
}

#___________________________________________________________________________________________________________________________________________
method CometComposer set_redundancy {v} {
 # If yes, display everything
 # If no then undisplay everything and call set_spaces
 set L_PM [CSS++ cr "#${objName}->PMs *"]
 if {$v} {
   foreach PM $L_PM {
     $PM Hide_Elements
    }
  } else {foreach PM $L_PM {
            $PM Hide_Elements *
		   }
          this set_spaces [this get_spaces]
         }
 
# Classical call
 [this get_Common_FC] set_redundancy $v
 foreach LM $this(L_LM) {$LM set_redundancy $v}
}

#___________________________________________________________________________________________________________________________________________
method CometComposer set_spaces {str} {
 set L_spaces [split $str ";"]
 foreach space L_spaces {
   set root    [lindex $space 0]
   set L_marks [lrange $space 2 end]
   foreach PM [CSS++ cr "#${objName}->PMs <--< \\$root/   ($L_marks)"] {
     $PM Hide_Elements
    }
  }
  
# Classical call
 [this get_Common_FC] set_spaces $str
 foreach LM $this(L_LM) {$LM set_spaces $str}
}

#___________________________________________________________________________________________________________________________________________
method CometComposer New_PM_active_for {C PM} {
 #puts "****** $objName New_PM_active_for $C $PM"
 $PM Subscribe_to_Add_prim_mother $objName "$objName New_composing_PM_plugged $C $PM" UNIQUE
}

#___________________________________________________________________________________________________________________________________________
method CometComposer New_composing_PM_plugged {C PM} {
 if {$this(adding_New_composing_PM_plugged)} {return}
 set this(adding_New_composing_PM_plugged) 1

 if {[this get_redundancy]} {
   #$PM Hide_Elements
   return
  }

 #puts "$objName : Talking about $PM"
 #$PM Hide_Elements *
 set L_spaces [split [this get_spaces] ";"]
 foreach space $L_spaces {
   set root    [lindex $space 0]
   set L_marks [lrange $space 2 end]
   #puts "--space : $space\n  root $root should display {$L_marks}"
   if {[lsearch $L_marks [$C Val_MetaData id]] != -1} {
     if {[CSS++ cr "#$PM <--< $root"] != ""} {
	   #puts "  $PM Hide_Elements"
	   #$PM Hide_Elements 
	  }
    }
  }
  
 set this(adding_New_composing_PM_plugged) 0
}
