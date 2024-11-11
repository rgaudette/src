#include <windows.h>
#include <winsock.h>
#include <stdio.h>
#include <stdlib.h>
#include <memory.h>

void DisplayWSAError(char *strErrMsg, int errCode);

void main(int argc, char * argv[]) {
    char        strHostname[256], rcvBuff[65536];
    int         errCode, lenSktAddr, nBytesRcv, nBytesSnd;

    WORD        wVersionRequested;
    WSADATA     WSAData;

    SOCKET      sktListen, sktServer, sktClient;
    SOCKADDR_IN inetClientAddr, inetServerAddr;
    u_short     portNum = 2000; 

    struct hostent  *infoHost;


    //
    //  Sockets application initialization, only necessary under windows 
    //	sockets appliactions
    //
    wVersionRequested = MAKEWORD(1,1);
    if(WSAStartup(wVersionRequested, &WSAData)) {
        errCode = WSAGetLastError();
        DisplayWSAError("Unable to initialize Windows sockets", errCode);
        exit(0);
    }

	
    //
    //  Create the socket address structure for server listen socket
    //
    gethostname(strHostname, sizeof(strHostname));
    printf("On host: %s\n", strHostname);
    infoHost = gethostbyname(strHostname);
    memcpy(&inetClientAddr.sin_addr, infoHost->h_addr, infoHost->h_length);
    inetClientAddr.sin_family = AF_INET; 
    inetClientAddr.sin_port = htons(portNum); 


    //
    //  Open the server listen socket
    //
    sktListen = socket(PF_INET, SOCK_STREAM, 0);
    if(sktListen == INVALID_SOCKET){
        errCode = WSAGetLastError();
        DisplayWSAError("Unable to get server socket", errCode);
        exit(0);
    }
    printf("Server socket %d\n", sktListen);


    //
    //  Bind the socket to a name
    //
    lenSktAddr = sizeof(inetClientAddr);
    if(bind(sktListen, &inetClientAddr, lenSktAddr)) { 
        errCode = WSAGetLastError();
        DisplayWSAError("Unable to bind server socket", errCode);
        exit(0);
    }
    printf("Server socket bound\n");
    printf("Service on port %d\n", ntohs(inetClientAddr.sin_port));
    
	
    //
    //  Get socket name, not sure why we have to do this since we just
    //  passed all of the info during bind?
    //
    if(getsockname(sktListen, (LPSOCKADDR)&inetClientAddr, &lenSktAddr)) {
        errCode = WSAGetLastError();
        DisplayWSAError("Unable to get server socket name", errCode);
        exit(0);
    } 
  
    printf("After getsockname server is on port %d\n",
        ntohs(inetClientAddr.sin_port));

    
    //
    //	Set server socket to listen mode
    //
    printf("Listening...\n");
    if(listen(sktListen, 1)) {
        errCode = WSAGetLastError();
        DisplayWSAError("Unable to listen", errCode);
        exit(0);
    }


    //
    //	Accept new connection and create a new socket
    //
    sktClient = accept(sktListen, NULL, NULL);
	if(sktClient == 0){
        errCode = WSAGetLastError();
        DisplayWSAError("Error accepting connection", errCode);
        exit(0);
    }

    //
    //	Open the client socket
    //
    sktServer = socket(PF_INET, SOCK_STREAM, 0);
    if(sktServer == INVALID_SOCKET){
        errCode = WSAGetLastError();
        DisplayWSAError("Unable to get client socket\n", errCode);
        exit(0);
    }
    printf("Client socket %d\n", sktServer);


    //
    //  Create the socket address structure
    //
    infoHost = gethostbyname(argv[1]);
    if(infoHost == NULL) {
        printf("Can not find host %s\n", argv[1]);
        exit(0);
    }
    memcpy(&inetServerAddr.sin_addr, infoHost->h_addr, infoHost->h_length);
    inetServerAddr.sin_family = AF_INET; 
    inetServerAddr.sin_port = htons(80); 

    
    //
    //  Connect to the true server
    //
    if(connect(sktServer, &inetServerAddr, sizeof(inetServerAddr))) {
        errCode = WSAGetLastError();
        DisplayWSAError("Unable to get client socket\n", errCode);
        exit(0);
    }

    for(;;){
	
        printf("\nWaiting for client response\n");
		
        rcvBuff[nBytesRcv - 1] = 0;
        while(rcvBuff[nBytesRcv - 1] != 10) {
            
            //
            //  Receive message from the client
            //
		    nBytesRcv = recv(sktClient, rcvBuff, 65535, 0);
		    if(nBytesRcv == SOCKET_ERROR) {
                errCode = WSAGetLastError();
		        DisplayWSAError("Unable to receive message from client\n",
                    errCode);
                exit(0);
            }
            else{
                if(nBytesRcv == 0) {
                    printf("Received 0 bytes from client\n");
                    exit(0);
                }
                printf("Received %d bytes from client\n", nBytesRcv);
                rcvBuff[nBytesRcv] = '\0';
                printf("%s\n", rcvBuff);
                printf("ascii code of last char %d\n", rcvBuff[nBytesRcv - 1]);
            }


            //
		    //	Send message to the true server
		    //
		    printf("Sending message to server\n");
            nBytesSnd = send(sktServer, rcvBuff, nBytesRcv, 0);
            if(nBytesSnd == SOCKET_ERROR){
			    errCode = WSAGetLastError();
                DisplayWSAError("Unable to send data to server\n", errCode);
            }
            printf("Bytes sent to server: %d\n", nBytesSnd);
        }
	    
        rcvBuff[nBytesRcv - 1] = 0;
        while(rcvBuff[nBytesRcv - 1] != 10) {
            //
            //  Receive the response from the true server
            //
            printf("\nWaiting for server response\n");
            nBytesRcv = recv(sktServer, rcvBuff, 65535, 0);
            if(nBytesRcv == SOCKET_ERROR) {
                errCode = WSAGetLastError();
                DisplayWSAError("Unable to receive data from server\n",
                    errCode);
                exit(0);
            }
            else {
                if(nBytesRcv == 0) {
                    printf("Received 0 bytes from server\n");
                    exit(0);
                }
                printf("Received %d bytes from server\n", nBytesRcv);
                rcvBuff[nBytesRcv] = '\0';
                printf("%s\n", rcvBuff);
                printf("ascii code of last char %d\n", rcvBuff[nBytesRcv - 1]);
            }
		
        
            //
            //  Pass the data back to the real client
            //
            printf("Sending message to client\n");
            nBytesSnd = send(sktClient, rcvBuff, nBytesRcv, 0);
            if(nBytesSnd == SOCKET_ERROR){
                errCode = WSAGetLastError();
                DisplayWSAError("Unable pass data back to the client\n",
                    errCode);
            }
            printf("Bytes sent to client: %d\n", nBytesSnd);
        }
    }
	
    //
    //  Clean up the open sockets
    //
    if(closesocket(sktListen)){
        errCode = WSAGetLastError();
        DisplayWSAError("Error closing listen socket\n", errCode);
    }
    if(closesocket(sktClient)){
        errCode = WSAGetLastError();
        DisplayWSAError("Error closing client socket\n", errCode);
    }
    if(closesocket(sktServer)){
        errCode = WSAGetLastError();
        DisplayWSAError("Error closing server socket\n", errCode);
    }
}

void DisplayWSAError(char *strErrMsg, int errCode) {
    fprintf(stderr, "%s\n", strErrMsg);
    fprintf(stderr, "Error number: %d\n", errCode);
    switch(errCode) {
	
    case WSANOTINITIALISED:
        printf("Windows sockets not initialized.\n");
        break;
	
    case WSAENETDOWN:
        printf("Network subsystem has failed.\n");
        break;
	
    case WSAEFAULT:
        printf("The namelen argument is not large enough.\n");
        break;

    case WSAEINPROGRESS:
        printf("A blocking Windows Sockets operation is in progress.\n");
        break;

    case WSAENOTSOCK:
        printf("The descriptor is not a socket.\n");
        break;

    case WSAEINVAL:
        printf("The socket has not been bound to an address with bind.\n");
        break;

    case WSAECONNREFUSED:
        printf("Connection refused\n");
        break;

    case WSAECONNRESET:
        printf("Connection reset\n");
        break;

    case WSAENOTCONN:
        printf("Socket not connected\n");
        break;

    default:
        printf("Unknown winsock error\n");
    }
}