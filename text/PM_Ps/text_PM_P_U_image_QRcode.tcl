inherit CometTexte_PM_P_U_QRcode PM_U_Container

#___________________________________________________________________________________________________________________________________________
method CometTexte_PM_P_U_QRcode constructor {name descr args} {
 this inherited $name $descr
	
	package require http
	this set_GDD_id TextDisplay_FUI_U_QRcode
	if {![info exists class(last_text_encoded)]} {
		 set class(last_text_encoded) ""
		 set class(image_file_name)   ""
		}
	
	set this(reconnect_LM) 0
   
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometTexte_PM_P_U_QRcode $L_methodes_set_Text {$this(FC)} {$this(L_actives_PM)}
Methodes_get_LC CometTexte_PM_P_U_QRcode $L_methodes_get_Text {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method CometTexte_PM_P_U_QRcode set_LM {LM} {
	this inherited $LM
	if {![info exists this(image)]} {
		 set this(image) [CPool get_a_comet CometImage]
		}
	this set_L_nested_handle_LM    $this(image)_LM_LP
	this set_L_nested_daughters_LM $this(image)_LM_LP

}

#___________________________________________________________________________________________________________________________________________
method CometTexte_PM_P_U_QRcode set_text {v} {
	if {$class(last_text_encoded) != $v} {
		 set class(last_text_encoded) $v
		 
		 # Get the image from internet
		 set class(last_file) $class(image_file_name)
		 set class(image_file_name) $::env(ROOT_COMETS)${objName}_[clock milliseconds].png
		 # puts "Save image into $class(image_file_name)\n\tcharset : $state(charset)\n\tcoding : $state(coding)"
	
		 set f [open $class(image_file_name) w+]
		 fconfigure $f -encoding binary
		::http::geturl http://api.qrserver.com/v1/create-qr-code/?[::http::formatQuery data $v size "200x200"] -channel $f -command [list $objName update_image $v $f]

		}
}

#___________________________________________________________________________________________________________________________________________
method CometTexte_PM_P_U_QRcode update_image {v stream token} {
	upvar #0 $token state
	
	if {$v != $class(last_text_encoded)} {
		 ::http::cleanup $token
		 close $stream
		 return
		}
		
	::http::cleanup $token
	close $stream
	
	# Update the CometImage with this file...
	if {[info exists this(image)]} {
		 # puts "$this(image) load_img $class(image_file_name)"
		 $this(image) load_img $class(image_file_name)
		} 
	
	if {[file exists $class(last_file)]} {file delete $class(last_file)}
	set class(last_file) $class(image_file_name)
	# puts end...
}

Trace CometTexte_PM_P_U_QRcode update_image