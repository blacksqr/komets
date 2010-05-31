proc File_read {f_name} {
  set f [open $f_name r]
  set rep [read $f]
  close $f
  
  return $rep
}

proc File_save {f_name str} {
  set f [open $f_name w]
  puts $f $str
  close $f
}

