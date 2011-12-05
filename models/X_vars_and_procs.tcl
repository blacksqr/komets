if {[info exists interpretor_DSL_comet_interface]} {} else {
  DSL_interface_interpretor interpretor_DSL_comet_interface
 }

proc Aide_nom {v re} {
 if {[gmlObject info exists object $v]} {
	 set L_classes [gmlObject info classes $v]
	} else {if {[gmlObject info exists class $v]} {
				 set L_classes [concat $v [gmlObject info classes $v]]
				} else {error "There is no object nor class names $v."}
		   }
 foreach c $L_classes {
   puts "Class $c :"
   foreach m [gmlObject info methods $c] {
	 if {[regexp $re $m]} {catch {puts "\t$m {[gmlObject info arglist $c $m]}"}}
	}
  }
}


 proc xml2list {xml res_name} {
     upvar $res_name res

     regsub -all {>\s*<} [string trim $xml " \n\t<>"] "\} \{" xml
     set xml [string map {> "\} \{#text \{" < "\}\} \{"}  $xml]

     set res ""   ;# string to collect the result
     set stack {} ;# track open tags
     set rest {}
     foreach item "{$xml}" {
         switch -regexp -- $item {
            ^# {append res "{[lrange $item 0 end]} " ; #text item}
            ^/ {
                regexp {/(.+)} $item -> tagname ;# end tag
                set expected [lindex $stack end]
                if {$tagname!=$expected} {error "$item != $expected"}
                set stack [lrange $stack 0 end-1]
                append res "\}\} "
          }
            /$ { # singleton - start and end in one <> group
               regexp {([^ ]+)( (.+))?/$} $item -> tagname - rest
               set rest [lrange [string map {= " "} $rest] 0 end]
               append res "{$tagname [list $rest] {}} "
            }
            default {
               set tagname [lindex $item 0] ;# start tag
               set rest [lrange [string map {= " "} $item] 1 end]
               lappend stack $tagname
               append res "\{$tagname [list $rest] \{"
            }
         }
         if {[llength $rest]%2} {error "att's not paired: $rest"}
     }
     if [llength $stack] {error "unresolved: $stack"}
     string map {"\} \}" "\}\}"} [lindex $res 0]
 }


#_________________________________________________________________________________________________________________________________
proc list2xml {list res_name} {
    upvar $res_name res

    switch -- [llength $list] {
        2 {lindex $list 1}
        3 {
            foreach {tag attributes children} $list break
            set res <$tag
            foreach {name value} $attributes {
                append res " $name=\"$value\""
            }
            if [llength $children] {
                append res >
                foreach child $children {
                    append res [list2xml $child]
                }
                append res </$tag>
            } else {append res />}
        }
        default {error "could not parse $list"}
    }
 }
