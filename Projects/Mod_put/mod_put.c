/*
 * ====================================================================
 * Copyright (c) 1995-1997 Lyonel VINCENT.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * 3. All advertising materials mentioning features or use of this
 *    software must display the following acknowledgment:
 *    "This product includes software developed by the Apache Group
 *    for use in the Apache HTTP server project (http://www.apache.org/)."
 *
 * 4. The names "Apache Server" and "Apache Group" must not be used to
 *    endorse or promote products derived from this software without
 *    prior written permission.
 *
 * 5. Redistributions of any form whatsoever must retain the following
 *    acknowledgment:
 *    "This product includes software developed by the Apache Group
 *    for use in the Apache HTTP server project (http://www.apache.org/)."
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY
 * EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE APACHE GROUP OR
 * ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
 * mod_put: implements the PUT and DELETE methods
 *
 * version 1.3 (March 1999)
 *
 * Lyonel VINCENT <vincent@hpwww.ec-lyon.fr>
 * modified by Krischan Jodies <krischan@roko.goe.net> to make it compile for
 * Apache 1.3
 * modified by Carolyn Weiss <cweiss@us.ibm.com> for EBCDIC support
 * 
 * usage:
 *	EnablePut	On|Off
 *		default value:	Off
 *		context:	Directory
 *		effect:		enables (or disables) the PUT method for a
 *				whole directory.
 *
 *	EnableDelete	On|Off
 *		default value:	Off
 *		context:	Directory
 *		effect:		enables (or disables) the DELETE method for a
 *				whole directory.
 *	umask		<octal value>
 *		default value:	007
 *		context:	Directory
 *		effect:		sets the umask for a whole directory (see umask(1)).
 */

#include "httpd.h"
#include "http_config.h"
#include "http_core.h"
#include "http_log.h"
#include "http_protocol.h"

#include <stdlib.h>
#include <sys/types.h>
#include <dirent.h>
#include <errno.h>

extern int errno;

#define DEF_UMASK (S_IROTH | S_IWOTH | S_IXOTH)

typedef struct
{
  int put_enabled;
  int delete_enabled;
  int umask;
} put_config_rec;

module put_module;

#define BLOCKSIZE 2048

const char *put_set_putenabled_flag (cmd_parms *cmd, put_config_rec *sec, int arg)
{
  sec->put_enabled=arg;
  return NULL;
}

const char *put_set_deleteenabled_flag (cmd_parms *cmd,	put_config_rec *sec, int arg)
{
  sec->delete_enabled=arg;
  return NULL;
}

const char *put_set_umask (cmd_parms *cmd, put_config_rec *sec, char * arg)
{
  sec->umask=strtol(arg,(char **)NULL,8);
  return NULL;
}

command_rec put_cmds[] = {
	{ "EnablePut", put_set_putenabled_flag, NULL, OR_AUTHCFG, FLAG, "Limited to 'on' or 'off'" },
	{ "EnableDelete", put_set_deleteenabled_flag, NULL, OR_AUTHCFG, FLAG, "Limited to 'on' or 'off'" },
	{ "umask", put_set_umask, NULL, OR_AUTHCFG, TAKE1, "numeric umask" },
	{ NULL }
};

void *create_put_dir_config (pool *p, char *d)
{
  put_config_rec * sec = (put_config_rec *)ap_pcalloc (p, sizeof(put_config_rec));

  if (!sec) return NULL; /* no memory... */

  sec -> put_enabled	=0;
  sec -> delete_enabled	=0;
  sec -> umask          =DEF_UMASK;
  return sec;
}

void make_dirs(pool * p, const char * filename, int umask)
{
  char * sto = ap_pstrdup(p, filename), * slash=sto, * dirname=sto;

  while(slash=strchr(slash+1,'/'))
  {
    *slash='\0';
    *dirname='/';
    mkdir(sto,(S_IRWXU | S_IRWXG | S_IRWXO) & ~umask);
    dirname=slash;
  }
}

