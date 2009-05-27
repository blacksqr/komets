inherit CometCUI_Editor Logical_consistency

#___________________________________________________________________________________________________________________________________________
method CometCUI_Editor constructor {name descr args} {
 this inherited $name $descr
 this set_GDD_id CT_CometCUI_Editor

# set up internal COMET graph
 set this(top_inter) [CPool get_a_comet CometInterleaving -set_name "CUI editor top interleaving" -Add_style_class "TOP INTERLEAVING"]
   set this(CV)      [CPool get_a_comet CometViewer       -set_name "Comet viewer"                -Add_style_class "COMET GRAPH VIEWER CUI"]
   set this(CGB)     [CPool get_a_comet CometGraphBuilder -set_name "CometGraph Builder"          -Add_style_class "COMET GRAPH BUILDER"]
   set this(cont)    [CPool get_a_comet CometContainer    -set_name "Container of the FUI"        -Add_style_class "CONTAINER FUI"]
   set this(filter)  [CPool get_a_comet CometContainer    -set_name "Filter of the FUI"           -Add_style_class "FILTER FUI"]
	 
 $this(top_inter) Add_daughters_R [list $this(CV) $this(CGB) $this(cont)]
 
 $this(cont) Add_daughters_R $this(filter)
# set up actions
 
# set up internal graph
 this Add_composing_comet [CSS++ cr "#$this(top_inter), #$this(top_inter) *"]
 this set_handle_composing_comet $this(top_inter)
 this set_handle_comet_daughters $this(top_inter) ""
 this Add_daughter               $this(top_inter)

# Set up other COMET facet
 set CFC ${objName}_CFC; CometCUI_Editor_CFC $CFC; this set_Common_FC $CFC

 set this(LM_LP) ${objName}_LM_LP
 CometCUI_Editor_LM_LP $this(LM_LP) $this(LM_LP) "The LM LP of $name"
   this Add_LM $this(LM_LP)
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometCUI_Editor dispose {} {this inherited}
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometCUI_Editor [P_L_methodes_set_CometCUI_Editor] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometCUI_Editor [P_L_methodes_get_CometCUI_Editor] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method CometCUI_Editor get_top_interleaving    {} {return $this(top_inter)}
#___________________________________________________________________________________________________________________________________________
method CometCUI_Editor get_comet_viewer        {} {return $this(CV)}
#___________________________________________________________________________________________________________________________________________
method CometCUI_Editor get_comet_graph_builder {} {return $this(CGB)}

#___________________________________________________________________________________________________________________________________________
method CometCUI_Editor Enlight_with_CSS {CSS} {
 set PM_FUI  [CSS++ $objName "#$this(filter)->PMs [this get_edited_comet]"]
 set new_CSS [string map [list {$current} $PM_FUI] $CSS]
 set L [CSS++ $objName $new_CSS]
 this Enlight $L
}

#___________________________________________________________________________________________________________________________________________
method CometCUI_Editor Enlight {L} {
 set L_PMs [list]
 foreach e $L {
   if {[lsearch [gmlObject info classes $e] Physical_model] >= 0} {
     lappend L_PMs $e
    } else {set L_PMs [concat $L_PMs [CSS++ $e "#$e->PMs"]]}
  }
 $this(CV) Enlight $L_PMs
 
 set root [CSS++ $objName "#$objName <--< CometRoot"] 
 if {$root != ""} {
	 if {[catch {$root Stop_Enlight; $root Enlight $L_PMs} err]} {
	   puts "ERROR in \"$objName Enlight {$L_PMs}\"\n  - err : $err"
	  }
  }
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
# Inject code for {set_edited_comet {v}} 
Inject_code CometCUI_Editor set_edited_comet \
            { if {[this get_edited_comet] != ""} {
			    if {[catch "$this(filter) Sub_daughter_R [this get_edited_comet]" err]} {puts "ERROR in $objName set_edited_comet $v:\n$err"}
               }
			  [this get_Common_FC] set_edited_comet $v
			  C_GDD $this(filter)_LM_LP "Implem" Container
			  set ptf [this get_ptf_of_CUI]
              puts "  ptf = $ptf"
			  $this(filter)_LM_LP set_PM_factories [$this(filter)_LM_LP get_L_compatible_factories_with_ptf $ptf]
              puts "  this(filter)_LM_LP get_PM_factories = [$this(filter)_LM_LP get_PM_factories]"
			  set L_PMs [$this(filter)_LM_LP get_L_PM]
              puts "  this(filter)_LM_LP get_L_PM = {$L_PMs}"
			  foreach PM $L_PMs {
                puts "    considering PM $PM"
			    if {![${PM}_cou_ptf Accept_for_daughter $ptf]} {
                  puts "    $PM is not compatible with $ptf and therefore destroyed\n    $PM classe's are [gmlObject info classes $PM]"
				  $PM dispose
				 } else {puts "    $PM is OK for the ptf $ptf.\n    $PM classe's are [gmlObject info classes $PM]"
                        }
			   }
              puts "  this(filter)_LM_LP get_L_PM = [$this(filter)_LM_LP get_L_PM]"
			  $this(cont)   Sub_daughter_R $this(filter); $this(cont) Add_daughter_R $this(filter); 
		      $this(filter) set_daughters_R $v
              if {$v != ""} {this Apply_style
                            }
			} \
			{}

#___________________________________________________________________________________________________________________________________________
# Inject code for {set_ptf_of_CUI {v}}
Inject_code CometCUI_Editor set_ptf_of_CUI \
			{ [this get_Common_FC] set_ptf_of_CUI $v
			  this set_edited_comet [this get_edited_comet]
			} \
			{}
#___________________________________________________________________________________________________________________________________________
Manage_CallbackList CometCUI_Editor set_ptf_of_CUI end

#___________________________________________________________________________________________________________________________________________
# Inject code for {set_style_file {v}} 
Inject_code CometCUI_Editor set_style_file \
			{ [this get_Common_FC] set_style_file $v
			  this Apply_style
			} \
			{}
			
Manage_CallbackList CometCUI_Editor set_style_file end

#___________________________________________________________________________________________________________________________________________
# Inject code for {Apply_style {}}
Inject_code CometCUI_Editor Apply_style \
			{ Apply_style_on [CSS++ $this(filter) "#$this(filter)->PMs [this get_edited_comet]"] [this get_L_mapping] [this get_gdd_op_file] [this get_style_file]
			  set L_PMs [CSS++ $this(filter) "#$this(filter)->PMs [this get_edited_comet]"]
			  set PM [lindex $L_PMs 0]
			  puts "CSS++ $this(filter) {#$this(filter)->PMs [this get_edited_comet]} : $L_PMs"
			  if {$PM != ""} {
			    $this(CV) set_element_and_level "$PM 10"
			   } else {
			           $this(CV) set_represented_element ""
					  }
			} \
			{}


