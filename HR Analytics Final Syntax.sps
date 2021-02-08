* Encoding: UTF-8.
***********************************************************************************************************
********************************************SCREENING******************************************************
***********************************************************************************************************

DATASET ACTIVATE DataSet1.
FREQUENCIES VARIABLES=Gender TechTrainingPriorYear Country CurrentYearPerformanceRating 
    PriorYearPerformanceRating Tenure VoluntaryTurnover Engagement Leadership PerformanceManagement 
    LearningDevelopment Culture ParticipatedLeadershipDevelopment PriorYearCompensation
  /STATISTICS=STDDEV VARIANCE RANGE MINIMUM MAXIMUM MEAN MEDIAN MODE
  /PIECHART FREQ
  /ORDER=ANALYSIS.

CORRELATIONS
  /VARIABLES=Gender TechTrainingPriorYear Country CurrentYearPerformanceRating 
    PriorYearPerformanceRating Tenure VoluntaryTurnover Engagement Leadership PerformanceManagement 
    LearningDevelopment Culture ParticipatedLeadershipDevelopment PriorYearCompensation
  /PRINT=TWOTAIL NOSIG
  /STATISTICS DESCRIPTIVES
  /MISSING=PAIRWISE.


USE ALL.
COMPUTE filter_$=(ParticipatedLeadershipDevelopment = 1).
VARIABLE LABELS filter_$ 'ParticipatedLeadershipDevelopment = 1 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

*******************DESCRIIPTIVES ON ONLY THOSE WHO PARTICIPATED ***********************

DESCRIPTIVES VARIABLES=Gender TechTrainingPriorYear Country CurrentYearPerformanceRating 
    PriorYearPerformanceRating Tenure VoluntaryTurnover Engagement Leadership PerformanceManagement 
    LearningDevelopment Culture ParticipatedLeadershipDevelopment PriorYearCompensation filter_$
  /STATISTICS=MEAN STDDEV MIN MAX.

CORRELATIONS
  /VARIABLES=Gender TechTrainingPriorYear Country CurrentYearPerformanceRating 
    PriorYearPerformanceRating Tenure VoluntaryTurnover Engagement Leadership PerformanceManagement 
    LearningDevelopment Culture ParticipatedLeadershipDevelopment PriorYearCompensation
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

************************************************************************************************************
***************************CLUSTER ANALYSIS (HIERCHICAL & KMEANS)****************************************
************************************************************************************************************

DATASET ACTIVATE DataSet1.
CLUSTER   Engagement Leadership PerformanceManagement LearningDevelopment Culture
  /METHOD WARD
  /MEASURE=SEUCLID
  /PRINT SCHEDULE
  /PLOT DENDROGRAM VICICLE.

QUICK CLUSTER Engagement Leadership PerformanceManagement LearningDevelopment Culture
  /MISSING=LISTWISE
  /CRITERIA=CLUSTER(7) MXITER(10) CONVERGE(0)
  /METHOD=KMEANS(NOUPDATE)
  /SAVE CLUSTER DISTANCE
  /PRINT INITIAL ANOVA CLUSTER DISTAN.

QUICK CLUSTER Engagement Leadership PerformanceManagement LearningDevelopment Culture
  /MISSING=LISTWISE
  /CRITERIA=CLUSTER(6) MXITER(10) CONVERGE(0)
  /METHOD=KMEANS(NOUPDATE)
  /SAVE CLUSTER DISTANCE
  /PRINT INITIAL ANOVA CLUSTER DISTAN.

QUICK CLUSTER Engagement Leadership PerformanceManagement LearningDevelopment Culture
  /MISSING=LISTWISE
  /CRITERIA=CLUSTER(5) MXITER(10) CONVERGE(0)
  /METHOD=KMEANS(NOUPDATE)
  /SAVE CLUSTER DISTANCE
  /PRINT INITIAL ANOVA CLUSTER DISTAN.

QUICK CLUSTER Engagement Leadership PerformanceManagement LearningDevelopment Culture
  /MISSING=LISTWISE
  /CRITERIA=CLUSTER(4) MXITER(10) CONVERGE(0)
  /METHOD=KMEANS(NOUPDATE)
  /SAVE CLUSTER DISTANCE
  /PRINT INITIAL ANOVA CLUSTER DISTAN.

