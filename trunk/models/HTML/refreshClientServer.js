var output = {};
var outputVer = {};
var i = 0;	
var mutex = false;
var forcing_send = false;

$(document).ready(function() {
	outputVer['Comet_port'] = $("#Comet_port").val();
	
	// Enregistrement de l'ip client dans le champ input IP_client
	try {
		addr = java.net.InetAddress.getLocalHost(); 
		ip = addr.getHostAddress();
		$("#IP_client").val(ip);
	}
	catch(err) {
		alert("Votre navigateur ne gère pas le java");
	}

	setInterval('refreshClientServer()',2000);		
});

function addOutput(obj,forcing) {
	// Ajout dans la map output la modification faite sur le client html
	output[obj.name] = obj.value;
	i++;
	if(forcing) { 
		forcing_send = forcing;
		refreshClientServer(); 
	}
}

function refreshClientServer() {
	//$("#p_debug").append("refreshClientServer --- ");
	if(mutex == false) {
		//$("#p_debug").append("INSIDE --- ");
		mutex = true;
		var do_update = false;
		
		// On enregistre la version du client et de son ip
		outputVer[$("#Version_value").attr("name")] = $("#IP_client").val() + " "+ $("#Version_value").val();
		
		// Récupération de la version serveur 
		$.ajax({
			type: "POST",
			url: "index.php",
			data: outputVer,
			success: function(msg){
				if(msg) {					
					try { 
						eval(msg);
					}
					catch(err) {
						//alert(err);
					}
					do_update = true;
				}
		    },
			error: function(err){
				alert("Problème de réception des mises à jour serveur\n\n"+err);				
			}
		});
		
		// Envoi de la version client si la il n'y a pas eu de modification du coté serveur
		if(do_update == false && i >= 1) {
			output['Comet_port'] = $("#Comet_port").val();
			
			$.ajax({
				type: "POST",
				url: "index.php",
				data: output,
				error: function(msg){
					alert("Problème d'envoi des mises à jour client\n\n"+err);
				}
			});			
		}
		
		// Réinitialisation des paramètres (modification du client non pris en compte si il y a une mise à jour serveur)
		output = {};
		i = 0;
		do_update = false;
		mutex = false;	
		if(forcing_send) { forcing_send = false; refreshClientServer(); }
	}
   //$("#p_debug").append("END<br/>");
}