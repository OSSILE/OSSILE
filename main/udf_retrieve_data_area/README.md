# SQL UDF Retrieve Data Area #

A set of SQL user defined functions to retrieve data from data areas.

## RETRIEVE_DATA_AREA_CHAR(name, library, offset, length)

Returns data area data as a character string. If the data area is a *DEC data
area, it will be converted to string format and returned. *LGL data areas are
treated the same as a *CHAR data area with length 1.

### Parameters
- name: data area name
- library: data area library, default `*LIBL`
- offset: 1-2000, default `NULL`
- length: 1-2000, default `NULL`

NOTE: If the offset/length is outside of the range of the data area data, only
the data is available will be returned and no padding will be added.

## RETRIEVE_DATA_AREA_DEC(name, library)

Returns data area data as a decimal. If the data area is not a *DEC data
area, an error is generated.

### Parameters
- name: data area name
- library: data area library, default `*LIBL`

NOTE: To accommodate data areas of any size, the return size is a DECIMAL(37, 9)

### How do I get set up? ###

For build and setup instructions, refer to the [README.md](../../README.md) for the OSSILE project

### Usage Example ###
* Call the SQL function like the following
```
CL: 
CL:CRTDTAARA DTAARA(TESTCHAR) TYPE(*CHAR) LEN(20) VALUE('hello world')
CL:CRTDTAARA DTAARA(TESTBOOL) TYPE(*LGL) VALUE('1')
CL:CRTDTAARA DTAARA(TESTDEC) TYPE(*DEC) LEN(20 9) VALUE(12345.67890)

values(ossile.retrieve_data_area_char('TESTCHAR'));
values(ossile.retrieve_data_area_char('TESTBOOL'));
values(ossile.retrieve_data_area_char('TESTDEC'));

values(ossile.retrieve_data_area_dec('TESTDEC'));
```


### API Documentation ###

[Retrieve Data Area (QWCRDTAA) API](https://www.ibm.com/support/knowledgecenter/ssw_ibm_i_73/apis/qwcrdtaa.htm)
