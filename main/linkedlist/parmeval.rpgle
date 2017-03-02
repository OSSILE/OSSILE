      *------------------------------------------------------------------------------
      *                          The MIT License (MIT)
      *
      * Copyright (c) 2017 Mihael Schmidt
      *
      * Permission is hereby granted, free of charge, to any person obtaining a copy 
      * of this software and associated documentation files (the "Software"), to deal 
      * in the Software without restriction, including without limitation the rights 
      * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
      * copies of the Software, and to permit persons to whom the Software is 
      * furnished to do so, subject to the following conditions:
      * 
      * The above copyright notice and this permission notice shall be included in 
      * all copies or substantial portions of the Software.
      *
      * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
      * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
      * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
      * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
      * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
      * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
      * SOFTWARE.
      *------------------------------------------------------------------------------


     H nomain
     
     
      *-------------------------------------------------------------------------
      * Prototypes
      *-------------------------------------------------------------------------
      /copy PARMEVAL_H
           

     /**
      * \brief Parameter Evaluation
      *
      * This procedure checks the passed number which combination of power of 2
      * numbers are added. It iterates through <em>all</em> numbers which may
      * be <em>inside</em> the passed number and returns for each a 1 or 0.
      *
      * <br><br>
      *
      * Example: 13
      * <ul>
      *   <li>1  = 1</li>
      *   <li>2  = 0</li>
      *   <li>4  = 1</li>
      *   <li>8  = 1</li>
      * </ul>
      *
      * For 13 it would return the string '1011'.
      *
      * \author Mihael Schmidt
      * \date   21.04.2008
      * 
      * \param Combination of power of 2 numbers
      * 
      * \return Evaluated parameter string (as varying)
      */
     P evalParm        B                    export
     D                 PI           100A    varying
     D   parm                        10I 0  const
      *
     D powerOf         PR             8F    extproc('pow')
     D  parm1                         8F    value
     D  parm2                         8F    value
      *
     D tmpParm         S             10I 0
     D start           S             10I 0
     D powStart        S             10I 0
     D retVal          S            100A    varying
      /free
       tmpParm = parm;

       // search for power of 2 which is bigger than the parm
       dow (powStart <= parm);
         start += 1;
         powStart = %int(powerOf(2 : start));
       enddo;

       // check if every power of 2 is in the parm
       // the checking is done backwards starting with the biggest
       dow (start > 0);
         start -= 1;
         powStart = %int(powerOf(2 : start));

         if (tmpParm < powStart);
           retVal = '0' + retVal;  // not in the parm
         else;
           retVal = '1' + retVal;  // parm contains this power of 2
           tmpParm -= powStart;
         endif;
       enddo;

       return retVal;
      /end-free
     P                 E
