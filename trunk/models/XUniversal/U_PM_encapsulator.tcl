#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit PM_Universal_encapsulator PM_Universal

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
# Let's consider a fake LM for the core PM                                                                                                 _
# It's aim is just to facilitate branchs                                                                                                   _
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method PM_Universal_encapsulator constructor {name descr PM_core args} {
 this inherited $name $descr
   set this(L_created)    [list]
   set this(core)         $PM_core
   set this(core_tmp)     ""
   set this(core_factice_LC) "${objName}_Fake_LC_of_$PM_core"
   set this(core_factice_LM) "$this(core_factice_LC)_LM_LP"
     Logical_model       $this(core_factice_LM) "Fake LM of $PM_core" {NO MORE DESCRIPTION}
     $this(core_factice_LM) Add_PM        $PM_core
     $this(core_factice_LM) set_PM_active $PM_core
     Logical_consistency $this(core_factice_LC) "Fake LC of $PM_core" {NO MORE DESCRIPTION}
     $this(core_factice_LC) Add_LM $this(core_factice_LM)
   this Add_composing_comet        [this get_core]
   this Add_handle_comet_daughters [this get_core] 0 {}
   this Add_handle_composing_comet [this get_core] 0 {}

   [this get_cou] maj [$PM_core get_cou]

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method PM_Universal_encapsulator Add_prim_mother {c Lprims {index -1}} {
 set rep [this inherited $c $Lprims $index]
 if {$rep != 1} {return $rep}

 if {[llength $this(L_handle_composing_daughters)] > 0} {
   set L [this get_handle_composing_comet]
   if {[llength $L] == 0} {return 0}
   set handle_nested_PM [lindex $L 0]
       set rep [this Add_daughter $handle_nested_PM]
   if {$rep != 1} {puts "  $objName a pour fils : \{[$objName get_daughters]\}\n\  $handle_nested_PM a pour pères : \{[$handle_nested_PM get_mothers]\}"}
   if {[string equal [$handle_nested_PM get_LC] [this get_LC]]} {} else {
     Connection [$handle_nested_PM get_LC]
    }
  }

 return $rep
}
#___________________________________________________________________________________________________________________________________________
method PM_Universal_encapsulator Add_daughter    {m {index -1}} {
 return [this inherited $m $index]

 global debug
 if {$debug} {puts "$objName Add_daughter $m $index"}

# 2 cas, soit on a des noeuds nestés, soit on en a pas.
# Cas on a des noeuds nestés
 if {[llength $this(L_handle_composing_daughters)] > 0} {
#  Il va falloir recréer toute la hierarchie PM à partie de la hiérarchie LM, puis ajouter effectivement la fille m à l'aide de la méthode héritée
#   puts "____________ Bidouille du Conteneur Universel _________________"
#   puts "  Handle composing comets : \{[this get_handle_composing_comet]\}"
   set L [this get_handle_composing_comet]
   if {[llength $L] == 0} {return 0}
   set handle_nested_PM [lindex $L 0]
   this inherited $handle_nested_PM
   if {[string equal [$handle_nested_PM get_LC] [this get_LC]]} {} else {
     Connection [$handle_nested_PM get_LC]
    }
#  Branchement de la nouvelle fille, elle sera placé sous un des noeuds nestés.
   return [this inherited $m $index]
  } else {
# Cas pas de noeuds nestés
      set rep [this inherited $m $index]
      puts "Ajout d'une fille, méthode de base : rep = $rep"
      if {[expr $rep == 1]} {
        set root [this get_root_for_daughters]
        if {[string equal $root NULL]} {
          this Sub_daughter $m;
          if {$debug} {puts "   !!! : La racine d'attache des fils de $objName est NULL"}
          return 0
         }
        set prev_exists    [$m Do_prims_still_exist]
        set prim_daughters [$m get_or_create_prims $root]
        if {[string equal $prim_daughters NULL]} {
          this Sub_daughter $m;
          if {$debug} {puts "   !!! : La poignée de $m est NULL"}
          return 0
         }
        $this(LM) set_PM_active $objName
        if {$prev_exists} {
#          puts "LE PROBLEME VIENDRAIT IL D'ICI???";
          return 2
         } else {
             this Add_prim_daughter $m       $prim_daughters $index
             $m   Add_prim_mother   $objName $root
             return 1
            }
       }
      return $rep
     }
}

#___________________________________________________________________________________________________________________________________________
method PM_Universal_encapsulator Sub_daughter    {m} {set rep [this inherited $m]
                                           if {[expr $rep == 1]} {set pos [lsearch $this(L_mothers) $m]
                                                                  this Sub_prim_daughter $m [$m get_prim_handle $pos] $pos
                                                                  $m set_prim_handle NULL
                                                                  return 1}
                                           return 0}


#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method PM_Universal_encapsulator get_factice_LC {} {return $this(core_factice_LC)}
method PM_Universal_encapsulator get_factice_LM {} {return $this(core_factice_LM)}

#___________________________________________________________________________________________________________________________________________
method PM_Universal_encapsulator dispose {} {
 foreach c $this(L_created) {$c dispose}
 this inherited
}

#___________________________________________________________________________________________________________________________________________
method PM_Universal_encapsulator Nested_style {DSL str daughters_handlers args} {
# Unbranch
 this Sub_handle_composing_comet [this get_handle_composing_comet]
 this Sub_handle_comet_daughters [this get_handle_comet_daughters]
 this Sub_composing_comet        [this get_composing_comets]
 foreach c $this(L_created) {$c dispose}

# Interprets
 set L [$DSL Interprets $str "${objName}_DSL_CG"]
 set racine          [lindex $L 0]
 set this(L_created) [lindex $L 1]

# Branch
 set racine_PM [lindex [${racine}_LM_LP get_L_actives_PM] 0]
 this Add_composing_comet        $racine_PM
 this Add_handle_composing_comet $racine_PM          0 {}
 this Add_handle_comet_daughters $daughters_handlers 0 {}

 set L [this get_mothers]
 foreach PM $L {
   set pos [lsearch [$PM get_daughters] $objName]
   $PM Sub_daughter $objName
   $PM Add_daughter $objName $pos
  }
 
 set LM [this get_LM]
 if {[string length $LM] > 0} {$LM Connect_PM_descendants $objName}

# Execute args commands
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method PM_Universal_encapsulator set_LM {LM} {
 this inherited $LM
   [this get_core] set_LM $LM
   if {[string equal $LM {}]} {
     [this get_core] set_Common_FC {}
    } else {
        [this get_core] set_Common_FC [$LM get_Common_FC]
        $LM Connect_PM_descendants $objName
       }
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method PM_Universal_encapsulator get_core { } {return $this(core)}
method PM_Universal_encapsulator set_core {c} {set this(core) $c}

#___________________________________________________________________________________________________________________________________________
method PM_Universal_encapsulator new_core {PM} {
 set old_core [this get_core]
 set LM       [this get_factice_LM]

 [this get_core] Substitute_by $PM
 this set_core $PM
 $LM Sub_PM $old_core
 $LM Add_PM $PM; $LM set_PM_active $PM

 return $PM
}

#___________________________________________________________________________________________________________________________________________
method PM_Universal_encapsulator new_core_type {type} {
 set LM [this get_LM]
 if {[string length $LM] == 0} {return {}}
 set PM_name "${$objName}_core_[$LM get_a_unique_id]"

 $type $PM_name $PM_name "New $type core for $objName"
 return [this new_core $PM_name]
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
proc Generate_Universal_PM_methods {class_name L_methods} {
 set entete "method $class_name "
# set    fin { return [eval $cmd]}
# append fin "\n" "\}"

 foreach m $L_methods {
   set methode_name [lindex $m 0]
   set params       [lindex $m 1]
     set    cmd $entete
     append cmd $methode_name " \{" $params "\} \{\n"
     append cmd {[this get_core] } "$methode_name "
       foreach p $params {
         append cmd "\$[lindex $p 0]" { }
        }
#     append cmd "\n" $fin
     append cmd "\n\}"
     eval $cmd
  }
}

