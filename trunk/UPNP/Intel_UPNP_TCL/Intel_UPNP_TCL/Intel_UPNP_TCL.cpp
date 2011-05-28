// Il s'agit du fichier DLL principal.

//_______________________________________________________________________________________________________________
//_______________________________________________________________________________________________________________
//_______________________________________________________________________________________________________________
#include "stdafx.h"

#include <iostream>

#include <tcl.h>

#include "Intel_UPNP_TCL.h"
extern "C" {
	#include "../ILibSSDPClient.c"
	#include "../ILibParsers.c"
}

//_______________________________________________________________________________________________________________
Tcl_Interp        *API_INTEL_UPNP_TCL_tcl_interp;
std::string        API_INTEL_UPNP_TCL_cmd_DeviceAdded, API_INTEL_UPNP_TCL_cmd_DeviceRemoved, API_INTEL_UPNP_TCL_cmd_MSEARCH;
void*              API_INTEL_UPNP_chain;

#include "SWIG/intel_upnp_tcl_wrap.cxx"
// API_INTEL_UPNP_TCL_tcl_interp = interp;
// API_INTEL_UPNP_chain = NULL;
//_______________________________________________________________________________________________________________
void INTEL_UPNP_new_message(void *sender, char* UDN, int Alive, char* LocationURL, int Timeout,void *cp);
DWORD WINAPI API_INTEL_UPNP_UPnPStackThreadRun(LPVOID args);

//_______________________________________________________________________________________________________________
//_______________________________________________________________________________________________________________
//_______________________________________________________________________________________________________________
const char* INTEL_UPNP_start(const bool sync, char *typeURI, const char *cmd_DeviceAdded, const char *cmd_DeviceRemoved, const char *cmd_MSearch, const char *cmd_SearchComplete);

//_______________________________________________________________________________________________________________
const char* INTEL_UPNP_listener_start_sync(char *typeURI, const char *cmd_DeviceAdded, const char *cmd_DeviceRemoved, const char *cmd_MSearch, const char *cmd_SearchComplete)
{return INTEL_UPNP_start(true, typeURI, cmd_DeviceAdded, cmd_DeviceRemoved, cmd_MSearch, cmd_SearchComplete);
}

//_______________________________________________________________________________________________________________
const char* INTEL_UPNP_listener_start(char *typeURI, const char *cmd_DeviceAdded, const char *cmd_DeviceRemoved, const char *cmd_MSearch, const char *cmd_SearchComplete)
{return INTEL_UPNP_start(false, typeURI, cmd_DeviceAdded, cmd_DeviceRemoved, cmd_MSearch, cmd_SearchComplete);
}

//_______________________________________________________________________________________________________________
const char* INTEL_UPNP_start(const bool sync, char *typeURI, const char *cmd_DeviceAdded, const char *cmd_DeviceRemoved, const char *cmd_MSearch, const char *cmd_SearchComplete)
{INTEL_UPNP_listener_set_cmd_DeviceAdded  (cmd_DeviceAdded);
 INTEL_UPNP_listener_set_cmd_DeviceRemoved(cmd_DeviceRemoved);
 INTEL_UPNP_listener_set_cmd_MSEARCH      (cmd_MSearch);

 if(API_INTEL_UPNP_chain) {
	 ILibStopChain(API_INTEL_UPNP_chain);
	} 
 while(API_INTEL_UPNP_chain != NULL) ;
 
 API_INTEL_UPNP_chain = ILibCreateChain();
 ILibCreateSSDPClientModule( API_INTEL_UPNP_chain
						   , typeURI, std::strlen(typeURI)
						   , &INTEL_UPNP_new_message, NULL );

 char *reserved = new char[10];
 if (sync) {API_INTEL_UPNP_UPnPStackThreadRun(NULL);
 } else {CreateThread(NULL,0,&API_INTEL_UPNP_UPnPStackThreadRun,NULL,0,NULL);}

 return "ILibCreateSSDPClientModule started";
}

//_______________________________________________________________________________________________________________
DWORD WINAPI API_INTEL_UPNP_UPnPStackThreadRun(LPVOID args)
{	//Tcl_Eval(API_INTEL_UPNP_TCL_tcl_interp, "puts {ILibStartChain started}");
	//printf("ILibStartChain\n"); 
	ILibStartChain(API_INTEL_UPNP_chain);
	//Tcl_Eval(API_INTEL_UPNP_TCL_tcl_interp, "puts {ILibStartChain ended}");
	//printf("End of ILibStartChain\n");
	API_INTEL_UPNP_chain = NULL;
	return 0;
}


