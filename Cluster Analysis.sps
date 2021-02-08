* Encoding: UTF-8.
**** Maria Brandao-Sze

**Run frequencies to understand data and look for out of range values, outliers, skews, restriction of range, missing data, and unlikely patterns

DATASET ACTIVATE DataSet1.
FREQUENCIES VARIABLES=Task1 Task2 Task3 Task4 Task5 Task6 Task7 Task8 Task9 Task10 Task11 Task12 
    Task13 Task14 Task15 Task16 Task17 Task18 Task19 Task20 Task21 Task22 Task23 Task24 MgrGender 
    MgrTenure MgrEngagement TeamEngagement TeamServiceBehavior1 TeamServiceBehavior2 
    TeamServiceBehavior3 TeamServiceBehavior4 TeamServiceBehavior5 TeamServiceBehavior6 
    KnowledgeServiceModel CustomerSatisfaction MallLocation StoreAge State
  /STATISTICS=VARIANCE RANGE MINIMUM MAXIMUM MEAN MEDIAN MODE SKEWNESS SESKEW
  /ORDER=ANALYSIS.

EXAMINE VARIABLES=Task1 Task2 Task3 Task13 Task14 Task15 Task16 Task17 Task18 Task19 Task20 Task21 
    Task22 Task23 Task24 MgrGender MgrTenure Task4 Task5 Task6 Task7 Task8 Task9 Task10 Task11 Task12 
    MgrEngagement TeamEngagement TeamServiceBehavior1 TeamServiceBehavior2 TeamServiceBehavior3 
    TeamServiceBehavior4 TeamServiceBehavior5 TeamServiceBehavior6 KnowledgeServiceModel 
    CustomerSatisfaction MallLocation StoreAge 
  /COMPARE VARIABLE
  /PLOT=BOXPLOT
  /STATISTICS=NONE
  /NOTOTAL
  /MISSING=LISTWISE.

*Missing data for 63 responses out of 114

***Demographics 
* Out of the 50 respondents 26 are male 24 are female
*Manage Tenure - No values on variable view. Ranges from 0-12, Missing 7,9,11. Contain outliers above

***Stores information
*Mall Location - have 49 locations, missing 3 out of the 52
**Maybe one of the stores is not in a mall since there are 63 missings. Something is wrong as there should be 63 missing not 62. I checked all variables on data view and missing data accounts for 63 across the board
*Located in 23 USA States

***Task variables:
*Missing 63 responses through out questions 
*Outliers on task 7, 14, 20 below 
*Outliers on task 11, 22, above 
*Outliers above and below tails Task 9

*Restriction of Range
*Task2
*Task3  
*Task4 
*Task 8
*Task 18
*Task 20
*24
*Hourly option the most not present in responses

*Task6,7,8,10,  12, 13, 14*, 16,17,21, 22,23- first time there are a few responses as never

*Tasks 1- 5, 9, 10,12 mostly on interaction, support, motivation, scheduling, budgeting - negative skewed
*Task 7, 11,14 interaciton with merchandise set up, engagement in staffing and hiring,  - positive skewed

***Engagement variables:
*Manager Engagement - No values on variable view. Ranges from 1-3. 45% scores 1. Does it mean more engaged? Outlier above tail
*Team Engagement - No values on variable view. Ranges from 5 to 12.75. Value 7 containing 5.8%. Outlier above tail

***TeamServiceBehavior variables:
*Greeting Customers within 10 feet - No values on variable view. Range 4 to 6. Score 5.5 has the most responses with 13.5%
*Asking Customers if there is anything.-  No values on variable view. Ranges 2-6. Score 4.75 has the most responses   with 9.6%. Outliers above and below.
*Smiling at or saying something... - No values on variable view. Ranges from 4-6. Score 5 has the most response with 19.2%
*Thanking a customer...-  No values on variable view. Ranges from 2 - 6. Outliers below.
*Finding a merchandise...-  No values on variable view. Ranges from 2.5 to 6.  Scre 5 has the most responses with 9.65. Outliers above.
*Asking customers about their... -  No values on variable view. Ranges from 1-6. Scors 5 and 6 have the most responses with 15.7%

*Missing information ranges between 62 to 65

***Customer Satisfaction
*Percent Net Promoters - No values on variable view. Ranges from 50.9 to 85.2.


***Run correlation to look for multicollinearity


CORRELATIONS
  /VARIABLES=Task1 Task2 Task3 Task4 Task5 Task6 Task7 Task8 Task9 Task10 Task11 Task12 Task13 
    Task14 Task15 Task16 Task17 Task18 Task19 Task20 Task21 Task22 Task23 Task24 MgrGender MgrTenure 
    MgrEngagement TeamEngagement TeamServiceBehavior1 TeamServiceBehavior2 TeamServiceBehavior3 
    TeamServiceBehavior4 TeamServiceBehavior5 TeamServiceBehavior6 KnowledgeServiceModel 
    CustomerSatisfaction MallLocation StoreAge
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

