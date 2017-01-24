**FREE

Ctl-Opt DftActGrp(*No);

Dcl-Ds Location;
  LIBRARY Char(10) Pos(1);
  OBJECT  Char(10) Pos(11);
END-DS;

Location = 'QSYS      SOMEOBJ';
//OR
LIBRARY = 'QSYS';
OBJECT  = 'SOMEOBJ';

*InLR = *On;
Return; 
