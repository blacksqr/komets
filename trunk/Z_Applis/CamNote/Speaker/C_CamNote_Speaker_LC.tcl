inherit CometCamNote_Speaker Logical_consistency

#___________________________________________________________________________________________________________________________________________
method CometCamNote_Speaker constructor {name descr args} {
 this inherited $name $descr

 set CFC "${objName}_CFC"; 
   CommonFC_CometCamNote_Speaker $CFC
   this set_Common_FC $CFC

# Nested comets
 CometSlideRemoteController ${objName}_telec "Remote Controller" "Remote Controller (${objName}_telec) of the speaker"
 CometContainer             ${objName}_visu_cont "Container of the slide viewer" {}
 CometContainer             ${objName}_cont_for_daughters "Container for daughters" {}
 CometActivator             ${objName}_act_preso diaporama "Button to toggle between fullscreen or windowed presentation" -set_text DIAPORAMA -Add_style_class DIAPORAMA
   ${objName}_act_preso Subscribe_to_activate $objName "$objName set_preso_mode \[expr 1-\[$objName get_preso_mode\]\]"

 this Add_nested_daughters [list ${objName}_telec ${objName}_visu_cont ${objName}_act_preso ${objName}_cont_for_daughters] \
                           [list ${objName}_act_preso ${objName}_telec ${objName}_visu_cont] \
                           [list ${objName}_cont_for_daughters] \
                           {}

# Logical models
 set this(LM_LP) "${objName}_LM_LP";
   CometCamNote_Speaker_LM_P  $this(LM_LP) $this(LM_LP) "The logical presentation of $name"
   this Add_LM $this(LM_LP);
 set this(LM_FC) "${objName}_LM_FC";
   CometCamNote_Speaker_LM_FC $this(LM_FC) $this(LM_FC) "This logical part manage different protocoles"
   this Add_LM $this(LM_FC);


# Evaluate arguments and return
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometCamNote_Speaker dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometCamNote_Speaker [L_methodes_set_CamNote_Speaker] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometCamNote_Speaker [L_methodes_get_CamNote_Speaker] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometCamNote_Speaker get_telec {} {return ${objName}_telec}

#___________________________________________________________________________________________________________________________________________
method CometCamNote_Speaker set_slide_viewer {c} {
 ${objName}_visu_cont set_daughters_R $c
 foreach LM $this(L_LM) {$LM set_slide_viewer $c}
}

#___________________________________________________________________________________________________________________________________________
Manage_CallbackList CometCamNote_Speaker set_preso_mode end