*Correlated:
Task 1, Task 2, Task 3, Task 4, task 8, task 13, task14 Task 15, task 16, task17, task 18, task 19, task 21, task22, task 23, Task 24, TeamServiceBehavior2 ,  TeamServiceBehavior4, TeamServiceBehavior6 , MgrTenure, 
TeamEngagement, TeamServiceBehavior3,  CustomerSatisfaction  , StoreAge, v 

CORRELATIONS
  /VARIABLES=Task1 Task2 Task3 Task4 Task8 Task13 
    Task14 Task15 Task16 Task17 Task18 Task19 Task21 Task22 Task23 Task24 MgrGender MgrTenure 
    MgrEngagement TeamEngagement TeamServiceBehavior3 
    TeamServiceBehavior4 TeamServiceBehavior6 
    CustomerSatisfaction StoreAge
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

* Task8, Task15, Task23, Task24 ,  TeamServiceBehavior4 ,  Task4 , Task15, Task2 ,  Task19,  TeamServiceBehavior6 , Task1,  Task3 
Task16 Task21  Task23 Task24 MgrTenure MgrGender StoreAge TeamServiceBehavior3 

CORRELATIONS
  /VARIABLES=Task1 Task2 Task3 Task4 Task8 
    Task15 Task16 Task19 Task21 Task23 Task24 MgrGender MgrTenure 
    TeamEngagement TeamServiceBehavior3 
    TeamServiceBehavior4 TeamServiceBehavior6 
    CustomerSatisfaction StoreAge
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

*Multicollinearity - possibly How often do you motivate your team members With How often you training team members and inspect inventory
How oftend do you inspect inventory with how often do you motivate your team members?

*graph one of the variables engagement

GRAPH
  /HISTOGRAM=Task1.

****Filter out 62 missing data 

USE ALL.
COMPUTE filter_$=(Task1 > 0 ).
VARIABLE LABELS filter_$ 'TeamEngagement  > 0  (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

***Run Cluster Analysis - Hierarchical

DATASET ACTIVATE DataSet1.
CLUSTER   Task1 Task2 Task3 Task4 Task5 Task6 Task7 Task8 Task9 Task10 Task11 Task12 Task13 Task14 
    Task15 Task16 Task17 Task18 Task19 Task20 Task21 Task22 Task23 Task24
  /METHOD WARD
  /MEASURE=SEUCLID
  /PRINT SCHEDULE
  /PLOT DENDROGRAM VICICLE.


*** Run K Means: On clusters of 15 to 5 

QUICK CLUSTER Task1 Task2 Task3 Task4 Task5 Task6 Task7 Task8 Task9 Task10 Task11 Task12 Task13 
    Task14 Task15 Task16 Task17 Task18 Task19 Task20 Task21 Task22 Task23 Task24
  /MISSING=LISTWISE
  /CRITERIA=CLUSTER(15) MXITER(10) CONVERGE(0)
  /METHOD=KMEANS(NOUPDATE)
  /SAVE CLUSTER
  /PRINT INITIAL ANOVA CLUSTER DISTAN.

QUICK CLUSTER Task1 Task2 Task3 Task4 Task5 Task6 Task7 Task8 Task9 Task10 Task11 Task12 Task13 
    Task14 Task15 Task16 Task17 Task18 Task19 Task20 Task21 Task22 Task23 Task24
  /MISSING=LISTWISE
  /CRITERIA=CLUSTER(11) MXITER(10) CONVERGE(0)
  /METHOD=KMEANS(NOUPDATE)
  /SAVE CLUSTER
  /PRINT INITIAL ANOVA CLUSTER DISTAN.

QUICK CLUSTER Task1 Task2 Task3 Task4 Task5 Task6 Task7 Task8 Task9 Task10 Task11 Task12 Task13 
    Task14 Task15 Task16 Task17 Task18 Task19 Task20 Task21 Task22 Task23 Task24
  /MISSING=LISTWISE
  /CRITERIA=CLUSTER(7) MXITER(10) CONVERGE(0)
  /METHOD=KMEANS(NOUPDATE)
  /SAVE CLUSTER
  /PRINT INITIAL ANOVA CLUSTER DISTAN.

QUICK CLUSTER Task1 Task2 Task3 Task4 Task5 Task6 Task7 Task8 Task9 Task10 Task11 Task12 Task13 
    Task14 Task15 Task16 Task17 Task18 Task19 Task20 Task21 Task22 Task23 Task24
  /MISSING=LISTWISE
  /CRITERIA=CLUSTER(6) MXITER(10) CONVERGE(0)
  /METHOD=KMEANS(NOUPDATE)
  /SAVE CLUSTER
  /PRINT INITIAL ANOVA CLUSTER DISTAN.


