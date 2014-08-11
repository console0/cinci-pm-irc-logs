<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:date="http://exslt.org/dates-and-times"
                xmlns:str="http://exslt.org/strings"
                xmlns:func="http://exslt.org/functions"
                xmlns:math="http://exslt.org/math"
                xmlns:chamdate="http://whapps.com/functions"
                extension-element-prefixes="date str func chamdate math">




<!--

   Chamdate - the chamelon 5 date utility XSLT
   
   This library is comprised of a number of handy utilities for handling
   date formatting without the need to reinvent the wheel: no awful substring hackery
   or asking a back-end developer to modify XML output.
   
   Chamdate can do:
   
   CONVERSION
   
   
   chamdate:datify         -  mysql to xslt date conversion
   
   
   DATE FORMATTING
   
   chamdate:pretty-date    -  formats dates in proper english, eg "Monday, January 1, 2014"
   
   chamdate:pretty-time    -  takes the time portion of a date and formats it as "8:05 AM"
   
   chamdate:short-date     -  returns a minimal date format, eg "1/1/2014"
   
   chamdate:format         -  a wrapper for the EXSLT format-date function, which allows you to specify
                              your own date formats using the standard Java notation:
                              see http://docs.oracle.com/javase/7/docs/api/java/text/SimpleDateFormat.html for formatting strings
   
   
   ELAPSED TIME
   
   chamdate:duration       -  returns the duration between two dates in days (d), hours (h), minutes(m), or seconds(s)
   
   chamdate:time-ago       -  returns the amount of timed elapsed since a date in pretty english, eg '5 minutes ago'

   
   
   
   FOR SAMPLES AND PARAMETERS SEE BELOW

--> 


                
<xsl:import href="str.padding.function.xsl" />

<date:months>
   <date:month length="31" abbr="Jan">January</date:month>
   <date:month length="28" abbr="Feb">February</date:month>
   <date:month length="31" abbr="Mar">March</date:month>
   <date:month length="30" abbr="Apr">April</date:month>
   <date:month length="31" abbr="May">May</date:month>
   <date:month length="30" abbr="Jun">June</date:month>
   <date:month length="31" abbr="Jul">July</date:month>
   <date:month length="31" abbr="Aug">August</date:month>
   <date:month length="30" abbr="Sep">September</date:month>
   <date:month length="31" abbr="Oct">October</date:month>
   <date:month length="30" abbr="Nov">November</date:month>
   <date:month length="31" abbr="Dec">December</date:month>
</date:months>

<date:days>
   <date:day abbr="Sun">Sunday</date:day>
   <date:day abbr="Mon">Monday</date:day>
   <date:day abbr="Tue">Tuesday</date:day>
   <date:day abbr="Wed">Wednesday</date:day>
   <date:day abbr="Thu">Thursday</date:day>
   <date:day abbr="Fri">Friday</date:day>
   <date:day abbr="Sat">Saturday</date:day>
</date:days>



<!--
chamdate:datify
converts a date string from an xml result to a format that can be used by any EXSLT date functions
      
example: chamdate:datify('2014-05-07 14:00:00');
      
output: '2014-05-07T14:00:00'
-->

<func:function name="chamdate:datify">
   <xsl:param name="date-string" />
   <func:result select="string(translate($date-string, ' ', 'T'))" />  
</func:function>


<!--
chamdate:is-date
Checks if an ISO date string is in the proper YYYY-MM-DDTHH:MM:SS format
and returns 1 or 0;
      
good example: chamdate:is-date('2014-05-07T14:00:00');
      
output: '1'

bad example: chamdate:is-date('1/1/2014');

output: '0'


-->
<func:function name="chamdate:is-date">
   <xsl:param name="date-string" />
   <func:result>
      <xsl:choose>
         <xsl:when test="
            $date-string != '' and
            substring($date-string, 5, 1) = '-' and
            substring($date-string, 8, 1) = '-' and
            substring($date-string, 11, 1) = 'T'">
            <xsl:value-of select="1" />
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="0" />   
         </xsl:otherwise>
      </xsl:choose>
   </func:result>
