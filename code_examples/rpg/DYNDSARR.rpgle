**FREE

Ctl-Opt DftActGrp(*No) ActGrp(*New);

Dcl-S Ptr   Pointer; //Keep at first element
Dcl-S DsPtr Pointer; //Ds Element

Dcl-Ds PersonData Qualified Based(DsPtr);
  ID    Int(5);
  Name  Char(25);
  Email Char(50);
  Telno Char(11);
END-DS;

Dcl-S DsElements Int(3);

//*********************************

SetElements(10);

SetIndex(1);
PersonData.ID    = 1;
PersonData.Name  = 'Liam';
PersonData.Email = 'me@me.com';
PersonData.Telno = '123456';


SetIndex(2);
PersonData.ID    = 2;
PersonData.Name  = 'Emily';
PersonData.Email = 'you@me.com';
PersonData.Telno = '654321';

SetIndex(1);

SetClear();

*InLR = *On;
Return;

//*********************************

Dcl-Proc SetElements;
  Dcl-Pi *N;
    pEleCount Int(3) Const;
  END-PI;

  If (Ptr = *Null);
    DsElements = pEleCount;
    Ptr   = %Alloc((%Size(PersonData) * DsElements) + 1);
    DsPtr = Ptr;
  Else;
    If (pEleCount > DsElements);
      //Realloc only works when allocating more memory, not less
      DsElements = pEleCount;
      Ptr = %Realloc(Ptr:(%Size(PersonData) * DsElements) + 1);
    Endif;
  ENDIF;
END-PROC;

//*********************************

Dcl-Proc SetIndex;
  Dcl-Pi *N;
    pIndex Int(3) Value;
  END-PI;

  If (pIndex < 1 OR pIndex > DsElements);
    //Can't be out of range
    Return;
  ENDIF;
  pIndex -= 1;

  DsPtr = Ptr + (%Size(PersonData) * pIndex);
END-PROC;

//*********************************

Dcl-Proc SetClear;
  Dealloc(NE) Ptr;
END-PROC; 
