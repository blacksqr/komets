function CometHierarchy_PM_P_tree_HTML__switch_plus_minus(id, id_d, i) {
 //alert (i);
 var p_m = "plus.png"
 if(i == 1) {p_m = "minus.png"}
 
 $('#' + id).html("<img src=\"./Comets/hierarchy/PM_Ps/HTML/images/" + p_m + "\"/>");
 $('#' + id).attr('onclick', '');
 $('#' + id).unbind('click').click( function () {CometHierarchy_PM_P_tree_HTML__switch_plus_minus(id, id_d, (1-i));} );
 $('#' + id_d).toggle('blind');
}