</func:function>


<!--  
chamdate:pretty-date
formats date as "Monday, January 1, 2014"
-->

<func:function name="chamdate:pretty-date">
   <xsl:param name="date-string" />
   <func:result select="chamdate:format($date-string, 'EEEE, MMMM d, yyyy')" />
</func:function>

<!--
chamdate:pretty-time
formats date as "12:00 AM/PM"
-->

<func:function name="chamdate:pretty-time">
   <xsl:param name="date-string" />
   <func:result select="chamdate:format($date-string, 'h:mm a')" />
</func:function>

<!--
chamdate:short-date
formats date as M/D/YYYY
-->

<func:function name="chamdate:short-date">
   <xsl:param name="date-string" />
   <func:result select="concat(date:month-in-year(chamdate:datify($date-string)), '/', chamdate:format($date-string, 'd/yyyy'))" />
</func:function>


<!--
chamdate:format
just a wrapper for the date:format-date() function, that takes an existing mysql date and
puts it in the proper format. This will help cut down on noise in your XSLT
-->
   

<func:function name="chamdate:format">
   <xsl:param name="date-string" />
   <xsl:param name="format" />
   <func:result select="date:format-date(chamdate:datify($date-string), $format)" />
</func:function>



<!--

chamdate:duration
returns an interval between two dates, based on parameters

as: 'd' days
    'h' hours
    'm' minutes
    's' seconds

    defaults to days 
    
-->

<func:function name="chamdate:duration">
   
   <xsl:param name="from-date" />
   <xsl:param name="to-date" />
   <xsl:param name="as" />
   
   <xsl:variable name="seconds"  select="date:seconds(date:difference($from-date, $to-date))" />
   
   <xsl:variable name="abs-seconds" select="math:abs($seconds)" />
   <xsl:variable name="minutes"  select="$abs-seconds div 60" />
   <xsl:variable name="hours"    select="$minutes div 60" />
   <xsl:variable name="days"     select="$hours div 24" />
   
   <func:result>
      <xsl:choose>
         <!-- d for days -->
         <xsl:when test="$as = 'd'">
            <xsl:value-of select="floor($days)" />      
         </xsl:when>
         <!-- h for hours -->
         <xsl:when test="$as = 'h'">
            <xsl:value-of select="floor($hours)" />      
         </xsl:when>
         
         <!-- m for minutes -->
         <xsl:when test="$as = 'm'">
            <xsl:value-of select="floor($minutes)" />      
         </xsl:when>
         
         <!-- s for seconds -->
         <xsl:when test="$as = 's'">
            <xsl:value-of select="$abs-seconds" />      
         </xsl:when>
         
         <!-- if nothing matches, then return days -->
         <xsl:otherwise>
            <xsl:value-of select="floor($days)" />
         </xsl:otherwise>
      </xsl:choose> 
      
   </func:result>   
</func:function>


<!--
chamdate:time-ago
outputs relative time in pretty english
-->

