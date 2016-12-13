-- Return source membres list
Create or Replace function OSSILE/LIST_SOURCE_MEMBERS (
      Library CHAR(10),
      FILE    char(10) ,
      Member  char(10) )
 RETURNS  TABLE (SRCNAME CHAR(10) , 
                 SRCTYPE CHAR(10), 
                 srcDATCRT DATE ,
                 srcDATCHG DATE, 
                 srcTEXT char(50)
                )
specific list_src_mbr
language RPGLE
deterministic
no sql               
external name 'OSSILE/LISTMEMBER'
parameter style DB2SQL
not fenced;

Create or Replace function OSSILE/LIST_SOURCE_MEMBERS (
      Library CHAR(10),
      FILE    char(10) )
 RETURNS  TABLE (SRCNAME CHAR(10) , 
                 SRCTYPE CHAR(10), 
                 srcDATCRT DATE ,
                 srcDATCHG DATE, 
                 srcTEXT char(50)
                )
specific list_src_mbr_all
language SQL
modifies SQL data
not fenced
set option commit=*none
begin
  return select * from table(OSSILE/List_Source_members ( Library, File, '*ALL' )) AS x;
end;
 
 