int do_put(request_rec *r)
{
  put_config_rec *sec = (put_config_rec *)ap_get_module_config (r->per_dir_config, &put_module);
  FILE * f, *strmTmp, *strmMailList;
  int result=OK, len=0;
  mode_t old_umask;
  char * buffer;
  char *strMLFile, *strMailList, *strMsg;

  //
  //  Variables to process RCS and mail code
  //
  int nC, iC;
  char *strPath, *strRCSDir;
  DIR *dirTemp;

  if(!sec->put_enabled) return FORBIDDEN;

  old_umask = umask(sec->umask);

  if(r->path_info)	/* a directory did not exist */
  {
    r->filename = ap_pstrcat(r->pool, r->filename, r->path_info, NULL);
    make_dirs(r->pool,r->filename,sec->umask);
  }

  f = ap_pfopen(r->pool, r->filename, "w");
  if(f == NULL)
  {
    ap_log_reason("file permissions deny server write access",r->filename,r);
    umask(old_umask);
    return FORBIDDEN;
  }

  if((result=ap_setup_client_block(r,REQUEST_CHUNKED_DECHUNK))==OK)
  {
    if(ap_should_client_block(r))
    {
      buffer = ap_palloc(r->pool, BLOCKSIZE);
      while((len=ap_get_client_block(r,buffer,BLOCKSIZE))>0)
	fwrite(buffer,len,1,f);
    }
    ap_send_http_header(r);
    ap_rprintf(r,"<HTML>File %s created.</HTML>\n",ap_escape_html(r->pool, r->uri));
  }

  ap_pfclose(r->pool,f);
  umask(old_umask);

  //
  //  Open a file in the temp directory and write out the page etc.
  //
  strmTmp  = fopen("/tmp/putout.log","a+");
  if(strmTmp == NULL) {
    fprintf(stderr, "Unable to open temp file\n");
  }
  else {
    fprintf(strmTmp, "==========================================================\n");
    fprintf(strmTmp, "the_request %s\n", r->the_request);
    fprintf(strmTmp, "unparsed_uri %s\n", r->unparsed_uri);
    fprintf(strmTmp, "uri %s\n", r->uri);
    fprintf(strmTmp, "filename %s\n", r->filename);
    fprintf(strmTmp, "pathinfo %s\n", r->path_info);
    fprintf(strmTmp, "conn_rec->user %s\n", r->connection->user);
    fprintf(strmTmp, "server_rec->server_hostname %s\n", r->server->server_hostname);
    fprintf(strmTmp, "server_rec->error_fname %s ", r->server->error_fname);
    if(r->server->error_log != NULL) 
      fprintf(strmTmp, "is open\n");
    else
      fprintf(strmTmp, "is not open\n");
  }

  //
  //  Parse the working directory out of the request_rec
  //
  nC = strlen(r->filename);
  for(iC=nC;iC>0;iC--)
    if(r->filename[iC-1] == '/') break;
  if(iC == 0) {
    fprintf(r->server->error_log, "Unable to parse PUT filename: %s\n", r->filename);
    fprintf(r->server->error_log, "Cant find directory seperator.\n");
    fprintf(r->server->error_log, "Skipping RCS and Mail checks.\n");
    return result;
  }
  strPath = (char *) calloc(iC+1, sizeof(char));
  if(strPath == NULL) {
    fprintf(r->server->error_log,
            "Unable to allocate memory for directory string\n");
    fprintf(r->server->error_log, "Skipping RCS and Mail checks\n");
    return result;
  }

  strncpy(strPath, r->filename, iC);
  fprintf(strmTmp, "PUT directory: %s\n", strPath);

  //
  //  Check to see if an RCS directory exists in the working directory,
  //  if so perform a system call to check in the new revision and check
  //  it back out in the locked state.
  //

  //
  //  Check to see if an RCS directory exists
  //
/*    strRCSDir = (char *) calloc(iC+4, sizeof(char)); */
/*    if(strRCSDir == NULL) { */
/*      fprintf(r->server->error_log,  */
/*              "Unable to allocate memory for RCS directory string.\n"); */
/*      fprintf(r->server->error_log, "Skipping any RCS logging\n"); */
/*    } */
/*    else { */
/*      strcpy(strRCSDir, strPath); */
/*      strcat(strRCSDir, "RCS"); */
/*      dirTemp = opendir(strRCSDir); */
/*      if(dirTemp == NULL) { */
/*        fprintf(r->server->error_log,  */
/*                "Unable to open RCS directory: %s\n", strRCSDir); */
/*        if(errno == EACCES) */
/*          fprintf(r->server->error_log,  */
/*                  "Insufficient permissions on RCS directory\n"); */
/*        if(errno == EMFILE) */
/*          fprintf(r->server->error_log, */
/*                  "Too many file descriptors in use by process.\n"); */
/*        if(errno == ENOMEM) */
/*          fprintf(r->server->error_log, */
/*                  "Insufficient memory to complete the operation.\n"); */
/*        if(errno == ENOTDIR) */
/*          fprintf(r->server->error_log, */
/*                  "Name is not a directory\n"); */
/*        if(errno == ENOENT) */
/*          fprintf(r->server->error_log, */
/*                  "RCS directory does not exist\n"); */
/*      } */
/*      else { */
/*        fprintf(strmTmp, "RCS directory %s\n", strRCSDir); */
/*      } */
/*      closedir(dirTemp); */

/*      free(strRCSDir); */
/*    } */

  //
  //  Check to see if there is a .MailList file in the working directory
  //
  strMLFile = (char *) calloc(iC+10, sizeof(char));
  if(strMLFile == NULL) {
    fprintf(r->server->error_log,
            "Unable to allocate memory for mail list file string.\n");
    fprintf(r->server->error_log, "Skipping any mail notification.\n");
  }
  else {
    strcpy(strMLFile, strPath);
    strcat(strMLFile, ".MailList");
    strmMailList = fopen(strMLFile, "r");
    if(strmMailList != NULL) {
      //
      //  Read in the mail list
      //  THIS NEEDS ERROR CHECKING
      //
      strMailList = calloc(1024, sizeof(char));
      fscanf(strmMailList, "%s\n", strMailList);
      fclose(strmMailList);
      strMsg = (char *) calloc(1024, sizeof(char));
      if(strMsg == NULL) {
        fprintf(r->server->error_log,
                "Unable to allocate memory for mail message file string.\n");
        fprintf(r->server->error_log, "Skipping any mail notification.\n");
      }
      else {
        //
        //  Create the message and use a system function to mail it to the MailList
        //
        sprintf(strMsg,
                "echo \"%s has posted new information to the page http://%s%s\" | mail -s \"DPDW Discussion update\" %s",
                r->connection->user, r->server->server_hostname, r->uri, 
                strMailList);
        fprintf(strmTmp, "%s\n", strMsg);
        system(strMsg);
        free(strMailList);
      }
    }
    free(strMLFile);


  }

  //
  //  Clean up
  //
  fclose(strmTmp);  

  free(strPath);
  fflush(r->server->error_log);
  return result;
}