<func:function name="chamdate:time-ago">
   
   <xsl:param name="date-string" />
   
   <xsl:variable name="now" select="date:date()" />
   <xsl:variable name="minutes" select="date:seconds(date:difference(chamdate:datify($date-string), $now)) div 60" />
   <xsl:variable name="delta-minutes" select="math:abs($minutes)" />
   
   <xsl:variable name="delta-in-words">
      <xsl:choose>
         <xsl:when test="$delta-minutes &lt; 1">
                 <xsl:text>less than a minute</xsl:text>
         </xsl:when>
         <xsl:when test="$delta-minutes = 1">
                 <xsl:text>1 minute</xsl:text>
         </xsl:when>
         <xsl:when test="$delta-minutes &lt; 45">
                 <xsl:value-of select="$minutes"/>
                 <xsl:text> minutes</xsl:text>
         </xsl:when>
         <xsl:when test="$delta-minutes &lt; 90">
                 <xsl:text>about one hour</xsl:text>
         </xsl:when>
         <xsl:when test="$delta-minutes &lt; 1440">
                 <xsl:value-of select="floor($delta-minutes div 60)"/>
                 <xsl:text> hours</xsl:text>
         </xsl:when>
         <xsl:when test="$delta-minutes &lt; 2880">
                 <xsl:text>one day</xsl:text>
         </xsl:when>
         <xsl:when test="$delta-minutes &lt; 43200">
                 <xsl:value-of select="round($delta-minutes div 1440)"/>
                 <xsl:text> days</xsl:text>
         </xsl:when>
         <xsl:when test="$delta-minutes &lt; 86400">
                 <xsl:text> about one month</xsl:text>
         </xsl:when>
         <xsl:when test="$delta-minutes &lt; 525600">
                 <xsl:value-of select="floor($delta-minutes div 43200)"/>
                 <xsl:text> months</xsl:text>
         </xsl:when>
         <xsl:when test="$delta-minutes &lt; 1051200">
                 <xsl:value-of select="floor($delta-minutes div 10080)"/>
                 <xsl:text> about one year</xsl:text>
         </xsl:when>
         <xsl:otherwise>
                 <xsl:value-of select="floor($delta-minutes div 525600)"/>
                 <xsl:text> years</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:variable>

   <xsl:choose>
      <xsl:when test='$minutes &lt; 0'>
         <xsl:choose>
                 <xsl:when test='$delta-in-words = "one day"'>
                     <func:result> tomorrow</func:result>
                 </xsl:when>
                 <xsl:when test='$delta-in-words = "about one month"'>
                     <func:result> last month</func:result>
                 </xsl:when>
                 <xsl:when test='$delta-in-words = "about one year"'>
                     <func:result> last year</func:result>
                 </xsl:when>
                 <xsl:otherwise>
                        <func:result>
                         <xsl:value-of select='$delta-in-words' />
                         <xsl:text> from now</xsl:text>
                        </func:result>
                 </xsl:otherwise>
         </xsl:choose>			
      </xsl:when>
      <xsl:otherwise>
         <xsl:choose>
                 <xsl:when test='$delta-in-words = "one day"'>
                         <func:result> yesterday</func:result>
                 </xsl:when>
                 <xsl:when test='$delta-in-words = "about one month"'>
                         <func:result> next month</func:result>
                 </xsl:when>
                 <xsl:when test='$delta-in-words = "about one year"'>
                         <func:result> next year</func:result>
                 </xsl:when>
                 <xsl:otherwise>
                        <func:result>
                         <xsl:value-of select='$delta-in-words' />
                         <xsl:text> ago</xsl:text>
                        </func:result>
                 </xsl:otherwise>
         </xsl:choose>
      </xsl:otherwise>
   </xsl:choose>
   

</func:function>
   


<!-- the date formatting magic DO NOT TOUCH. EVER-->