QUICK CLUSTER Engagement Leadership PerformanceManagement LearningDevelopment Culture
  /MISSING=LISTWISE
  /CRITERIA=CLUSTER(3) MXITER(10) CONVERGE(0)
  /METHOD=KMEANS(NOUPDATE)
  /SAVE CLUSTER DISTANCE
  /PRINT INITIAL ANOVA CLUSTER DISTAN.


**************************CLUSTERS DESCRIPTIVE ANALYSIS*****************************************


STRING Traingtime_recode (A8).
RECODE TechTrainingPriorYear (0 thru 50='less than 50') (51 thru 100='51-100') (101 thru 
    150='101-150') (151 thru 200='151-200') (201 thru Highest='more than 201') INTO Traingtime_recode.
EXECUTE.
**ignore the warning message

CROSSTABS
  /TABLES=QCL_5 BY Gender Country Tenure VoluntaryTurnover ParticipatedLeadershipDevelopment Traingtime_recode 
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW 
  /COUNT ROUND CELL.

MEANS TABLES=CurrentYearPerformanceRating PriorYearPerformanceRating BY QCL_5
  /CELLS=MEAN COUNT STDDEV.


SORT CASES  BY QCL_5.
SPLIT FILE SEPARATE BY QCL_5.

DESCRIPTIVES VARIABLES=TechTrainingPriorYear 
  /STATISTICS=MEAN STDDEV MIN MAX.

****************************************************************************************************************************
***********************************************TURNOVER ANALYSIS*********************************************************
****************************************************************************************************************************
*Utilized Final Data 5-3.sav

***Recode the variable to 0 and 1  - VoluntaryTurnoverFinal 
*For sake of not getting confused with labeling - 0 =Stayed 1 = Leave

DATASET ACTIVATE DataSet1.
RECODE VoluntaryTurnover (.00=0) (1=1) (ELSE=SYSMIS) INTO VoluntaryTurnoverFinal.
VARIABLE LABELS  VoluntaryTurnoverFinal '0stayed1leave'.
EXECUTE.

***Run a frequency on whole data set 
*Not much turnover 90% stayed .09 variance

FREQUENCIES VARIABLES=VoluntaryTurnoverFinal
  /STATISTICS=VARIANCE MEAN MEDIAN MODE
  /ORDER=ANALYSIS.

****Split file by cluster of 5

SORT CASES  BY QCL_5.
SPLIT FILE LAYERED BY QCL_5.
*SPLIT FILE OFF

***Run a frequency on cluster voluntary turnover

FREQUENCIES VARIABLES=VoluntaryTurnoverFinal
  /STATISTICS=VARIANCE MEAN MEDIAN MODE
  /ORDER=ANALYSIS.

***Run correlation
*All variables

CORRELATIONS
  /VARIABLES=VoluntaryTurnoverFinal Gender TechTrainingPriorYear Country 
    CurrentYearPerformanceRating PriorYearPerformanceRating Tenure Engagement Leadership 
    PerformanceManagement LearningDevelopment Culture ParticipatedLeadershipDevelopment 
    PriorYearCompensation filter_$
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

*Correlated to Turnover - Key drivers
*Cluster 1-Gender, Country, CurrentYearPerformanceRating, Tenure (Years of Service), Engagement Score
*Cluster 2--Gender, Country, CurrentYearPerformanceRating, PriorYearPerformanceRating, Tenure (Years of Service), Learning Development Score
*Clluster 3--Gender, Country, CurrentYearPerformanceRating, Tenure (Years of Service)
*Cluster 4--Gender, CurrentYearPerformanceRating, PriorYearPerformanceRating, Tenure (Years of Service),  Leadership Score
*Cluster5--Gender, CurrentYearPerformanceRating, Tenure (Years of Service), Engagement Score, Learning Development Score

*Multicollinearity - no significant variable is highly correlated. Values are < .4 

*****Run Logistic Regression for Turnover
*Cluster 5 - Group 1
*Cluster 1-Gender, Country, CurrentYearPerformanceRating , Tenure (Years of Service), Engagement Score

*Categorical breakdown - logistic regression

LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 1
  /METHOD=ENTER Gender Country CurrentYearPerformanceRating Tenure Engagement 
  /CONTRAST (Gender)=Indicator
  /CONTRAST (Country)=Indicator
  /PRINT=CORR CI(95)
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.5).


