set found_Gmlobject 0
if {[lsearch [info commands] method] >= 0} {set found_Gmlobject 1}

if {[lsearch [info proc] Comet_files_root] == -1} {
 cd ..
   set cfr [pwd]/
 cd Comets
  set comet_files_root ""
  proc Comet_files_root {{d {}}} {
   global comet_files_root;
   if {[string length $d] == 0} {
     return $comet_files_root
    } else {return [set comet_files_root $d]}
  }
 Comet_files_root $cfr
}

if {!$found_Gmlobject} {
    if {[catch {load [Comet_files_root]Comets/gmlObject.dll} err]} {
	if {[catch {load [Comet_files_root]Comets/libgiltclobject.so} err]} {
	    catch {puts "Impossible to load the binary version of gmlObject, trying to load the TCL version..."}
	    source [Comet_files_root]Comets/gml_Object.old_tcl
	} else {
	    proc gmlObject args { eval "gilObject $args"}
	    catch {puts "linux compiled gml lib loaded"}
	}
    }
} else {catch {puts "gmlObject has still been loaded"}}
