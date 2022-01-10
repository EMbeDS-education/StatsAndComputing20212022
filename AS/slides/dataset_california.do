/*“California Test Score” data set the book Introduction to Econometrics, Stock and Watson, 2003*/

/*
The California Standardized Testing and Reporting (STAR)) dataset contains data on test performance, 
school characteristics and student demographic backgrounds. 
The data used here are from all 420 K-6 and K-8 districts in California.
Test scores are the average of the reading and math scores on the Stanford 9 standardized test administered to 5th grade students.

TESTSCR: average test score (Y)
STR: STUDENT TEACHER RATIO (X1) - number of full-time equivalent teachers in the district divided by the number of students
EL_PCT: PERCENT OF ENGLISH LEARNERS (X2) - % of students that are English Learners (that is, students for whom English is a second language)
*/


cd "/Users/user/Documents/Dati/DIDATTICA/allievi/Allievi_20_21/corso AS/dataset/"

use california, clear

/*linear regression*/

*Binary variable el_pct, where ‘0’ if English learners (el_pct) is lower than 10%, ‘1’ equal to 10% or higher
generate hi_el = 0 if el_pct<10 
replace hi_el=1 if el_pct>=10

*Binary hi_str, where ‘0’ if student-teacher ratio (str) is lower than 20, ‘1’ equal to 20 or higher.

generate hi_str = 0 if str<20
replace hi_str=1 if str>=20

*interaction term

generate str_el = hi_str*hi_el

regress testscr hi_el hi_str str_el

/*The effect of hi_str on the tests scores is -1.9 
but given the interaction term (and assuming all coefficients are significant), 
the net effect is -1.9 -3.5*hi_el. If hi_el is 0 then the effect is -1.9 (which is hi_str coefficient), 
but if hi_elis 1 then the effect is -1.9 -3.5 = -5.4. 
In this case, the effect of student-teacher ratio is more negative in districts where the percent of English learners is higher*/

/*expected values of test scores given different values of hi_strand hi_el*/
predict yh1 if hi_str==0 & hi_el==0
predict yh2 if hi_str==1 & hi_el==0

sum yh1 yh2

/*Here we estimate the net effect of low/high student-teacher ratio holding constant the percent of English learners. 
When hi_el is 0 the effect of going from low to high student-teacher ratio goes from a score of 664.2 to 662.2, a difference of 1.9. 
you could argue that moving from high str to low str improve test scores by 1.9 in low English learners districts*/

/*Continuous str, student-teacher ratio and Binary hi_el*/

g str_el2 = str * hi_el
regress testscr str hi_el str_el2

/*The effect of stron testscrwill be mediated by hi_el.
–
If hi_elis 0 (low) then the effect of str is 682.2 –0.97*str.
–
If hi_elis 1 (high) then the effect of stris 682.2 –0.97*str + 5.6 –1.28*str = 687.8 –2.25*str

Notice that how hi_el changes both the intercept and the slope of str. Reducing str by one in low EL districts will increase test scores by 0.97 points, 
but it will have a higher impact (2.25 points) in high EL districts. The difference between these two effects is1.28 which is the coefficient of the interaction*/
