**FREE

///
// CEE Date API Example: Calculate Weekstart and -end
//
// This example uses the ILE CEE Date API to convert the current or passed date
// into a lilian date. The weekday is calculated through the API CEEDYWK
// (1 - 7, 1 = sunday). Then the weekstart and -end is calculated.
//
// The passed date must be in ISO format like 20161213 for the 13th december 2016
// and needs to be passed as character data, f. e. CALL CALCWEEK '20161213' .
//
// The following APIs were used:
// 
// - Convert Date to Lilian Format (CEEDAYS)
// - Convert Lilian Date to Character Format (CEEDATE)
// - Get Day Of Week (Numeric) (CEEDYWK)
//
// \author Mihael Schmidt
// \date   2016-12-14
///


// the main procedure is used as the program entry point
ctl-opt main(main);


//-------------------------------------------------------------------------------------------------
// Prototypes
//-------------------------------------------------------------------------------------------------
dcl-pr main extpgm('CALCWEEK');
  date char(8) options(*nopass);
end-pr;

dcl-pr cee_getLilianDate extproc('CEEDAYS') opdesc;
  charDate char(20) const options(*varsize);
  formatString char(20) const options(*varsize);
  lilianDate int(10);
  errorcode char(100) options(*varsize : *nopass);
end-pr;

dcl-pr cee_getDateFromLilian extproc('CEEDATE') opdesc;
  lilianDate int(10) const;
  formatString char(20) const options(*varsize);
  dateString char(20) options(*varsize);
  errorcode char(100) options(*varsize : *nopass);
end-pr;

//
// CEEDYWK returns the weekday as a number between 1 and 7
//
// 1 = Sonntag    / Sunday
// 2 = Montag     / Monday
// 3 = Dienstag   / Tuesday
// 4 = Mittwoch   / Wednesday
// 5 = Donnerstag / Thursday
// 6 = Freitag    / Friday
// 7 = Samstag    / Saturday
//
// 0 = Fehler bei der Berechnung / ungültiges Datum / invalid date
//
dcl-pr cee_getDayOfWeekNumeric extproc('CEEDYWK') opdesc;
  lilianDate int(10) const;
  dayOfWeek int(10);
  errorcode char(100) options(*varsize : *nopass);
end-pr;


//-------------------------------------------------------------------------------------------------
// Procedures
//-------------------------------------------------------------------------------------------------
dcl-proc main;
  dcl-pi *N;
    date char(8) options(*nopass);
  end-pi;
  
  dcl-s today packed(7 : 0);
  dcl-s todayLilian int(10);
  dcl-s dayOfWeek int(10);
  dcl-s weekstartL int(10);
  dcl-s weekendL int(10);
  dcl-s weekstart char(10);
  dcl-s weekend char(10);
  dcl-s errorcode char(100);

  // check the parameters
  if (%parms() = 1);
    monitor;
      today = %dec(%date(date : *ISO0) : *longjul);
      on-error *all;
        dsply %trimr('No valid ISO date: ' + date);
        *inlr = *on;
        return;
    endmon;
  else;
    // no parameter passed => take the current date
    today = %dec(%date() : *longjul);
  endif;


  cee_getLilianDate(%char(today) : 'YYYYDDD' : todayLilian);

  cee_getDayOfWeekNumeric(todayLilian : dayOfWeek : errorcode);

  // calculate weekstart /-end
  weekstartL = todayLilian - dayOfWeek + 1;                  // sunday
  weekendL = weekstartL + 6;                                 // saturday
  cee_getDateFromLilian(weekstartL : 'YYYY-MM-DD' : weekstart);
  cee_getDateFromLilian(weekendL : 'YYYY-MM-DD' : weekend);

  dsply %trim('Weekstart: ' + weekstart);
  dsply %trim('Weekend  : ' + weekend);
  
end-proc;