QUICK CLUSTER Task1 Task2 Task3 Task5 Task8 Task4 Task24 Task22 Task10 Task6 Task9 Task7 Task14 
    Task15 Task11 Task12 Task13 Task16 Task18 Task17 Task19 Task23 Task20 Task21
  /MISSING=LISTWISE
  /CRITERIA=CLUSTER(5) MXITER(10) CONVERGE(0)
  /METHOD=KMEANS(NOUPDATE)
  /SAVE CLUSTER
  /PRINT INITIAL ANOVA CLUSTER DISTAN.

***Cluster of 5 
1-4 not often, 5-6 often, 7-9 very often

*Cluster 1 
- Very often: Interacts with team members, customer over the phone, support register when busy, review and respond to customer satisfaction, engages in professional development
- Often: Interacts with customers in store, engage in store meetings, manage team performance, motivates team, works the register, schedule staff. Engage in budgeting, staff & customer resolution, store goal, and marketing
- Not very often: Engage in ordering inventory, staffing and hiring. Not involved in merchandise set up. Interact with regional mgt. Training of team

*Cluster 2
- Very often: Interacts with customer, team, regional. Team: motivates, manages performance, provides support when busy. Inspects inventory. Engage in customer resolution, sales&marketing, review & respond to customer satisfaction 
- Often: Cover a register shift. Engage in budgeting, ordering inventory, staff problem resolution, goal setting and professional development
- Not very often: Engage in store meetings, scheduling of staff, staffing hiring. Interact with merchandise set up or stock up. 

*Cluster 3
- Very often: Interacts with customer on phone, and team. Team: support when busy. Inspects inventory. Engage customer satisfaction review 
- Often: Interact with customer in store, regional management. Team: train, motivate, manage performance. Covers a shift on register. Inspect inventory. Engage in ordering inventory, customer problem resolution, sales and marketing
- Not very often: Interact with merchandise set up or stock up.  Engage in staffing hiring, budgeting, staff problem resolution, goal setting for store, professional development 

*Cluster 4
- Very often:  Interacts with customer on phone, and team. Engage customer problem resolution
- Often: Interact with customer in store, regional management. Team:motivate. Provides support to register when busy. Inspect inventory. Engage in budgeting, staff problem resolution, sales & marketing, review & respond customer survey
- Not very often: Team: Training, manage performance, engage in store meeting, schedule staff, covers a register shift. Interact wit merchandise set up or stock up.  Engage in staffing & hiring, ordering inventory, store goal setting, 
professional development

*Cluster 5
- Very often: Interacts with customers, team and regional. Team: Motivates, manage performance, provide support when busy. Engage in budgeting, customer problem resolution. Review customer survey
- Often: Trains team. Inspect inventory. Engage in staff problem resolution, sales & marketing. Respond to customer survey 
- Not very often: Engage in store meetings, staffing and hiring, scheduling of staff. Covers a register shift. Interact with merchandise managing, ordering,  set up or stock up. Engage in store goal setting, professional development

* Cluster profiles to team service behaviors

CROSSTABS
  /TABLES=QCL_9 BY TeamServiceBehavior1 TeamServiceBehavior2 TeamServiceBehavior3 
    TeamServiceBehavior4 TeamServiceBehavior5 TeamServiceBehavior6
  /FORMAT=AVALUE TABLES
  /CELLS=COUNT ROW 
  /COUNT ROUND CELL.

*Cluster 1 - 
Greeting: 56 % above half 
Asking customer if can help: 56% above half
Smiling/talking to customer: 23 % above half
Thanking customer: 34 % above half
Finding merchandise for customer: 45% above half
Customer Satisfaction upon check out:  67% above half

*Cluster 2 -
Greeting: 54% above half
Asking customer if can help: 55% above half
Smiling/talking to customer: 45% above half
Thanking customer: 45% above half
Finding merchandise for customer: 72% above half
Customer Satisfaction upon check out:  64% above half

*Cluster 3 -
Greeting: 30% above half 
Asking customer if can help: 46% above half
Smiling/talking to customer: 46% above half
Thanking customer: 33% above half
Finding merchandise for customer: 54% above half
Customer Satisfaction upon check out:   59% above half

*Cluster 4 -
Greeting: 75% above half
Asking customer if can help: 50 % above half 
Smiling/talking to customer: 75% above half
Thanking customer: 75% above half
Finding merchandise for customer: 75% above half
Customer Satisfaction upon check out:   100% above half

*Cluster 5 -
Greeting: 87% above half
Asking customer if can help: 75% above half
Smiling/talking to customer: 75% above half
Thanking customer: 75% above half
Finding merchandise for customer: 62% above half
Customer Satisfaction upon check out: 37% above half

** Cluster profiles to customer experience

CROSSTABS
  /TABLES=QCL_9 BY CustomerSatisfaction
  /FORMAT=AVALUE TABLES
  /CELLS=COUNT ROW 
  /COUNT ROUND CELL.

*Cluster 1 - 34% above half 
*Cluster 2 - 63% above half
*Cluster 3 - 46% above half
*Cluster 4 - 75% above half
*Cluster 5 - 50% above half
