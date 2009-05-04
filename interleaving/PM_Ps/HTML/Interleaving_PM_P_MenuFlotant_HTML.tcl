#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Interleaving_PM_P_MenuFlotant_HTML PM_HTML
#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_MenuFlotant_HTML constructor {name descr args} {
 this inherited $name $descr
 eval "$objName configure $args"
}
#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_MenuFlotant_HTML Render {strm_name {dec {}}} {
upvar $strm_name strm
append strm $dec {<DIV id=" } [this get_name] { " STYLE="position:absolute; top:10; left:10" onMouseDown="javascript:testClick(id)"  style="cursor:move"> } "\n"
append strm $dec "  " {<TABLE BORDER=1 CELLPADDING=1 CELLSPACING=2 WIDTH=300>} "\n"
append strm $dec "  " "  " {<TR >} "\n"
append strm $dec "  " "  " "  " {<TD>} "\n"
append strm $dec "  " "  " "  " "  " { <TABLE onMouseOut="disparition('edit')" onMouseOver="apparition('edit')" BORDER=0 CELLPADDING=0 CELLSPACING=0 > } "\n"
append strm $dec "  " "  " "  " "  " "  " { <tr> } "\n"
append strm $dec "  " "  " "  " "  " "  " "  " {<TD BGCOLOR=#000000  >} "\n"
append strm $dec "  " "  " "  " "  " "  " "  " "  " {<FONT SIZE=2 face="Verdana" COLOR=#FFCC00><B> } [eval [this get_LC] get_name ] {</B></FONT>} "\n"
append strm $dec "  " "  " "  " "  " "  " "  " {</TD>} "\n"
append strm $dec "  " "  " "  " "  " "  " { </Tr> } "\n"
append strm $dec "  " "  " "  " "  " "  " { <TR weight = 0>} "\n"
append strm $dec "  " "  " "  " "  " "  " "  " {<TD BGCOLOR=#000000 COLOR=#FFCC00>} "\n"
append strm $dec "  " "  " "  " "  " "  " "  " "  " {<DIV  id= "edit" style="visibility: hidden;">} "\n"
append strm $dec "  " "  " "  " "  " "  " "  " "  " "  " {<IMG SRC="left.gif" Height="12"> Edit}  "\n"
append strm $dec "  " "  " "  " "  " "  " "  " "  " "  " {<A HREF="#" onclick="document.location.reload();return(false)"><IMG SRC="refresh.gif" Height="12"></A> Edit}  "\n"
append strm $dec "  " "  " "  " "  " "  " "  " "  " "  " {<A href="javascript:expandPara( 'fonctionEdit' )"> Edit</A>}   "\n"
append strm $dec "  " "  " "  " "  " "  " "  " "  " "  " {<A  href="javascript:expandPara( 'menu1' )"> Reduire</A>}   "\n"
append strm $dec "  " "  " "  " "  " "  " "  " "  " {</DIV>} "\n"
append strm $dec "  " "  " "  " "  " "  " "  " "  " {<P Id = "fonctionEdit" style="display: none;"> }   "\n"
append strm $dec "  " "  " "  " "  " "  " "  " "  " "  " {<input type="radio" name="cometEclate" value="oui" checked="checked" /> Eclater la comet <br/>}   "\n"
append strm $dec "  " "  " "  " "  " "  " "  " "  " "  " {<input type="radio" name="cometEclate" value="non"  /> Rassembler la comet <br/>}   "\n"
append strm $dec "  " "  " "  " "  " "  " "  " "  " "  " {<input type="submit" value="OK" />}   "\n"
append strm $dec "  " "  " "  " "  " "  " "  " "  " {</P></br>} "\n"
append strm $dec "  " "  " "  " "  " "  " "  " {</TD>} "\n"
append strm $dec "  " "  " "  " "  " "  " {</TR>} "\n"
append strm $dec "  " "  " "  " "  " {</TABLE> } "\n"
append strm $dec "  " "  " "  " {</TD>} "\n"
append strm $dec "  " "  " {</TR>} "\n"
append strm $dec "  " "  " {<TR>} "\n"
append strm $dec "  " "  " "  " {<TABLE BORDER=1 CELLPADDING=1 CELLSPACING=2 WIDTH=300 id ="menu1" style="display: block;" > } "\n"
this Render_daughters strm "$dec        "
append strm $dec "  " "  " "  " {</TABLE>} "\n"
append strm $dec "  " "  " {</TR>} "\n"
append strm $dec "  "  {</TABLE>} "\n"
append strm $dec {</DIV> } "\n"
append strm $dec { <TABLE BORDER=1 CELLPADDING=1 CELLSPACING=2><TR ><TD><div id="montexte"></div></TD></TR> } "\n"
}

#__________________________________________________
Methodes_set_LC Interleaving_PM_P_MenuFlotant_HTML [P_L_methodes_set_CometInterleaving] {}  {}
Methodes_get_LC Interleaving_PM_P_MenuFlotant_HTML [P_L_methodes_get_CometInterleaving] {}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_MenuFlotant_HTML Render_daughters {strm_name {dec {}}} {
 upvar $strm_name rep
 set L   [eval [this get_LC] get_daughters]
 set pos 0
 foreach c [ this get_daughters] {
	  set txt {}
	  $c Render_all txt "" 
	  set txt [regsub -all "\n" $txt {}]
	  set txt [regsub -all "\"" $txt " \\\' "]	
	 
    append rep $dec {<TR><TD BGCOLOR=#9FB1D8 NOWRAP><FONT SIZE=2 face="Verdana">&nbsp;<A CLASS=ejsmenu    href="javascript:afficher( ' } $txt { ' )" >} [eval [lindex $L $pos] get_name] {</A></FONT>&nbsp;</TD></TR>} "\n"
   incr pos
  }

}