**Looking at Block 1:Method = Enter, Model as a set is significant.Therefore we can continue with the process

*Correlated & statistically significant:  gender(1-female), Country (3,7, 8), CurrentYearPerformanceRating
*Drop the not significant variable- Engagement Score, Tenure

**The drivers with the largest odds ratios:  gender, current year performance 

* As Logistic regression is run with the significant predictors

LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 1
  /METHOD=ENTER Gender Country CurrentYearPerformanceRating
  /CONTRAST (Gender)=Indicator
  /CONTRAST (Country)=Indicator
  /PRINT=CORR CI(95)
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.5).

*cut of point .3

LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 1
  /METHOD=ENTER Gender Country CurrentYearPerformanceRating
  /CONTRAST (Gender)=Indicator
  /CONTRAST (Country)=Indicator
  /PRINT=CORR CI(95)
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.3).

*cut of point .2

LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 1
  /METHOD=ENTER Gender Country CurrentYearPerformanceRating
  /CONTRAST (Gender)=Indicator
  /CONTRAST (Country)=Indicator
  /PRINT=CORR CI(95)
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.2).

*cut of point .13 *

LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 1
  /METHOD=ENTER Gender Country CurrentYearPerformanceRating
  /CONTRAST (Gender)=Indicator
  /CONTRAST (Country)=Indicator
  /PRINT=CORR CI(95)
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.13).

*cut of point .1 *

LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 1
  /METHOD=ENTER Gender Country CurrentYearPerformanceRating
  /CONTRAST (Gender)=Indicator
  /CONTRAST (Country)=Indicator
  /PRINT=CORR CI(95)
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.1).

** provide option .13

*Cluster 2
*Cluster 2--Gender, Country, CurrentYearPerformanceRating, PriorYearPerformanceRating, Tenure, LearningDevelopment

LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 2
  /METHOD=ENTER Gender Country CurrentYearPerformanceRating PriorYearPerformanceRating Tenure LearningDevelopment
  /CONTRAST (Gender)=Indicator
  /CONTRAST (Country)=Indicator
  /PRINT=CORR CI(95)
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.5).


**Looking at Block 1:Method = Enter, Model as a set is significant.Therefore we can continue with the process
*Correlated & significant: gender(1-female), Country (1,3,6,7), CurrentYearPerformanceRating
*Drop the not significant variable- PriorYearPerformanceRating,   LearningDevelopment, Tenure
**The drivers with the largest odds ratio: gender, current year performance 

* As Logistic regression is run with the significant predictors


LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 2
  /METHOD=ENTER Gender Country CurrentYearPerformanceRating 
  /CONTRAST (Gender)=Indicator
  /CONTRAST (Country)=Indicator
  /PRINT=CORR CI(95)
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.5).

*cut of point .3

LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 2
  /METHOD=ENTER Gender Country CurrentYearPerformanceRating 
  /CONTRAST (Gender)=Indicator
  /CONTRAST (Country)=Indicator
  /PRINT=CORR CI(95)
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.3).

*cut of point .2

LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 2
  /METHOD=ENTER Gender Country CurrentYearPerformanceRating  
  /CONTRAST (Gender)=Indicator
  /CONTRAST (Country)=Indicator
  /PRINT=CORR CI(95)
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.2).

*cut of point .12

LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 2
  /METHOD=ENTER Gender Country CurrentYearPerformanceRating 
  /CONTRAST (Gender)=Indicator
  /CONTRAST (Country)=Indicator
  /PRINT=CORR CI(95)
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.12).

*cut of point .1 

LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 2
  /METHOD=ENTER Gender Country CurrentYearPerformanceRating 
  /CONTRAST (Gender)=Indicator
  /CONTRAST (Country)=Indicator
  /PRINT=CORR CI(95)
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.1).

** provide option .12

*Cluster 3
*Clluster 3--Gender, Country, CurrentYearPerformanceRating, Tenure

LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 3
  /METHOD=ENTER Gender Country CurrentYearPerformanceRating Tenure 
  /CONTRAST (Gender)=Indicator
  /CONTRAST (Country)=Indicator
  /PRINT=CORR CI(95)
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.5).

