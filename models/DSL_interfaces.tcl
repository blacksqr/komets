#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
# DSL for declarating interfaces, names are automatically generated in a predicitve way. ___________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method DSL_interface_interpretor constructor {} {
 set this(dec) ""
 set this(lexic,|||)    CometInterleaving
 set this(lexic,C_Cont) CometContainer
 set this(lexic,C_Text) CometText
 set this(lexic,C_Img)  CometImage
 set this(lexic,C_Spec) CometSpecifyer
 set this(lexic,C_OkCa) CometOkCancel
 set this(lexic,C_Act)  CometActivator
 set this(lexic,C_DC)   CometChoice
 set this(lexic,C_RC)   CometChoiceN
 set this(lexic,C_GDDVisu) CometGDDVisu
 
 set this(unique_id) 0
 
 set this(dsl_gdd) ""
 
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method DSL_interface_interpretor get_dsl_gdd { } {return $this(dsl_gdd)} 
method DSL_interface_interpretor set_dsl_gdd {v} {set this(dsl_gdd) $v}

#___________________________________________________________________________________________________________________________________________
method DSL_interface_interpretor get_a_unique_id {} {
 incr this(unique_id)
 return $this(unique_id)
}

#___________________________________________________________________________________________________________________________________________
# La grammaire :                                                                                                                           _
#   DSL       : NAME = DSL_Comet | DSL_Comet ; DSL                                                                                         _
#   DSL_Comet : ''| ".*" | COMET (ARGS) | COMET (ARGS, L_COMETS)                                                                           _
#   L_COMETS  : DSL | DSL, L_COMETS                                                                                                        _
#   ARGS      : ".*"                                                                                                                       _
#   COMET     : $this(L_lexic)                                                                                                             _
# La génération des noms                                                                                                                   _
#   Au moment où on traduit, donner les paramètres suivant :                                                                               _
#     - Prefixe                                                                                                                            _
#   Générer les noms de sorte à éviter les ambiguités.                                                                                     _
#     - Refléter la hiérarchie                                                                                                             _
#     - Refléter l'index dans la liste des fils                                                                                            _
#   ex : si C_cont(truc, C_DC(toto, machin)) alors                                                                                         _
#           C_cont_1.C_DC_0.toto                                                                                                           _
# 1) Découpage lexical                                                                                                                     _
# 2) Construction de l'arbre syntaxique                                                                                                    _
# 3) Exécution de la sémantique                                                                                                            _
#___________________________________________________________________________________________________________________________________________

#___________________________________________________________________________________________________________________________________________
# Exemples :
#  |||(,C_DC(, "a", "b", "c", "d", "e"), C_Text(set_text coucou), C_DC(, "1", "2", "3"), "hehe")
#  |||(,C_Act(OK), C_Text(set_text coucou))
#  |||(,C_Text(), C_Text())
# set str "|||(.....)"
# DSL_interface_interpretor DSL
# set L [DSL Interp_DSL str]
# DSL DSL L

