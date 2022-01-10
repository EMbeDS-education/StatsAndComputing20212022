cd "/Users/user/Documents/Dati/DIDATTICA/allievi/Allievi_20_21/corso AS/dataset/"

use urban, clear

g homrate=(nhomic/pop)*100000

 
scatter inequal homrate , mlabel(city) saving(gr1)


scatter inequal homrate if city!="Dallas", mlabel(city) saving(gr2)


gr combine gr1.gph gr2.gph


/* univariate analysis
analyse first each variable of interest without any assumption or without imposing any theoretical distribution 
on the data:

1) analyse the distribution of the variables (is it normal-symmetrical?) 

2) veryfying the presence of any extreme value and evaluate the possibility to "clean" the data and determine the impact of this
action"
3) start summarizing the data (graphs, freq tables, location and dispersion indexes)


*/

  histogram homrate, percent  normal bin(10) xlabel(0(3)30, alternate) ytick(0(0.05)0.40, tposition(crossing)) ylabel(#10) title("Homicide Rate distribution") 

  sum homrate
  
  sum homrate, d
  
     /*if the mean is greater than the median (skewness>0) than the distribution is asymmetrical - right skewed- and with 
  positive outliers
  Dal confronto tra media e mediana si ha un’indicazione dell’asimmetria di una distribuzione:
Se media=mediana la distribuzione è simmetrica (skewness = 0)
Se media>mediana abbiamo outliers positivi (skewness > 0)
Se media<mediana abbiamo outliers negativi (skewness < 0)*/ 

  
 
 /*If homrate were normally distributed, the line (the median) would be in the middle of the box (the 25th and 75th percentiles, Q1 and Q3) 
 and the ends of the whiskers (the upper and lower adjacent values, which are the most extreme values within Q3+1.5(Q3-Q1) and Q1-1.5*(Q3-Q1), respectively) 
 would be equidistant from the box. */
 
graph box homrate, mark(1,mlabel(city))

sum homrate if city!="Dallas", d


scatter inequal homrate if city!="Dallas"

 twoway scatter inequal homrate if city!="Dallas" , mlabel(city) ///
|| lfit inequal homrate if city!="Dallas"


scatter inequal homrate if city!="Dallas"

iqr homrate

/*
============================================================
 IQR (Interquartile Range) = 75th percentile - 25th percentile
      Pseudo standard deviation = IQR/1.349
      10% trim mean             = Average of cases between 10th and
                                     90th percentiles
      Inner fences              = Q(25)-1.5IQR and Q(75)+1.5IQR
      Outer fences              = Q(25)-3IQR   and Q(75)+3IQR
      Mild outlier              = Q(25)-3IQR <= x < Q(25)-1.5IQR  or
                                  Q(75)+1.5IQR < x <= Q(75)+3IQR
      Severe outlier            = x < Q(25)-3IQR  or  x > Q(75)+3IQR
=============================================================

Thus a "severe outlier" lies more than 3 IQR away from the nearer 
quartile  J.W. Tukey. 1977. */



histogram homicrate if city!="Dallas", fraction normal bin(10) xlabel(0(3)30, alternate) ytick(0(0.05)0.40, tposition(crossing)) ylabel(#10) title("Homicide Rate distribution") 
kdensity homicrate if city!="Dallas", normal


twoway scatter poor educ if city!="Berkeley" , mlabel(city) 

/*
"getting rid" of severe outliers is  not 
always a good idea unless there is independent evidence that 
the data are wholly untrustworthy . Dropping values more than 
3 IQR away from the nearer quartile will in most instances throw
out important information*/