**Looking at Block 1:Method = Enter, Model as a set is significant.Therefore we can continue with the process
*Correlated & significant: gender(1-female), Country (1,3, 6), CurrentYearPerformanceRating 
*Drop the not significant variable- Tenure
**The drivers with the largest odd ratios: gender, current year performance 

* As Logistic regression is run with the significant predictors

LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 3
  /METHOD=ENTER Gender Country CurrentYearPerformanceRating  
  /CONTRAST (Gender)=Indicator
  /CONTRAST (Country)=Indicator
  /PRINT=CORR CI(95)
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.5).

*Cut of point .2

LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 3
  /METHOD=ENTER Gender Country CurrentYearPerformanceRating  
  /CONTRAST (Gender)=Indicator
  /CONTRAST (Country)=Indicator
  /PRINT=CORR CI(95)
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.2).

*cut of .15

LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 3
  /METHOD=ENTER Gender Country CurrentYearPerformanceRating  
  /CONTRAST (Gender)=Indicator
  /CONTRAST (Country)=Indicator
  /PRINT=CORR CI(95)
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.15).

*cut of .13

LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 3
  /METHOD=ENTER Gender Country CurrentYearPerformanceRating  
  /CONTRAST (Gender)=Indicator
  /CONTRAST (Country)=Indicator
  /PRINT=CORR CI(95)
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.13).

** provide option .13

*Cluster 4
*Cluster 4--Gender, CurrentYearPerformanceRating, PriorYearPerformanceRating, Tenure (Years of Service),  Leadership Score

LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 4
  /METHOD=ENTER Gender CurrentYearPerformanceRating Tenure Leadership PriorYearPerformanceRating
  /CONTRAST (Gender)=Indicator
  /PRINT=CORR CI(95)
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20) CUT(0.5).


**Looking at Block 1:Method = Enter, Model as a set is significant.Therefore we can continue with the process
*Correlated & significant: Gender(1-female ), CurrentYearPerformanceRating,  Tenure, Leadership 
*Drop the not significant variable- PriorYearPerformanceRating

**The drivers with the largest odd ratios: gender, tenure, leadership, current year performance 

* As Logistic regression is run with the significant predictors

LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 4
  /METHOD=ENTER Gender CurrentYearPerformanceRating Tenure Leadership
  /CONTRAST (Gender)=Indicator
  /PRINT=CORR CI(95)
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20) CUT(0.5).

*cut of point .2

LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 4
  /METHOD=ENTER Gender CurrentYearPerformanceRating Tenure Leadership
  /CONTRAST (Gender)=Indicator
  /PRINT=CORR CI(95)
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20) CUT(0.2).

*cut of .14

LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 4
  /METHOD=ENTER Gender CurrentYearPerformanceRating Tenure Leadership
  /CONTRAST (Gender)=Indicator
  /PRINT=CORR CI(95)
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20) CUT(0.14).

*cut of .13

LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 4
  /METHOD=ENTER Gender CurrentYearPerformanceRating Tenure Leadership
  /CONTRAST (Gender)=Indicator
  /PRINT=CORR CI(95)
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20) CUT(0.13).

* cut of .11

LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 4
  /METHOD=ENTER Gender CurrentYearPerformanceRating Tenure Leadership
  /CONTRAST (Gender)=Indicator
  /PRINT=CORR CI(95)
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20) CUT(0.11).

** provide option .14

*Cluster 5
*Cluster5--Gender, CurrentYearPerformanceRating,  Tenure, Engagement, LearningDevelopment 

LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 5
  /METHOD=ENTER Gender CurrentYearPerformanceRating Tenure Engagement LearningDevelopment 
  /CONTRAST (Gender)=Indicator
  /PRINT=CORR CI(95)
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20) CUT(0.5).

**Looking at Block 1:Method = Enter, Model as a set is significant.Therefore we can continue with the process
*Correlated & significant: Gender(1-female ), CurrentYearPerformanceRating, Tenure, Engagement,  
*Drop the not significant variable- LearningDevelopment  

**The drivers with the largest odd ratios: gender, engagement, tenure, current year performance 

* As Logistic regression is run with the significant predictors

LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 5
  /METHOD=ENTER Gender Engagement Tenure CurrentYearPerformanceRating  
  /CONTRAST (Gender)=Indicator
  /PRINT=CORR CI(95)
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20) CUT(0.5).