int do_delete(request_rec *r)
{
  put_config_rec *sec = (put_config_rec *)ap_get_module_config (r->per_dir_config, &put_module);

  if(!sec->delete_enabled) return FORBIDDEN;
  if(r->finfo.st_mode == 0) return NOT_FOUND;
  if(unlink(r->filename))
  {
    ap_log_reason("file permissions deny file deletion",r->filename,r);
    return FORBIDDEN;
  }

  ap_send_http_header(r);

  ap_rprintf(r,"<HTML>File %s deleted.</HTML>\n",ap_escape_html(r->pool, r->uri));

  return OK;
}

int put_handler(request_rec *r)
{
  if(r->proxyreq) return DECLINED;
  if(r->method_number == M_PUT)
  {
#ifdef CHARSET_EBCDIC
	  ap_checkconv(r);
#endif
	  return do_put(r);
  }
  else
  if(r->method_number == M_DELETE) return do_delete(r);
  return DECLINED;
}

handler_rec put_handlers[] =
{
	{ "*/*", put_handler },
	{ NULL }
};

module put_module = {
   STANDARD_MODULE_STUFF,
   NULL,			/* initializer */
   create_put_dir_config,	/* dir config creater */
   NULL,			/* dir merger --- default is to override */
   NULL,			/* server config */
   NULL,			/* merge server config */
   put_cmds,			/* command table */
   put_handlers,		/* handlers */
   NULL,			/* filename translation */
   NULL,			/* check_user_id */
   NULL,			/* check access rights */
   NULL,			/* check access */
   NULL,			/* type_checker */
   NULL,			/* fixups */
   NULL,			/* logger */
   NULL				/* header parser */
};
