inherit CometViewer_PM_FC_basic Physical_model

#_________________________________________________________________________________________________________
method CometViewer_PM_FC_basic constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CometViewer_PM_FC_basic

 eval "$objName configure $args"
 return $objName
}

#_________________________________________________________________________________________________________
Methodes_set_LC CometViewer_PM_FC_basic [L_methodes_set_CometViewer] {}          {}
Methodes_get_LC CometViewer_PM_FC_basic [L_methodes_get_CometViewer] {$this(FC)}

#_________________________________________________________________________________________________________
Generate_PM_setters CometViewer_PM_FC_basic [P_L_methodes_FC_set_CometViewer_COMET_RE]

#_________________________________________________________________________________________________________
#_________________________________________________________________________________________________________
#_________________________________________________________________________________________________________
method CometViewer_PM_FC_basic set_represented_element {e} {this Update_dot}
#_________________________________________________________________________________________________________
method CometViewer_PM_FC_basic set_go_inside_level     {e} {this Update_dot}
#_________________________________________________________________________________________________________
method CometViewer_PM_FC_basic set_go_out_daughters    {e} {this Update_dot}

#_________________________________________________________________________________________________________
method CometViewer_PM_FC_basic Update_dot {} {
 this prim_set_dot_description [this Generate_dot_from [this get_represented_element] [this get_go_inside_level] [this get_go_out_daughters]]
}

#_________________________________________________________________________________________________________
#_________________________________________________________________________________________________________
#_________________________________________________________________________________________________________
method CometViewer_PM_FC_basic Generate_dot_from {root go_inside_level go_daughters} {
 puts "Graph_to_dot $root $go_inside_level $go_daughters"
 set color           white
 set color_composite green
 
 if {[lsearch [gmlObject info classes $root] Physical_model] != -1} {
   set PM $root; set gogogo 1
   while {$PM != "" && $gogogo} {
     set prim [$PM get_hiden_prim_elements]
	 if {[lsearch $prim *] != -1} {
       set color           grey60
	   set color_composite green4
	   set gogogo 0
      }
	 set PM [$PM get_mothers]
    }
  }

 set    str "digraph G {\n"
   set this(mark) [clock clicks]
   this Comet_to_dot $root str "" [CSS++ cr "#$root, #$root *"] $go_inside_level $go_daughters $color $color_composite
 append str "}\n"
 
 return $str
}

#_________________________________________________________________________________________________________
# Colorer en gris clair les noeuds qui sont cachés...
# == si get_prim_handle ou get_handle_for_daughters ne sont pas affichés
#_________________________________________________________________________________________________________
method CometViewer_PM_FC_basic Comet_to_dot {C str_name dec L_OK_recurse go_inside go_daughters color color_composite} {
 if {[lsearch $L_OK_recurse $C] == -1} {return}
 if {[$C Has_MetaData Comet_to_dot]} {
   if {[$C Val_MetaData Comet_to_dot] == $this(mark)} {return}
  }
 if {$C != $L_OK_recurse} {$C Add_MetaData Comet_to_dot $this(mark)}
 
 upvar $str_name str
 
 set inside_comets [CSS++ $C "#${C}(*) - #$C *"]
 append str $dec "  $C\[label=\"[[$C get_LC] get_name]\"\];\n"

 if {[lsearch [gmlObject info classes $C] Physical_model] != -1} {
   set prim [$C get_hiden_prim_elements]
   if {[lsearch $prim *] != -1} {
     set color           grey60
	 set color_composite green4
    }
  }
 
 if {$go_inside && $inside_comets != ""} {
     append str $dec "  subgraph cluster_$C {\n"
#     append str $dec "    label = \"$C\";\n"
     #puts "In subgraph of $C :\n  - inside_comets : {$inside_comets}"
	 if {$inside_comets != ""} {append str $dec "    $C \[shape=box, style=filled, fillcolor=$color_composite\];\n"}
       foreach d [$C get_daughters] {
	     append str $dec "    $C -> $d; \n"
	     this Comet_to_dot $d str "$dec  " $inside_comets [expr $go_inside - 1] 1 $color $color_composite
	    }
     append str $dec "   }\n"
	 foreach d [$C get_out_daughters] {
	   set m [$d get_mothers]
	   append str $dec "  $m -> $d;\n"
	   this Comet_to_dot $d str $dec $d 0 0 $color $color_composite
	  }
     if {$go_daughters} {
	   foreach d [$C get_out_daughters] {
	     if {[lsearch $L_OK_recurse $d] != -1} {
		   this Comet_to_dot $d str $dec $L_OK_recurse $go_inside $go_daughters $color $color_composite
		  }
        }
	  }
  } else {if {$inside_comets != ""} {
            append str $dec "  $C\[shape=box, style=filled, fillcolor=$color_composite\];\n"
		   } else {append str $dec "  $C\[style=filled, fillcolor=$color\];\n"}
          if {$go_daughters} {
		    foreach d [$C get_out_daughters] {
              if {[lsearch $L_OK_recurse $d] != -1} {
			    this Comet_to_dot $d str $dec $L_OK_recurse $go_inside $go_daughters $color $color_composite
                append str $dec "  $C -> $d;\n"
			   }
             }
		   }
		 }
		 
}
