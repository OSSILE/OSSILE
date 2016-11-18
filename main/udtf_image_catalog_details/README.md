# SQL UDTF Image Catalog Details #

A SQL user defined table function to get the details for an image catalog.

### What does this UDTF do? ###

* This SQL function will return details of a specified image catalog.

* The following attributes are returned:

Attribute                                            | Optical entry | Tape entry    | No entry
-----------------------------------------------------|:-------------:|:-------------:|:-------------:
Image catalog type                                   | Value         | Value         | Value
Image catalog status                                 | Value         | Value         | Value
Reference image catalog indicator                    | Value         | Value         | Value
Dependent image catalog indicator                    | Value         | Value         | Value
Image catalog text                                   | Value         | Value         | Value
Virtual device name                                  | Value         | Value         | Value
Number of image catalog directories                  | Value         | Value         | Value
Number of image catalog entries                      | Value         | Value         | Value
Reference image catalog name                         | Value         | Value         | Value
Reference image catalog library name                 | Value         | Value         | Value
Next tape volume                                     | Value         | Value         | Value
Image catalog mode                                   | Value         | Value         | Value
Image catalog directory                              | Value         | Value         | Value
Image_catalog_entry_index                            | Value         | Value         | null
Image_catalog_entry_status                           | Value         | Value         | null
Image_catalog_entry_text                             | Value         | Value         | null
Image_file_name                                      | Value         | Value         | null
Write_protect_status                                 | Value         | Value         | null
Opt_Volume_name                                      | Value         | null          | null
Opt_Access_information                               | Value         | null          | null
Opt_Media_type                                       | Value         | null          | null
Opt_Image_size_MB                                    | Value         | null          | null
Tap_Volume_name                                      | null          | Value         | null
Tap_Maximum_volume_size_MB                           | null          | Value         | null
Tap_Current_number_of_bytes_available                | null          | Value         | null
Tap_Current_number_of_bytes_used_by_volume           | null          | Value         | null
Tap_Percent_used                                     | null          | Value         | null
Tap_First_file_sequence_number_in_the_virtual_volume | null          | Value         | null
Tap_Last_file_sequence_number_in_the_virtual_volume  | null          | Value         | null
Tap_Next_volume_indicator                            | null          | Value         | null
Tap_Density                                          | null          | Value         | null
Tap_Type_of_volume                                   | null          | Value         | null
Tap_Allocated_volume_size_MB                         | null          | Value         | null


### How do I get set up? ###

For build and setup instructions, refer to the [README.md](../../README.md) for the OSSILE project


### Usage example ###
```
select * from table(qgpl.image_catalog_details()) icd
```


### API Documentation ###

[Retrieve Image Catalog Details (QVOIRCLD) API](http://www.ibm.com/support/knowledgecenter/ssw_ibm_i_71/apis/qvoircld.htm)
