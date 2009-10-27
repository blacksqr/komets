if {[catch "load gmlObject.dll" err]} {
 puts "Impossible to load the binary version of gmlObject, trying to load the TCL version..."
 source gml_Object.old_tcl
}

