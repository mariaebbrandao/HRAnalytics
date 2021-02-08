* Encoding: UTF-8.
****MariaBrandaoSze
***Homework 2

****Response to Question 1: Create an integrated file of the key driver homework files
*Merge datasets 1,2,3 by adding variables based on key values(Mastrid)

DATASET ACTIVATE DataSet3.
SORT CASES BY MASTRID.
DATASET ACTIVATE DataSet2.
SORT CASES BY MASTRID.
DATASET ACTIVATE DataSet3.
MATCH FILES /FILE=*
  /FILE='DataSet2'
  /BY MASTRID.
EXECUTE.

SORT CASES BY MASTRID mCompetency1 mCompetency2 mCompetency3 mCompetency4 mCompetency5 mCompetency6 
    mCompetency7 mCompetency8 dCompetency1 dCompetency2 dCompetency3 dCompetency4 dCompetency5 
    dCompetency6 dCompetency7 dCompetency8.
DATASET ACTIVATE DataSet1.
SORT CASES BY MASTRID mCompetency1 mCompetency2 mCompetency3 mCompetency4 mCompetency5 mCompetency6 
    mCompetency7 mCompetency8 dCompetency1 dCompetency2 dCompetency3 dCompetency4 dCompetency5 
    dCompetency6 dCompetency7 dCompetency8.
DATASET ACTIVATE DataSet3.
MATCH FILES /FILE=*
  /FILE='DataSet1'
  /BY MASTRID mCompetency1 mCompetency2 mCompetency3 mCompetency4 mCompetency5 mCompetency6 
    mCompetency7 mCompetency8 dCompetency1 dCompetency2 dCompetency3 dCompetency4 dCompetency5 
    dCompetency6 dCompetency7 dCompetency8.
EXECUTE.

**** Response to Question 2: Do any of the tests have supportive validity evidence?
*Look at descriptive data to understand the dataset and look for variability, missing data, initiation point, variables to work with and be cautious with
*Leadership Judgment there are high numbers of missing data, 30 a little less than a 1/3


FREQUENCIES VARIABLES=Interview Biodata AbilityTest RiskTakingPropensity judgementOverallTScore 
    mCompetency1 mCompetency2 mCompetency3 mCompetency4 mCompetency5 mCompetency6 mCompetency7 
    mCompetency8 dCompetency1 dCompetency2 dCompetency3 dCompetency4 dCompetency5 dCompetency6 
    dCompetency7 dCompetency8 PerformanceRating
  /STATISTICS=STDDEV VARIANCE RANGE MEAN
  /ORDER=ANALYSIS.

*Look at correlation for predictors that are correlated and remove those that are not correlated


CORRELATIONS
  /VARIABLES=Interview Biodata AbilityTest RiskTakingPropensity judgementOverallTScore mCompetency1 
    mCompetency2 mCompetency3 mCompetency4 mCompetency5 mCompetency6 mCompetency7 mCompetency8 
    dCompetency1 dCompetency2 dCompetency3 dCompetency4 dCompetency5 dCompetency6 dCompetency7 
    dCompetency8 PerformanceRating
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

*Rating from structured interview correlates with Performance Rating. Biodata inventory correlates with Personality -Risk taking, competency 3&5, and performance rating. Standardized Ability Test correlates with Competency 1,2,4,5,6,
 and Performance Rating. Personality Risk correlates with Biodata Inventory, Leadership Judgment. Leadership Judgment correlates with Personality Risk Taking. Performance Rating correlates with Rating...,Biodata..,Standardize ability
 competency 1,2,5,6,7,8


**** Response to Question 3: How well does the set of predictors work?
*Look at ANOVA, model is significant p<.05
*Look at Model Summary - to see what R Square indicates  and Std. Error of the Estimate indicates
*Look at Coefficients - see which variables have the highest standardized Coefficients, the significance, and collinearity statistics VIF
*As I add or remove variables compare the Adjusted R Square


REGRESSION
  /DESCRIPTIVES MEAN STDDEV CORR SIG N
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA COLLIN TOL
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT PerformanceRating
  /METHOD=ENTER Interview Biodata AbilityTest RiskTakingPropensity judgementOverallTScore 
    mCompetency1 mCompetency2 mCompetency3 mCompetency4 mCompetency5 mCompetency6 mCompetency7 
    mCompetency8 dCompetency1 dCompetency2 dCompetency3 dCompetency4 dCompetency5 dCompetency6 
    dCompetency7 dCompetency8
  /SCATTERPLOT=(*SDRESID ,PerformanceRating).

* Based on the above points the bellow model was determined
* The R square indicates that 28% of the variance in Performance Rating can be predicted from the variables Biodata Inventory, Standardized Ability Test and Competency 8 from Manager  

REGRESSION
  /DESCRIPTIVES MEAN STDDEV CORR SIG N
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA COLLIN TOL
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT PerformanceRating
  /METHOD=ENTER  Biodata AbilityTest
    mCompetency8. 


**** Response to Question 4: Which predictor is the most important?
*Standardized ability test has the highest Standardized Coefficients, .484

REGRESSION
  /DESCRIPTIVES MEAN STDDEV CORR SIG N
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA COLLIN TOL
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT PerformanceRating
  /METHOD=ENTER Interview Biodata AbilityTest RiskTakingPropensity judgementOverallTScore 
    mCompetency1 mCompetency2 mCompetency3 mCompetency4 mCompetency5 mCompetency6 mCompetency7 
    mCompetency8 dCompetency1 dCompetency2 dCompetency3 dCompetency4 dCompetency5 dCompetency6 
    dCompetency7 dCompetency8
  /SCATTERPLOT=(*SDRESID ,PerformanceRating).

**** Response to Question 5: Any issues with the predictors or data
*As I have no content on the variables and literature understanding on the topic, I don't know what the relevant variables are.
*My choices are being made based on values as I look at R Square, Std. Error, Standardized Coefficients, Significance level, and Collinearity statistics VIF
*But I am assuming as it is hard to determine the predictors I am to run Parallel Analysis.

**** Response to Question 6: How accurate is the equation?
  The standard error of the regression model, which includes Performance Rating as criterion and  Biodata AbilityTest mCompetency8 as predictors, is of .51508. 
  *In comparison with the other model that has all variables, the R-square is lower but the standard error is similar. 
  *Since we know that R-square increases as more variables are added. The model with fewer variables and a similar standard error of the estimate is preferred. 

**** Response to Question 7: What will happen with the operational sample?
*The goal is to create a reliable and valid regression model by doing as much research, literature review and rigorous analysis as possible. The process will approximate the model to 
the operational sample. But even when the equation is rigorous and diligent, differences and errors are to be accounted for during implementation. Hence the importance of conducting
cross validation and comparing the adjusted R square. The model is based on a development sample, therefore when implemented in an operational sample might not fit as well. 
  
    




