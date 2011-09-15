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

SSDPClientModule *ssdp_client_module;


#include "SWIG/intel_upnp_tcl_wrap.cxx"
// API_INTEL_UPNP_TCL_tcl_interp = interp;
// API_INTEL_UPNP_chain          = NULL;
//_______________________________________________________________________________________________________________
void INTEL_UPNP_new_message(void *sender, char* UDN, int Alive, char* LocationURL, int Timeout,void *cp);
DWORD WINAPI API_INTEL_UPNP_UPnPStackThreadRun(LPVOID args);

void INTEL_UPNP_Call_MSEARCH() {
	ILibSSDP_IPAddressListChanged( ssdp_client_module );
}

//_______________________________________________________________________________________________________________
//_______________________________________________________________________________________________________________
//_______________________________________________________________________________________________________________
const char* INTEL_UPNP_start(const bool sync, char *typeURI, const char *cmd_DeviceAdded, const char *cmd_DeviceRemoved, const char *cmd_MSearch, const char *cmd_SearchComplete);

//_______________________________________________________________________________________________________________
const char* INTEL_UPNP_listener_start_sync(char *typeURI, const char *cmd_DeviceAdded, const char *cmd_DeviceRemoved, const char *cmd_MSearch, const char *cmd_SearchComplete)
{	return INTEL_UPNP_start(true, typeURI, cmd_DeviceAdded, cmd_DeviceRemoved, cmd_MSearch, cmd_SearchComplete);
}

//_______________________________________________________________________________________________________________
const char* INTEL_UPNP_listener_start(char *typeURI, const char *cmd_DeviceAdded, const char *cmd_DeviceRemoved, const char *cmd_MSearch, const char *cmd_SearchComplete)
{	return INTEL_UPNP_start(false, typeURI, cmd_DeviceAdded, cmd_DeviceRemoved, cmd_MSearch, cmd_SearchComplete);
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
 ssdp_client_module = (struct SSDPClientModule*)ILibCreateSSDPClientModule( API_INTEL_UPNP_chain
											    , typeURI, std::strlen(typeURI)
											    , &INTEL_UPNP_new_message, NULL );

 char *reserved = new char[10];
 if (sync) {API_INTEL_UPNP_UPnPStackThreadRun(NULL);
 } else {CreateThread(NULL,0,&API_INTEL_UPNP_UPnPStackThreadRun,NULL,0,NULL);
		}

 return "ILibCreateSSDPClientModule started";
}

DWORD WINAPI API_INTEL_UPNP_Command_server(LPVOID args);
//_______________________________________________________________________________________________________________
void Start_socket_client_command(unsigned int port)
{	int *tcp_port = (int*)malloc( sizeof(int) );
	*tcp_port = port;
	CreateThread(NULL, 0, &API_INTEL_UPNP_Command_server, tcp_port, 0, NULL);
}

//#include <sys/socket.h>
//#include <sys/types.h>
//#include <netinet/in.h>
//#include <netdb.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
//#include <unistd.h>
#include <errno.h>
#include <winsock.h>

