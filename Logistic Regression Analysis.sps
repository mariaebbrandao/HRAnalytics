* Encoding: UTF-8.
*Maria Brandao Sze - Homework 4

* Encoding: UTF-8.

*Run frequency on all variables

DATASET ACTIVATE DataSet1.
FREQUENCIES VARIABLES=TIME_LEV_Y1 GEO_Y1 YR_SERVE_Y1 Promotion Engagement CompanyPractices 
    CompetitiveRewards Opportunities Work QualityofLife People REVIEW2 TotalHoursTraining
  /STATISTICS=STDDEV VARIANCE MINIMUM MAXIMUM MEAN MEDIAN
  /ORDER=ANALYSIS.

** Missing information overall low with the exception of Performance Review Year 1 - missing about 24.56% of the data  
** I don't see values that are incorrect or that requires further investigation

*Run a corrleation on all variables

CORRELATIONS
  /VARIABLES= Promotion Engagement CompanyPractices CompetitiveRewards Opportunities Work QualityofLife People REVIEW2 TotalHoursTraining
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

*Q1. What are the key drivers of employee promotion?
* These were the variables that were statistically significant:
* Engagement, CompanyPractices, CompetitiveRewards, Opportunities, Work, QualityofLife, and People

*Multicollinearity - Highly intercorrelated
* Engagement, CompanyPractices, CompetitiveRewards, Opportunities, Work, QualityofLife, and People


*Run logistic regression

LOGISTIC REGRESSION VARIABLES Promotion
  /METHOD=ENTER Engagement CompanyPractices CompetitiveRewards Opportunities Work QualityofLife 
    People 
  /SAVE=PRED COOK
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20) CUT(.5).

*Looking at Block 1:Method = Enter, Model as a set is significant.Therefore I can continue with the process
*Looking at Variables in the Equation, the predictors Engagement and Opportunities the sign flips so highly correlated to Promotion in year 2, multicollinearity exists
*Remove one independent variable - chose to remove both Opportunities as the sign flipped and engagement because it is not significant 


LOGISTIC REGRESSION VARIABLES Promotion
  /METHOD=ENTER CompanyPractices CompetitiveRewards Work QualityofLife People 
  /SAVE=PRED COOK
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20) CUT(.5).

* As Logistic regression is ran, the remaining key drivers are CompanyPractices CompetitiveRewards Work QualityofLife People 

*Include your rationale for your cut point?

LOGISTIC REGRESSION VARIABLES Promotion
  /METHOD=ENTER Engagement CompanyPractices CompetitiveRewards Work QualityofLife People 
  /SAVE=PRED COOK
  /PRINT=CI(95)
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.2).

*Increase in  accuracy on who is going to be promoted, bigger increase in number of not promoted that falls under promoted

LOGISTIC REGRESSION VARIABLES Promotion
  /METHOD=ENTER Engagement CompanyPractices CompetitiveRewards Work QualityofLife People 
  /SAVE=PRED COOK
  /PRINT=CI(95)
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.15).

*Increase in  accuracy on who is going to be promoted, even bigger increase in number of not promoted that falls under promoted
*Since the difference in Percentage correct does not vary much between .15 and .20, but the number of true vs. false positives spikes from 498 to 1026.
*Therefore, I choose the cut off point of .2   

LOGISTIC REGRESSION VARIABLES Promotion
  /METHOD=ENTER CompanyPractices CompetitiveRewards Work QualityofLife People 
  /SAVE=PRED COOK
  /PRINT=CI(95)
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.2).

*Q2. How accurate is your predictive model?
The accuracy for Promotion is 26.7%

*Q3. Which drivers have the largest changes in the
odds? What are the relative weights of the
drivers?

*The drivers with the largest changes are QualityofLife, CompetitiveRewards, and People
*The relative weights of the driver are ... (Kept getting error)

*Q4. Pick two geographies and examine if you get different results.

DATASET ACTIVATE DataSet3.
LOGISTIC REGRESSION VARIABLES Promotion
  /METHOD=ENTER CompanyPractices CompetitiveRewards Work QualityofLife People 
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20) CUT(.5).

LOGISTIC REGRESSION VARIABLES Promotion
  /METHOD=ENTER CompanyPractices CompetitiveRewards Work QualityofLife People 
  /SAVE=PRED PGROUP
  /PRINT=CI(95)
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.2).

*USA sample size = 11,839
*USA .5 cut value = 37.9 accuracy on promoted, Predictors company practices and Quality of life no longer significant. Competitive Rewards remains as the driver with the largest changes in the odds 
*USA .2 cut value =  40.7 accuracy on promoted and true vs. false is still relatively small, 104 

*Japan sample size = 1385
*Japan .5 cut value =  accuracy on promoted, Predictors company practices and Quality of life no longer significant. Competitive Rewards remains as the driver with the largest changes in the odds
*Japan .2 cut value =  42.3 accuracy on promoted
*Japan .1 cut value = 44.2 accuracy on promoted, decided to lower cut off value as number of true vs false is still relatively small, 80 

LOGISTIC REGRESSION VARIABLES Promotion
  /METHOD=ENTER CompanyPractices CompetitiveRewards Work QualityofLife People 
  /SAVE=PRED PGROUP
  /PRINT=CI(95)
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.1).








