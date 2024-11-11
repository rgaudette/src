#include<iostream.h>

//
//  Class: bdlink
//  
//   A bidirectional link with an integer data item
//
class bdlink {

  //  Pointers to adjacent links
  bdlink* prev;
  bdlink* next;

  //  The stored value
  int val;
  
public:
 
  //  Set the previous link pointer
  void setPrev(bdlink* new_prev) {
    prev = new_prev;
  }

  //  Set the next link pointer
  void setNext(bdlink* new_next) {
    next = new_next;
  }

  //  Get the next link pointer
  bdlink* getNext(void) {return next;}

  //  Set the value of the link
  void setVal(int new_val) {
    val = new_val;
  }

  //  Get the value of the link
  int get_val(void) {return val; }
};

//
//  Class: dllist
//
class dllist {
  //
  // Pointer to the head of the list
  //
  
  bdlink* head;
  
public:
  dllist(int init_val) {
    head = new bdlink;
    head->setPrev(NULL);
    head->setNext(NULL);
    head->setVal(init_val);
  }
  //
  // Necessary interfaces
  // append - append an item on to the end of the list
  // remove - remove an item from the end of the list
  // insert - insert an item at a specified place on the list
  // delete - delete a specfied item on the list
  // walk_and_print - wa
  
  void append(int newval);

  void walk_and_print(void);
};

void dllist::append(int newval) {

}


void dllist::walk_and_print(void) {
  bdlink* curr = head;
  int iLink = 1;
  int cv; 
  do {
    cv = curr->get_val();
    cout << "Link: " << iLink << '\t' << cv << '\n';;
    curr = curr->getNext();
  }while(curr != NULL) ;
}

int main(int argc, char *argv[]) {

  dllist my_list(3);
  
  my_list.walk_and_print();
  
}