#___________________________________________________________________________________________________________________________________________
method DSL_interface_interpretor DSL {L_name prefixe} {
 upvar $L_name L

 if {[llength $L]==0} {return}
 set name  [lindex $L 0]
 set arbre [lindex $L 1]
   set type [lindex $arbre 0]
   set argu [lindex $arbre 1]
   set fils [lindex $arbre 2]
 if {$name == ""} {
   set name $prefixe
  }

# Est ce un type constructeur ?
 #puts "$objName DSL_interface_interpretor::DSL\n  L_name  = $L_name\n  prefixe = $prefixe"
 #puts "  type = $type"
 #puts "_________________"
 #puts "  What is $name ?"
 set L_comets_created [list]
 if {[info exists this(lexic,$type)]} {
   #puts "    => A constructor"
   set txt "$this(lexic,$type) $name $name {Automatically generated using the CometInterface DSL $objName} $argu"
   set type $this(lexic,$type)
   if {![gmlObject info exists object $name]} {
     lappend L_comets_created $name
     eval $txt
	} else {eval "$name configure $argu"; $name set_daughters_R {}}
# Est ce un nom de variable ?
  } else {if {[gmlObject info exists object $type]} {
            #puts "    => A variable"
            set name $type
            puts "$type est un objet."
			# Est ce le nom d'un noeud du GDD ?							 
            if {$type == "GDD_Node" || [lsearch [gmlObject info classes $type] GDD_Node] >= 0} {
			  #puts "    => A GDD_node"
			  # Retrouver le LC correspondant dans le GDD
			  $this(dsl_gdd) QUERY "?n : $type : NODE()->REL(type~=GDD_inheritance && type!=GDD_restriction)*->\$n()"
              set gdd_rep       [lindex [$this(dsl_gdd) get_Result] 0] 
			  #puts "gdd_rep = $gdd_rep"
			  set gdd_task_node [lindex [lindex $gdd_rep 1] 0]
			  if {$gdd_task_node == ""} {set gdd_task_node $type}

			  # Identifier l'usine du LC correspondant
			  if {[llength [$gdd_task_node get_L_factories]] == 0} {
			    $this(dsl_gdd) QUERY "?n : $gdd_task_node : NODE()->REL(type~=GDD_inheritance)*->\$n()->REL(type==GDD_restriction)->NODE(name==IS_root)"
				set gdd_rep          [lindex [$this(dsl_gdd) get_Result] 0] 
				set root_restriction [lindex [lindex $gdd_rep 1] 0]
				set factory          [lindex [$root_restriction get_L_factories] 0]
				#puts "factory = $factory"
			   } else {set factory [lindex [$gdd_task_node get_L_factories] 0]
			           #puts "factory = $factory"
			          }

			  # Trouver toutes les implementations de $type et les donner comme usines de l'instance
			  set name $factory
			  set txt "set name \[CPool get_a_comet $factory $argu\]"
			  eval $txt
			  lappend L_comets_created $name

			  # Ajouter les usines correspondants aux autres implémentations de la même tâche
			  # Vérifier avant si le type demandé à l'origine n'est pas une CUI, auquel cas il faut ne laisser que lui comme usine
			  set L_PM_factories ""
			  set cameleon_type ""
			  #puts "  set cameleon_type \[$type get_type\]"
			  catch {set cameleon_type [$type get_type]}
			  if {$cameleon_type == "GDD_FUI"} {
			    set L_PM_factories [$type get_L_factories]
				set fact [lindex $L_PM_factories 0]
				if {[llength $L_PM_factories] > 0} {
				  ${name}_LM_LP set_PM_factories [Generate_factories_for_PM_type [list "$fact [$type get_ptf]" \
                                                                                 ] ${name}_LM_LP]
				 }
			   }
			  
			  if {$L_PM_factories == ""} {
					  set req_gdd_direct_implem "?n : $type : NODE()<-REL(type~=GDD_inheritance && type!=GDD_restriction)*<REL(type~=GDD_implementation)<-\$n()"
					  set req_gdd_all_implem    "?n : $gdd_task_node : NODE()<-REL(type~=GDD_inheritance && type!=GDD_restriction)*<REL(type~=GDD_implementation)<-\$n()"
					  #puts $req_gdd_direct_implem
					  $this(dsl_gdd) QUERY $req_gdd_direct_implem; set res_gdd [$this(dsl_gdd) get_Result]
						#puts "  res_gdd : {$res_gdd}"
						set L_nodes_implem [lindex [lindex $res_gdd 0] 1]
					  
					  # Add other factories
					  #puts $req_gdd_all_implem
					  $this(dsl_gdd) QUERY $req_gdd_all_implem; set res_gdd [$this(dsl_gdd) get_Result]
						#puts "  res_gdd : {$res_gdd}"
						Add_list L_nodes_implem [lindex [lindex $res_gdd 0] 1]
						#puts "${name}_LM_LP Update_factories $L_nodes_implem"
						${name}_LM_LP Update_factories $L_nodes_implem
					  }
			 }
           } else {global $type
                   if {[info exists $type]} {
                     #puts "    => Something that still exists"
					 set name $type
                    } else {if {[gmlObject info exists class $type]} {
					         #puts "    => A class name"
		                     # C'est un nom de classe, est ce un élément de COMET ?
                             if {$type == "Logical_consistency" || [lsearch [gmlObject info classes $type] Logical_consistency] >= 0} {
							   set txt "set name \[CPool get_a_comet $type $argu\]"
							   eval $txt
							   lappend L_comets_created $name
							  }
							 } else {if {[regexp {^@([0-9]*)} $type reco ad]} {
									   return $ad
                                      } else {puts "ERROR in DSL;\n   \"$type\" is neither a constructor nor a comet : [info exists $type]"}
						            } 
				            } 
                  }
         }

 set pos 0
 set ad  -1
 foreach f $fils {
   set a [lindex $f 1]
   if {[string equal [lindex $a 0] {}]} {continue}
   set comet_f [this DSL f "${name}__${type}_[this get_a_unique_id]"]
     if {[regexp {^([0-9]*)$} $comet_f reco ad]} {
#       puts "Positionnement en $ad"
       continue
      }
   set L_comets_created [concat $L_comets_created [lindex $comet_f 1]]
   $name Add_daughter_R [lindex $comet_f 0] $ad
   if {$ad != -1} {incr ad}
   incr pos
  }

 return [list $name $L_comets_created]
}

