**FREE

Ctl-Opt DftActGrp(*No);

Dcl-Ds BBCNewsData Qualified Dim(50);
  Title       Varchar(128);
  Description Varchar(1024);
  Link        Varchar(255);
  Published   Varchar(20);
END-DS;

EXEC SQL
  DECLARE BBC_Cur CURSOR FOR
  SELECT *
  FROM XMLTABLE('$result/rss/channel/item'
      PASSING XMLPARSE(
         DOCUMENT
           SYSTOOLS.HTTPGETCLOB('http://feeds.bbci.co.uk/news/world/rss.xml?edition=uk','')
      ) as "result"
         COLUMNS
            title VARCHAR(128) PATH 'title',
            description VARCHAR(1024) PATH 'description',
            link VARCHAR(255) PATH 'link',
   		   pubDate VARCHAR(20) PATH 'substring(pubDate, 1, 16)'
   ) AS RESULT;

EXEC SQL OPEN BBC_Cur;

EXEC SQL
  FETCH NEXT FROM BBC_Cur
  FOR 50 ROWS
  INTO :BBCNewsData;

EXEC SQL CLOSE BBC_Cur;

*InLR = *On;
Return; 