<func:function name="date:format-date">
   <xsl:param name="date-time" />
   <xsl:param name="format" />
   <xsl:variable name="formatted">
      <xsl:choose>
         <xsl:when test="starts-with($date-time, '---')">
            <xsl:value-of select="date:_format-date($format, 'Z', 'NaN', 'NaN', number(substring($date-time, 4, 2)))" />
         </xsl:when>
         <xsl:when test="starts-with($date-time, '--')">
            <xsl:value-of select="date:_format-date($format, 'Z', 'NaN', number(substring($date-time, 3, 2)), number(substring($date-time, 6, 2)))" />
         </xsl:when>
         <xsl:otherwise>
            <xsl:variable name="neg" select="starts-with($date-time, '-')" />
            <xsl:variable name="no-neg">
               <xsl:choose>
                  <xsl:when test="$neg or starts-with($date-time, '+')">
                     <xsl:value-of select="substring($date-time, 2)" />
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="$date-time" />
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <xsl:variable name="no-neg-length" select="string-length($no-neg)" />
            <xsl:variable name="timezone">
               <xsl:choose>
                  <xsl:when test="substring($no-neg, $no-neg-length) = 'Z'">Z</xsl:when>
                  <xsl:otherwise>
                     <xsl:variable name="tz" select="substring($no-neg, $no-neg-length - 5)" />
                     <xsl:if test="(substring($tz, 1, 1) = '-' or 
                                    substring($tz, 1, 1) = '+') and
                                   substring($tz, 4, 1) = ':'">
                        <xsl:value-of select="$tz" />
                     </xsl:if>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <xsl:if test="not(string($timezone)) or
                          $timezone = 'Z' or 
                          (substring($timezone, 2, 2) &lt;= 23 and
                           substring($timezone, 5, 2) &lt;= 59)">
               <xsl:variable name="dt" select="substring($no-neg, 1, $no-neg-length - string-length($timezone))" />
               <xsl:variable name="dt-length" select="string-length($dt)" />
               <xsl:choose>
                  <xsl:when test="substring($dt, 3, 1) = ':' and
                                  substring($dt, 6, 1) = ':'">
                     <xsl:variable name="hour" select="substring($dt, 1, 2)" />
                     <xsl:variable name="min" select="substring($dt, 4, 2)" />
                     <xsl:variable name="sec" select="substring($dt, 7)" />
                     <xsl:if test="$hour &lt;= 23 and
                                   $min &lt;= 59 and
                                   $sec &lt;= 60">
                        <xsl:value-of select="date:_format-date($format, $timezone, 'NaN', 'NaN', 'NaN', $hour, $min, $sec)" />
                     </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:variable name="year" select="substring($dt, 1, 4) * (($neg * -2) + 1)" />
                     <xsl:choose>
                        <xsl:when test="not(number($year))" />
                        <xsl:when test="$dt-length = 4">
                           <xsl:value-of select="date:_format-date($format, $timezone, $year)" />
                        </xsl:when>
                        <xsl:when test="substring($dt, 5, 1) = '-'">
                           <xsl:variable name="month" select="substring($dt, 6, 2)" />
                           <xsl:choose>
                              <xsl:when test="not($month &lt;= 12)" />
                              <xsl:when test="$dt-length = 7">
                                 <xsl:value-of select="date:_format-date($format, $timezone, $year, $month)" />
                              </xsl:when>
                              <xsl:when test="substring($dt, 8, 1) = '-'">
                                 <xsl:variable name="day" select="substring($dt, 9, 2)" />
                                 <xsl:if test="$day &lt;= 31">
                                    <xsl:choose>
                                       <xsl:when test="$dt-length = 10">
                                          <xsl:value-of select="date:_format-date($format, $timezone, $year, $month, $day)" />
                                       </xsl:when>
                                       <xsl:when test="substring($dt, 11, 1) = 'T' and
                                                       substring($dt, 14, 1) = ':' and
                                                       substring($dt, 17, 1) = ':'">
                                          <xsl:variable name="hour" select="substring($dt, 12, 2)" />
                                          <xsl:variable name="min" select="substring($dt, 15, 2)" />
                                          <xsl:variable name="sec" select="substring($dt, 18)" />
                                          <xsl:if test="$hour &lt;= 23 and
                                                        $min &lt;= 59 and
                                                        $sec &lt;= 60">
                                             <xsl:value-of select="date:_format-date($format, $timezone, $year, $month, $day, $hour, $min, $sec)" />
                                          </xsl:if>
                                       </xsl:when>
                                    </xsl:choose>
                                 </xsl:if>
                              </xsl:when>
                           </xsl:choose>
                        </xsl:when>
                     </xsl:choose>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:variable>
   <func:result select="string($formatted)" />   
</func:function>

