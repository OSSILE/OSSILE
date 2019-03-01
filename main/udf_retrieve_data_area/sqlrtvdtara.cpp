// Copyright (c) 2018 IBM
// 
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <memory.h>
#include <qusec.h>
#include <qwcrdtaa.h>
#include <sqludf.h>
#include <except.h>
#include <mih/cpynv.h>

#define MAX_SIZE 2000

#define BUFFER_SIZE (sizeof(Qwc_Rdtaa_Data_Returned_t) + MAX_SIZE)

static int retrieve_data_area(const char* lib, const short* lib_ind,
                              const char* name, const short* name_ind,
                              char* buffer, char* sqlstate, char* msgdata)
{
    char obj_name[20];
    const char* blanks = "          ";
    
    ::memcpy(obj_name, *name_ind ? blanks : name, 10);
    ::memcpy(obj_name+10, *lib_ind ? blanks : lib, 10);
    
    int err = 0;
    
#pragma exception_handler (OtherErrExit, 0, 0, _C2_MH_ESCAPE, _CTLA_HANDLE,        "CPF0000 MCH0000 CEE0000")
#pragma exception_handler (NotFoundExit, 0, 0, _C2_MH_ESCAPE, _CTLA_HANDLE_NO_MSG, "CPF1015 CPF1021")
#pragma exception_handler (NotAuthExit,  0, 0, _C2_MH_ESCAPE, _CTLA_HANDLE_NO_MSG, "CPF1016 CPF1022")
#pragma exception_handler (NotAllocExit, 0, 0, _C2_MH_ESCAPE, _CTLA_HANDLE_NO_MSG, "CPF1063 CPF1067")
    
    QWCRDTAA(buffer, BUFFER_SIZE, obj_name, -1, MAX_SIZE, &err);
    
#pragma disable_handler
#pragma disable_handler
#pragma disable_handler
#pragma disable_handler
    
    return 0;
    
NotFoundExit:
    strcpy(sqlstate, "42704");
    goto ErrorExit;
    
NotAuthExit:
    strcpy(sqlstate, "42501");
    goto ErrorExit;
    
NotAllocExit:
    strcpy(sqlstate, "57012");
    goto ErrorExit;
    
OtherErrExit:
    strcpy(sqlstate, "58004");
    goto ErrorExit;
    
ErrorExit:
    return -1;
}

extern "C" int retrieve_data_area_char(
  // IN parameters
  const SQLUDF_CHAR* name,
  const SQLUDF_CHAR* library,
  const SQLUDF_INTEGER* offset,
  const SQLUDF_INTEGER* length,
  
  // OUT parameters
  SQLUDF_VARCHAR* data,
  
  // IN indicators
  const SQLUDF_NULLIND* name_ind,
  const SQLUDF_NULLIND* library_ind,
  const SQLUDF_NULLIND* offset_ind,
  const SQLUDF_NULLIND* length_ind,
  
  // OUT indicators
  SQLUDF_NULLIND* data_ind,
  
  // UDF args
  SQLUDF_TRAIL_ARGS)
{
    int act_offset = 0, act_length = MAX_SIZE;
    char buffer[BUFFER_SIZE];
    
    // Assume OK
    strcpy(sqludf_sqlstate, SQLUDF_STATE_OK);
    *sqludf_msgtext = 0;
    
    if(*offset_ind == 0)
    {
        act_offset = *offset - 1;
    }
    
    if(*length_ind == 0)
    {
        act_length = *length;
    }
    
    if(act_offset < 0 || act_length < 0)
    {
        // Invalid lengths specified
        strcpy(sqludf_sqlstate, "22023");
        strcpy(sqludf_msgtext, "NEGATIVE OFFSET OR LENGTH SPECIFIED");

        return 0;
    }
    
    if(retrieve_data_area(library, library_ind, name, name_ind, buffer,
       sqludf_sqlstate, sqludf_msgtext) < 0) return 0;
    
    Qwc_Rdtaa_Data_Returned_t* header = (Qwc_Rdtaa_Data_Returned_t*) buffer;

    char* returned_data = buffer + sizeof(*header);
    int data_length = header->Bytes_Returned - sizeof(*header);
    
    // If it's not a decimal type, return the character data
    // otherwise, convert the packed decimal data to a character string
    if(memcmp(header->Type_Value_Returned, "*DEC ", 5) != 0)
    {
        if(act_offset > data_length)
        {
            // offset is past data, nothing to return
            *data = 0;
            return 0;
        }
        
        returned_data += act_offset;
        data_length -= act_offset;
        
        if(act_length > data_length)
        {
            act_length = data_length;
        }
        
        ::memcpy(data, returned_data, act_length);
        data[act_length] = 0;
    }
    else
    {
        int scale = header->Length_Value_Returned;
        int digits = header->Number_Decimal_Positions;
        
        char* num = buffer + header->Bytes_Returned;
        
        cpynv(NUM_DESCR(_T_ZONED,  scale, digits), num,
              NUM_DESCR(_T_PACKED, scale, digits), returned_data);
        
        // If negative print the sign leading and convert to char
        if((num[scale-1] & 0xF0) == 0xD0 )
        {
            *data++ = '-';
            num[scale-1] |= 0xF0;
        }
        
        // Remove leading and trailing zeroes from output
        char* start = num;
        char* end = num + scale;
        char* mid = end - digits;
        
        for(; start < mid && *start == 0xF0; ++start) ;
        for(; end > mid && end[-1] == 0xF0; --end) ;
        
        int bytes = (int)(mid - start);
        memcpy(data, start, bytes);
        data += bytes;
        
        bytes = (int)(end - mid);
        if(bytes)
        {
            // TODO: Do we need to accomodate different' decimal formats?
            *data++ = '.';
            
            memcpy(data, mid, bytes);
            data[bytes] = 0;
        }
    }
    *data_ind = 0;
    
    return 0;
}

extern "C" int retrieve_data_area_decimal(
  // IN parameters
  const SQLUDF_CHAR* name,
  const SQLUDF_CHAR* library,
  
  // OUT parameters
  SQLUDF_VARCHAR* data,
  
  // IN indicators
  const SQLUDF_NULLIND* name_ind,
  const SQLUDF_NULLIND* library_ind,
  
  // OUT indicators
  SQLUDF_NULLIND* data_ind,
  
  // UDF args
  SQLUDF_TRAIL_ARGS)
{
    char buffer[BUFFER_SIZE];
    
    // Assume OK
    strcpy(sqludf_sqlstate, SQLUDF_STATE_OK);
    *sqludf_msgtext = 0;
    
    if(retrieve_data_area(library, library_ind, name, name_ind, buffer,
       sqludf_sqlstate, sqludf_msgtext) < 0) return 0;
    
    Qwc_Rdtaa_Data_Returned_t* header = (Qwc_Rdtaa_Data_Returned_t*) buffer;
    
    // If it's not a decimal, return NULL
    if(memcmp(header->Type_Value_Returned, "*DEC ", 5) != 0)
    {
        *data_ind = -1;
        return 0;
    }
    
    char* returned_data = buffer + sizeof(*header);
    int scale = header->Length_Value_Returned;
    int digits = header->Number_Decimal_Positions;

    // Widen the decimal to the output size: DEC(37,9)
    // The largest decimal type allowed in a data area is
    // DEC(28,9) which means we have to support up to 28 digits
    // before the decimal and 9 digits after, thus DEC(37,9)
    cpynv(NUM_DESCR(_T_PACKED,    37,      9), data,
          NUM_DESCR(_T_PACKED, scale, digits), returned_data);
    *data_ind = 0;
    
    return 0;
}