void Print_socket_error() {
	 switch( WSAGetLastError() ) {
		 //case WSAENOTINITIALISED: printf("WSAENOTINITIALISED\n"); break;
		 case WSAENETDOWN: printf("WSAENETDOWN\n"); break;
		 case WSAEAFNOSUPPORT: printf("WSAEAFNOSUPPORT\n"); break;
		 case WSAEINPROGRESS: printf("WSAEINPROGRESS\n"); break;
		 case WSAEMFILE: printf("WSAEMFILE\n"); break;
		 case WSAENOBUFS: printf("WSAENOBUFS\n"); break;
		 case WSAEPROTONOSUPPORT: printf("WSAEPROTONOSUPPORT\n"); break;
		 case WSAEPROTOTYPE: printf("WSAEPROTOTYPE\n"); break;
		 case WSAESOCKTNOSUPPORT: printf("WSAESOCKTNOSUPPORT\n"); break;
		 case WSAECONNREFUSED: printf("WSAECONNREFUSED\n"); break;
		 default: printf("Unknown error %d\n", WSAGetLastError());
		}
}
//_______________________________________________________________________________________________________________
DWORD WINAPI API_INTEL_UPNP_Command_server(LPVOID args)
{		int tcp_port = *( (int*)args );
        int sock, bytes_recieved, retour;  
        char send_data[1024],recv_data[1024];
        struct hostent *host;
        struct sockaddr_in server_addr;  

		WORD wVersionRequested;
		WSADATA wsaData;
		int err;

		wVersionRequested = MAKEWORD( 1, 1 );

		err = WSAStartup( wVersionRequested, &wsaData );
		if ( err != 0 ) {
			printf("Tell the user that we couldn't find a useable winsock.dll.\n");
			return 1;
		   } else {//printf("Sockets API init OK");
				  }

		//printf("gethostbyname\n");
        host = gethostbyname("localhost");

		//printf("Init socket\n");
        if ((sock = socket(AF_INET, SOCK_STREAM, 0)) == INVALID_SOCKET/*-1*/) {
             printf("\tAn error occured\n");
			 Print_socket_error();			
			 perror("Socket");
             return(1);
			}

		//printf("Config socket\n\tport : %d\n", tcp_port);
        server_addr.sin_family = AF_INET; printf("1-");
        server_addr.sin_port = htons( tcp_port ); printf("2-");
        server_addr.sin_addr = *((struct in_addr *)host->h_addr); printf("3\n");
        memset(&(server_addr.sin_zero), 0, 8); //bzero(&(server_addr.sin_zero),8); 

		//printf("Connect socket\n");
        if (connect(sock, (struct sockaddr *)&server_addr,
                    sizeof(struct sockaddr)) == -1) 
        {
            Print_socket_error();	
			perror("Connect");
            return(1);
        }

		//printf("Start socket client for commands\n");
        while(1)
        {
          bytes_recieved = recv(sock,recv_data,1024,0);
          recv_data[bytes_recieved] = '\0';
 
		  if(bytes_recieved > 0) {
			  printf("Received command : %s\n", recv_data);
			  if (strcmp(recv_data, "MSEARCH") == 0) {
				 INTEL_UPNP_Call_MSEARCH();
				}
			  strcpy(send_data, "Done"); send_data[4] = '\0';
			  retour = send(sock, send_data, strlen(send_data), 0);
			  if (retour == SOCKET_ERROR) {
				 printf("Unable to send answer\n");
				} else {printf("Sent %d bytes\n", retour);}
		     } else {break;}
        }
		closesocket(sock);
		//printf("End socket client for commands\n");
	return 0;
}

//_______________________________________________________________________________________________________________
DWORD WINAPI API_INTEL_UPNP_UPnPStackThreadRun(LPVOID args)
{	ILibStartChain(API_INTEL_UPNP_chain);
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
 printf("IN-");

 Tcl_DString cmd;
 Tcl_DStringInit(&cmd);
	if(Alive != 0) {
		if (strncasecmp(UDN,"M-SEARCH",8) == 0) {
			printf("MSEARCH CB ... ");
			Tcl_DStringAppend(&cmd, API_INTEL_UPNP_TCL_cmd_MSEARCH.c_str(), API_INTEL_UPNP_TCL_cmd_MSEARCH.length());
			Tcl_DStringAppend(&cmd, " {", 2);
			Tcl_DStringAppendElement(&cmd, "UDN"); Tcl_DStringAppendElement(&cmd, "M-SEARCH");
			Tcl_DStringAppendElement(&cmd, "ST" ); if(LocationURL) {Tcl_DStringAppendElement(&cmd, LocationURL);} else {Tcl_DStringAppendElement(&cmd, "");}
			char *str_cmd = Tcl_DStringAppend(&cmd, "}", 1);
			
			printf("-> %s", str_cmd);
			Tcl_Eval(API_INTEL_UPNP_TCL_tcl_interp, str_cmd);
			
			Tcl_DStringFree(&cmd);
			printf("-OUT MSEARCH\n");
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
	
	//printf("-> %s", str_cmd);
	Tcl_Eval(API_INTEL_UPNP_TCL_tcl_interp, str_cmd);  //printf("%s\n", str_cmd);

 Tcl_DStringFree(&cmd);

 printf("-OUT\n");
}

