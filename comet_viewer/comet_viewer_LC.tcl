inherit CometViewer Logical_consistency

#_________________________________________________________________________________________________________
#_________________________________________________________________________________________________________
#_________________________________________________________________________________________________________
method CometViewer constructor { name descr args} {
    this inherited $name $descr
	  this set_GDD_id CT_CometViewer
	this set_nb_max_daughters 0
	set this(CFC) ${objName}_CFC; CometViewer_CFC $this(CFC)
	  this set_Common_FC $this(CFC)
	
	set this(LM_LP) "${objName}_LM_LP"
	CometViewer_LM_P $this(LM_LP) "${name}_LM_LP" "The logical presentation of $name"
	this Add_LM $this(LM_LP);

	set this(LM_FC) "${objName}_LM_FC"
	CometViewer_LM_FC $this(LM_FC) "${name}_LM_FC" "The logical function core of $name"
	this Add_LM $this(LM_FC);

 eval "$objName configure $args"
 return $objName
}

#_________________________________________________________________________________________________________
method CometViewer dispose {} {this inherited}

#_________________________________________________________________________________________________________
#_________________________________________________________________________________________________________
#_________________________________________________________________________________________________________
Methodes_set_LC CometViewer [L_methodes_set_CometViewer] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometViewer [L_methodes_get_CometViewer] {$this(FC)}

#_________________________________________________________________________________________________________
method CometViewer Enlight_with_CSS {CSS_expr} {
 set L_nodes  [CSS++ [this get_L_roots] $CSS_expr]
 this Enlight $L_nodes
}
