/*
* INTEL CONFIDENTIAL
* Copyright (c) 2002, 2003 Intel Corporation.  All rights reserved.
* 
* The source code contained or described herein and all documents
* related to the source code ("Material") are owned by Intel
* Corporation or its suppliers or licensors.  Title to the
* Material remains with Intel Corporation or its suppliers and
* licensors.  The Material contains trade secrets and proprietary
* and confidential information of Intel or its suppliers and
* licensors. The Material is protected by worldwide copyright and
* trade secret laws and treaty provisions.  No part of the Material
* may be used, copied, reproduced, modified, published, uploaded,
* posted, transmitted, distributed, or disclosed in any way without
* Intel's prior express written permission.

* No license under any patent, copyright, trade secret or other
* intellectual property right is granted to or conferred upon you
* by disclosure or delivery of the Materials, either expressly, by
* implication, inducement, estoppel or otherwise. Any license
* under such intellectual property rights must be express and
* approved by Intel in writing.
* 
* $Workfile: ILibSSDPClient.c
* $Revision: #1.0.1181.32801
* $Author:   Intel Corporation, Intel Device Builder
* $Date:     Thursday, March 27, 2003
*
*/
#ifndef MICROSTACK_NO_STDAFX
//#include "stdafx.h"
#endif
#include <windows.h>
#include <math.h>
#include <winioctl.h>
#include <winbase.h>
#include <winerror.h>
#include <stdlib.h>
#include <stdio.h>
#include <stddef.h>
#include <string.h>
#include <winsock.h>
#include <wininet.h>
#include <malloc.h>

#include "ILibSSDPClient.h"
#include "ILibParsers.h"

#define UPNP_PORT 1900
#define UPNP_GROUP "239.255.255.250"
#define DEBUGSTATEMENT(x) x
#define strncasecmp(x,y,z) _strnicmp(x,y,z)
struct SSDPClientModule
{
	void (*PreSelect)(void* object,fd_set *readset, fd_set *writeset, fd_set *errorset, int* blocktime);
	void (*PostSelect)(void* object,int slct, fd_set *readset, fd_set *writeset, fd_set *errorset);
	void (*Destroy)(void* object);
	void (*FunctionCallback)(void *sender, char* UDN, int Alive, char* LocationURL, int Timeout, void *user);
	char* DeviceURN;
	int DeviceURNLength;
	
	int *IPAddress;
	int NumIPAddress;
	
	SOCKET SSDPListenSocket;
	SOCKET MSEARCH_Response_Socket;
	int Terminate;
	void *Reserved;
};


