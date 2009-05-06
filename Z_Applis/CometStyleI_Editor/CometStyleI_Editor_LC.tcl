inherit CometStyleI_Editor Logical_consistency

#___________________________________________________________________________________________________________________________________________
method CometStyleI_Editor constructor {name descr args} {
 this inherited $name $descr
 this set_GDD_id CT_CometStyleI_Editor
 
# set up internal COMET graph
 set this(top_inter)              [CPool get_a_comet CometInterleaving -set_name "SWL top interleaving" -Add_style_class "TOP INTERLEAVING"]
 $this(top_inter)           Add_daughters_R [list ]

# set up actions
 
# set up internal graph
 this Add_composing_comet [CSS++ cr "#$this(top_inter), #$this(top_inter) *"]
 this set_handle_composing_comet $this(top_inter)
 this set_handle_comet_daughters $this(top_inter) ""
 this Add_daughter               $this(top_inter)
 
# Define facets
 set CFC ${objName}_CFC; CometStyleI_Editor_CFC $CFC; this set_Common_FC $CFC

 set this(LM_LP) ${objName}_LM_LP
 CometStyleI_Editor_LM_LP $this(LM_LP) $this(LM_LP) "The LM LP of $name"
   this Add_LM $this(LM_LP)

# Finishing   
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometStyleI_Editor dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
Generate_accessors CometStyleI_Editor [list top_inter]

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometStyleI_Editor [P_L_methodes_set_CometStyleI_Editor] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometStyleI_Editor [P_L_methodes_get_CometStyleI_Editor] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Inject_code CometStyleI_Editor Add_a_new_version \
            {set CUI_editor [CPool get_a_comet CometCUI_Editor -Add_style_class ID_$id]
			 $this(top_inter) Add_daughters_R $CUI_editor
			} \ 
			{}

#___________________________________________________________________________________________________________________________________________
Inject_code CometStyleI_Editor Sub_version_id \
            {} \
			{set CUI_editor [CSS++ $objName "#$this(top_inter) > CometCUI_Editor.ID_$id"]
			 if {$CUI_editor != ""} {$this(top_inter) Sub_daughter_R $CUI_editor}
			}

