inherit WizardOfOz_Helper_PM_P_B207_Hasselt PM_BIGre
set dir [pwd]
  cd [get_B207_files_root]
  source B207_Helper.tcl
  cd $dir


#___________________________________________________________________________________________________________________________________________
method WizardOfOz_Helper_PM_P_B207_Hasselt constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id WizardOfOz_Helper_PM_P_B207_Hasselt

   set this(B207_Helper) ${objName}_helper
   B207_Helper $this(B207_Helper)
   set this(primitives_handle) [helper get_root]

 this set_prim_handle        $this(primitives_handle)
 this set_root_for_daughters $this(primitives_handle)

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC WizardOfOz_Helper_PM_P_B207_Hasselt [L_methodes_set_Avatar_Helper] {} {}
Methodes_get_LC WizardOfOz_Helper_PM_P_B207_Hasselt [L_methodes_get_Avatar_Helper] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method WizardOfOz_Helper_PM_P_B207_Hasselt Plug_MANIP_under {n} {
 set Manip_root [$this(B207_Helper) get_MANIP_root_for_hands]
 $n Ajouter_fils_au_debut $Manip_root
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method WizardOfOz_Helper_PM_P_B207_Hasselt set_Display_Avatar {b} {
 B_configure [$this(B207_Helper) get_avatar] -Afficher_noeud $b -Gerer_contacts $b
}

#___________________________________________________________________________________________________________________________________________
method WizardOfOz_Helper_PM_P_B207_Hasselt set_Display_hands {b} {
 B_configure [$this(B207_Helper) get_root_for_hands] -Afficher_noeud $b -Gerer_contacts $b
}

#___________________________________________________________________________________________________________________________________________
method WizardOfOz_Helper_PM_P_B207_Hasselt set_Display_points {b} {
 puts "TODO => WizardOfOz_Helper_PM_P_B207_Hasselt::set_Display_points $b"
}

#___________________________________________________________________________________________________________________________________________
method WizardOfOz_Helper_PM_P_B207_Hasselt Fade_avatar {t V} {
 set avatar [$this(B207_Helper) get_avatar] 
 $avatar Afficher_noeud 1
 set V0 [$avatar Couleur 3]
 B_transfo_rap $t "set t_cour \\\[\$rap V_courant\\\]; $avatar Couleur 3 \\\[expr $VO + \\\$t_cour * ($V-$V0)]"
}