void ILibReadSSDP(SOCKET ReadSocket, struct SSDPClientModule *module)
{
	int bytesRead = 0;
	char* buffer = (char*)malloc(4096);
	struct sockaddr_in addr;
	int addrlen = sizeof(struct sockaddr_in);
	struct packetheader *packet;
	struct packetheader_field_node *node;
	struct parser_result* pnode;
	
	char* Location = NULL;
	char* UDN = NULL;
	int Timeout = 0;
	int Alive = 0;
	int info_Alive = 0;
	int OK;
	int rt;
	
	// printf("message : ");
	bytesRead = recvfrom(ReadSocket, buffer, 4096, 0, (struct sockaddr *) &addr, &addrlen);
	if(bytesRead<=0) 
	{
		FREE(buffer);
		return;
	}
	//printf("SSDP (%d bytes):\n%s\n", bytesRead, buffer);
	packet = ILibParsePacketHeader(buffer,0,bytesRead);
	// printf("Finish parsing...\n");
	if(packet == NULL) {FREE(buffer); return;}
	if(packet->Directive==NULL)
	{	// printf("packet->Directive==NULL\n");
		/* M-SEARCH Response */
		if(packet->StatusCode==200)
		{
			node = packet->FirstField;
			while(node!=NULL)
			{
				if(strncasecmp(node->Field,"LOCATION",8)==0)
				{	// printf("\tLOCATION ...");
					Location = (char*)MALLOC(node->FieldDataLength+1);
					memcpy(Location,node->FieldData,node->FieldDataLength);
					Location[node->FieldDataLength] = '\0';
				}
				if(strncasecmp(node->Field,"CACHE-CONTROL",13)==0)
				{	// printf("\tCACHE-CONTROL ...");
					pnode = ILibParseString(node->FieldData, 0, node->FieldDataLength, "=", 1);
					pnode->LastResult->data[pnode->LastResult->datalength] = '\0';
					Timeout = atoi(pnode->LastResult->data);
					ILibDestructParserResults(pnode);
				}
				if(strncasecmp(node->Field,"USN",3)==0)
				{	// printf("\tUSN ...");
					pnode = ILibParseString(node->FieldData, 0, node->FieldDataLength, "::", 2);
					pnode->FirstResult->data[pnode->FirstResult->datalength] = '\0';
					UDN = pnode->FirstResult->data+5;
					ILibDestructParserResults(pnode);
				}
				node = node->NextField;
			}
			if(module->FunctionCallback!=NULL)
			{	// printf("\tCB");
				module->FunctionCallback(module,UDN,-1,Location,Timeout,module->Reserved);
			}
			
		}
	}
	else
	{	// printf("ouch?\n");
		// printf("packet->Directive == %s\n", packet->Directive);
		/* M-SEARCH Packet */
		if(strncasecmp(packet->Directive,"M-SEARCH",8)==0)
		{// printf("MSEARCH packet...");
		 node = packet->FirstField;
		 while(node!=NULL)
			{node->Field[node->FieldLength] = '\0';
			 if(strncasecmp(node->Field,"HOST",4)==0 && node->FieldLength==4) {
				 node->FieldData[node->FieldDataLength] = '\0';
				 // printf("HOST : %s ...", node->FieldData);
				}
			 if(strncasecmp(node->Field,"MAN",3)==0 && node->FieldLength==3) {
				 node->FieldData[node->FieldDataLength] = '\0';
				 // printf("MAN : %s ...", node->FieldData);
				}
			 if(strncasecmp(node->Field,"MX",2)==0 && node->FieldLength==2) {
				 node->FieldData[node->FieldDataLength] = '\0';
				 // printf("MX : %s ...", node->FieldData);
				}
			 if(strncasecmp(node->Field,"ST",2)==0 && node->FieldLength==2) {
				 node->FieldData[node->FieldDataLength] = '\0';
				 //Location = node->FieldData;
				 Location = (char*)MALLOC(node->FieldDataLength+1);
				 memcpy(Location,node->FieldData,node->FieldDataLength);
				 Location[node->FieldDataLength] = '\0';
				 // printf("ST : %s ...", node->FieldData);
				}
			// Next field
			 node = node->NextField;
			}
		 // printf("Done\n");
		 module->FunctionCallback(module, "M-SEARCH", 1, Location, 0, module->Reserved);
		 // printf("CB done\n");
		}

		/* Notify Packet */
		if(strncasecmp(packet->Directive,"NOTIFY",6)==0)
		{	//printf("On a un NOTIFY...\n");
			OK = 0;
			rt = 0;
			info_Alive = 0;
			node = packet->FirstField;
			while(node!=NULL)
			{
				node->Field[node->FieldLength] = '\0';
				if(node->FieldLength==2 && strncasecmp(node->Field,"NT",2)==0 )
				{   //printf("\tNT...\n");
					node->FieldData[node->FieldDataLength] = '\0';
					if(strncasecmp(node->FieldData,module->DeviceURN,module->DeviceURNLength)==0)
					{
						OK = -1;
					}
					else if(strncasecmp(node->FieldData,"upnp:rootdevice",15)==0)
					{
						rt = -1;
					}
					else
					{	//printf("\t!Break...NOTIFY is not about the device...\n");
						break;
					}
				}
				if(node->FieldLength==3 && strncasecmp(node->Field,"NTS",3)==0)
				{   //printf("\tNTS...\n");
					if(strncasecmp(node->FieldData,"ssdp:alive",10)==0)
					{
						Alive = -1; info_Alive = 1;
						//rt = 0;
					}
					else
					{
						Alive = 0; info_Alive = 1;
						//OK = 0;
					}
				}
				if(node->FieldLength==3 && strncasecmp(node->Field,"USN",3)==0)
				{	//printf("\tUSN...\n");
					pnode = ILibParseString(node->FieldData, 0, node->FieldDataLength, "::", 2);
					pnode->FirstResult->data[pnode->FirstResult->datalength] = '\0';
					UDN = pnode->FirstResult->data+5;
					ILibDestructParserResults(pnode);
				}
				if(node->FieldLength==8 && strncasecmp(node->Field,"LOCATION",8)==0)
				{	//printf("\tLOCATION...\n");
					Location = (char*)MALLOC(node->FieldDataLength+1);
					memcpy(Location,node->FieldData,node->FieldDataLength);
					Location[node->FieldDataLength] = '\0';
				}
				if(node->FieldLength==13 && strncasecmp(node->Field,"CACHE-CONTROL",13)==0)
				{	//printf("\tCACHE-CONTROL...\n");
					pnode = ILibParseString(node->FieldData, 0, node->FieldDataLength, "=", 1);
					pnode->LastResult->data[pnode->LastResult->datalength] = '\0';
					Timeout = atoi(pnode->LastResult->data);
					ILibDestructParserResults(pnode);
				}
				node = node->NextField;
			}
			if( (OK!=0 || rt!=0) && info_Alive==1 && UDN && ((Location != NULL) || (Alive == 0)))
			{	//printf("\tCallback...\n");
				if(module->FunctionCallback!=NULL)
				{
					module->FunctionCallback(module,UDN,Alive,Location,Timeout,module->Reserved);
				}
			}
		}
	}
	// printf("Juste before FREE(Location)\n");
	if(Location!=NULL) {FREE(Location);}
	// printf("Juste before ILibDestructPacket\n");
	ILibDestructPacket(packet);
	// printf("Juste before FREE(buffer)\n");
	FREE(buffer);
}

