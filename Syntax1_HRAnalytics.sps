* Encoding: UTF-8.
***Q = Question, **R = Response, *M = Markdown(Explanation)

DATASET ACTIVATE DataSet1.
*** QI. screen the items v4-v20 to determine if there are any problems that need corrected

*M. Screening for: Out of range values, outliers, skews, restriction of range, missing data, unlikely patterns

FREQUENCIES VARIABLES=v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 v16 v17 v18 v19 v20
  /STATISTICS=STDDEV VARIANCE RANGE MINIMUM MAXIMUM SEMEAN MEAN MEDIAN MODE SUM SKEWNESS SESKEW 
    KURTOSIS SEKURT
  /HISTOGRAM NORMAL
  /ORDER=ANALYSIS.

EXAMINE VARIABLES=v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 v16 v17 v18 v19 v20 
  /COMPARE VARIABLE
  /PLOT=BOXPLOT
  /STATISTICS=NONE
  /NOTOTAL
  /MISSING=LISTWISE.

** R1. Missing data (NA) ranges from 27 to 78 NAs, across variables v4-v20
** R2. Likert scale option 6 is missing in all variables from v4-v20. V12 is missing Likert Scale 5 and 6 
** R3. Most varibles are skewed to the right
** R4. There are outliers across all variables from v4-v20 all above maximum quartile

*** QII. Compute a work centrality variable using v13-V20 and examine the descriptive statistics
*M. Work centrality variable - creating a composite variable 
*M. Compute mean and sum for variables from v13-v20, creating two new variables
 
COMPUTE WorkCentralityCompositeScore=MEAN(v13,v14,v15,v16,v17,v18,v19,v20).
EXECUTE.

COMPUTE WorkCentralityCompositeSum=SUM(v13,v14,v15,v16,v17,v18,v19,v20).
EXECUTE.

* M. Run a correlation to see if mean and sum progress similarly, correlation high .9 =mean and sum provides similar information
 *M. As correlation is high, I can choose to run descriptive information on one of the variables

CORRELATIONS
  /VARIABLES=WorkCentralityCompositeScore WorkCentralityCompositeSum
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

*M. Run descriptive statistics on WorkCentralityVariable

FREQUENCIES VARIABLES=WorkCentralityCompositeScore
  /STATISTICS=STDDEV VARIANCE MEAN MEDIAN MODE SUM
  /HISTOGRAM NORMAL
  /ORDER=ANALYSIS.

** RQII. 1) WorkCentrality is skewed to the right
** RQII. 2) Mean = 2.24 and Median = 2 which suggests that most respondents rates highly the importance of work
** RQII. 3)WorkCentrality 25%percentile is in between 1.71 and 1.75. The 75%percentile is between 2.29 and 2.38

*** QIII. Segment the data based on country to examine the descriptive statistics
*M. Segment the dataset by country variable v3 

DATASET ACTIVATE DataSet1.
SORT CASES  BY v3.
SPLIT FILE SEPARATE BY v3.

*M. Examine composite variable and variables from v13-v20 for descriptive statistics

FREQUENCIES VARIABLES=WorkCentralityCompositeScore  v13 v14 v15 v16 v17 v18 v19 v20 
  /NTILES=4
  /STATISTICS=STDDEV VARIANCE RANGE MINIMUM MAXIMUM SEMEAN MEAN MEDIAN MODE SUM
  /FORMAT=LIMIT(2)
  /ORDER=ANALYSIS.

*M. Examine boxplot of composite variable and v13-v20 

EXAMINE VARIABLES=WorkCentralityCompositeScore  v13 v14 v15 v16 v17 v18 v19 v20 
  /COMPARE VARIABLE
  /PLOT=BOXPLOT
  /STATISTICS=NONE
  /NOTOTAL
  /MISSING=LISTWISE.

DATASET ACTIVATE DataSet1.
SORT CASES  BY v3.
SPLIT FILE OFF

*** QIV. Are there any differences between the USA and Russia? Spain and Japan?
*M. USA vs Russia
*M.Run an independent t test to detect differences between USA and Russia

T-TEST GROUPS=v3(6 18)
  /MISSING=ANALYSIS
  /VARIABLES=WorkCentralityCompositeScore
  /CRITERIA=CI(.95).

**RQIV. We fail to reject the null hypothesis, that there is no difference between USA and Russia, p>.05  

npar test
 /m-w = WorkCentralityCompositeScore by v3(6 18)
 
 **RQIV. As the distribution is not normal, run the Wilcoxon-Mann-Whitney test
 **RQIV. The results suggest that there is a statistically significant difference between USA and Russia (z=-3.710 , p= 0.000)

*M. Spain vs. Japan
*M.Run an independent t test to detect differences between Spain and Japan

T-TEST GROUPS=v3(13 24)
  /MISSING=ANALYSIS
  /VARIABLES=WorkCentralityCompositeScore
  /CRITERIA=CI(.95).

**RQIV. We reject the null hypothesis, that there is no difference between Spain and Japan, p<.05  

npar test
 /m-w = WorkCentralityCompositeScore by v3(13 24)
 
 **RQIV. As the distribution is not normal, run the Wilcoxon-Mann-Whitney test
 **RQIV. The results suggest that there is a statistically significant difference between Spain and Japan (z=-13.77 , p= 0.000)

***QV. Is the importance score correlated with “Time in paid job”

CORRELATIONS
  /VARIABLES=WorkCentralityCompositeScore v4
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

**RQV. Based on the results, WorkCentrality is weak positive correlated to time in paid job, r=.23 ,p<.05
