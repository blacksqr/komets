<?php
$found_SOAP = false; $size = -1;
$entete = "";
foreach (getallheaders() as $name => $value) {
	if (strtoupper($name) == "SOAPACTION") {$found_SOAP = true;}
	$entete .= $name . " : " . $value . "\n<br/>";
}

if ($found_SOAP) {
	$data = file_get_contents("php://input");
	$fp = fsockopen("129.88.66.127", 1945, $errno, $errstr, 10);
	fwrite($fp, "15 PIPO_UPNP_WCOMP ");
	fwrite($fp, strlen( utf8_decode($data))); fwrite($fp, " "); 
	fwrite($fp, $data); flush(); 
	$out = "";
	while (!feof($fp)) {$out .= fread($fp, 8192);}
	echo $out;
	fclose($fp);
} else {echo "No SOAP action found in the headers
<br/>" . $entete;}
?>

