inherit PM_P_treectrl_TK PM_TK
package require treectrl 2.0

#_________________________________________________________________________________________________________
method PM_P_treectrl_TK constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CT_Hierarchy_AUI_basic_CUI_tree_ala_explorer_TK
   set this(columnID) 0
 
 eval "$objName configure $args"
}

#_________________________________________________________________________________________________________
method PM_P_treectrl_TK dispose {} {this inherited}

#_________________________________________________________________________________________________________
Methodes_set_LC PM_P_treectrl_TK [L_methodes_set_hierarchy] {} {}
Methodes_get_LC PM_P_treectrl_TK [L_methodes_get_hierarchy] {$this(FC)}

#_________________________________________________________________________________________________________
method PM_P_treectrl_TK refresh {} {
 puts "$objName refresh.\n  root : [this get_element_root]"
 $this(mytree) item element configure root 0 elemText -text [this get_element_root]
 set this(Item_element,0) [this get_element_root]
 this Add_child_items $this(mytree) 0
}

#_________________________________________________________________________________________________________
method PM_P_treectrl_TK get_or_create_prims {root} {

	set LM              [this get_LM]
	set this(common_FC) [$LM get_Common_FC]

	set this(element_root) 		[$this(common_FC) get_element_root]
	set this(ll_cmd)		[$this(common_FC) get_ll_cmd]
	set this(Item_element,0) 	"$this(element_root)"


	############

	set this(root)	$root

	set tree_name "$root.tk_${objName}_tree"
          set this(mytree) [treectrl $tree_name -width 250 -height 300 -showrootbutton yes]
#  	  pack $this(mytree) -expand yes -fill both
          set columnID [$this(mytree) column create -text [this get_element_root] -width 240]
          set this(columnID) $columnID

	$this(mytree) configure -treecolumn $columnID

	$this(mytree) element create elemBorder 	border -background #ece9d8 -filled yes -relief solid -thickness 1
	$this(mytree) element create elemBorder2 	border -background #E0FFE0 -filled yes -relief solid -thickness 1
	$this(mytree) element create elemText text

	$this(mytree) style create style1
	$this(mytree) style elements style1 {elemBorder elemText}
	$this(mytree) style layout style1 elemBorder -union {elemText} -ipadx 4 -ipady 4
	$this(mytree) style layout style1 elemText

	$this(mytree) style create style2
	$this(mytree) style elements style2 {elemBorder2 elemText}
	$this(mytree) style layout style2 elemBorder2 -union {elemText} -ipadx 4 -ipady 4
	$this(mytree) style layout style2 elemText

	$this(mytree) item configure root -button yes
	$this(mytree) item style set root $columnID style1
	$this(mytree) item element configure root $columnID elemText -text [this get_element_root]


    set cmd get_daughters

	append L_daughters_Root " " [$this(element_root) $cmd]
	set cmd_list "list $L_daughters_Root"
	set L_daughters_Root [eval $cmd_list]

	foreach n $L_daughters_Root {
		set itemID [$this(mytree) item create -button yes]
		set this(Item_element,$itemID) $n
		$this(mytree) item collapse $itemID
		$this(mytree) item style set $itemID $columnID style2
		$this(mytree) item element configure $itemID $columnID elemText -text $n
		$this(mytree) item lastchild root $itemID
	}


	$this(mytree) notify bind $this(mytree) <Expand-before> "$objName Add_child_items %T %I"
	$this(mytree) notify bind root          <ActiveItem>    "$objName maj_active_elt %c"

	set L 	[list $tree_name]
	return 	[this set_prim_handle $L]

}
#_________________________________________________________________________________________________________
method PM_P_treectrl_TK Add_child_items { tree parent } {
        puts "$objName Add_child_items $tree $parent\n  Comet to deploy : $this(Item_element,$parent)"
	set depth [$tree depth $parent]

	if {[expr $depth % 2] == 1} {
		set style style1
	} else {set style style2 }

	set l_cmd	[$this(common_FC) get_cmd $depth]
	set name	[lindex $l_cmd 1]
	set cmd 	[lindex $l_cmd 2]

	set L_daughters [list]

	if { $name != {} } {
		set L_daughters [lappend L_daughters $name]
	}

	set name_element       $this(Item_element,$parent)
#	set name_element       [$tree item element cget root 0 elemText -text]
	append L_daughters " " [$name_element $cmd]
	set cmd_list "list $L_daughters"
	set L_daughters [eval $cmd_list]
	puts "  L_daughters : \{$L_daughters\}"
        set nb_daughters [llength $L_daughters]

#	if {[$tree item numchildren $parent] == $nb_daughters} return
#	# plus ou moins un (nested)
        set nb_childs [$tree item numchildren $parent]
        puts "nb_childs : $nb_childs"
	if {$nb_childs > 0} {
		set first 	[$tree item firstchild $parent]
		set last 	[$tree item lastchild $parent]
		$tree item delete $first $last
	}

	set columnID first

	foreach n $L_daughters {
 		set itemID [$tree item create -button yes]
 		set this(Item_element,$itemID) $n
        $tree item collapse $itemID
        $tree item style set $itemID $columnID $style
        $tree item element configure $itemID $columnID elemText -text "$n"
        $tree item lastchild $parent $itemID
 	}

 return
}
#_________________________________________________________________________________________________________
method PM_P_treectrl_TK maj_active_elt { active_elt } {
 puts "$objName maj_active_elt $active_elt"
 [this get_LC] set_currents $this(Item_element,$active_elt)
}
#_________________________________________________________________________________________________________
method PM_P_treectrl_TK set_element_root {r} {
 [this get_Common_FC] set_element_root $r
 this refresh
}
#_________________________________________________________________________________________________________
method PM_P_treectrl_TK set_currents {lc} {
# this refresh
}

