#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit LM_Universal_encapsulator Logical_model

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
# Let's consider a fake LM for the core PM                                                                                                 _
# It's aim is just to facilitate branchs                                                                                                   _
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method LM_Universal_encapsulator constructor {name descr LM_core L_PM L_actives_PM type_PM args} {
 this inherited $name $descr
   set this(L_created)    [list]
   set this(core)         $LM_core
   if {[regexp "^(.*)_LM_LP$" $LM_core rep comet_name]} {} else {set comet_name "Fake_LC_of_$objName"}
   set this(core_factice_LC) $comet_name
     Logical_consistency $this(core_factice_LC) "Fake LC of $LM_core" {NO MORE DESCRIPTION}
     $this(core_factice_LC) set_Common_FC [$LM_core get_Common_FC]
     $this(core_factice_LC) Add_LM $LM_core
     $LM_core set_LC $comet_name

# Generating some universal PM
   set PM_name "${objName}_PM_universal_[this get_a_unique_id]"
   $type_PM $PM_name $PM_name {Universal PM}
     this Add_PM         $PM_name
     this set_PM_active  $PM_name

   this Add_nested_daughters [this get_core] [this get_core] [this get_core] {}

 eval "$objName configure $args"
 return $objName
}
#___________________________________________________________________________________________________________________________________________
method LM_Universal_encapsulator dispose {} {
 foreach c $this(L_created) {$c dispose}
 this inherited
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method LM_Universal_encapsulator DEBUG_display_PM_and_daughters {dec} {
 foreach PM [this get_L_actives_PM] {
   puts "$dec$PM daughters :"
   foreach d [$PM get_daughters] {
     puts "$dec$dec$d"
    }
  }
}

#___________________________________________________________________________________________________________________________________________
method LM_Universal_encapsulator Add_daughter    {m {index -1}} {
 global debug
 if {$debug} {puts "$objName Add_daughter $m $index"}
# 2 cas, soit on a des noeuds nestés, soit on en a pas.
# Cas on a des noeuds nestés
 if {[llength $this(L_handle_composing_daughters)] > 0} {
#  Il va falloir recréer toute la hierarchie PM à partie de la hiérarchie LM, puis ajouter effectivement la fille m à l'aide de la méthode héritée
   set L [this get_handle_comet_daughters]
   if {[llength $L] == 0} {return 0}
   
   if {$index==-1 || $index>=[llength $L]} {set pos end} else {set pos $index}
   set handle_nested_LM [lindex $L $pos]

#   this inherited $handle_nested_LM
   if {[string equal [$handle_nested_LM get_LC] [this get_LC]]} {} else {}
   this set_LM_to_connect_daughters $L
   this inherited $m
#  Branchement de la nouvelle fille, elle sera placé sous un des noeuds nestés.
   return [this inherited $m $index]
  } else {this inherited $m $index
         }
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method LM_Universal_encapsulator get_factice_LC {} {return $this(core_factice_LC)}

#___________________________________________________________________________________________________________________________________________
method LM_Universal_encapsulator Nested_style {DSL str daughters_handlers args} {
# Unbranch
 this Sub_handle_composing_comet [this get_handle_composing_comet]
 this Sub_handle_comet_daughters [this get_handle_comet_daughters]
 this Sub_composing_comet        [this get_composing_comets]
 foreach c $this(L_created) {$c dispose}

# Interprets
 set L [$DSL Interprets $str "${objName}_DSL_CG"]
 set racine          [lindex $L 0]
 set this(L_created) [lindex $L 1]
# puts "$objName Nested_style \"$str\" $daughters_handlers"
# puts "  - Root   : $racine"
# puts "  - Childs : "
# foreach c $this(L_created) {
#  puts "     - $c"
# }

# Branch
 set racine_LM ${racine}_LM_LP 
 this Add_composing_comet        $racine_LM
 this Add_handle_composing_comet $racine_LM          0 {}
 this Add_handle_comet_daughters $daughters_handlers 0 {}

 set L [this get_mothers]
 foreach LM $L {
   set pos [lsearch [$LM get_out_daughters] $objName]
   $LM Sub_daughter $objName
   $LM Add_daughter $objName $pos
   Connection [$LM get_LC]
  }

# Execute args commands
 eval "$objName configure $args"
}

#___________________________________________________________________________________________________________________________________________
method LM_Universal_encapsulator get_core { } {return $this(core)}
method LM_Universal_encapsulator set_core {c} {set this(core) $c}

#___________________________________________________________________________________________________________________________________________
method LM_Universal_encapsulator set_LC {LC} {
 this inherited $LC
   [this get_core] set_LC $LC
   if {[string equal $LC {}]} {
     [this get_core] set_Common_FC {}
    } else {
        [this get_core] set_Common_FC [$LC get_Common_FC]
        [this get_core] set_LC        $LC
       }
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
proc Encapsulate {LM PM_class {encaps_class LM_Universal_encapsulator}} {
 set LC  [$LM get_LC]
 set L_d [$LM get_out_daughters]
 set L_m_tmp [$LM get_mothers]
 set L_m     {}
 foreach m $L_m_tmp {set pos [lsearch [$m get_out_daughters] $LM]
                     lappend L_m [list $m $pos]
                    }
 set class [lindex [gmlObject info classes $LM] 0]

# Supprimer LM
 set L_PM         [$LM get_L_PM]
 set L_actives_PM [$LM get_L_actives_PM]
 $LM set_L_PM {}
 #puts "Encapsulate $LM $PM_class\n  $LM dispose"
 $LM dispose
 #puts "  FIN DISPOSE"
 
# Recréer un LM équivalent qui sera nesté, détruire les PMs créés automatiquement, rebrancher les anciens PMs sur le noyau
 set LM_core "${LC}_Preso_core_LM_LP"
 $class $LM_core $LM_core "Core LM of $LM"
   set L [$LM_core get_L_PM]
 $LM_core set_LC           $LC
 $LM_core set_L_PM         $L_PM
 $LM_core set_L_actives_PM $L_actives_PM
 foreach PM $L            {$PM dispose}
 foreach PM $L_actives_PM {
   set L [$PM get_mothers]
   foreach m $L {$L Sub_daughter $PM}
  }

# Encapsuler
 $encaps_class $LM "$LM encapsulates $LM_core" {NO MORE DESCRIPTION} $LM_core $L_PM $L_actives_PM $PM_class
   $LC Sub_LM $LM
   $LC Add_LM $LM
 $LM_core set_LC $LC
# Relier le LM avec les anciennes mères et filles
 foreach mp $L_m {
   set m [lindex $mp 0]
   set p [lindex $mp 1]
   $m Add_daughter $LM $p
   $m Connect_PM_descendants
  }
 $LM Add_daughters $L_d

 $LM Connect_PM_descendants

 return $LM_core
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
proc Generate_Universal_LM_methods {class_name L_methods} {
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

