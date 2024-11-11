/****
 *
 *	list.h - definitions for list data structures
 *
 ***/
#ifndef __LIST_HEADER__
#define __LIST_HEADER__
 
typedef
 	struct listhdr
 	{
 		struct listhdr *next, *prev;
 	}
 	list;
 	
#define LISTHDR list *next, *prev
#define TLISTHDR(type) type *next, *prev
#define NULLPTR NULL
 
#define P(node) ((node)->prev)
#define N(node) ((node)->next)
 
typedef
 	struct list_list
 	{
 		TLISTHDR(struct list_list);
 		list *l_list;
 	}list_list;
 	
#define LLIST(type,ll) (type*)ll->l_list
 
#define NEW_LIST_LIST NEW(list_list, sizeof(list_list))
 
#define ADD(new,first) (P(new) = NULL, N(new) = first,\
 			( ((first)!=NULL) ? (P(first)= (new), 0) :0),\
 			first = (new))
 							
#define INSERT(new,after) (P(new) = (after),N(new) = N(after),\
			( (N(after)!=NULL) ? (P(N(after))=(new), 0) :0),\
 			N(after) = (new) )
 							
#define REMOVE(elt) ( ( (P(elt)!=NULL) ? (N(P(elt))=N(elt), 0) :0 ),\
 			( (N(elt)!=NULL) ? (P(N(elt))=P(elt), 0) :0) )
 							
#define TRACE(t_var,ini) for((t_var)=(ini); (t_var)!=NULL; (t_var) = N(t_var))
#define FREE_LIST(lst) {while(N(lst)){lst=N(lst);free(P(lst));}free(lst);}
#define FIRSTP(ptr) (P(ptr) == NULL)
#define ENDP(ptr) (N(ptr) == NULL)
 
#define DEL(elt,base) ( ( (P(elt)!=NULL) ? (N(P(elt)) = N(elt)) :0),\
 			( (N(elt)!=NULL) ? (P(N(elt)) = P(elt)) :0) ,\
 			( ((elt)==(base)) ? ((base) = N(base) ) :0))

#endif
