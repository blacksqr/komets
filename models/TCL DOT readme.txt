CONTENTS:

This zip file contains a MS Windows Tcldot package built with ActiveTcl 8.4.11.2 (threaded)
and the Graphviz files of version 2.7. ( 2.7.20051221.0540 )

USAGE:
extract the tcldot.zip into your ActiveTcl directory, so that the all DLLs other than tcldot.dll are
placed in the bin dir and the tcldot subdir with tcldot.dll and pkgIndex.tcl is placed in lib.

The test the package loading with:

package require Tk
package require Tcldot
set g [dotnew digraph]
set n1 [$g addnode]
set n2 [$g addnode]
$g addedge $n1 $n2
$g layout
set code [$g render]
set c [canvas .c -bg white]
pack $c -expand 1 -fill both
eval $code


KNOWN BUGS:
The 'write' method of the graph object does not work, as i do not (yet) know the correct magic on Windows
to get a FILE* from a Tcl_Channel object. 

Have fun
Michael Schlenker

mic42@users.sourceforge.net