*cut of .3

LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 5
  /METHOD=ENTER Gender Engagement Tenure CurrentYearPerformanceRating  
  /CONTRAST (Gender)=Indicator
  /PRINT=CORR CI(95)
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20) CUT(0.3).

*cut of .13

LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 5
  /METHOD=ENTER Gender Engagement Tenure CurrentYearPerformanceRating  
  /CONTRAST (Gender)=Indicator
  /PRINT=CORR CI(95)
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20) CUT(0.13).

*cut of .105

LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 5
  /METHOD=ENTER Gender Engagement Tenure CurrentYearPerformanceRating  
  /CONTRAST (Gender)=Indicator
  /PRINT=CORR CI(95)
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20) CUT(0.105).

*cut of .1

LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 5
  /METHOD=ENTER Gender Engagement Tenure CurrentYearPerformanceRating  
  /CONTRAST (Gender)=Indicator
  /PRINT=CORR CI(95)
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20) CUT(0.1).

** provide option .13


*** As 1 of the countries of the 9 is a constant, country 9 - the USA. We decided to investigate further by recoding countries to see the impact of adding USA to the model
*Created variable CountryV2 to narrow options to the 9 countries of choice  

RECODE Country (6=1) (17=2) (21=3) (25=4) (26=5) (35=6) (43=7) (50=8) (51=9) (ELSE=SYSMIS) INTO 
    CountryV2.
VARIABLE LABELS  CountryV2 'Country v2'.
EXECUTE.

***Created individual variables for each country to run logistic regression on separate countries

*Brazil

RECODE CountryV2 (1=1) (ELSE=0) INTO Brazil.
VARIABLE LABELS  Brazil 'Brazil'.
EXECUTE.

*Run frequency to check if table of frequencies match

FREQUENCIES VARIABLES=CountryV2 Brazil
  /ORDER=ANALYSIS.

*Germany

RECODE CountryV2 (2=2) (ELSE=0) INTO Germany.
VARIABLE LABELS  Germany 'Germany'.
EXECUTE.

*Run frequency to check if table of frequencies match

FREQUENCIES VARIABLES=CountryV2 Germany
  /ORDER=ANALYSIS.

*India

RECODE CountryV2 (3=3) (ELSE=0) INTO India.
VARIABLE LABELS  India 'India'.
EXECUTE.

*Italy

RECODE CountryV2 (4=4) (ELSE=0) INTO Italy.
VARIABLE LABELS  Italy 'Italy'.
EXECUTE.

*Japan

RECODE CountryV2 (5=5) (ELSE=0) INTO Japan.
VARIABLE LABELS  Japan 'Japan'.
EXECUTE.

*Philippines

RECODE CountryV2 (6=6) (ELSE=0) INTO Philippines.
VARIABLE LABELS  Philippines 'Philippines'.
EXECUTE.

*Spain

RECODE CountryV2 (7=7) (ELSE=0) INTO Spain.
VARIABLE LABELS  Spain 'Spain'.
EXECUTE.

*United Kingdom

RECODE CountryV2 (8=8) (ELSE=0) INTO UnitedKingdom.
VARIABLE LABELS  UnitedKingdom 'UnitedKingdom'.
EXECUTE.

*USA

RECODE CountryV2 (9=9) (ELSE=0) INTO USA.
VARIABLE LABELS  USA 'USA'.
EXECUTE.

*Final revision on table of frequencies to see if all countries contains the right number of employees
 
FREQUENCIES VARIABLES=CountryV2 Brazil Germany India Italy Japan Philippines Spain UnitedKingdom USA    
  /ORDER=ANALYSIS.


*Run a logistic regression on 8 countries, including USA and removing one country which in the original model was not significant
*Used only main key drivers

*Cluster 1

LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 1
  /METHOD=ENTER Gender CurrentYearPerformanceRating Tenure Germany India Italy Japan 
    Philippines Spain UnitedKingdom USA 
  /PRINT=CORR CI(95)
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.5).

*Countries with significant values are - India

*Cluster 2

LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 2
  /METHOD=ENTER Gender CurrentYearPerformanceRating Tenure Germany India Italy Japan 
    Philippines Spain UnitedKingdom USA
  /PRINT=CORR CI(95)  
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.5).