//_______________________________________________________________________________________________________________
const char* INTEL_UPNP_listener_get_cmd_DeviceAdded  () {return API_INTEL_UPNP_TCL_cmd_DeviceAdded.c_str()  ;}
const char* INTEL_UPNP_listener_get_cmd_DeviceRemoved() {return API_INTEL_UPNP_TCL_cmd_DeviceRemoved.c_str();}
const char* INTEL_UPNP_listener_get_cmd_MSEARCH      () {return API_INTEL_UPNP_TCL_cmd_MSEARCH.c_str();}

//_______________________________________________________________________________________________________________
void INTEL_UPNP_listener_set_cmd_DeviceAdded  (const char *str) {API_INTEL_UPNP_TCL_cmd_DeviceAdded   = str;}
void INTEL_UPNP_listener_set_cmd_DeviceRemoved(const char *str) {API_INTEL_UPNP_TCL_cmd_DeviceRemoved = str;}
void INTEL_UPNP_listener_set_cmd_MSEARCH      (const char *str) {API_INTEL_UPNP_TCL_cmd_MSEARCH   = str;}

//_______________________________________________________________________________________________________________
//_______________________________________________________________________________________________________________
//_______________________________________________________________________________________________________________
void INTEL_UPNP_new_message(void *sender, char* UDN, int Alive, char* LocationURL, int Timeout,void *cp)
{if(UDN == NULL) {return;}
 Tcl_DString cmd;
 Tcl_DStringInit(&cmd);
	if(Alive != 0) {
		if (strncasecmp(UDN,"M-SEARCH",8) == 0) {
			//printf("MSEARCH CB ... ");
			Tcl_DStringAppend(&cmd, API_INTEL_UPNP_TCL_cmd_MSEARCH.c_str(), API_INTEL_UPNP_TCL_cmd_MSEARCH.length());
			Tcl_DStringAppend(&cmd, " {", 2);
			Tcl_DStringAppendElement(&cmd, "UDN"); Tcl_DStringAppendElement(&cmd, "M-SEARCH");
			Tcl_DStringAppendElement(&cmd, "ST" ); if(LocationURL) {Tcl_DStringAppendElement(&cmd, LocationURL);} else {Tcl_DStringAppendElement(&cmd, "");}
			char *str_cmd = Tcl_DStringAppend(&cmd, "}", 1);
			Tcl_Eval(API_INTEL_UPNP_TCL_tcl_interp, str_cmd);
			Tcl_DStringFree(&cmd);
			//printf("DONE!\n");
			return;
		} else {Tcl_DStringAppend(&cmd, API_INTEL_UPNP_TCL_cmd_DeviceAdded.c_str(), API_INTEL_UPNP_TCL_cmd_DeviceAdded.length());
			   }
		} else	{Tcl_DStringAppend(&cmd, API_INTEL_UPNP_TCL_cmd_DeviceRemoved.c_str(), API_INTEL_UPNP_TCL_cmd_DeviceRemoved.length());
				}
	Tcl_DStringAppend(&cmd, " {", 2);
	Tcl_DStringAppendElement(&cmd, "UDN"); Tcl_DStringAppendElement(&cmd, UDN);
	if (Alive != 0) {
		Tcl_DStringAppendElement(&cmd, "LocationURL"); if(LocationURL) {Tcl_DStringAppendElement(&cmd, LocationURL);} else {Tcl_DStringAppendElement(&cmd, "");}
		}

	char tmp[256];
	itoa(Alive, tmp, 10);
	Tcl_DStringAppendElement(&cmd, "Alive"); Tcl_DStringAppendElement(&cmd, tmp);
	itoa(Timeout, tmp, 10);
	Tcl_DStringAppendElement(&cmd, "Timeout"); Tcl_DStringAppendElement(&cmd, tmp);

	char *str_cmd = Tcl_DStringAppend(&cmd, "}", 1);
	Tcl_Eval(API_INTEL_UPNP_TCL_tcl_interp, str_cmd);  //printf("%s\n", str_cmd);

 Tcl_DStringFree(&cmd);
}

