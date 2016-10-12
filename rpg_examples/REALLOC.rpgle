**FREE

Ctl-Opt DftActGrp(*No);

Dcl-S Ptr  Pointer;

Ptr = %Alloc(11);
%Str(Ptr:11) = 'HELLOWORLD';

Ptr = %Realloc(Ptr:21);

Dealloc(NE) Ptr;

*InLR = *On;
Return; 