void ILibSSDPClientModule_PreSelect(void* object,fd_set *readset, fd_set *writeset, fd_set *errorset, int* blocktime)
{
	struct SSDPClientModule *module = (struct SSDPClientModule*)object;
	FD_SET(module->SSDPListenSocket,readset);
	FD_SET(module->MSEARCH_Response_Socket, readset);
}
void ILibSSDPClientModule_PostSelect(void* object,int slct, fd_set *readset, fd_set *writeset, fd_set *errorset)
{
	struct SSDPClientModule *module = (struct SSDPClientModule*)object;
	if(slct>0)
	{
		if(FD_ISSET(module->SSDPListenSocket,readset)!=0)
		{
			ILibReadSSDP(module->SSDPListenSocket,module);
		}
		if(FD_ISSET(module->MSEARCH_Response_Socket,readset)!=0)
		{
			ILibReadSSDP(module->MSEARCH_Response_Socket,module);
		}
	}
}

void ILibSSDPClientModule_Destroy(void *object)
{
	struct SSDPClientModule *s = (struct SSDPClientModule*)object;
	FREE(s->DeviceURN);
	if(s->IPAddress!=NULL)
	{
		FREE(s->IPAddress);
	}
}
void ILibSSDP_IPAddressListChanged(void *SSDPToken)
{
	struct SSDPClientModule *RetVal = (struct SSDPClientModule*)SSDPToken;
	int i;
	struct sockaddr_in dest_addr;
	struct ip_mreq mreq;
	char* buffer;
	int bufferlength;
	struct in_addr interface_addr;
	printf("1-");
	
	// <ALEX DEBUG>
	struct sockaddr_in addr;
	int ra = 1;
	memset((char *)&addr, 0, sizeof(addr));
	addr.sin_family = AF_INET;
	addr.sin_addr.s_addr = htonl(INADDR_ANY);
	addr.sin_port = htons(UPNP_PORT);
	// </ALEX DEBUG>
	
	dest_addr.sin_family = AF_INET;
	dest_addr.sin_addr.s_addr = inet_addr(UPNP_GROUP);
	dest_addr.sin_port = htons(UPNP_PORT);
	
	printf("2-");
	for(i=0;i<RetVal->NumIPAddress;++i)
	{
		mreq.imr_multiaddr.s_addr = inet_addr(UPNP_GROUP);
		mreq.imr_interface.s_addr = RetVal->IPAddress[i];
		if (setsockopt(RetVal->SSDPListenSocket, IPPROTO_IP, IP_ADD_MEMBERSHIP,(char*)&mreq, sizeof(mreq)) < 0)
		{printf("Error?-");
		}
		
	}
	printf("3-");
	buffer = (char*)MALLOC(105+RetVal->DeviceURNLength);
	bufferlength = sprintf(buffer,"M-SEARCH * HTTP/1.1\r\nMX: 3\r\nST: %s\r\nHOST: 239.255.255.250:1900\r\nMAN: \"ssdp:discover\"\r\n\r\n",RetVal->DeviceURN);
	
	printf("4-");
	FREE(RetVal->IPAddress);
	RetVal->NumIPAddress = ILibGetLocalIPAddressList(&(RetVal->IPAddress));

	// <ALEX DEBUG>
	int err;
	if ( (err = setsockopt(RetVal->SSDPListenSocket, SOL_SOCKET, SO_REUSEADDR,(char*)&ra, sizeof(ra))) < 0)
	{
		printf("Setting SockOpt SO_REUSEADDR failed\r\n");
		exit(1);
	}
	/*if ( (err = bind(RetVal->SSDPListenSocket, (struct sockaddr *) &(addr), sizeof(addr))) < 0)
	{
		printf("SSDPListenSocket bind\n");
		switch(err) {
			case WSANOTINITIALISED : printf("WSANOTINITIALISED\n"); break;
			case WSAENETDOWN : printf("WSAENETDOWN\n"); break;
			case WSAEACCES : printf("WSAEACCES\n"); break;
			case WSAEADDRINUSE : printf("WSAEADDRINUSE\n"); break;
			case WSAEADDRNOTAVAIL : printf("WSAEADDRNOTAVAIL\n"); break;
			case WSAEFAULT : printf("WSAEFAULT\n"); break;
			case WSAEINPROGRESS : printf("WSAEINPROGRESS\n"); break;
			case WSAEINVAL : printf("WSAEINVAL\n"); break;
			case WSAENOBUFS : printf("WSAENOBUFS\n"); break;
			case WSAENOTSOCK : printf("WSAENOTSOCK\n"); break;
			default: printf("Unknown error %d\n", err);
			}
		exit(1);
	}*/
	// </ALEX DEBUG>
	printf("5-");
	for(i=0;i<RetVal->NumIPAddress;++i)
	{
		interface_addr.s_addr = RetVal->IPAddress[i];
		if (setsockopt(RetVal->MSEARCH_Response_Socket, IPPROTO_IP, IP_MULTICAST_IF,(char*)&interface_addr, sizeof(interface_addr)) == 0)
		{
			sendto(RetVal->MSEARCH_Response_Socket, buffer, bufferlength, 0, (struct sockaddr *) &dest_addr, sizeof(dest_addr));
		}
	}
	printf("6\n");
	FREE(buffer);
}