*Countries with significant values are - India and Spain

*Cluster 3

LOGISTIC REGRESSION VARIABLES VoluntaryTurnoverFinal
  /SELECT=QCL_5 EQ 3
  /METHOD=ENTER Gender CurrentYearPerformanceRating  Brazil Germany India Italy Philippines
   Spain UnitedKingdom USA
  /PRINT=CORR CI(95) 
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.5).

*Countries with significant values are - India and  Spain

*Cluster 4 - Country was not correlated 
*Cluster 5 - Country was not correlated 


*******************************************************************************************************************
***************************************LEADERSHIP****************************************************************
******************************************************************************************************************

*********************************************** Cluster Analysis: ANCOVA Analysis ***********************************************
*SPLIT FILE: Within-cluster ancova analysis.
SPLIT FILE SEPARATE BY QCL_5.

**** Testing the assumption of homogeneity of variance ***************

GLM  PriorYearPerformanceRating TechTrainingPriorYear Country Tenure VoluntaryTurnover Gender BY 
    ParticipatedLeadershipDevelopment
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /POSTHOC=ParticipatedLeadershipDevelopment(TUKEY LSD BONFERRONI) 
  /EMMEANS=TABLES(ParticipatedLeadershipDevelopment) COMPARE ADJ(BONFERRONI)
  /PRINT=DESCRIPTIVE ETASQ HOMOGENEITY
  /CRITERIA=ALPHA(.05)
  /DESIGN= ParticipatedLeadershipDevelopment.

*Cluster 3 Result - Techtraining violations

SPLIT FILE OFF.

**************** Testing Assumption of homogeneity of regression *******************

******** Cluster 1 Analysis **********

USE ALL.
COMPUTE filter_$=(QCL_5 = 1).
VARIABLE LABELS filter_$ 'QCL_5 = 1 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.


UNIANOVA CurrentYearPerformanceRating BY ParticipatedLeadershipDevelopment WITH  
    TechTrainingPriorYear PriorYearPerformanceRating 
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /CRITERIA=ALPHA(0.05)
  /DESIGN=ParticipatedLeadershipDevelopment TechTrainingPriorYear 
    ParticipatedLeadershipDevelopment*TechTrainingPriorYear 
    ParticipatedLeadershipDevelopment*PriorYearPerformanceRating .

*Cluster 1 Homogeneity of Regression  - Techtraining passed. 

**** Cluster 2 Analysis *****

USE ALL.
COMPUTE filter_$=(QCL_5 = 2).
VARIABLE LABELS filter_$ 'QCL_5 = 2 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.

UNIANOVA CurrentYearPerformanceRating BY ParticipatedLeadershipDevelopment WITH 
    TechTrainingPriorYear PriorYearPerformanceRating 
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /CRITERIA=ALPHA(0.05)
  /DESIGN=ParticipatedLeadershipDevelopment TechTrainingPriorYear 
    ParticipatedLeadershipDevelopment*TechTrainingPriorYear  
    ParticipatedLeadershipDevelopment*PriorYearPerformanceRating.

*Cluster 2 Homogeneity of Regression  - Techtraining passed. 

*Cluster 3 Analysis

USE ALL.
COMPUTE filter_$=(QCL_5 = 3).
VARIABLE LABELS filter_$ 'QCL_5 = 3 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.

UNIANOVA CurrentYearPerformanceRating BY ParticipatedLeadershipDevelopment WITH 
    PriorYearPerformanceRating 
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /CRITERIA=ALPHA(0.05)
  /DESIGN=ParticipatedLeadershipDevelopment PriorYearPerformanceRating 
    ParticipatedLeadershipDevelopment*PriorYearPerformanceRating.

*Cluster 3 Homogeneity of Regression: PriorYear performance mediates Current year performance

****** Cluster 4 Analysis *****

USE ALL.
COMPUTE filter_$=(QCL_5 = 4).
VARIABLE LABELS filter_$ 'QCL_5 = 4 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.

UNIANOVA CurrentYearPerformanceRating BY ParticipatedLeadershipDevelopment WITH TechTrainingPriorYear PriorYearPerformanceRating 
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /CRITERIA=ALPHA(0.05)
  /DESIGN=ParticipatedLeadershipDevelopment TechTrainingPriorYear 
    ParticipatedLeadershipDevelopment*TechTrainingPriorYear 
    ParticipatedLeadershipDevelopment*PriorYearPerformanceRating.

