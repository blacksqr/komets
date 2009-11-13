set found_Gmlobject 0
foreach loaded_dll [info loaded] {
  if {[string equal [lindex $loaded_dll 1] Gmlobject]} {set found_Gmlobject 1; break}
 }

if {!$found_Gmlobject} {
	if {[catch {load [Comet_files_root]Comets/gmlObject.dll} err]} {
	 puts "Impossible to load the binary version of gmlObject, trying to load the TCL version..."
	 source [Comet_files_root]Comets/gml_Object.old_tcl
	}
} else {puts "gmlObject has still been loaded"}
