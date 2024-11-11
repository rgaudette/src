
#ifndef RESOURCE_H
#define RESOURCE_H

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

///////////////////////////////////////////////////////////////////
// resource.h  -- contains macros used for commands


///////////////////////////////////////////////////////////////////
// COMMAND VALUES FOR MENUBAR AND TOOLBAR ENTRIES


///////////////////////////////////////////////////////////////////
// File-menu entries
#define ID_FILE_NEW_WINDOW          10010
#define ID_FILE_NEW                 10020
#define ID_FILE_OPEN                10030
#define ID_FILE_OPEN_RECENT         10040
#define ID_FILE_CLOSE               10050

#define ID_FILE_SAVE                10060
#define ID_FILE_SAVE_AS             10070

#define ID_FILE_PRINT               10080

#define ID_FILE_QUIT                10090


///////////////////////////////////////////////////////////////////
// Edit-menu entries
#define ID_EDIT_COPY                11010
#define ID_EDIT_CUT                 11020
#define ID_EDIT_PASTE               11030


///////////////////////////////////////////////////////////////////
// View-menu entries                    
#define ID_VIEW_TOOLBAR             12010
#define ID_VIEW_STATUSBAR           12020

///////////////////////////////////////////////////////////////////
// Help-menu entries
#define ID_HELP_CONTENTS            1002

///////////////////////////////////////////////////////////////////
// General application values
#define ID_STATUS_MSG               1001

#endif // RESOURCE_H