<func:function name="date:_format-date">
   <xsl:param name="format" select="''" />
   <xsl:param name="timezone" select="'Z'" />
   <xsl:param name="year" />
   <xsl:param name="month" select="1" />
   <xsl:param name="day" select="1" />
   <xsl:param name="hour" select="0" />
   <xsl:param name="minute" select="0" />
   <xsl:param name="second" select="0" />
   <xsl:variable name="char" select="substring($format, 1, 1)" />
   <xsl:variable name="formatted">
     <xsl:choose>
        <xsl:when test="not($format)" />
        <xsl:when test='$char = "&apos;"'>
           <xsl:choose>
              <xsl:when test='substring($format, 2, 1) = "&apos;"'>
                 <xsl:text>&apos;</xsl:text>
                 <xsl:value-of select="date:_format-date(substring($format, 3), $timezone, $year, $month, $day, $hour, $minute, $second)" />
              </xsl:when>
              <xsl:otherwise>
                 <xsl:variable name="literal-value" select='substring-before(substring($format, 2), "&apos;")' />
                 <xsl:value-of select="$literal-value" />
                 <xsl:value-of select="date:_format-date(substring($format, string-length($literal-value) + 2), $timezone, $year, $month, $day, $hour, $minute, $second)" />
              </xsl:otherwise>
           </xsl:choose>
        </xsl:when>
        <xsl:when test="not(contains('abcdefghjiklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', $char))">
           <xsl:value-of select="$char" />
           <xsl:value-of select="date:_format-date(substring($format, 2), $timezone, $year, $month, $day, $hour, $minute, $second)" />
        </xsl:when>
        <xsl:when test="not(contains('GyMdhHmsSEDFwWakKz', $char))">
           <xsl:message>
              Invalid token in format string: <xsl:value-of select="$char" />
           </xsl:message>
           <xsl:value-of select="date:_format-date(substring($format, 2), $timezone, $year, $month, $day, $hour, $minute, $second)" />
        </xsl:when>
        <xsl:otherwise>
           <xsl:variable name="next-different-char" select="substring(translate($format, $char, ''), 1, 1)" />
           <xsl:variable name="pattern-length">
              <xsl:choose>
                 <xsl:when test="$next-different-char">
                    <xsl:value-of select="string-length(substring-before($format, $next-different-char))" />
                 </xsl:when>
                 <xsl:otherwise>
                    <xsl:value-of select="string-length($format)" />
                 </xsl:otherwise>
              </xsl:choose>
           </xsl:variable>
           <xsl:choose>
              <xsl:when test="$char = 'G'">
                 <xsl:choose>
                    <xsl:when test="string($year) = 'NaN'" />
                    <xsl:when test="$year > 0">AD</xsl:when>
                    <xsl:otherwise>BC</xsl:otherwise>
                 </xsl:choose>
              </xsl:when>
              <xsl:when test="$char = 'M'">
                 <xsl:choose>
                    <xsl:when test="string($month) = 'NaN'" />
                    <xsl:when test="$pattern-length >= 3">
                       <xsl:variable name="month-node" select="document('')/*/date:months/date:month[number($month)]" />
                       <xsl:choose>
                          <xsl:when test="$pattern-length >= 4">
                             <xsl:value-of select="$month-node" />
                          </xsl:when>
                          <xsl:otherwise>
                             <xsl:value-of select="$month-node/@abbr" />
                          </xsl:otherwise>
                       </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$pattern-length = 2">
                       <xsl:value-of select="format-number($month, '00')" />
                    </xsl:when>
                    <xsl:otherwise>
                       <xsl:value-of select="$month" />
                    </xsl:otherwise>
                 </xsl:choose>
              </xsl:when>
              <xsl:when test="$char = 'E'">
                 <xsl:choose>
                    <xsl:when test="string($year) = 'NaN' or string($month) = 'NaN' or string($day) = 'NaN'" />
                    <xsl:otherwise>
                       <xsl:variable name="month-days" select="sum(document('')/*/date:months/date:month[position() &lt; $month]/@length)" />
                       <xsl:variable name="days" select="$month-days + $day + boolean(((not($year mod 4) and $year mod 100) or not($year mod 400)) and $month > 2)" />
                       <xsl:variable name="y-1" select="$year - 1" />
                       <xsl:variable name="dow"
                                     select="(($y-1 + floor($y-1 div 4) -
                                               floor($y-1 div 100) + floor($y-1 div 400) +
                                               $days) 
                                              mod 7) + 1" />
                       <xsl:variable name="day-node" select="document('')/*/date:days/date:day[number($dow)]" />
                       <xsl:choose>
                          <xsl:when test="$pattern-length >= 4">
                             <xsl:value-of select="$day-node" />
                          </xsl:when>
                          <xsl:otherwise>
                             <xsl:value-of select="$day-node/@abbr" />
                          </xsl:otherwise>
                       </xsl:choose>
                    </xsl:otherwise>
                 </xsl:choose>
              </xsl:when>
              <xsl:when test="$char = 'a'">
                 <xsl:choose>
                    <xsl:when test="string($hour) = 'NaN'" />
                    <xsl:when test="$hour >= 12">PM</xsl:when>
                    <xsl:otherwise>AM</xsl:otherwise>
                 </xsl:choose>
              </xsl:when>
              <xsl:when test="$char = 'z'">
                 <xsl:choose>
                    <xsl:when test="$timezone = 'Z'">UTC</xsl:when>
                    <xsl:otherwise>UTC<xsl:value-of select="$timezone" /></xsl:otherwise>
                 </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                 <xsl:variable name="padding">
                    <xsl:choose>
                       <xsl:when test="$pattern-length > 10">
                          <xsl:value-of select="str:padding($pattern-length, '0')" />
                       </xsl:when>
                       <xsl:otherwise>
                          <xsl:value-of select="substring('0000000000', 1, $pattern-length)" />
                       </xsl:otherwise>
                    </xsl:choose>
                 </xsl:variable>
                 <xsl:choose>
                    <xsl:when test="$char = 'y'">
                       <xsl:choose>
                          <xsl:when test="string($year) = 'NaN'" />
                          <xsl:when test="$pattern-length > 2"><xsl:value-of select="format-number($year, $padding)" /></xsl:when>
                          <xsl:otherwise><xsl:value-of select="format-number(substring($year, string-length($year) - 1), $padding)" /></xsl:otherwise>
                       </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$char = 'd'">
                       <xsl:choose>
                          <xsl:when test="string($day) = 'NaN'" />
                          <xsl:otherwise><xsl:value-of select="format-number($day, $padding)" /></xsl:otherwise>
                       </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$char = 'h'">
                       <xsl:variable name="h" select="$hour mod 12" />
                       <xsl:choose>
                          <xsl:when test="string($hour) = 'NaN'"></xsl:when>
                          <xsl:when test="$h"><xsl:value-of select="format-number($h, $padding)" /></xsl:when>
                          <xsl:otherwise><xsl:value-of select="format-number(12, $padding)" /></xsl:otherwise>
                       </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$char = 'H'">
                       <xsl:choose>
                          <xsl:when test="string($hour) = 'NaN'" />
                          <xsl:otherwise>
                             <xsl:value-of select="format-number($hour, $padding)" />
                          </xsl:otherwise>
                       </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$char = 'k'">
                       <xsl:choose>
                          <xsl:when test="string($hour) = 'NaN'" />
                          <xsl:when test="$hour"><xsl:value-of select="format-number($hour, $padding)" /></xsl:when>
                          <xsl:otherwise><xsl:value-of select="format-number(24, $padding)" /></xsl:otherwise>
                       </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$char = 'K'">
                       <xsl:choose>
                          <xsl:when test="string($hour) = 'NaN'" />
                          <xsl:otherwise><xsl:value-of select="format-number($hour mod 12, $padding)" /></xsl:otherwise>
                       </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$char = 'm'">
                       <xsl:choose>
                          <xsl:when test="string($minute) = 'NaN'" />
                          <xsl:otherwise>
                             <xsl:value-of select="format-number($minute, $padding)" />
                          </xsl:otherwise>
                       </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$char = 's'">
                       <xsl:choose>
                          <xsl:when test="string($second) = 'NaN'" />
                          <xsl:otherwise>
                             <xsl:value-of select="format-number($second, $padding)" />
                          </xsl:otherwise>
                       </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$char = 'S'">
                       <xsl:choose>
                          <xsl:when test="string($second) = 'NaN'" />
                          <xsl:otherwise>
                             <xsl:value-of select="format-number(substring-after($second, '.'), $padding)" />
                          </xsl:otherwise>
                       </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$char = 'F'">
                       <xsl:choose>
                          <xsl:when test="string($day) = 'NaN'" />
                          <xsl:otherwise>
                             <xsl:value-of select="floor($day div 7) + 1" />
                          </xsl:otherwise>
                       </xsl:choose>
                    </xsl:when>
                    <xsl:when test="string($year) = 'NaN' or string($month) = 'NaN' or string($day) = 'NaN'" />
                    <xsl:otherwise>
                       <xsl:variable name="month-days" select="sum(document('')/*/date:months/date:month[position() &lt; $month]/@length)" />
                       <xsl:variable name="days" select="$month-days + $day + boolean(((not($year mod 4) and $year mod 100) or not($year mod 400)) and $month > 2)" />
                       <xsl:choose>
                          <xsl:when test="$char = 'D'">
                             <xsl:value-of select="format-number($days, $padding)" />
                          </xsl:when>
                          <xsl:when test="$char = 'w'">
                             <xsl:value-of select="date:_week-in-year($days, $year)" />
                          </xsl:when>
                          <xsl:when test="$char = 'W'">
                             <xsl:variable name="y-1" select="$year - 1" />
                             <xsl:variable name="day-of-week" 
                                           select="(($y-1 + floor($y-1 div 4) -
                                                    floor($y-1 div 100) + floor($y-1 div 400) +
                                                    $days) 
                                                    mod 7) + 1" />
                             <xsl:choose>
                                <xsl:when test="($day - $day-of-week) mod 7">
                                   <xsl:value-of select="floor(($day - $day-of-week) div 7) + 2" />
                                </xsl:when>
                                <xsl:otherwise>
                                   <xsl:value-of select="floor(($day - $day-of-week) div 7) + 1" />
                                </xsl:otherwise>
                             </xsl:choose>
                          </xsl:when>
                       </xsl:choose>
                    </xsl:otherwise>
                 </xsl:choose>
              </xsl:otherwise>
           </xsl:choose>
           <xsl:value-of select="date:_format-date(substring($format, $pattern-length + 1), $timezone, $year, $month, $day, $hour, $minute, $second)" />
        </xsl:otherwise>
     </xsl:choose>
   </xsl:variable>
   <func:result select="string($formatted)" />
