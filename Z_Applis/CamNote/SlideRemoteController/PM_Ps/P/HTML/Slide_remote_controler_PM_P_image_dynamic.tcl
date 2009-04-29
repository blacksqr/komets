
inherit CometSlideRemoteController_PM_P_HTML_image_dynamic PM_HTML

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometSlideRemoteController_PM_P_HTML_image_dynamic constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id N_controller_CUI_basic_gfx_skinnable_simple_HTML
   set this(num_to_set) 0
   set this(t_ms)	    500
   set class(mark)      0
   set this(L_boutons)  [list go_to_bgn go_to_nxt go_to_prv go_to_end]
   set this(dir)        {./Comets/Z_Applis/CamNote/SlideRemoteController/PM_Ps/P/HTML}
   this read_style_from_file $this(dir)/Skins/skin1.xml
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometSlideRemoteController_PM_P_HTML_image_dynamic get_mark {}  {return $class(mark)}
method CometSlideRemoteController_PM_P_HTML_image_dynamic set_mark {m} {set class(mark) $m}

#___________________________________________________________________________________________________________________________________________
#method CometSlideRemoteController_PM_P_HTML_image_dynamic go_to_bgn {} {[this get_LC] set_val [this get_b_inf]}
#method CometSlideRemoteController_PM_P_HTML_image_dynamic go_to_prv {} {[this get_LC] set_val [expr ([this get_val]-1 < [this get_b_inf])?[this get_b_inf]:[this get_val]-1]}
#method CometSlideRemoteController_PM_P_HTML_image_dynamic go_to_nxt {} {[this get_LC] set_val [expr ([this get_val]+1 > [this get_b_sup])?[this get_b_sup]:[this get_val]+1]}
#method CometSlideRemoteController_PM_P_HTML_image_dynamic go_to_end {} {[this get_LC] set_val [this get_b_sup]}
#___________________________________________________________________________________________________________________________________________
Generate_PM_setters CometSlideRemoteController_PM_P_HTML_image_dynamic [L_methodes_set_SlideRemoteController]
#___________________________________________________________________________________________________________________________________________

method CometSlideRemoteController_PM_P_HTML_image_dynamic dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
Generate_accessors CometSlideRemoteController_PM_P_HTML_image_dynamic [list t_ms]

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometSlideRemoteController_PM_P_HTML_image_dynamic $L_methodes_set_choicesN {$this(FC)} {}
Methodes_get_LC CometSlideRemoteController_PM_P_HTML_image_dynamic $L_methodes_get_choicesN {$this(FC)}
Methodes_set_LC CometSlideRemoteController_PM_P_HTML_image_dynamic [L_methodes_set_SlideRemoteController] {$this(FC)} {}
Methodes_get_LC CometSlideRemoteController_PM_P_HTML_image_dynamic [L_methodes_get_SlideRemoteController] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________

#___________________________________________________________________________________________________________________________________________
method CometSlideRemoteController_PM_P_HTML_image_dynamic Render_JS {strm_name mark {dec {}}} {
 upvar $strm_name strm
 if {$mark != [this get_mark]} {
   append strm $dec {function RemotControl_cmd(telec, action) } "\{\n"
   append strm $dec {  document.forms["root"].elements["pipo_button"].value =  telec + "__XXX__" + action ;} "\n"
   append strm $dec {  document.root.submit();} "\n"
   append strm $dec " \}\n"
   append strm $dec "function show(id){\n"
   append strm $dec "  if(document.getElementById){tabler = document.getElementById(id);tabler.style.display=\"inline\";}}\n"
   append strm $dec "function hide(id){ \n"
   append strm $dec "  if(document.getElementById){tabler = document.getElementById(id);tabler.style.display=\"none\";}}\n"
  }

 this set_mark $mark
 this Render_daughters_JS strm $mark $dec
}

#___________________________________________________________________________________________________________________________________________
method CometSlideRemoteController_PM_P_HTML_image_dynamic read_style_from_file {f_name} {
 set f [open $f_name]
   set txt [read $f]
 close $f

 set L {}; xml2list $txt L
   set L [lindex $L 0]
   foreach e [lindex $L 2] {
 	 set name [lindex $e 0]
     foreach {att val} [lindex $e 1] {
	   set this($name,$att) $val
	  }
    }   
}
#___________________________________________________________________________________________________________________________________________
method CometSlideRemoteController_PM_P_HTML_image_dynamic Render {strm_name {dec {}}} {
 upvar $strm_name strm

 append strm $dec {<div } [this Style_class] { style="position: relative;">} "\n"
 append strm $dec {<span style="position: absolute;">} "\n"
# append strm $dec {<span>} "\n"

 # Les boutons
 append strm $dec {  <div style="z-index:2; position:absolute; text-align:center; color:} $this(z_txt,color) {; width:} $this(z_txt,width) {; left:} $this(z_txt,x) {; top:} $this(z_txt,y) {;" id="} ${objName}_txt_num {">} "\n"
 foreach bt $this(L_boutons) {
   append strm $dec "    <span id=\"${objName}_txt_$bt\" style=\"display:none\">$this($bt,text)</span>\n"
  }
 append strm $dec {  </div>} "\n"

 foreach bt $this(L_boutons) {
	append strm $dec {  <img style="z-index:2; position:absolute; left:} $this($bt,x) {; top:} $this($bt,y) {;" id="} ${objName}_$bt {" src="} $this(dir)/Skins/$this($bt,img) {" onclick="javascript:RemotControl_cmd('} $objName {', 'prim_} $bt {')" onmouseout="hide('} ${objName}_txt_$bt {')" onmouseover="show('} ${objName}_txt_$bt {')" />} "\n"
  }

 append strm $dec {  <div style="position:absolute; top:} $this(go_to_slide,y) {; left:} $this(go_to_slide,x) {;" id="} $objName {_div_select">} "\n"
 append strm $dec {  <select id="} ${objName}_select {" name="} $objName {__XXX__prim_set_current" value="[this get_val]">} "\n$dec    "
 for {set i [this get_b_inf]} {$i <= [this get_b_sup]} {incr i [this get_step]} {
    append strm "<option value=\"$i\" " {onmouseup="javascript:document.root.submit();"}
	  if {$i == [this get_val]} {append strm { selected="selected"}}
	append strm ">$i</option>"
  }
 append strm "\n$dec  </select>\n"
 append strm $dec "  </div>\n"
 append strm $dec {</span>} "\n"

 # Le fond
 append strm $dec {  <img style="z-index:1" src="} $this(dir)/Skins/$this(bg,img) {" />} "\n"

 append strm $dec "</div>\n"
}