void* ILibCreateSSDPClientModule(void *chain, char* DeviceURN, int DeviceURNLength, void (*CallbackPtr)(void *sender, char* UDN, int Alive, char* LocationURL, int Timeout, void *user),void *user)
{
	int i;
	struct sockaddr_in addr;
	struct sockaddr_in dest_addr;
	struct SSDPClientModule *RetVal = (struct SSDPClientModule*)MALLOC(sizeof(struct SSDPClientModule));
	int ra = 1;
	struct ip_mreq mreq;
	char* buffer;
	int bufferlength;
	char* _DeviceURN;
	struct in_addr interface_addr;
	unsigned char TTL = 4;
	
	memset((char *)&addr, 0, sizeof(addr));
	memset((char *)&interface_addr, 0, sizeof(interface_addr));
	memset((char *)&(addr), 0, sizeof(dest_addr));
	
	dest_addr.sin_family = AF_INET;
	dest_addr.sin_addr.s_addr = inet_addr(UPNP_GROUP);
	dest_addr.sin_port = htons(UPNP_PORT);
	
	addr.sin_family = AF_INET;
	addr.sin_addr.s_addr = htonl(INADDR_ANY);
	addr.sin_port = htons(UPNP_PORT);	
	
	RetVal->Destroy    = &ILibSSDPClientModule_Destroy;
	RetVal->PreSelect  = &ILibSSDPClientModule_PreSelect;
	RetVal->PostSelect = &ILibSSDPClientModule_PostSelect;
	
	RetVal->Reserved = user;
	RetVal->Terminate = 0;
	RetVal->FunctionCallback = CallbackPtr;
	RetVal->DeviceURN = (char*)MALLOC(DeviceURNLength+1);
	memcpy(RetVal->DeviceURN,DeviceURN,DeviceURNLength);
	RetVal->DeviceURN[DeviceURNLength] = '\0';
	RetVal->DeviceURNLength = DeviceURNLength;
	
	RetVal->NumIPAddress = ILibGetLocalIPAddressList(&(RetVal->IPAddress));
	RetVal->SSDPListenSocket = socket(AF_INET, SOCK_DGRAM, 0);
	ILibGetDGramSocket(htonl(INADDR_ANY), &(RetVal->MSEARCH_Response_Socket));
	
	if (setsockopt(RetVal->MSEARCH_Response_Socket, IPPROTO_IP, IP_MULTICAST_TTL,(char*)&TTL, sizeof(TTL)) < 0)
	{
		/* Ignore this case */
	}
	if (setsockopt(RetVal->SSDPListenSocket, SOL_SOCKET, SO_REUSEADDR,(char*)&ra, sizeof(ra)) < 0)
	{
		printf("Setting SockOpt SO_REUSEADDR failed\r\n");
		exit(1);
	}
	if (bind(RetVal->SSDPListenSocket, (struct sockaddr *) &(addr), sizeof(addr)) < 0)
	{
		printf("SSDPListenSocket bind\n");
		exit(1);
	}
	
	for(i=0;i<RetVal->NumIPAddress;++i)
	{
		mreq.imr_multiaddr.s_addr = inet_addr(UPNP_GROUP);
		mreq.imr_interface.s_addr = RetVal->IPAddress[i];
		if (setsockopt(RetVal->SSDPListenSocket, IPPROTO_IP, IP_ADD_MEMBERSHIP,(char*)&mreq, sizeof(mreq)) < 0)
		{
			printf("SSDPListenSocket setsockopt mreq\n");
			exit(1);
		}
		
	}
	
	ILibAddToChain(chain,RetVal);
	_DeviceURN = (char*)MALLOC(DeviceURNLength+1);
	memcpy(_DeviceURN,DeviceURN,DeviceURNLength);
	_DeviceURN[DeviceURNLength] = '\0';
	buffer = (char*)MALLOC(105+DeviceURNLength);
	bufferlength = sprintf(buffer,"M-SEARCH * HTTP/1.1\r\nMX: 3\r\nST: %s\r\nHOST: 239.255.255.250:1900\r\nMAN: \"ssdp:discover\"\r\n\r\n",_DeviceURN);
	
	for(i=0;i<RetVal->NumIPAddress;++i)
	{
		interface_addr.s_addr = RetVal->IPAddress[i];
		//printf("Send SSDP search message to %d\n", RetVal->IPAddress[i]);
		if (setsockopt(RetVal->MSEARCH_Response_Socket, IPPROTO_IP, IP_MULTICAST_IF,(char*)&interface_addr, sizeof(interface_addr)) == 0)
		{
			sendto(RetVal->MSEARCH_Response_Socket, buffer, bufferlength, 0, (struct sockaddr *) &dest_addr, sizeof(dest_addr));
		}
	}
	
	FREE(_DeviceURN);
	FREE(buffer);
	return(RetVal);
}
