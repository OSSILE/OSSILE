             CMD        PROMPT('Get PTF ftom iPTF site')                        
             PARM       KWD(SITE) TYPE(*CHAR) LEN(128) +                        
                          DFT('delivery01-bld.dhe.ibm.com') +                   
                          PROMPT('IBM iPTF Site')                               
             PARM       KWD(USER) TYPE(*CHAR) LEN(15) PROMPT('iPTF +            
                          User (use quotes)')  DFT('anonymous')                 
             PARM       KWD(PASSWORD) TYPE(*CHAR) LEN(15) +                     
                          PROMPT('User Password (use quotes)')                  
             PARM       KWD(DIR) TYPE(*CHAR) LEN(50) PROMPT('iPTF +             
                          Rmt Dir')                                             
             PARM       KWD(IMGCLG) TYPE(*CHAR) LEN(10) DFT('iPTF') +           
                          PROMPT('Image Catalog Name')                          
             PARM       KWD(LCLDIR) TYPE(*CHAR) LEN(30) DFT('/iPTF') +          
                          PROMPT('iPTF Local Directory')                        
