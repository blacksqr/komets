
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometCamNote_Speaker_PM_U PM_Universal
#___________________________________________________________________________________________________________________________________________
method CometCamNote_Speaker_PM_U constructor {name descr args} {
 this inherited $name $descr
   this set_nb_max_mothers 1
   this set_cmd_placement {}
   
   set this(svg_place_visu)  ""

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometCamNote_Speaker_PM_U [L_methodes_set_CamNote_Speaker] {$this(FC)} {}
Methodes_get_LC CometCamNote_Speaker_PM_U [L_methodes_get_CamNote_Speaker] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method CometCamNote_Speaker_PM_U Add_daughter {PM {index -1}} {
# Check if PM is related to a LM nested in the LM of $objName
 set LM [this get_LM]
 set L  [$LM get_handle_composing_comet]
 if {[lsearch $L [$PM get_LM]] >= 0} {
   return [this inherited $PM $index]
  } else {$LM Connect_PM_descendants $objName $L
         }
 return 0
}

#___________________________________________________________________________________________________________________________________________
method CometCamNote_Speaker_PM_U set_preso_mode {m} {
 if {[${objName}_cou_ptf Accept_for_daughter Ptf_BIGre]} {
   set DSL [this get_DSL_CSSpp]
   set PM_visu  [$DSL Interprets {CometContainer \!CometContainer/ \>CometImage/} $objName]
   set cont [$PM_visu  get_prim_handle]
   if {$m} {
     if {[string equal "" $this(svg_place_visu) ]} {set this(svg_place_visu)  [B_repere2D]}
     $this(svg_place_visu)  maj $cont
     set transfo [B_transfo 1500]
       set bt [$cont Boite_fils]
       set ef_x [expr [N_i_mere Largeur]/[$bt Tx]]; set ef_y [expr [N_i_mere Hauteur]/[$bt Ty]];
       set px [$cont Px]; set py [$cont Py]; set r [$cont Rotation]
       set    cmd "set v \[$transfo V_courant\];\n"
       append cmd "$cont maj \[expr (1-\$v)*$px\] \[expr (1-\$v)*$py\] \[expr (1-\$v)*$r\] \[expr (1-\$v)*[$cont Ex]+\$v*$ef_x\] \[expr (1-\$v)*[$cont Ey]+\$v*$ef_y\];\n"
       set rap_pdt [B_rappel [Interp_TCL] $cmd]
     $transfo abonner_a_rappel_pendant [$rap_pdt Rappel]
     $transfo Demarrer
     N_i_mere Ajouter_deformation_dynamique $transfo
    } else {if {[string equal "" $this(svg_place_visu)]} {return}
            set transfo [B_transfo 1500]
              set    cmd "set v \[$transfo V_courant\];\n"
              set px [$this(svg_place_visu) Px]; set py [$this(svg_place_visu) Py]; set r [$this(svg_place_visu) Rotation]
              set ex [$this(svg_place_visu) Ex]; set ey [$this(svg_place_visu) Ey]
              append cmd "$cont maj \[expr (1-\$v)*[$cont Px]+\$v*$px\] \[expr (1-\$v)*[$cont Py]+\$v*$py\] \[expr (1-\$v)*[$cont Rotation]+\$v*$r\] \[\expr (1-\$v)*[$cont Ex]+\$v*$ex\] \[\expr (1-\$v)*[$cont Ey]+\$v*$ey\];\n"
              set rap_pdt [B_rappel [Interp_TCL] $cmd]
            $transfo abonner_a_rappel_pendant [$rap_pdt Rappel]
            $transfo Demarrer
            N_i_mere Ajouter_deformation_dynamique $transfo
           }
  }
}