*Cluster 4 Homogeneity of Regression - All but turnover passed. 

****** Cluster 5 Analysis ******

USE ALL.
COMPUTE filter_$=(QCL_5 = 5).
VARIABLE LABELS filter_$ 'QCL_5 = 5 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.

UNIANOVA CurrentYearPerformanceRating BY ParticipatedLeadershipDevelopment WITH TechTrainingPriorYear PriorYearPerformanceRating 
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /CRITERIA=ALPHA(0.05)
  /DESIGN=ParticipatedLeadershipDevelopment TechTrainingPriorYear 
    ParticipatedLeadershipDevelopment*TechTrainingPriorYear 
    ParticipatedLeadershipDevelopment*PriorYearPerformanceRating .

*Cluster 5 Homogeneity of Regression - All but Gender and Country passed. 

********************************** ANCOVA Analysis ********************************** 

****** Cluster 1 Analysis *******
USE ALL.
COMPUTE filter_$=(QCL_5 = 1).
VARIABLE LABELS filter_$ 'QCL_5 = 1 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.

UNIANOVA CurrentYearPerformanceRating BY ParticipatedLeadershipDevelopment WITH 
    PriorYearPerformanceRating
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /SAVE=COOK
  /EMMEANS=TABLES(ParticipatedLeadershipDevelopment) WITH(PriorYearPerformanceRating=MEAN) COMPARE 
    ADJ(BONFERRONI)
  /PRINT=ETASQ HOMOGENEITY DESCRIPTIVE 
  /CRITERIA=ALPHA(.05)
  /DESIGN=PriorYearPerformanceRating ParticipatedLeadershipDevelopment.

UNIANOVA CurrentYearPerformanceRating BY ParticipatedLeadershipDevelopment WITH 
    PriorYearPerformanceRating TechTrainingPriorYear
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /SAVE=COOK
  /EMMEANS=TABLES(ParticipatedLeadershipDevelopment) WITH(PriorYearPerformanceRating=MEAN TechTrainingPriorYear=MEAN) COMPARE ADJ(BONFERRONI)
  /PRINT=ETASQ DESCRIPTIVE HOMOGENEITY
  /CRITERIA=ALPHA(.05)
  /DESIGN=PriorYearPerformanceRating TechTrainingPriorYear 
    ParticipatedLeadershipDevelopment.

* Cluster 1 Ancova Results:
- Controlling for prior year performance - did not see a difference in current performance based on participation
- Controlling for prior year performance and techtraining - did not see a difference in current performance based on participation


****** Cluster 2 Analysis *******

USE ALL.
COMPUTE filter_$=(QCL_5 = 2).
VARIABLE LABELS filter_$ 'QCL_5 = 2 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.

UNIANOVA CurrentYearPerformanceRating BY ParticipatedLeadershipDevelopment WITH 
    PriorYearPerformanceRating
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /SAVE=COOK
  /EMMEANS=TABLES(ParticipatedLeadershipDevelopment) WITH(PriorYearPerformanceRating=MEAN) COMPARE ADJ(BONFERRONI)
  /PRINT=ETASQ HOMOGENEITY DESCRIPTIVE 
  /CRITERIA=ALPHA(.05)
  /DESIGN=PriorYearPerformanceRating ParticipatedLeadershipDevelopment.

UNIANOVA CurrentYearPerformanceRating BY ParticipatedLeadershipDevelopment WITH 
    PriorYearPerformanceRating TechTrainingPriorYear 
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /SAVE=COOK
  /EMMEANS=TABLES(ParticipatedLeadershipDevelopment) WITH(PriorYearPerformanceRating=MEAN TechTrainingPriorYear=MEAN) COMPARE ADJ(BONFERRONI)
  /PRINT=ETASQ DESCRIPTIVE HOMOGENEITY
  /CRITERIA=ALPHA(.05)
  /DESIGN=PriorYearPerformanceRating TechTrainingPriorYear ParticipatedLeadershipDevelopment.


* Cluster 2 Ancova Results:
Controlling for prior performance, there is no difference in current performance based on participation
Controlling for prior performance and techtraining, there is no difference in current performance based on participation

