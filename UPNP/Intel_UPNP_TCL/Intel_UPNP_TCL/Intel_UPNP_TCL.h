// Intel_UPNP_TCL.h

#pragma once

const char* INTEL_UPNP_listener_start(char *typeURI, const char *cmd_DeviceAdded, const char *cmd_DeviceRemoved, const char *cmd_SearchComplete);
const char* INTEL_UPNP_listener_start_sync(char *typeURI, const char *cmd_DeviceAdded, const char *cmd_DeviceRemoved, const char *cmd_SearchComplete);

const char* INTEL_UPNP_listener_get_cmd_DeviceAdded  ();
const char* INTEL_UPNP_listener_get_cmd_DeviceRemoved();

void INTEL_UPNP_listener_set_cmd_DeviceAdded  (const char *str);
void INTEL_UPNP_listener_set_cmd_DeviceRemoved(const char *str);
 