#___________________________________________________________________________________________________________________________________________
method DSL_interface_interpretor Interprets {str {prefixe CG}} {
 set this(dec) ""
 set L [this Interp_DSL str]
# puts "\n________________________________\nArbre interprété : "
# Afficher_arbre $L
# puts "\n________________________________\n"
 if {$this(dsl_gdd) == ""} {
   puts "WARNING : The dsl interpretor is not specified : use \"$objName set_dsl_gdd ...\""
  }
 return [this DSL L $prefixe]
}

#___________________________________________________________________________________________________________________________________________
method DSL_interface_interpretor Interp_DSL {str_name} {
# puts "$this(dec)Interp_DSL";
 set dec $this(dec)
 append this(dec) "  "
 upvar $str_name   str

 set reco {^[ \n]*([a-z|A-Z|\||0-9|_]*)[ \n]*=[ \n]*(.*)$}
 if {[regexp $reco $str oki v_name str]} {
   #puts "$this(dec)v_name : $v_name"
   return [list $v_name [this Interp_DSL_Comet str]]
  }
# puts "$this(dec)v_name : NULL"
# puts "$this(dec)str    : $str"
 set rep [this Interp_DSL_Comet str]
 return [list {} $rep]

 if {[string length $rep] == 0} {
#   puts "$this(dec)Plus rien à faire. rep = \"$rep\""
   return {}
  } else {return [list {} $rep]}
}

#___________________________________________________________________________________________________________________________________________
method DSL_interface_interpretor Parse_to_equilibrate {str_name v_equi_name nb_desequi symb_plus symb_minus} {
# puts "$this(dec)Parse_to_equilibrate"; append this(dec) "  "
 upvar $str_name    str
 upvar $v_equi_name v_equi

 set taille [string length $str]
 set pos 0
 while {$nb_desequi != 0 && $pos < $taille} {
   set lettre [string index $str $pos]
     if {[string equal "\\"          $lettre]} {incr pos; continue} else {
     if {[string equal "$symb_plus"  $lettre]} {incr nb_desequi  1} else {
     if {[string equal "$symb_minus" $lettre]} {incr nb_desequi -1}
     }}
   incr pos
  }

 if {$nb_desequi == 0} {
   set v_equi [string range $str 0    [expr $pos-1] ]
   set str    [string range $str $pos end           ]
   return 1
  } else {return 0}
}