****** Cluster 3 Analysis *******

USE ALL.
COMPUTE filter_$=(QCL_5 = 3).
VARIABLE LABELS filter_$ 'QCL_5 = 3 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.

UNIANOVA CurrentYearPerformanceRating BY ParticipatedLeadershipDevelopment WITH 
    PriorYearPerformanceRating 
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /SAVE=COOK
  /EMMEANS=TABLES(ParticipatedLeadershipDevelopment) WITH(PriorYearPerformanceRating=MEAN) COMPARE 
    ADJ(BONFERRONI)
  /PRINT=ETASQ HOMOGENEITY DESCRIPTIVE 
  /CRITERIA=ALPHA(.05)
  /DESIGN=PriorYearPerformanceRating ParticipatedLeadershipDevelopment.

* Cluster 3 Ancova Results:
*Controlling for prior performance, no difference observed based on participation


****** Cluster 4 Analysis *******

USE ALL.
COMPUTE filter_$=(QCL_5 = 4).
VARIABLE LABELS filter_$ 'QCL_5 = 4 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.

UNIANOVA CurrentYearPerformanceRating BY ParticipatedLeadershipDevelopment WITH 
    PriorYearPerformanceRating
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /SAVE=COOK
  /EMMEANS=TABLES(ParticipatedLeadershipDevelopment) WITH(PriorYearPerformanceRating=MEAN) COMPARE 
    ADJ(BONFERRONI)
  /PRINT=ETASQ HOMOGENEITY DESCRIPTIVE 
  /CRITERIA=ALPHA(.05)
  /DESIGN=PriorYearPerformanceRating ParticipatedLeadershipDevelopment.

UNIANOVA CurrentYearPerformanceRating BY ParticipatedLeadershipDevelopment WITH 
    PriorYearPerformanceRating TechTrainingPriorYear 
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /SAVE=COOK
  /EMMEANS=TABLES(ParticipatedLeadershipDevelopment) WITH(PriorYearPerformanceRating=MEAN TechTrainingPriorYear=MEAN) COMPARE 
    ADJ(BONFERRONI)
  /PRINT=ETASQ HOMOGENEITY DESCRIPTIVE 
  /CRITERIA=ALPHA(.05)
  /DESIGN=PriorYearPerformanceRating ParticipatedLeadershipDevelopment TechTrainingPriorYear.

* Cluster 4 Ancova Results:
Controlling for prior performance, there is no difference in current performance based on participation
Controlling for prior performance and techtraining, there is no difference in current performance based on participation


****** Cluster 5 Analysis *******
USE ALL.
COMPUTE filter_$=(QCL_5 = 5).
VARIABLE LABELS filter_$ 'QCL_5 = 5 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.

UNIANOVA CurrentYearPerformanceRating BY ParticipatedLeadershipDevelopment WITH 
    PriorYearPerformanceRating
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /SAVE=COOK
  /EMMEANS=TABLES(ParticipatedLeadershipDevelopment) WITH(PriorYearPerformanceRating=MEAN) COMPARE 
    ADJ(BONFERRONI)
  /PRINT=ETASQ HOMOGENEITY DESCRIPTIVE 
  /CRITERIA=ALPHA(.05)
  /DESIGN=PriorYearPerformanceRating ParticipatedLeadershipDevelopment.

UNIANOVA CurrentYearPerformanceRating BY ParticipatedLeadershipDevelopment WITH 
    PriorYearPerformanceRating TechTrainingPriorYear
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /SAVE=COOK
  /PLOT=PROFILE(ParticipatedLeadershipDevelopment)
  /EMMEANS=TABLES(ParticipatedLeadershipDevelopment) WITH(PriorYearPerformanceRating=MEAN TechTrainingPriorYear=MEAN)COMPARE 
    ADJ(BONFERRONI)
  /PRINT=ETASQ DESCRIPTIVE HOMOGENEITY
  /CRITERIA=ALPHA(.05)
  /DESIGN=PriorYearPerformanceRating ParticipatedLeadershipDevelopment TechTrainingPriorYear.

* Cluster 5 Ancova Results:
Controlling for prior performance, there is no difference in current performance based on participation
Controlling for prior performance and techtraining, there is no difference in current performance based on participation







