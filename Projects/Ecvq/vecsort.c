/*************************************************************************
**************************************************************************
**  Function: VecSort
**
**  Description:
**      VecSort searches through vecValues and fills Indices with the
**  indices of the decreasing sorted vecValues.
**
**
**  $Author: root $
**
**  $Date: 1996/03/20 03:02:34 $
**
**  $Revision: 1.5 $
**
**  $State: Exp $
**
**  $Log: vecsort.c,v $
**  Revision 1.5  1996/03/20 03:02:34  root
**  *** empty log message ***
**
**    Revision 1.5  1995/08/29  02:06:09  root
**    Changed malloc.h to stdlib.h include
**
**    Revision 1.4  1995/08/28  02:23:03  root
**    Fixed forgotten freeing of lstArray
**
**    Revision 1.3  1995/08/28  02:21:07  root
**    Added include for malloc.h
**
**    Revision 1.2  1995/08/19  22:19:59  root
**    INT32 changed to standard int.
**
**    Revision 1.1  1995/08/19  19:36:50  root
**    Initial revision
**
**
**
**************************************************************************
*************************************************************************/

#include <stdio.h>
#include <stdlib.h>

void VecSort(float *vecValues, int *Indices, int nValues) {

    int idxVal;
    
    typedef struct list_simple {
        float Value;
        int Index;
        struct list_simple *ptrNext;
    } lstSimple;

    lstSimple Head, *lstArray, *lstCurrLink;

    lstArray = (lstSimple *) calloc(nValues, sizeof(lstSimple));
    if(lstArray == NULL) {
        fprintf(stderr, "VecSort: Unable to allocate linked list\n");
    }

    /**
     **  Initialization 
     **       - copy the vector values into the list
     **       - set the head of the list to point to the first element
     **/
    for(idxVal = 0; idxVal < nValues; idxVal++) {
        lstArray[idxVal].Value = vecValues[idxVal];
        lstArray[idxVal].Index = idxVal;
        lstArray[0].ptrNext = NULL;
    }

    Head.ptrNext = &(lstArray[0]);

    /**
     **  Walk through the array inserting links when a value is found that
     **  is less than the current value.
     **/
    for(idxVal = 1; idxVal < nValues; idxVal++) {
        lstCurrLink = &Head;
        while(lstCurrLink->ptrNext->Value > vecValues[idxVal]) {
            /**
             **  Inctrement the pointer to the next link
             **/
            lstCurrLink = lstCurrLink->ptrNext;

            /**
             **  If we are at the end of the list break out of the loop.
             **/
            if(lstCurrLink->ptrNext == NULL) {
                break;
            }
        }
        
        /**
         **  Insert the link at the current point
         **/
        lstArray[idxVal].ptrNext = lstCurrLink->ptrNext;
        lstCurrLink->ptrNext = &(lstArray[idxVal]);
    }

    /**
     **  Walk the list copying the indices into Indices
     **/
    
    lstCurrLink = Head.ptrNext;
    idxVal = 0;
    while(lstCurrLink->ptrNext != NULL){
        Indices[idxVal++] = lstCurrLink->Index;
        lstCurrLink = lstCurrLink->ptrNext;
    }
    
    Indices[idxVal] = lstCurrLink->Index;

    free(lstArray);
}

