var output     = {};
var output_tmp = {};
var outputVer  = {};
var i = 0;	
var i_tmp = 0;	
var mutex        = false;
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
		alert("Votre navigateur ne g�re pas le java");
		ip = '127.0.0.1';
		$("#IP_client").val(ip);
	}

	//setInterval('refreshClientServer()',2000);		
	maj();
});

function maj() {
	refreshClientServer();
	setTimeout('maj()',$("#Update_interval").val());
}

function addOutput(obj,forcing) {
	// Ajout dans la map output la modification faite sur le client html
	if(mutex) {output_tmp[obj.name] = obj.value; i_tmp++;} else {output[obj.name] = obj.value; i++;}
	
	if(forcing) { 
		forcing_send = forcing;
		refreshClientServer(); 
	}
}

function addOutput_proc_val(proc, val, forcing) {
	// Ajout dans la map output la modification faite sur le client html
	if(mutex) {output_tmp[proc] = val; i_tmp++;} else {output[proc] = val; i++;}
	if(forcing) { 
		forcing_send = forcing;
		refreshClientServer(); 
	}
}

function refreshClientServer() {
	if(mutex == false) {
		mutex = true;
		
		// On enregistre la version du client et de son ip
		outputVer[$("#Version_value").attr("name")] = $("#IP_client").val() + " "+ $("#Version_value").val();
		
		// R�cup�ration de la version serveur 
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
						alert(err);
					}
					output = {};
					i = 0;
					mutex = false;
				} else if(i >= 1) {output['Comet_port'] = $("#Comet_port").val();
								   output[$("#Version_value").attr("name")] = $("#IP_client").val() + " "+ $("#Version_value").val();
								   if(forcing_send) {forcing_send = false;}
						           $.ajax({
										type: "POST",
										url: "index.php",
										data: output,
										success : function(msg) {mutex = false;
																 output = output_tmp;
										                         output_tmp = {};
																 i = i_tmp;
																 i_tmp = 0;
																 if(msg) {try {eval(msg);
																	          } catch(err) { alert(err);
																						   }
																		 }
																 
																 if(forcing_send) {forcing_send = false;
																				   refreshClientServer();
																				  }
																},
										error: function(msg) {mutex = false;
										                      alert("Probl�me d'envoi des mises � jour client\n\n" + msg);
															 }
									});
				                 } else {mutex = false;
										 if(forcing_send) {forcing_send = false;
														   refreshClientServer();
														  }
										}
		    },
			error: function(err){
			    mutex = false;
				alert("Probl�me de r�ception des mises � jour serveur\n\n"+err);
			}
		});
	}
}