</func:function>

<func:function name="date:_week-in-year">
   <xsl:param name="days" />
   <xsl:param name="year" />
   <xsl:variable name="y-1" select="$year - 1" />
   <!-- this gives the day of the week, counting from Sunday = 0 -->
   <xsl:variable name="day-of-week" 
                 select="($y-1 + floor($y-1 div 4) -
                          floor($y-1 div 100) + floor($y-1 div 400) +
                          $days) 
                         mod 7" />
   <!-- this gives the day of the week, counting from Monday = 1 -->
   <xsl:variable name="dow">
      <xsl:choose>
         <xsl:when test="$day-of-week"><xsl:value-of select="$day-of-week" /></xsl:when>
         <xsl:otherwise>7</xsl:otherwise>
      </xsl:choose>
   </xsl:variable>
   <xsl:variable name="start-day" select="($days - $dow + 7) mod 7" />
   <xsl:variable name="week-number" select="floor(($days - $dow + 7) div 7)" />
   <xsl:choose>
      <xsl:when test="$start-day >= 4">
         <func:result select="$week-number + 1" />
      </xsl:when>
      <xsl:otherwise>
         <xsl:choose>
            <xsl:when test="not($week-number)">
               <func:result select="date:_week-in-year(365 + ((not($y-1 mod 4) and $y-1 mod 100) or not($y-1 mod 400)), $y-1)" />
            </xsl:when>
            <xsl:otherwise>
               <func:result select="$week-number" />
            </xsl:otherwise>
         </xsl:choose>
      </xsl:otherwise>
   </xsl:choose>
</func:function>

</xsl:stylesheet>