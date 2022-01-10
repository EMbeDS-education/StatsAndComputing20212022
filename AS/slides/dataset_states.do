/*education data (education efficacy) from the book Statistics with Stata by Lawrence C. Hamilton*/

/*
SAT scores, variable csat 

Per pupil expenditures primary & secondary (expense)
•
% HS graduates taking SAT (percent)
•
Median household income (income)
•
% adults with HS diploma (high)
•
% adults with college degree (college)



Are SAT scores higher in states that spend more money on education controlling by other factors?

*/


cd "/Users/user/Documents/Dati/DIDATTICA/allievi/Allievi_20_21/corso AS/dataset/"

use states, clear

/*linear regression*/

regress csat expense

/*OUTPUT: 
table with estimates of coefficients and tests
anova table: 
Model Sum of Squares (MSS). The closer to TSS the better fit.
Residual Sum of Squares (RSS)
Total Sum of Squares (TSS)
Average Model Sum of Squares = MSS/(k-1) where k= # predictors
Average Residual Sum of Squares = RSS/(n –k) where n = # of observations
Average Total Sum of Squares = TSS/(n–1)

RSS = 0 ⇒ Tutte le osservazioni giacciono sulla retta di regressione, 
cioè tutti i valori stimati sono uguali ai valori osservati

Dividing the sum of squares of the residual by its degrees of freedom  yields MSS 
If you further take a square root, you'll get Root MSE that is
the standard deviation of the error term

R2: 21% of the observed variance is explained by the model
The F-statistic, tests whether R2 is different from zero.
Adj R2 shows the same as R2 but adjusted by the # of cases and # of variables. 
When the # of variables is small and the # of cases is very large then Adj R2 is closer to R2. 
This provides a more honest association between X and Y
*/


/*adding the other predictors including the categorical variable region, use i. to create dummies */
xi: regress csat expense percent income high college i.region



  /*correlation matrix*/

graph matrix csat percent expense income high college, half maxis(ylabel(none) xlabel(none))
 
 /* it looks like there is a curvilinear relationship between csat and percent*/

scatter csat percent

/*To deal with U-shaped curves we need to add a square version of the variable*/

g perc2=percent^2

xi: regress csat expense percent perc2 income high college i.region

/* the coeff of perc is negative and the one of perc2 is postive (U relationship)

SAT decreases with % HS graduates taking SAT but then, 
and at some point the SAT doesn't deacreases (reaches the suboptimal level) 
and starts to increases. 
The point here is that there should be also
justification for including the square of the variable*/

/*residual check*/

xi: regress csat expense percent perc2 income high college i.region 
predict csat_predict

scatter csat csat_predict

/*the model seems to be doing a good job in predicting Y*/

predict e, resid

histogram e, kdensity normal

/*
Quintile-normal plots (qnorm) check for non-normality in the extremes of the data (tails). 
It plots quintiles of residuals vs quintiles of a normal distribution. 
Tails are a bit off the normal*/

qnorm e

swilk e

/*
The null hypothesis is that the distribution of the residuals is normal, 
here the p-value is 0.59 we failed to reject the null (at 95%). 
We conclude then that residuals are normally distributed*/

/*test for heteroskedasticiy (predicted vs residuals)*/

rvfplot, yline(0)

/*Residuals seem to slightly expand at higher levels of Yhat*/


/*
Breusch-Pagan test. 
The null hypothesis is that residuals are homoskedastic. 
here we fail to reject the null at 95% and concluded that residuals are homogeneous. 
*/
 
 estat hettest

label variable csat_predict "csat predicted"

/*Multicollinearity: VIF after regress*/

vif

/*outliers*/

predict studres, rstudent

sort studres

list  state studres in 1/10

list  state studres in -10/l
/*
We should pay attention to studentized residuals that exceed +2 or -2, 
 even more concerned about residuals that exceed +3 or -3*/

 /* leverage's to identify observations that will have potential 
 great influence on regression coefficient estimates.
 The observations with the highest leverage had the greatest influence on the regression coefficients
 Generally, a point with leverage greater than (2k+2)/n should be carefully examined. 
 Here k is the number of predictors and n is the number of observations. 

 
 */
predict lev, hat

 display (2*9+2)/51
 
 gen cutoff= (lev>=.39215686)

 list state if cutoff==1
 

/*
 We can make a plot that shows the leverage by the residual squared and look for observations 
 that are jointly high on both of these measures.  
 We can do this using the lvr2plot command. lvr2plot stands 
 for leverage versus residual squared plot. Using residual squared instead of residual itself, 
 the graph is restricted to the first quadrant and the relative positions of data points are preserved. 
 This is a quick way of checking potential influential observations and outliers at the same time. 
 Both types of points are of great concern for us. */

 lvr2plot, mlabel(state)

 
 /*influential:
The lowest value that Cook's D can assume is zero, and the higher the Cook's D is, 
the more influential the point. The convention cut-off point is 4/n. 
We can list any observation above the cut-off point*/

predict d, cooksd
list state d if d>4/51








