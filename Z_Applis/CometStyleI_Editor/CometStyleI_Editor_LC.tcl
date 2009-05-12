inherit CometStyleI_Editor Logical_consistency

#___________________________________________________________________________________________________________________________________________
method CometStyleI_Editor constructor {name descr args} {
 this inherited $name $descr
 this set_GDD_id CT_CometStyleI_Editor
 
# set up internal COMET graph
 set this(cont_root)   [CPool get_a_comet CometContainer    -set_name "ROOT"               -Add_style_class "ROOT"              ]
   set this(top_inter) [CPool get_a_comet CometInterleaving -set_name "TOP INTERLEAVING"   -Add_style_class "TOP INTERLEAVING"  ]
   set this(CV)        [CPool get_a_comet CometViewer       -set_name "COMET GRAPH VIEWER" -Add_style_class "COMET TASK GRAPH VIEWER"]
   set this(meta)      [CPool get_a_comet CSS_Meta_IHM      -set_name "COMET META CSS"     -Add_style_class "COMET META CSS"]
 $this(cont_root) Add_daughters_R [list $this(top_inter) $this(CV) $this(meta)]

# set up actions
 set this(L_selected_nodes) [list]
 $this(meta) Subscribe_to_Select_elements alex "after 100 $objName Update_Enlight \[list \$L\]" UNIQUE  
 
# set up internal graph
 this Add_composing_comet [CSS++ cr "#$this(top_inter), #$this(top_inter) *"]
 this set_handle_composing_comet $this(cont_root)
 this set_handle_comet_daughters $this(cont_root) ""
 this Add_daughter               $this(cont_root)
 
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
Generate_accessors CometStyleI_Editor [list top_inter CV cont_root meta L_selected_nodes]

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometStyleI_Editor Update_Enlight {L} {
 puts "$objName Update_Enlight {$L}"
 set nL [list]
 foreach e $L {
   if {[lsearch $this(L_selected_nodes) $e] >= 0} {
	 Sub_list this(L_selected_nodes) $e
    } else {lappend nL $e}
  }
 
 Add_list this(L_selected_nodes) $nL
 
 puts "this(L_selected_nodes) == {$this(L_selected_nodes)}"
 puts "  Let's find the task related to each node"
 set L_LC_to_enlight [list]
 foreach node $this(L_selected_nodes) {
   set L_classes [gmlObject info classes $node]
   if {[lsearch $L_classes Physical_model] >= 0} {
     set toplevel_PM [$node get_toplevel_nesting_PM]
	 lappend L_LC_to_enlight [$toplevel_PM get_real_LC]
	} else {lappend L_LC_to_enlight $node}
  }
 puts "$this(CV) Enlight {$L_LC_to_enlight}"  
 $this(CV) Enlight $L_LC_to_enlight
 
 puts "________________________________________________________________________"
 foreach C [CSS++ $objName "#$this(top_inter) CometCUI_Editor"] {
   puts "_________________ $C"
   puts "$C Enlight {$this(L_selected_nodes)}"
   $C Enlight $this(L_selected_nodes)
  }
}


#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometStyleI_Editor [P_L_methodes_set_CometStyleI_Editor] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometStyleI_Editor [P_L_methodes_get_CometStyleI_Editor] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Inject_code CometStyleI_Editor Add_a_new_version \
            {set CUI_editor [CPool get_a_comet CometCUI_Editor -Add_style_class "ID_$id"]
			 this set_ptf_for_id $id Ptf_TK
			 $this(top_inter) Add_daughters_R $CUI_editor
			 $CUI_editor set_edited_comet [this get_edited_comet]
			 $CUI_editor Subscribe_to_set_ptf_of_CUI $objName "$objName Update_CUI_editor_ptf $id $CUI_editor"
			} \
			{}

#___________________________________________________________________________________________________________________________________________
method CometStyleI_Editor Update_CUI_editor_ptf {id CUI_editor} {
 if {[this get_ptf_for_id $id] != [$CUI_editor get_ptf_of_CUI]} {
   $CUI_editor set_ptf_of_CUI [this get_ptf_for_id $id]
  }
}
			
#___________________________________________________________________________________________________________________________________________
# method CometStyleI_Editor Sub_version_id {id}
Inject_code CometStyleI_Editor Sub_version_id \
            {} \
			{set CUI_editor [CSS++ $objName "#$this(top_inter) CometCUI_Editor.ID_$id"]
			 if {$CUI_editor != ""} {$this(top_inter) Sub_daughter_R $CUI_editor}
			}

#___________________________________________________________________________________________________________________________________________
# method CometStyleI_Editor set_edited_comet {v}
Inject_code CometStyleI_Editor set_edited_comet \
            {$this(CV) set_element_and_level [list $v 10]
			 foreach CUI_editor [CSS++ $objName "#$this(top_inter) CometCUI_Editor"] {
			   $CUI_editor set_edited_comet $v
			  }
			} \
			{}
		
#___________________________________________________________________________________________________________________________________________
# method CometStyleI_Editor set_style_file_for_id {id file_name}
Inject_code CometStyleI_Editor set_style_file_for_id \
            {set CUI_editor [CSS++ $objName "#$this(top_inter) CometCUI_Editor.ID_$id"]
			 if {$CUI_editor != ""} {
			   $CUI_editor set_style_file $file_name
			  }
			} \
			{}
			
#___________________________________________________________________________________________________________________________________________
# method CometStyleI_Editor set_ptf_for_id {id ptf}
Inject_code CometStyleI_Editor set_ptf_for_id \
            {set CUI_editor [CSS++ $objName "#$this(top_inter) CometCUI_Editor.ID_$id"]
			 if {$CUI_editor != ""} {
			   $CUI_editor set_ptf_of_CUI $ptf
			  }
			} \
			{}
          