#___________________________________________________________________________________________________________________________________________
method DSL_interface_interpretor Interp_DSL_Comet {str_name} {
# puts "$this(dec)Interp_DSL_Comet"
 upvar $str_name str
   set dec $this(dec)
   append this(dec) "  "

 set reco {^[ \n]*([\||a-z|A-Z|0-9|_]*)[ \n]*\((.*)$}
 if {[regexp $reco $str oki m str]} {
   set this(dec) $dec
#   puts "$this(dec) |m   : $m"
   set L_args {}
   if {[this Parse_to_equilibrate str L_args 1 "(" ")"]} {} else {puts "FAILED to equilibrate (.\n$str"; return {}}
   set this(dec) $dec
#   puts "$this(dec) |Arguments de $m : $L_args"
#   puts "$this(dec) |Reste à interpréter : $str"
   set taille [string length $L_args]
   for {set i 0} {$i < $taille} {incr i} {
     set lettre [string index $L_args $i]
     if {[string equal "\\" $lettre]} {incr i; continue} else {
     if {[string equal  ,   $lettre]} {set a        [string range $L_args 0           [expr $i-1] ]
                                       set str_fils [string range $L_args [expr $i+1] end         ]
                                       return [list $m $a [this Interp_L_Comets str_fils]]
                                      }
                                                           }
    }
   return [list $m [string range $L_args 0 end-1] {}]
  } else {
      if {[regexp {^[ \n]*"(.*)$} $str oki str]} {
        set txt {}
        if {[this Parse_to_equilibrate str txt 1 NULL "\""]} {} else {puts "AU SECOURS"; return {}}
        set txt_value [string range $txt 0 end-1]
        set this(dec) $dec
#        puts "$this(dec) |C_Text : \"$txt_value\""
#        puts "$this(dec) |reste  : $str"
        return [list C_Text "-set_name \{$txt_value\} -set_text \{$txt_value\}" {}]
       } else {if {[regexp {^[ \n]*@([0-9]*)[ \n]*(.*)$} $str oki ad str]} {
                 return [list "@$ad" {} {}]
                }
              }
     }
 return {}
}

#___________________________________________________________________________________________________________________________________________
method DSL_interface_interpretor Interp_L_Comets {str_name} {
 upvar $str_name str
 set dec $this(dec)
# puts "$this(dec)Interp_L_Comets"; append this(dec) "| "

 set L_rep [list]

# puts "$dec|AVANT Interp_DSL\n$dec|->str : $str"
 set rep [this Interp_DSL str]
# puts "$dec|->rep : \"$rep\""
# puts "$dec|->str : $str"
 while {[string length $rep] > 0} {
   lappend L_rep $rep
   set this(dec) $dec
   if {[regexp {^[) \n]*$} $str oki str]} {
#     puts "$dec|->Plus rien à faire, c'est vide : \"$str\"";
     break
    }
   if {[regexp {^[) \n]*,[ \n]*(.*)$} $str oki str]} {
     set rep [this Interp_DSL str]
#     puts "$dec|->rep:\"$rep\""
     continue
    }
   break
  }
# puts "$dec|->Plus rien à annalyser.\n$dec |str : $str"
 return $L_rep
}

#___________________________________________________________________________________________________________________________________________
proc Afficher_arbre {L {dec ""}} {
 if {[llength $L]==0} {return}
 set name  [lindex $L 0]
 set arbre [lindex $L 1]
   set type [lindex $arbre 0]
   set argu [lindex $arbre 1]
   set fils [lindex $arbre 2]

 puts "${dec}name : \"$name\""
 puts "${dec}type : $type"
 puts "${dec}argu : $argu"

 foreach f $fils {
   Afficher_arbre $f "$dec  "
  }
}

