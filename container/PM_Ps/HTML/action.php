<html>
	<head>	
		<title>Application temperature</title>
		<link href="style.css" rel="stylesheet" type="text/css">
	</head>	
	<body>
		<?
		  $saison = $_REQUEST['saison'] ;
		  $email = $_REQUEST['email'] ;
		  $comments = $_REQUEST['comments'] ;
		  $email = $_REQUEST['email'] ;
		  if (!isset($_REQUEST['email'])) {
		    
		  }
		  elseif (empty($email) || empty($message)) {
		   echo "il faut remplir tous les paramétres!!";
		  }
		  else {
				echo" vous avez choisis pour la saison : $saison";
		  }
		?>
	</body>
</html>