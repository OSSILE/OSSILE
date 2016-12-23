# Interfaces in RPG #

In RPG from time to time there may be a need for some dynamics in your 
programming style. Especially when you want to be more open about the 
possibilities of your program. 

This is probably even more true when you are not doing in-house development 
because with in-house development your know your client and their needs and 
can change the program to the needs of that **one** client.

But when your are selling a product you probably have *different* clients with 
*different* needs. This is even more true with open source development. There 
may be thousands of "clients" which you don't even know and thus cannot know 
their special needs nor their environments.


## Scenario
In this example we will develop a program which imports master data from 
different sources. The data may come in different formats, f. e. XML, fixed 
column length text file, CSV file and perhaps even in JSON via a web service. 
And perhaps next year there will be a totally new and cool binary format. Who 
knows. (There currently are binary formats available like [BSON](http://bsonspec.org/) 
but they are not so commonly used for data exchange at the moment).


## Interface
First you want to define an interface with which your main program (which 
processes the data) will communicate. So you have your main program and probably 
some programs (or service programs) which will handle the different inputs 
(input providers).

One possibility to code this would be for the main program to directly talk to 
each input provider.

```
                        +----------+
                        |          |
                        |   Main   |
                        |          |
                        +----------+
                           + + +
                           | | |
                           | | |
           +---------------+ | +---------------+
           |                 |                 |
           v                 v                 v
      +----------+      +----------+      +----------+
      |          |      |          |      |          |
      | SRVPGM A |      | SRVPGM B |      | SRVPGM C |
      |          |      |          |      |          |
      +----------+      +----------+      +----------+
```

But this would bind the main program directly to all input providers. We will 
abstract the input with an input interface.


```
                        +----------+
                        |          |
                        |   Main   |
                        |          |
                        +----------+
                             +
                             |
                             |
                             v
                        +----------+
                        |          |
                        | Interface|
                        |          |
                        +----------+
                           + + +
                           | | |
                           | | |
           +---------------+ | +---------------+
           |                 |                 |
           v                 v                 v
      +----------+      +----------+      +----------+
      |          |      |          |      |          |
      | SRVPGM A |      | SRVPGM B |      | SRVPGM C |
      |          |      |          |      |          |
      +----------+      +----------+      +----------+
```

Now we can bind the main program to the interface and leave it open which input 
provider will be used.

We now need to define what should be passed between the input provider the 
interface and the main program.

```
dcl-pr input_load pointer extproc('input_load') end-pr;
```

We settle on returning a pointer to the main program. Though anything could hide 
behind this pointer we specify it in the API documentation of the interface what 
the caller can expect to get with a call of the procedure. It is important to 
write this down and the best place is directly at the interface prototype. 

```
///
// \brief Loading input data from resource
//
// This procedure returns the next input data from the resource. It returns one
// item at a time.
//
// \param Input provider
//
// \return item_t - the data structure is empty if no more items are available
///
dcl-pr input_load likeds(item_t) extproc('input_load');
  inputProvider pointer const;
end-pr;
```

Note: I like to prefix exported procedure with a namespace to make it (more) 
      unique.

Now we need to define the data structure for the data.

```
dcl-ds item_t qualified template;
  ean char(13);
  name char(20);
  description char(100);
  vendor int(10);
end-ds;
```

And we need to define the data structure for the input interface.

```
dcl-ds input_t qualified template;
  userData pointer;
  proc_load pointer(*proc);
  proc_finalize pointer(*proc);
end-ds;
```

Most input providers will probably need to do some clean up (like closing a 
file) after getting all the data from the resource so we need to add a procedure 
for that and we call it input_finalize.

```
///
// \brief Clean up
// 
// This procedure will clean up and free any resources.
//
// \param Input provider
///
dcl-pr input_finalize extproc('input_finalize');
  inputProvider pointer;
end-pr;
```

We have the prototypes and the data structures defined. Now we need the program 
code which routes the call to the corresponding input provider implementation.

```
dcl-proc input_load export;
  dcl-pi *N likeds(item_t);
    inputProvider pointer const;
  end-pi;

  dcl-s ptr pointer;
  dcl-ds inputDs likeds(input_t) based(ptr);
  dcl-s procPointer pointer(*proc);
  dcl-pr load likeds(item_t) extproc(procPointer);
    inputProvider pointer const;
  end-pr;

  ptr = inputProvider;
  procPointer = inputDs.proc_load;

  return load(inputProvider);
end-proc;
```

```
dcl-proc input_finalize export;
  dcl-pi *N;
    inputProvider pointer;
  end-pi;

  dcl-s ptr pointer;
  dcl-ds inputDs likeds(input_t) based(ptr);
  dcl-s procPointer pointer(*proc);
  dcl-pr finalize pointer extproc(procPointer);
    inputProvider pointer;
  end-pr;

  ptr = inputProvider;
  procPointer = inputDs.proc_finalize;

  finalize(inputProvider);

  if (ptr <> *null);
    dealloc(ne) ptr;
  endif;
end-proc;
```

## Input Provider
Each input provider needs to implement the procedures from the interface, 
namely _input_load_ and _input_finalize_.

```
dcl-proc input_xml_load;
  dcl-pi *N likeds(ítem_t);
    inputProvider pointer const;
  end-pi;

  dcl-ds item likeds(item_t);

  // fill item_t data structure with next item data
  ...

  return item;
end-proc;
```

```
dcl-proc input_xml_finalize;
  dcl-pi *N;
    inputProvider pointer;
  end-pi;

  dcl-ds inputDs likeds(input_t) based(inputProvider);
  dcl-ds inputProviderDs likeds(input_xml_t) based(inputDs.userData);

  // clean up allocated memory for the input provider
  dealloc inputDs.userData;
  dealloc(n) inputProvider;
end-proc;
```

We also need a procedure which sets up the xml input provider and a data 
structure which holds the xml input provider specific data.

```
dcl-ds input_xml_t qualified template;
  path char(1024);
  loaded ind;
  items likeds(item_t) dim(100);
  itemCount int(10);
  currentItemIndex int(10);
end-ds;
```

```
///
// \brief Create XML input provider instance
//
// \param null terminated string which holds the path to the xml stream file
//
// \return pointer to the xml input provider instance
///
dcl-proc input_xml_create export;
  dcl-pi *N pointer;
    userData pointer const;
  end-pi;

  dcl-s ptr pointer;
  dcl-s inputDs likeds(input_t) based(ptr);
  dcl-s inputProviderPtr;
  dcl-s inputProviderDs likeds(input_xml_t);

  ptr = %alloc(%size(input_t);

  inputProvider = %alloc(%size(input_xml_t));
  inputProviderDs.path = %str(userData);

  ...

  inputDs.userData = inputProviderPtr;
  inputDs.proc_load = %paddr('input_xml_load');
  inputDs.proc_finalize = %paddr('input_xml_finalize');

  return ptr;
end-proc;
```


## Put it all together
And here is the main program which chooses which input provider it uses and 
calls the interface procedures.

```
**FREE

ctl-opt main(main);

/include 'input_t.rpgle'
/include 'input_h.rpgle'
/include 'input_xml_h.rpgle'

dcl-pr main end-pr;

dcl-proc main;
  dcl-s input pointer;
  dcl-s inputProvider pointer;
  dcl-ds item likeds(item_t);

  // creates the instance of the xml input provider
  inputProvider = input_xml_create('data.xml');

  // load the data via the input provider
  item = input_load(inputProvider);
  dow (item.id <> *blank);
    dsply item.id;      
    item = input_load(inputProvider);
  enddo;

  // cleanup the input provider
  input_finalize(inputProvider);
end-proc;
```
Note: By directly creating a the input provider in the main program we have a 
dependency to the input provider implementation from the main program, see More 
Dynamics.


## Extending
If you put all interface data structures necessary for implementing an input 
provider into one file/member (_input_t_ and _item_t_ in this case), you can 
even extend the system without having any other dependencies.

Clients can extend the system without touching the code base of the program, 
see _More Dynamics_.


## Dependencies
The funny thing is that only RPG developers are happy to have dependencies 
between their objects. The rest of the software development world hate 
dependencies (or at least too many dependencies). 

The reason is quite simple: RPG developers like to check the object dependencies 
to know which programs and objects are related and needs to be checked if 
something needs to be changed.

The rest of the development world hate too many dependencies because they tend 
to make it more painful to test the programs with a test framework.

It is not the case that their is no unit test framework available for RPG, 
[RPGUnit](http://rpgunit.sf.net) and [ILEUnit](http://ileunit.sf.net). But 
writing unit tests sadly hasn't gained much ground in the RPG community.


## More dynamics
In the above example of the main program the input provider has been hard coded 
into the program code which is ok. But sometimes we need to be even more dynamic. 
With the [Reflection](http://rpgnextgen.com/index.php?content=download#reflection) 
service program (thanks to [Dieter Bender](http://www.bender-dv.de) ) we can get 
the procedure pointer for a procedure by its name, like this:

```
procedurePointer = reflection_getProcedurePointer(serviceProgram : %trimr(createProcedureName));
```

This also removes the direct object dependency to the input provider.


## Building
The project stores the source code in the IFS in stream files. The make
tool is used to build the project. BIN_LIB and INCLUDE are variables in the
Makefile which can be overwritten with your own values.

BIN_LIB: the library for modules and binding directory

INCLUDE: the IFS folder for the header files / copy books

```
make BIN_LIB=MSCHMIDT INCLUDE=/home/mschmidt/include
```

Note: The Makefile needs a PC like CCSID, like 819.


## Finishing
Some of my side projects use interfaces like the [RNG Input Provider]
(http://rpgnextgen.com/index.php?content=input) project.


## Tools
Here are some of the tools I used:

- [Dillinger](http://dillinger.io) - Markdown editor
- [ASCIIFlow](http://www.asciidraw.com) - ASCII Art editor
- [MiWorkplace](https://miworkplace.com) - RPG Editor


## Questions
If you have any questions just drop me a mail at mihael@rpgnextgen.com .
