* Encoding: UTF-8.
*****MariaBrandaoSze
****Run descriptive statistics on gender to determine biggest group

DATASET ACTIVATE DataSet2.
FREQUENCIES VARIABLES=Gender
  /ORDER=ANALYSIS.

****Recode to create new variable

RECODE Gender (1=1) (0=0) (ELSE=SYSMIS) INTO male.
VARIABLE LABELS  male 'male=1 female=0'.
EXECUTE.


****************************************************
****Perform crosstabs analysis to determine 80% Rule, 2SD, Fisher test
***Outcome on first hurdle

CROSSTABS
  /TABLES=Stage1Decision BY male
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT EXPECTED COLUMN 
  /COUNT ROUND CELL.

****80% Rule
IR=.743/.679= 1.09426
1.09>.8 = no imbalance between male to female comparison

****2SD
square root of 2.184= 1.47784
Zd=1.48<1.96 = not significant, no disparity

****Fisher's Test
Fisher's Exact Test= .166>.05=no significant, no disparity

*******************************************************

****Perform crosstabs analysis to determine 80% Rule, 2SD, Fisher test
***Outcome on second hurdle

CROSSTABS
  /TABLES=Stage2Decision BY male
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT EXPECTED COLUMN 
  /COUNT ROUND CELL.

****80% Rule
IR=.785/.717= 1.0948396
1.09>.8 = no imbalance between male to female comparison

****2SD
square root of 1.968= 1.40285
Zd=1.40<1.96 = not significant, no disparity

****Fisher's Test
Fisher's Exact Test= .182>.05=no significant, no disparity

******************************

****Perform crosstabs analysis to determine 80% Rule, 2SD, Fisher test
***Outcome on hiring decision

CROSSTABS
  /TABLES=Hired BY male
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT EXPECTED COLUMN 
  /COUNT ROUND CELL.

****80% Rule
IR=.787/.538= 1.46282
1.46>.8 = no imbalance between male to female comparison

****2SD
square root of 16.399= 4.049568
Zd=4.05>1.96 = significant, there is a disparity

****Fisher's Test
Fisher's Exact Test= .000<.05=significant, there is a disparity

****Response Q1: Looking at the last stage -the hiring decision. We see that there is a 
violation and hiring rates are statistically significant in 2SD and Fisher's test with 78.7% males being hired to 53.8% of females

****Response Q3: If these jobs were for managers the number of females being hired
are under utilized

****Response Q2,4 & 5: N/A