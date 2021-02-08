* Encoding: UTF-8.
*******Maria Brandao Sze - Homework 6 - Ancova

*Descriptives on variables 

DESCRIPTIVES VARIABLES=PreProductivity PostProductivity PostUpSell PreUpSell CustomerCommentsPost 
    CustomerCommentsPre Condition
  /STATISTICS=MEAN STDDEV MIN MAX.

*Correlation
*Covariates should not be correlated

CORRELATIONS
  /VARIABLES= PostProductivity PostUpSell  CustomerCommentsPost 
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

*Number of customer comments after training is correlated to productivity and number of up sell 

*Anova -multivariate
* Issues with Anova -Too much variation, the original means have more variation than accounted

GLM PostProductivity PostUpSell CustomerCommentsPost BY Condition
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /POSTHOC=Condition(TUKEY SCHEFFE LSD) 
  /PRINT=DESCRIPTIVE ETASQ OPOWER
  /CRITERIA=ALPHA(.05)
  /DESIGN= Condition.

*Ancova
*Control for preexisting and group averages 

GLM PostProductivity PostUpSell CustomerCommentsPost BY Condition WITH PreProductivity PreUpSell 
    CustomerCommentsPre
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /EMMEANS=TABLES(Condition) WITH(PreProductivity=MEAN PreUpSell=MEAN CustomerCommentsPre=MEAN) 
  /PRINT=DESCRIPTIVE ETASQ OPOWER
  /CRITERIA=ALPHA(.05)
  /DESIGN=PreProductivity PreUpSell CustomerCommentsPre Condition.

*PreProductivity is significant to productivity after manage training
*PreUpSell is significant to number of up-sell opportunities created after training
*The training worked for the employee productivity and up selling of opportunities. But had no impact on customer comments 
*The economic value of the training is $260,000

 




