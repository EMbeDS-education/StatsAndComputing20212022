/***


Remember, the CLT tells us (more or less) that if we take the mean from a sample and do 
this over and over again, the resulting sampling distribution (which is the distribution of the means from the sample) 
should begin to look like a normal curve. 
*/

/****/

clear
set more off
set obs 100000
set seed 12345
capture drop y ybar10 ybar100 
gen y = (uniform()>0.2) /*the outcome, dummy variable, bernoullli distribution*/
hist y
* draw 1000 samples; each sample contains 10 obs; draw histogram of the sample me 
gen ybar10 = .
forvalues i = 1(1)1000 {
local n0 = (`i'-1)*10+1
   local nn = `n0' + 9
   qui sum y in `n0'/`nn'
   qui replace ybar10 = r(mean) in `i'
   }
   histogram ybar10 in 1/1000
   sum ybar10 in 1/1000, detail

    /*
Notice that this second histogram is more symmetric than the first histogram. We can
almost see a bell, even though an asymmetric one. 
Also note that the horizontal distance between bars gets smaller. In the limit when
the sample size is infinity, the bars become immediately adjacent, meaning that the
normal random variable is continuous (but Bernoulli is discrete).*/
   
  *draw 1000 samples; each sample contains 100 obs; draw histogram of the sample m 
  gen ybar100 = .
forvalues i = 1(1)1000 {
local n0 = (`i'-1)*100+1
  local nn = `n0' + 99
qui sum y in `n0'/`nn'
   qui replace ybar100 = r(mean) in `i'
   }
   histogram ybar100 in 1/1000
   sum ybar100 in 1/1000, detail

   *If we ignore the gaps in the graph, we almost see a symmetric bell!
   *In theory the sample size should be infinitely large for CLT to hold. In practice we
*can get the sample mean very close to normality for n as small as 30.
