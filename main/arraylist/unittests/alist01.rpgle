     /**
      * \brief Unit Test : ArrayList
      *
      * \author Mihael Schmidt
      * \date   19.04.2011
      *
      * \link http://www.rpgnextgen.com RPG Next Gen
      * \link http://rpgunit.sourceforge.net RPGUnit 
      */

     H nomain

      *-------------------------------------------------------------------------
      * Prototypes
      *-------------------------------------------------------------------------
     D test_create...
     D                 PR
     D test_add...
     D                 PR
     D test_addPositioned...
     D                 PR
     D test_typedValues...
     D                 PR
     D test_remove...
     D                 PR
     D test_contains...
     D                 PR
     D test_index...
     D                 PR
     D test_bigList...
     D                 PR
     D test_frequency...
     D                 PR
     D test_replace...
     D                 PR
     D test_copy...
     D                 PR
     D test_sublist...
     D                 PR
     D test_swap...
     D                 PR
     D test_foreach...
     D                 PR
     D test_toCharArray...
     D                 PR
     D test_reverse...
     D                 PR
     D test_split...
     D                 PR
     D test_toString...
     D                 PR
      *
     D callback_foreach...
     D                 PR                  extproc('callback_foreach')
     D   entry                         *   const
     D   length                      10I 0 const
     D   userdata                      *   const


      /copy RPGUNIT1,TESTCASE
      /copy alist_h

     P test_create...
     P                 B                   export
      *
     D arraylist       S               *
      /free
       arraylist = arraylist_create();
       assert(arraylist <> *null : 'Pointer to arraylist must not be null.');

       arraylist_dispose(arraylist);

       assert(arraylist = *null : 'Pointer to arraylist must be null after ' +
                                  'disposal.');
      /end-free
     P                 E


     P test_add...
     P                 B                   export
      *
     D arraylist       S               *
     D value           S             50A

      /free
       arraylist = arraylist_create();

       value = 'Mihael Schmidt';
       arraylist_add(arraylist : %addr(value) : %size(value));
       iEqual(1 : arraylist_getSize(arraylist));

       clear value;
       value = %str(arraylist_get(arraylist : 0));
       aEqual('Mihael Schmidt' : value);

       arraylist_dispose(arraylist);
      /end-free
     P                 E

     P test_addPositioned...
     P                 B                   export
      *
     D arraylist       S               *
     D value           S             50A

      /free
       arraylist = arraylist_create();

       value = 'Mihael';
       arraylist_add(arraylist : %addr(value) : %size(value));
       value = 'Aaron';
       arraylist_add(arraylist : %addr(value) : %size(value) : 0);

       clear value;
       value = %str(arraylist_get(arraylist : 0));
       aEqual('Aaron' : value);

       clear value;
       value = %str(arraylist_get(arraylist : 1));
       aEqual('Mihael' : value);

       monitor;
         value = %str(arraylist_get(arraylist : 10));
         fail('This should have triggered an out of bounds error.');
         on-error *all;
         assert(*on : 'This should have triggered an out of bounds error.');
       endmon;

       value = 'Jon';
       arraylist_addFirst(arraylist : %addr(value) : %size(value));
       value = 'Scott';
       arraylist_addLast(arraylist : %addr(value) : %size(value));

       iEqual(4 : arraylist_getSize(arraylist));

       clear value;
       value = %str(arraylist_getFirst(arraylist));
       aEqual('Jon' : value);

       clear value;
       value = %str(arraylist_getLast(arraylist));
       aEqual('Scott' : value);

       arraylist_dispose(arraylist);
      /end-free
     P                 E


     P test_typedValues...
     P                 B                   export
      *
     D arraylist       S               *
     D float           S              4F
     D double          S              8F
      /free
       arraylist = arraylist_create();

       arraylist_addShort(arraylist : 1);
       arraylist_addInteger(arraylist : 358);
       arraylist_addLong(arraylist : 2011041920110419);
       arraylist_addDecimal(arraylist : 15.5);
       arraylist_addString(arraylist : 'Mihael');
       arraylist_addBoolean(arraylist : *on);
       arraylist_addDate(arraylist : %date());
       arraylist_addFloat(arraylist : 1.23456789);
       arraylist_addDouble(arraylist :1.234567890123456789);

       iEqual(1 : arraylist_getShort(arraylist : 0));
       iEqual(358 : arraylist_getInteger(arraylist : 1));
       assert(2011041920110419 = arraylist_getLong(arraylist : 2) :
              'Long value not equal');
       assert(15.5 = arraylist_getDecimal(arraylist : 3) :
              'Decimal value not equal');
       aEqual('Mihael' : arraylist_getString(arraylist : 4));
       assert(arraylist_getBoolean(arraylist : 5) :
              'Boolean value not true');
       assert(%date() = arraylist_getDate(arraylist : 6) :
              'Date value not today');
       assert(1.23456789 - arraylist_getFloat(arraylist : 7) < 0.00000001 :
              'Float value not equal: ' +
              %char(arraylist_getFloat(arraylist : 7)));
       assert(1.234567890123456789 - arraylist_getDouble(arraylist : 8) <
              0.000000000000000001 :
              'Double value not equal: ' +
              %char(arraylist_getDouble(arraylist : 8)));

       arraylist_dispose(arraylist);
      /end-free
     P                 E


     P test_empty...
     P                 B                   export
      *
     D arraylist       S               *
      /free
       arraylist = arraylist_create();

       assert(arraylist_isEmpty(arraylist) : 'ArrayList must be empty after ' +
                                             'creation.');

       arraylist_addString(arraylist : 'Mihael');

       assert(not arraylist_isEmpty(arraylist) :
              'ArrayList must not be empty after adding one element.');

       arraylist_clear(arraylist);

       assert(arraylist_isEmpty(arraylist) : 'ArrayList must be empty ' +
                                             'after clearing.');

       iEqual(0 : arraylist_getSize(arraylist));

       arraylist_dispose(arraylist);
      /end-free
     P                 E


     P test_remove...
     P                 B                   export
      *
     D arraylist       S               *
      /free
       arraylist = arraylist_create();

       arraylist_addString(arraylist : 'Mihael');
       arraylist_addString(arraylist : 'Larry');
       arraylist_addString(arraylist : 'Mark');
       arraylist_addString(arraylist : 'Brian');
       arraylist_addString(arraylist : 'Dieter');
       arraylist_addString(arraylist : 'Thomas');

       iEqual(6 : arraylist_getSize(arraylist));

       arraylist_remove(arraylist : 0);
       iEqual(5 : arraylist_getSize(arraylist));
       aEqual('Larry' : arraylist_getString(arraylist : 0));

       arraylist_removeFirst(arraylist);
       iEqual(4 : arraylist_getSize(arraylist));
       aEqual('Mark' : arraylist_getString(arraylist : 0));

       arraylist_removeLast(arraylist);
       iEqual(3 : arraylist_getSize(arraylist));
       aEqual('Mark' : arraylist_getString(arraylist : 0));
       aEqual('Dieter' : arraylist_getString(arraylist : 2));

       monitor;
         arraylist_remove(arraylist : 100);
         fail('This should have triggered an out of bounds error.');
         on-error *all;
           assert(*on : 'This should have triggered an out of bounds error.');
       endmon;

       arraylist_addString(arraylist : 'Mihael');
       arraylist_addString(arraylist : 'Larry');
       iEqual(5 : arraylist_getSize(arraylist));

       arraylist_removeRange(arraylist : 0 : 2);
       iEqual(3 : arraylist_getSize(arraylist));
       aEqual('Dieter' : arraylist_getString(arraylist : 0));

       monitor;
         arraylist_removeRange(arraylist : 0 : 10);
         fail('This should trigger an out of bounds error.');
         on-error *all;
           assert(*on : 'This should trigger an out of bounds error.');
       endmon;
       iEqual(3 : arraylist_getSize(arraylist));

       arraylist_dispose(arraylist);
      /end-free
     P                 E


     P test_index...
     P                 B                   export
      *
     D arraylist       S               *
     D stringValue     S             10A
     D intValue        S             10I 0
      /free
       arraylist = arraylist_create();

       arraylist_addString(arraylist : 'Mihael');
       arraylist_addString(arraylist : 'Dieter');
       arraylist_addString(arraylist : 'Thomas');
       arraylist_addInteger(arraylist : 358);
       arraylist_addString(arraylist : 'Mihael');
       arraylist_addDate(arraylist : %date());

       stringValue = 'Mihael';
       iEqual(0 : arraylist_indexOf(arraylist : %addr(stringValue) : 6));
       intValue = 358;
       iEqual(3 : arraylist_indexOf(arraylist : %addr(intValue) : 4));
       intValue = 359;
       iEqual(-1 : arraylist_indexOf(arraylist : %addr(intValue) : 4));

       iEqual(4 : arraylist_lastIndexOf(arraylist : %addr(stringValue) : 6));
       iEqual(-1 : arraylist_lastIndexOf(arraylist : %addr(stringValue) : 7));

       arraylist_dispose(arraylist);
      /end-free
     P                 E

     P test_contains...
     P                 B                   export
      *
     D arraylist       S               *
     D stringValue     S             10A
     D dateValue       S               D
     D intValue        S             10I 0

      /free
       arraylist = arraylist_create();

       arraylist_addString(arraylist : 'Mihael');
       arraylist_addString(arraylist : 'Dieter');
       arraylist_addString(arraylist : 'Thomas');
       arraylist_addInteger(arraylist : 358);
       arraylist_addDate(arraylist : %date());

       stringValue = 'Mihael';
       assert(arraylist_contains(arraylist : %addr(stringValue) : 6) :
              'String value is in the arraylist.');
       assert(not arraylist_contains(arraylist : %addr(stringValue) : 8) :
              'String value with trailing blanks is not in the arraylist.');
       stringValue = 'MIHAEL';
       assert(not arraylist_contains(arraylist : %addr(stringValue) : 6) :
              'Uppercase string value is not in the arraylist.');
       intValue = 358;
       assert(arraylist_contains(arraylist : %addr(intValue) : 4) :
              '358 (int) is in the arraylist.');
       intValue = 359;
       assert(not arraylist_contains(arraylist : %addr(intValue) : 4) :
              '359 (int) is not in the arraylist.');

       arraylist_dispose(arraylist);
      /end-free
     P                 E


     P test_frequency...
     P                 B                   export
      *
     D arraylist       S               *
     D string          S             10A
      /free
       arraylist = arraylist_create();

       arraylist_addString(arraylist : 'Mihael');
       arraylist_addString(arraylist : 'Dieter');
       arraylist_addString(arraylist : 'Thomas');
       arraylist_addInteger(arraylist : 358);
       arraylist_addString(arraylist : 'Mihael');
       arraylist_addDate(arraylist : %date());

       string = 'Mihael';
       iEqual(2 : arraylist_frequency(arraylist : %addr(string) : 6));
       string = 'Dieter';
       iEqual(1 : arraylist_frequency(arraylist : %addr(string) : 6));
       iEqual(0 : arraylist_frequency(arraylist : %addr(string) : 7));

       arraylist_dispose(arraylist);
      /end-free
     P                 E


     P test_replace...
     P                 B                   export
      *
     D arraylist       S               *
     D string          S             10A
      /free
       arraylist = arraylist_create();

       arraylist_addString(arraylist : 'Mihael');
       arraylist_addString(arraylist : 'Dieter');
       arraylist_addString(arraylist : 'Thomas');
       arraylist_addString(arraylist : 'Scott');

       iEqual(4 : arraylist_getSize(arraylist));

       string = 'Henrik';

       arraylist_replace(arraylist : 3 : %addr(string) : 6);

       iEqual(4 : arraylist_getSize(arraylist));
       aEqual('Mihael' : arraylist_getString(arraylist : 0));
       aEqual('Dieter' : arraylist_getString(arraylist : 1));
       aEqual('Thomas' : arraylist_getString(arraylist : 2));
       aEqual('Henrik' : arraylist_getString(arraylist : 3));

       monitor;
         arraylist_replace(arraylist : 4 : %addr(string) : 6);
         fail('This should have triggered an out of bounds error.');
         on-error *all;
           assert(*on : 'This should have triggered an out of bounds error.');
       endmon;

       arraylist_dispose(arraylist);
      /end-free
     P                 E


     P test_bigList...
     P                 B                   export
      *
     D arraylist       S               *
     D i               S             10I 0
      /free
       arraylist = arraylist_create();

       for i = 0 to 100000;
         arraylist_addInteger(arraylist : i);
       endfor;

       for i = 0 to 10;
         iEqual(i * 10000 : arraylist_getInteger(arraylist : i) * 10000);
       endfor;

       arraylist_dispose(arraylist);
      /end-free
     P                 E


     P test_copy...
     P                 B                   export
      *
     D arraylist       S               *
     D copylist        S               *
      /free
       arraylist = arraylist_create();

       arraylist_addString(arraylist : 'Mihael');
       arraylist_addString(arraylist : 'Dieter');
       arraylist_addString(arraylist : 'Thomas');

       copylist = arraylist_copy(arraylist);

       assert(copylist <> *null :'copy must return a pointer to an arraylist.');
       iEqual(3 : arraylist_getSize(copylist));
       aEqual('Mihael' : arraylist_getString(copylist : 0));
       aEqual('Dieter' : arraylist_getString(copylist : 1));
       aEqual('Thomas' : arraylist_getString(copylist : 2));

       arraylist_dispose(copylist);
       arraylist_dispose(arraylist);
      /end-free
     P                 E


     P test_sublist...
     P                 B                   export
      *
     D arraylist       S               *
     D sublist         S               *
      /free
       arraylist = arraylist_create();

       arraylist_addString(arraylist : 'Mihael');
       arraylist_addString(arraylist : 'Dieter');
       arraylist_addString(arraylist : 'Thomas');

       // complete sublist
       sublist = arraylist_sublist(arraylist : 0);
       assert(sublist <> *null :
              'sublist must return a pointer to an arraylist.');
       iEqual(3 : arraylist_getSize(sublist));
       aEqual('Mihael' : arraylist_getString(sublist : 0));
       aEqual('Dieter' : arraylist_getString(sublist : 1));
       aEqual('Thomas' : arraylist_getString(sublist : 2));
       arraylist_dispose(sublist);

       // partial list
       sublist = arraylist_sublist(arraylist : 2);
       iEqual(1 : arraylist_getSize(sublist));
       aEqual('Thomas' : arraylist_getString(sublist : 0));
       arraylist_dispose(sublist);

       // partial list with specified length
       sublist = arraylist_sublist(arraylist : 1 : 1);
       assert(sublist <> *null :
              'sublist must return a pointer to an arraylist.');
       iEqual(1 : arraylist_getSize(sublist));
       aEqual('Dieter' : arraylist_getString(sublist : 0));
       arraylist_dispose(sublist);

       // provoke out of bounds error
       monitor;
         arraylist_sublist(arraylist : 4);
         fail('This should have triggered an out of bounds error.');
         on-error *all;
           assert(*on : 'This should have triggered an out of bounds error.');
       endmon;

       // provoke out of bounds error
       monitor;
         arraylist_sublist(arraylist : 1 : 10);
         fail('This should have triggered an out of bounds error.');
         on-error *all;
           assert(*on : 'This should have triggered an out of bounds error.');
       endmon;

       arraylist_dispose(arraylist);
      /end-free
     P                 E


     P test_swap...
     P                 B                   export
      *
     D arraylist       S               *
      /free
       arraylist = arraylist_create();

       arraylist_addString(arraylist : 'Mihael');
       arraylist_addString(arraylist : 'Dieter');
       arraylist_addString(arraylist : 'Thomas');

       arraylist_swap(arraylist : 0 : 2);
       aEqual('Thomas' : arraylist_getString(arraylist : 0));
       aEqual('Dieter' : arraylist_getString(arraylist : 1));
       aEqual('Mihael' : arraylist_getString(arraylist : 2));

       arraylist_swap(arraylist : 1 : 1);
       aEqual('Thomas' : arraylist_getString(arraylist : 0));
       aEqual('Dieter' : arraylist_getString(arraylist : 1));
       aEqual('Mihael' : arraylist_getString(arraylist : 2));

       arraylist_dispose(arraylist);
      /end-free
     P                 E


     P test_foreach...
     P                 B                   export
      *
     D arraylist       S               *
     D sum             S             10I 0
     D i               S             10I 0
      /free
       arraylist = arraylist_create();

       for i = 1 to 10;
         arraylist_addInteger(arraylist : i);
       endfor;

       iEqual(10 : arraylist_getSize(arraylist));
       iEqual(0 : sum);

       arraylist_foreach(arraylist : %paddr('callback_foreach') : %addr(sum));

       iEqual(55 : sum);

       arraylist_dispose(arraylist);
      /end-free
     P                 E


     P callback_foreach...
     P                 B
     D                 PI
     D   entry                         *   const
     D   length                      10I 0 const
     D   userdata                      *   const
      *
     D sum             S             10I 0 based(userdata)
     D number          S             10I 0 based(entry)
      /free
       sum += number;
      /end-free
     P                 E


     P test_toCharArray...
     P                 B                   export
      *
     D arraylist       S               *
     D names           S             10A   dim(5)
      /free
       arraylist = arraylist_create();

       arraylist_addString(arraylist : 'LinkedList');
       arraylist_addString(arraylist : 'Vector');
       arraylist_addString(arraylist : 'ArrayList');

       iEqual(3 : arraylist_getSize(arraylist));

       arraylist_toCharArray(arraylist : %addr(names) : %elem(names) : 10);

       aEqual('LinkedList' : names(1));
       aEqual('Vector' : names(2));
       aEqual('ArrayList' : names(3));
       aEqual(*blank : names(4));
       aEqual(*blank : names(5));

       arraylist_dispose(arraylist);
      /end-free
     P                 E


     P test_reverse...
     P                 B                   export
      *
     D arraylist       S               *
      /free
       arraylist = arraylist_create();

       // on empty list
       arraylist_reverse(arraylist);

       // on list with just one element
       arraylist_addString(arraylist : 'Mihael');
       arraylist_reverse(arraylist);
       iEqual(1 : arraylist_getSize(arraylist));
       aEqual('Mihael' : arraylist_getString(arraylist : 0));

       // on list with multiple elements
       arraylist_addString(arraylist : 'Dieter');
       arraylist_addString(arraylist : 'Thomas');

       arraylist_reverse(arraylist);
       aEqual('Thomas' : arraylist_getString(arraylist : 0));
       aEqual('Dieter' : arraylist_getString(arraylist : 1));
       aEqual('Mihael' : arraylist_getString(arraylist : 2));

       arraylist_dispose(arraylist);
      /end-free
     P                 E


     P test_split...
     P                 B                   export
      *
     D arraylist       S               *
     D string          S          65535A
      /free
       arraylist = arraylist_create();

       string = 'Linked List;Vector;ArrayList' + x'00';
       arraylist = arraylist_split(string);

       assert(arraylist <> *null : 'Pointer should not be null if assigned ' +
                                   'by split');
       iEqual(3 : arraylist_getSize(arraylist));
       aEqual('Linked List' : arraylist_getString(arraylist : 0));
       aEqual('Vector' : arraylist_getString(arraylist : 1));
       aEqual('ArrayList' : arraylist_getString(arraylist : 2));

       arraylist_dispose(arraylist);

       string = 'Linked List Vector ArrayList';
       arraylist = arraylist_split(string : ' ');
       iEqual(4 : arraylist_getSize(arraylist));
       aEqual('Linked' : arraylist_getString(arraylist : 0));
       aEqual('List' : arraylist_getString(arraylist : 1));
       aEqual('Vector' : arraylist_getString(arraylist : 2));
       aEqual('ArrayList' : arraylist_getString(arraylist : 3));

       arraylist_dispose(arraylist);
      /end-free
     P                 E


     P test_toString...
     P                 B                   export
      *
     D arraylist       S               *
     D string          S           1000A   varying
      /free
       arraylist = arraylist_create();

       arraylist_addString(arraylist : 'Dieter');
       arraylist_addString(arraylist : 'Mihael');
       arraylist_addString(arraylist : 'Thomas');

       string = arraylist_toString(arraylist);
       aEqual('Dieter,Mihael,Thomas' : string);

       string = arraylist_toString(arraylist : ';');
       aEqual('Dieter;Mihael;Thomas' : string);

       string = arraylist_toString(arraylist : ',' : ' { ' : ' } ');
       aEqual(' { Dieter } , { Mihael } , { Thomas } ' : string);

       arraylist_dispose(arraylist);
      /end-free
     P                 E
