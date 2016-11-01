# AEM: PS2 - Instrumental Variables
## Maxwell Austensen
## November 2, 2016


### 1

In the first-stage regression of mpg on displacement we see that the coefficient on displacement is statistically significant at the 1% level. The coefficient on displacement is -0.044, which equates to a one standard deviation increase in displacement being associated with 71% of one standard deviation decrease in mpg. This association means that automobiles with greater engine displacement are less fuel efficient. 

Displacement is a strong instrument for mpg. The model's R-squared indicates that 50% of the variation in mpg can be explained by displacement. The critical value of the first-stage F-statistic is 71.41, which is well above the commonly used thresholds used to test for weak instruments of 10 and 24. This means that the squared bias of the coefficient of interest in the IV model exceeds 10% of the squared bias of the coefficient of interest in an OLS model, because the F-statistic is greater than 10. Additionally, because the F-statistic is greater then 24 the actual level of 5% significance test exceeds 15%, meaning that a 5% test falsely rejects the null hypothesis no more than 15% of the time.

While displacement is clearly relevant to mpg, it is less clear whether it can be considered exogenous and satisfy the exclusion restriction. It seems possible that displacement could have an effect on price through mechanisms other than just effecting fuel efficiency - for example through it's effect on horsepower.


### 2

(See log)

### 3

Eventually labor regulations will be used as an instrument for growth in manufacturing to examine spillover effects of manufacturing on service sector. Here it is helpful to first examine some reduced-form regressions of service sector growth on labor regulations directly. In these specifications we see that the association between labor regulations and growth in the service sector is positive and statistically significant at the 1% level. This hold for each round separately, with the effect being more than twice as large in the later round. When we use the full sample and include both an indicator for the later round and that round interacted with labor regulations we see that the association between labor regulations and service sector growth was greater in the later round and this differential association is statistically significant at the 1% level. Finally, when we include fixed effects for state and 2-digit industry codes, we find that the magnitude of the effect of labor regulations decreases only slightly (as do the other coefficients) and remains positive and statistically significant at the 1% level. 


--------------------------------------------------------------------------------------------
                      (1)             (2)             (3)             (4)             (5)   
             gva_ln_yea~y    gva_ln_yea~y    gva_ln_yea~y    gva_ln_yea~y    gva_ln_yea~y   
--------------------------------------------------------------------------------------------
labor_reg           0.359***        0.729***        0.454***        0.359***        0.345***
                  (21.95)         (19.28)         (29.08)         (19.84)          (6.10)   

round_63                                            0.355***        0.148***        0.131***
                                                  (20.02)          (5.55)          (5.07)   

labor_reg~63                                                        0.370***        0.318***
                                                                  (10.37)          (9.22)   





### 4



----------------------------------------------------------------------------
                      (1)             (2)             (3)             (4)   
             gva_ln_yea~y    gva_ln_yea~y    gva_ln_yea~y    gva_ln_yea~y   
----------------------------------------------------------------------------
manu_all           0.0227***      0.00338         0.00752***        0.355***
                  (11.32)          (1.58)          (3.44)          (6.48)   

manu_post          0.0222***       0.0229***      0.00745          0.0128** 
                   (5.59)          (5.81)          (1.73)          (3.04)   

post                0.213***        0.165***        0.443***        0.324***
                   (5.73)          (4.50)          (9.16)          (6.86)   

labor_reg                           0.420***        0.330***       -0.437***
                                  (24.48)         (16.56)         (-4.31)   

0.labor_re~t                                            0               0   
                                                      (.)             (.)   

0.labor_re~t                                       -0.344***       -0.271***
                                                  (-8.82)         (-7.16)   

1.labor_re~t                                            0               0   
                                                      (.)             (.)   

1.labor_re~t                                            0               0   
                                                      (.)             (.)   


### 5


# a


# b


# c


# d


------------------------------------------------------------
                      (1)             (2)             (3)   
             gva_ln_yea~y    gva_ln_yea~y    gva_ln_yea~y   
------------------------------------------------------------
manu_all            0.129***      -0.0244***      -0.0242***
                  (29.48)         (-8.04)         (-7.86)   

manu_post                                          0.0864***
                                                   (9.17)   

labor_reg                                           0.374***
                                                  (10.70)   

post                                               -0.396***
                                                  (-5.02)   

_cons               11.50***        13.38***        12.94***
                 (325.90)        (150.80)        (154.08)   


FIXED effects 		NO             YES              YES