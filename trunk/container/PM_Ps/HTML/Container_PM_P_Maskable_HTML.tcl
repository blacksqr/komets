#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Container_PM_P_Maskable_HTML PM_HTML
#___________________________________________________________________________________________________________________________________________
method Container_PM_P_Maskable_HTML constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Container_Maskable_HTML
   this set_mark 0
   
 set this(pos_x) 0
 set this(pos_y) 0
 set this(width) 250
 set this(height) 100
 set this(visibility) 1
 set this(opacity) 10
 set this(layer) 50
 set this(is_movable) 1
 set this(is_resizable) 1
 set this(is_maskable) 1
 set this(is_opacifiable) 1
 
 this set_AJAX_id_for_daughters ${objName}_inside

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_Maskable_HTML get_mark {}  {return $class(mark)}
method Container_PM_P_Maskable_HTML set_mark {m} {set class(mark) $m}

#___________________________________________________________________________________________________________________________________________
Generate_accessors Container_PM_P_Maskable_HTML [list pos_x pos_y is_movable is_resizable is_maskable is_opacifiable visibility width height]

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_Maskable_HTML set_height {v} {set this(height) [string map [list { } {} {px} {} {%} {}] $v]}
method Container_PM_P_Maskable_HTML set_width  {v} {set this(width)  [string map [list { } {} {px} {} {%} {}] $v]}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_Maskable_HTML Render_JS {strm_name mark {dec {}}} {
 upvar $strm_name strm
 if {$mark != [this get_mark]} {
   #retourne la valeur de la position x de la liste
   append strm $dec "  function fnWinX(l) \{\n"
   append strm $dec "    return (l.split('|'))\[0\];\n"
   append strm $dec "  \}\n"
   
   #retourne la valeur de la position y de la liste
   append strm $dec "  function fnWinY(l) \{\n"
   append strm $dec "    return (l.split('|'))\[1\];\n"
   append strm $dec "  \}\n"
   
   #retourne la valeur de la largeur de la liste
   append strm $dec "  function fnWinWidth(l) \{\n"
   append strm $dec "    return (l.split('|'))\[2\];\n"
   append strm $dec "  \}\n"
   
   #retourne la valeur de la hauteur de la liste
   append strm $dec "  function fnWinHeight(l) \{\n"
   append strm $dec "    return (l.split('|'))\[3\];\n"
   append strm $dec "  \}\n"
   
   #retourne la valeur de la visibilite de la liste
   append strm $dec "  function fnWinVisibility(l) \{\n"
   append strm $dec "    return (l.split('|'))\[4\];\n"
   append strm $dec "  \}\n"
   
   #retourne la valeur de l'opacite de la liste
   append strm $dec "  function fnWinOpacity(l) \{\n"
   append strm $dec "    return (l.split('|'))\[5\];\n"
   append strm $dec "  \}\n"
   
   #retourne la valeur du numero de calque (z-index)
   append strm $dec "  function fnWinZIndex(l) \{\n"
   append strm $dec "    return (l.split('|'))\[6\];\n"
   append strm $dec "  \}\n"
   
   #retourne la liste des valeurs mise a jour avec la nouvelle valeur passee en parametre
   append strm $dec "  function fnWinUpdPropertie(l, num, val) \{\n"
   append strm $dec "    var allProperties = l.split('|');\n"
   append strm $dec "    allProperties\[num\] = val;\n"
   append strm $dec "    return (allProperties.join('|'));\n"
   append strm $dec "  \}\n"
   
   # variables utilisees pour le conteneur
   append strm $dec "  var vgCurrentAction = null;\n"
   append strm $dec "  var vgCurrentElement = null;\n"
   append strm $dec "  var ogCurrentElement = null;\n"
   append strm $dec "  var vgCurrentElementX = 0;\n"
   append strm $dec "  var vgCurrentElementY = 0;\n"
   append strm $dec "  var vgCurrentElementWidth = 0;\n"
   append strm $dec "  var vgCurrentElementHeight = 0;\n"
   append strm $dec "  var vgCurrentIntervalX = 0;\n"
   append strm $dec "  var vgCurrentIntervalY = 0;\n"
   append strm $dec "  var vgMouseX = 0;\n"
   append strm $dec "  var vgMouseY = 0;\n"
   append strm $dec "  var vgCurrentMouseX = 0;\n"
   append strm $dec "  var vgCurrentMouseY = 0;\n"
   append strm $dec "  var vgMouseState = 'up';\n"
   
    append strm $dec "  function fnCurrentElement(el) \{\n"
    append strm $dec "    if (vgMouseState!='down') \{\n"
    append strm $dec "      if (el == null) \{\n"
    append strm $dec "        vgCurrentElement = null;\n"
    append strm $dec "        ogCurrentElement = null;\n"
    append strm $dec "      \}\n"
    append strm $dec "      else \{\n"
    append strm $dec "        vgCurrentElement = el;\n"
    append strm $dec "        ogCurrentElement = document.getElementById(el);\n"
    append strm $dec "      \}\n"
    append strm $dec "    \}\n"
    append strm $dec "  \}\n"
    
    append strm $dec "  function fnCurrentAction(ac) \{\n"
    append strm $dec "    if (vgMouseState!='down') \{\n"
    append strm $dec "      if (ac == null) \{\n"
    append strm $dec "        vgCurrentAction = null;\n"
    append strm $dec "      \}\n"
    append strm $dec "      else \{\n"
    append strm $dec "        vgCurrentAction = ac;\n"
    append strm $dec "      \}\n"
    append strm $dec "    \}\n"
    append strm $dec "  \}\n"
    
    append strm $dec "  function fnZIndexFg() \{\n"
    append strm $dec "    var els = document.getElementsByName('window_container');\n"
    append strm $dec "    var zIndexMax = 0;\n"
    append strm $dec "    for (var i = 0 ; i<els.length ; i++) \{\n"
    append strm $dec "      var zIndexCurrent = parseInt(els\[i\].style.zIndex);\n"
    append strm $dec "      if (zIndexMax < zIndexCurrent) \{\n"
    append strm $dec "        zIndexMax = zIndexCurrent;\n"
    append strm $dec "      \}\n"
    append strm $dec "    \}\n"
    append strm $dec "    return zIndexMax;\n"
    append strm $dec "  \}\n"
   
    append strm $dec "  // utilisee pour le debogage\n"
    append strm $dec "  function fnCurrentProperties(el) \{\n"
    append strm $dec "    var infos = document.getElementById(el+'_infos');\n"
    append strm $dec "    if (infos!=null) \{\n"
    append strm $dec "      infos.innerHTML = 'currentElement : '+vgCurrentElement+'<br>currentAction : '+vgCurrentAction+'<br>mouseState : '+vgMouseState+'<br>mouseX, mouseY : '+vgMouseX+','+vgMouseY+'<br>currentMouseX, currentMouseY : '+vgCurrentMouseX+','+vgCurrentMouseY+'<br>currentIntervalX, currentIntervalY : '+vgCurrentIntervalX+','+vgCurrentIntervalY+'<br>currentElementWidth : '+vgCurrentElementWidth+'<br>currentElementHeight : '+vgCurrentElementHeight+'<br>currentElementX : '+vgCurrentElementX+'<br>currentElementY : '+vgCurrentElementY+'<br>SAUVEGARDE : '+document.getElementById(el+'__XXX__WinProperties').value;\n"
    append strm $dec "    \}\n"
    append strm $dec "  \}\n"
   
  append strm $dec "  function fnEvents() \{\n"
  append strm $dec "    document.onmousedown = function(e) \{\n"
  append strm $dec "      vgMouseState = 'down';\n"
  append strm $dec "      // on enregistre l'emplacement du clic initial\n"
  append strm $dec "      vgMouseX = (navigator.appName.substring(0,3) == 'Net') ? e.pageX : event.x+document.body.scrollLeft;\n"
  append strm $dec "      vgMouseY = (navigator.appName.substring(0,3) == 'Net') ? e.pageY : event.y+document.body.scrollTop;\n"
  append strm $dec "      if (vgCurrentElement!=null && ogCurrentElement!=null) \{\n"
  append strm $dec "        switch (vgCurrentAction) \{\n"
  append strm $dec "          case 'move':\n"
  append strm $dec "            // on enregistre l'emplacement de l'element\n"
  append strm $dec "            vgCurrentElementX = ogCurrentElement.offsetLeft;\n"
  append strm $dec "            vgCurrentElementY = ogCurrentElement.offsetTop;\n"
  append strm $dec "            // on positionne l'element au premier plan\n"
  append strm $dec "            ogCurrentElement.style.zIndex = fnZIndexFg() + 1;\n"
  append strm $dec "            break;\n"
  append strm $dec "          case 'resize':\n"
  append strm $dec "            // on enregistre la taille de l'element\n"
  append strm $dec "            vgCurrentElementWidth = parseInt(ogCurrentElement.style.width);\n"
  append strm $dec "            vgCurrentElementHeight = parseInt(ogCurrentElement.style.height);\n"
  append strm $dec "            break;\n"
  append strm $dec "          default :\n"
  append strm $dec "            break;\n"
  append strm $dec "        \}\n"
  append strm $dec "      \}\n"
  append strm $dec "      //fnCurrentProperties(vgCurrentElement);\n"
  append strm $dec "    \}\n"
  append strm $dec "    document.onmouseup = function(e) \{\n"
  append strm $dec "      if (vgCurrentElement!=null && ogCurrentElement!=null) \{\n"
  append strm $dec "        // on recupere le champ hidden qui va servir a la sauvegarde\n"
  append strm $dec "        var backup = document.getElementById(vgCurrentElement+'__XXX__WinProperties');\n"
  append strm $dec "        switch (vgCurrentAction) \{\n"
  append strm $dec "          case 'move':\n"
  append strm $dec "            // sauvegarde de la nouvelle position\n"
  append strm $dec "            if (backup!=null) \{\n"
  append strm $dec "              vgCurrentElementX = parseInt(ogCurrentElement.style.left);\n"
  append strm $dec "              vgCurrentElementY = parseInt(ogCurrentElement.style.top);\n"
  append strm $dec "              var updList = fnWinUpdPropertie(backup.value, 0, vgCurrentElementX);\n"
  append strm $dec "              updList = fnWinUpdPropertie(updList, 1, vgCurrentElementY);\n"
  append strm $dec "              backup.value = fnWinUpdPropertie(updList, 6, ogCurrentElement.style.zIndex);\n"
  append strm $dec "            \}\n"
  append strm $dec "            // remise a zero des variables utilisees\n"
  append strm $dec "            vgCurrentElementX = 0;\n"
  append strm $dec "            vgCurrentElementY = 0;\n"
  append strm $dec "            break;\n"
  append strm $dec "          case 'resize':\n"
  append strm $dec "            // sauvegarde de la nouvelle taille\n"
  append strm $dec "            if (backup!=null) \{\n"
  append strm $dec "              vgCurrentElementWidth = parseInt(ogCurrentElement.style.width);\n"
  append strm $dec "              vgCurrentElementHeight = parseInt(ogCurrentElement.style.height);\n"
  append strm $dec "              var updList = fnWinUpdPropertie(backup.value, 2, vgCurrentElementWidth);\n"
  append strm $dec "              backup.value = fnWinUpdPropertie(updList, 3, vgCurrentElementHeight);\n"
  append strm $dec "            \}\n"
  append strm $dec "            // remise a zero des variables utilisees\n"
  append strm $dec "            vgCurrentElementWidth = 0;\n"
  append strm $dec "            vgCurrentElementHeight = 0;\n"
  append strm $dec "            break;\n"
  append strm $dec "          case 'mask':\n"
  append strm $dec "            // on n'affiche pas le contenu ni le redimensionneur\n"
  append strm $dec "            var resize_selector  = document.getElementById(vgCurrentElement+'_resize_selector');\n"
  append strm $dec "            var conteneur_inside = document.getElementById(vgCurrentElement+'_inside');\n"
  append strm $dec "              if (resize_selector  !=null)  \{resize_selector.style.display  = 'none';\}\n"
  append strm $dec "              if (conteneur_inside != null) \{conteneur_inside.style.display = 'none';\}\n"
  append strm $dec "            // on recupere le selecteur de modification de masquage\n"
  append strm $dec "            var mask_selector = document.getElementById(vgCurrentElement+'_mask_selector');\n"
  append strm $dec "            // on recupere le selecteur de modification d'affichage\n"
  append strm $dec "            var unmask_selector = document.getElementById(vgCurrentElement+'_unmask_selector');\n"
  append strm $dec "            // on reduit la fenetre\n"
  append strm $dec "            ogCurrentElement.style.height = '';\n"
  append strm $dec "            if (mask_selector!=null && unmask_selector!=null) \{\n"
  append strm $dec "              mask_selector.style.display   = 'none';\n"
  append strm $dec "              unmask_selector.style.display = 'inline';\n"
  append strm $dec "            \}\n"
  append strm $dec "            // on enregistre le fait que le contenu de la fenetre soit masque \n"
  append strm $dec "            if (backup!=null) \{\n"
  append strm $dec "              var updList = fnWinUpdPropertie(backup.value, 4, 0);\n"
  append strm $dec "              backup.value = updList;\n"
  append strm $dec "            \}\n"
  append strm $dec "            break;\n"
  append strm $dec "          case 'unmask':\n"
  append strm $dec "            // Retaillable???\n"
  append strm $dec "            var is_movable = document.getElementById(vgCurrentElement+'_is_movable');\n"
  append strm $dec "            // on n'affiche pas le contenu ni le redimensionneur\n"
  append strm $dec "            var resize_selector  = document.getElementById(vgCurrentElement+'_resize_selector');\n"
  append strm $dec "            var conteneur_inside = document.getElementById(vgCurrentElement+'_inside');\n"
  append strm $dec "              if (resize_selector  !=null)  \{resize_selector.style.display  = 'block';\}\n"
  append strm $dec "              if (conteneur_inside != null) \{conteneur_inside.style.display = 'block';\}\n"
  append strm $dec "            // on recupere le selecteur de modification de masquage\n"
  append strm $dec "            var mask_selector   = document.getElementById(vgCurrentElement+'_mask_selector');\n"
  append strm $dec "            // on recupere le selecteur de modification d'affichage\n"
  append strm $dec "            var unmask_selector = document.getElementById(vgCurrentElement+'_unmask_selector');\n"
  append strm $dec "            // Is the container movable? \n"
  append strm $dec "            var is_movable      = document.getElementById(vgCurrentElement+'_is_movable').value;\n"
  append strm $dec "            // on restaure la fenetre\n"
  append strm $dec "            if (backup!=null) \{\n"
  append strm $dec "              if (is_movable == 1) \{ogCurrentElement.style.height = fnWinHeight(backup.value)+'px';\} else \{ogCurrentElement.style.height = '';\}\n"
  append strm $dec "            \}\n"
  append strm $dec "            if (mask_selector!=null && unmask_selector!=null) \{\n"
  append strm $dec "              mask_selector.style.display = 'inline';\n"
  append strm $dec "              unmask_selector.style.display = 'none';\n"
  append strm $dec "            \}\n"
  append strm $dec "            // on enregistre le fait que le contenu de la fenetre ne soit plus masque...et oui \n\n"
  append strm $dec "            if (backup!=null) \{\n"
  append strm $dec "              var updList = fnWinUpdPropertie(backup.value, 4, 1);\n"
  append strm $dec "              backup.value = updList;\n"
  append strm $dec "            \}\n"
  append strm $dec "            break;\n"
  append strm $dec "          case 'opacify':\n"
  append strm $dec "            // on recupere la valeur d'opacite\n"
  append strm $dec "            var opacity = -(-ogCurrentElement.style.opacity - 0.1);\n"
  append strm $dec "            if (opacity<0.1) \{\n"
  append strm $dec "              opacity = 0.1\n"
  append strm $dec "            \}\n"
  append strm $dec "            else if (opacity>1) \{\n"
  append strm $dec "              opacity = 1\n"
  append strm $dec "            \}\n"
  append strm $dec "            // on met a jour l'opacite\n"
  append strm $dec "            ogCurrentElement.style.opacity = opacity;\n"
  append strm $dec "            // on enregistre la nouvelle opacite\n"
  append strm $dec "            if (backup!=null) \{\n"
  append strm $dec "              var updList = fnWinUpdPropertie(backup.value, 5, opacity*10);\n"
  append strm $dec "              backup.value = updList;\n"
  append strm $dec "            \}\n"
  append strm $dec "            break;\n"
  append strm $dec "          case 'unopacify':\n"
  append strm $dec "            // on recupere la valeur d'opacite\n"
  append strm $dec "            var opacity = ogCurrentElement.style.opacity - 0.1;\n"
  append strm $dec "            if (opacity<0.1) \{\n"
  append strm $dec "              opacity = 0.1\n"
  append strm $dec "            \}\n"
  append strm $dec "            else if (opacity>1) \{\n"
  append strm $dec "              opacity = 1\n"
  append strm $dec "            \}\n"
  append strm $dec "            // on met a jour l'opacite\n"
  append strm $dec "            ogCurrentElement.style.opacity = opacity;\n"
  append strm $dec "            // on enregistre la nouvelle opacite\n"
  append strm $dec "            if (backup!=null) \{\n"
  append strm $dec "              var updList = fnWinUpdPropertie(backup.value, 5, opacity*10);\n"
  append strm $dec "              backup.value = updList;\n"
  append strm $dec "            \}\n"
  append strm $dec "            break;\n"
  append strm $dec "          default :\n"
  append strm $dec "            break;\n"
  append strm $dec "        \}\n"
  append strm $dec "      \}\n"
  append strm $dec "      vgMouseState = 'up';\n"
  append strm $dec "      //fnCurrentProperties(vgCurrentElement);\n"
  append strm $dec "    \}  /*hehe*/\n"
  append strm $dec "    // Let's see how to move...\n"
  append strm $dec "    document.onmousemove = function(e)\{\n"
  append strm $dec "      if (vgMouseState == 'down') \{\n"
  append strm $dec "        // on enregistre la position du curseur\n"
  append strm $dec "        vgCurrentMouseX = (navigator.appName.substring(0,3) == 'Net') ? e.pageX : event.x+document.body.scrollLeft;\n"
  append strm $dec "        vgCurrentMouseY = (navigator.appName.substring(0,3) == 'Net') ? e.pageY : event.y+document.body.scrollTop;\n"
  append strm $dec "        // calcul du deplacement du curseur\n"
  append strm $dec "        vgCurrentIntervalX = vgCurrentMouseX - vgMouseX;\n"
  append strm $dec "        vgCurrentIntervalY = vgCurrentMouseY - vgMouseY;\n"
  append strm $dec "        if (vgCurrentElement!=null && ogCurrentElement!=null) \{\n"
  append strm $dec "          switch (vgCurrentAction) \{\n"
  append strm $dec "            case 'move':\n"
  append strm $dec "              // deplacement de l'element\n"
  append strm $dec "              ogCurrentElement.style.left = (vgCurrentElementX + vgCurrentIntervalX)+'px';\n"
  append strm $dec "              ogCurrentElement.style.top = (vgCurrentElementY + vgCurrentIntervalY)+'px';\n"
  append strm $dec "              break;\n"
  append strm $dec "            case 'resize':\n"
  append strm $dec "              // redimensionnement de l'element\n"
  append strm $dec "              ogCurrentElement.style.width = (vgCurrentElementWidth + vgCurrentIntervalX)+'px';\n"
  append strm $dec "              ogCurrentElement.style.height = (vgCurrentElementHeight + vgCurrentIntervalY)+'px';\n"
  append strm $dec "              break;\n"
  append strm $dec "            default :\n"
  append strm $dec "              break;\n"
  append strm $dec "          \}\n"
  append strm $dec "        \}\n"
  append strm $dec "      \}\n"
  append strm $dec "      //fnCurrentProperties(vgCurrentElement);\n"
  append strm $dec "    \}\n"
  append strm $dec "  \}\n"

  append strm $dec "  StkFunc(fnEvents);\n"

 }
 this Render_daughters_JS strm $mark $dec
 this set_mark $mark
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_Maskable_HTML Render {strm_name {dec {}}} {
 upvar $strm_name strm

 append strm $dec "<p id=\"${objName}_infos\" style=\"display: none;\"></p>\n"

 # champ permettant de sauvegarder les valeurs des proprietes de la fenetre
 append strm $dec "<input type=\"hidden\" id=\"${objName}__XXX__WinProperties\" name=\"${objName}__XXX__WinProperties\" value=\"${this(pos_x)}|${this(pos_y)}|${this(width)}|${this(height)}|${this(visibility)}|${this(opacity)}|${this(layer)}\" />\n"
 append strm $dec "<input type=\"hidden\" id=\"${objName}_is_movable\" value=\"$this(is_movable)\" />\n"
 
 # si la possibilite de masquage est desactivee, le contenu de la fenetre est affiche
 if {$this(is_maskable) == 0} {set this(visibility) 1}
 
 # si la possibilite de transparence est desactivee, l'opacite est reglee au maximum
 if {$this(is_opacifiable) == 0} {set this(opacity) 10}

 # implementation de la fenetre
 append strm $dec "<div id=\"${objName}\" name=\"window_container\" style=\"display: block; "
 if {${this(visibility)} == 0} {
   if {$this(is_movable)} {
     append strm "width:${this(width)}px; height:16px"
    } else {append strm "width:''; height:''"}
  } else {if {$this(is_movable)} {
            append strm "width:${this(width)}px; height:${this(height)}px"
		   } else {append strm "width:''; height:''"}
         }
 append strm "; position: "
 if {$this(is_movable) == 0} {
   append strm "static; "
   set position static
 } else {append strm "absolute; top: ${this(pos_y)}px; left: ${this(pos_x)}px; "
         set position absolute
        }
 append strm " opacity: [expr {${this(opacity)}/10.0}]; z-index: ${this(layer)};\">\n"
 append strm $dec "  <div id=\"${objName}_header\" style=\"text-align: right; display: block; height: 20px; background-color: #000000; color: #ffffff;\">\n"
 if {$this(is_movable) != 0} {
   append strm $dec "    <span id=\"${objName}_move_selector\" style=\"display: inline; width: 16px; height: 16px; position: $position; top: 0px; left: 0px; cursor: move; background: url(./src_img/move.gif);\" onMouseOver=\"javascript: fnCurrentAction('move'); fnCurrentElement('${objName}');\" onMouseOut=\"javascript: fnCurrentAction(); fnCurrentElement();\"></span>\n"
 }
# Title of the window
 set text_title [[this get_nesting_LC] get_name]
 append strm $dec "      <span id=\"${objName}_text_title\" style=\"float: left;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$text_title</span>\n"
 
# Rest of the header
 if {$this(is_opacifiable) != 0} {
   append strm $dec "    <img src=\"./src_img/minus.gif\" id=\"${objName}_unopacify_selector\" style=\"align: right; display: inline; width: 16px; height: 16px; position: $position; top: 0px; right: 32px; cursor: pointer; background: url(./src_img/minus.gif) no-repeat 0px 4px;\" onMouseOver=\"javascript: fnCurrentAction('unopacify'); fnCurrentElement('${objName}');\" onMouseOut=\"javascript: fnCurrentAction(); fnCurrentElement();\"/>\n"
   append strm $dec "    <img src=\"./src_img/plus.gif\"  id=\"${objName}_opacify_selector\"   style=\"align: right; display: inline; width: 16px; height: 16px; position: $position; top: 0px; right: 16px; cursor: pointer; background: url(./src_img/plus.gif) no-repeat 0px 4px;\" onMouseOver=\"javascript: fnCurrentAction('opacify'); fnCurrentElement('${objName}');\" onMouseOut=\"javascript: fnCurrentAction(); fnCurrentElement();\"/>\n"
 }
 if {$this(is_maskable) != 0} {
   append strm $dec "    <img src=\"./src_img/mask.gif\"   id=\"${objName}_mask_selector\" style=\"display: "
   if {${this(visibility)} == 0} {append strm "none"} else {append strm "inline"}
   append strm "; width: 16px; height: 16px; position: $position; align: right; top: 0px; right: 0px; cursor: pointer; background: url(./src_img/mask.gif);\" onMouseOver=\"javascript: fnCurrentAction('mask'); fnCurrentElement('${objName}');\" onMouseOut=\"javascript: fnCurrentAction(); fnCurrentElement();\"/>\n"
   append strm $dec "    <img src=\"./src_img/unmask.gif\" id=\"${objName}_unmask_selector\" style=\"display: "
   if {$this(visibility) == 0} {append strm "inline"} else {append strm "none"}
   append strm "; width: 16px; height: 16px; position: $position; top: 0px; right: 0px; cursor: pointer; background: url(./src_img/unmask.gif);\" onMouseOver=\"javascript: fnCurrentAction('unmask'); fnCurrentElement('${objName}');\" onMouseOut=\"javascript: fnCurrentAction(); fnCurrentElement();\"/>\n"
  }
 append strm $dec "  </div>\n"
# End of header...

 append strm $dec "  <span id=\"${objName}_inside\" style=\"display: block; "
   if {$this(visibility) == 0} {append strm "display:none "}
   append strm "\">\n"
   this inherited strm "$dec    "
 append strm $dec "  </span>\n"
 if {${this(is_resizable)} != 0 && $this(is_movable)} {
   append strm $dec "  <span id=\"${objName}_resize_selector\" style=\"display: "
   if {${this(visibility)} == 0} {append strm "none"} else {append strm "block"}
   append strm "; width: 16px; height: 16px; position: absolute; bottom: 0px; right: 0px; cursor: se-resize; background: url(./src_img/corner.gif);\" onMouseOver=\"javascript: fnCurrentAction('resize'); fnCurrentElement('${objName}');\" onMouseOut=\"javascript: fnCurrentAction(); fnCurrentElement();\"></span>\n"
 }
 append strm $dec "</div>\n"
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_Maskable_HTML WinProperties {L} {
  set L [split $L |]
  set this(pos_x) [lindex $L 0]
  set this(pos_y) [lindex $L 1]
  set this(width) [lindex $L 2]
  set this(height) [lindex $L 3]
  set this(visibility) [lindex $L 4]
  set this(opacity) [lindex $L 5]
  set this(layer) [lindex $L 6]
} 

