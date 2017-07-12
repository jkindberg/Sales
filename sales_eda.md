g---
title: "sales data EDA"
output:
  html_document:
    toc: yes
  pdf_document:
    toc: yes
---
<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>


# Read, process data

<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>


View before doing anything to raw sales data
<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>


```
Observations: 1,338
Variables: 22
$ Agent           <chr> "America's Health Advisors Insurance Agency - ...
$ ID              <dbl> 672170522, 672170491, NA, 672170006, 672169745...
$ Policy          <chr> "STA10045799", "STA10037359", NA, "STA10027830...
$ Name            <chr> " Michael  Arcuri  ", " Kallie  Cole  ", NA, "...
$ City            <chr> "exton", "Surprise", NA, "Loretto", "prescott"...
$ State           <chr> "PA", "AZ", NA, "PA", "AZ", "AZ", "AZ", "KY", ...
$ Phone           <chr> "(610) 563-4264", "(602) 615-2430", NA, "(814)...
$ Email           <chr> "michael.arcuri@comcast.net", "kcranch55@yahoo...
$ Product         <chr> "Pivot Deluxe 3x4", "Pivot Economy 3x4 ", NA, ...
$ Benefit         <chr> "$2,500 Deductible", "$3,000 Deductible", NA, ...
$ One-time        <dbl> 15, 15, NA, 15, 15, 15, 15, 15, 15, 15, 15, 15...
$ Monthly         <dbl> 594.48, 165.18, NA, 266.72, 400.11, 129.50, 80...
$ Method          <chr> "MasterCard", "ACH", NA, "ACH", "Visa", "ACH",...
$ Paid            <dbl> 1, NA, NA, 1, 1, 1, 1, 1, NA, NA, 1, 1, 1, NA,...
$ Created         <dttm> 2017-07-01, 2017-07-01, NA, 2017-06-30, 2017-...
$ First Billing   <dttm> 2017-07-01, 2017-07-04, NA, 2017-06-30, 2017-...
$ Active          <dttm> 2017-08-01, 2017-07-04, NA, 2017-07-01, 2017-...
$ Next Billing    <dttm> 2017-09-01, NA, NA, 2017-08-01, 2017-08-01, 2...
$ Amount          <dbl> 623.48, 209.18, NA, 295.72, 429.11, 158.50, 10...
$ Hold            <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
$ Date Inactive   <dttm> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
$ Inactive Reason <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
```



<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>


### Web data needs reformatting to be a dataframe

<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>


Date column needs to be cleaned up

<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>


### Website-specific dataframe creation
<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>


```
Observations: 183
Variables: 9
$ Date                 <date> 2017-01-01, 2017-01-02, 2017-01-03, 2017...
$ Total Web Sales      <dbl> 2, 4, 3, 1, 1, 2, 0, 0, 0, 0, 2, 1, 5, 1,...
$ Sessions             <dbl> 117, 202, 272, 231, 243, 189, 131, 128, 2...
$ Users                <dbl> 106, 178, 233, 201, 216, 156, 123, 118, 1...
$ Pageviews            <dbl> 461, 785, 894, 767, 809, 732, 373, 331, 8...
$ Pages/ Session       <dbl> 3.94, 3.89, 3.29, 3.32, 3.33, 3.87, 2.85,...
$ Avg Session Duration <dbl> 0.12083333, 0.13333333, 0.10833333, 0.115...
$ Bounce Rate          <dbl> 0.3333, 0.4554, 0.4779, 0.4589, 0.4691, 0...
$ % of New Session     <dbl> 0.7436, 0.6733, 0.6949, 0.6970, 0.7119, 0...
```



## Add columns and features to raw data

### Dates

Add columns for other intervals of each date

<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>


### 3x4 vs non column
<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>


```

       Pivot Choice   Pivot Choice 3x4         Pivot Deluxe 
                202                 461                  19 
   Pivot Deluxe 3x4       Pivot Economy  Pivot Economy 3x4  
                 83                 199                 293 
     Pivot Standard Pivot Standard 3x4  
                 35                  44 
```



<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>



### Count column for aggregation

for ggplot2

<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>



### Mapping state names for plotting purposes

ggplot2 requires the long form name of a state but this dataset only has state acronyms. I'm merging the data to **state.csv** in order to make graphs later

<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>


```
# A tibble: 6 × 2
      region State
       <chr> <chr>
1    alabama    AL
2     alaska    AK
3    arizona    AZ
4   arkansas    AR
5 california    CA
6   colorado    CO
```



<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>



The state data is latitute and longitude information for states - meta data needed for plots

<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>


```
Observations: 15,537
Variables: 6
$ long      <dbl> -87.46201, -87.48493, -87.52503, -87.53076, -87.5708...
$ lat       <dbl> 30.38968, 30.37249, 30.37249, 30.33239, 30.32665, 30...
$ group     <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1...
$ order     <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 1...
$ region    <chr> "alabama", "alabama", "alabama", "alabama", "alabama...
$ subregion <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ...
```



##### **Merge** 

<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>


```
Observations: 15,537
Variables: 7
$ long      <dbl> -87.46201, -87.48493, -87.52503, -87.53076, -87.5708...
$ lat       <dbl> 30.38968, 30.37249, 30.37249, 30.33239, 30.32665, 30...
$ group     <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1...
$ order     <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 1...
$ region    <chr> "alabama", "alabama", "alabama", "alabama", "alabama...
$ subregion <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ...
$ State     <chr> "AL", "AL", "AL", "AL", "AL", "AL", "AL", "AL", "AL"...
```



<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>

<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>


```
Observations: 1,336
Variables: 29
$ Agent           <chr> "America's Health Advisors Insurance Agency - ...
$ ID              <dbl> 672170522, 672170491, 672170006, 672169745, 67...
$ Policy          <chr> "STA10045799", "STA10037359", "STA10027830", "...
$ Name            <chr> " Michael  Arcuri  ", " Kallie  Cole  ", " Jan...
$ City            <chr> "exton", "Surprise", "Loretto", "prescott", "L...
$ State           <chr> "PA", "AZ", "PA", "AZ", "AZ", "AZ", "KY", "GA"...
$ Phone           <chr> "(610) 563-4264", "(602) 615-2430", "(814) 674...
$ Email           <chr> "michael.arcuri@comcast.net", "kcranch55@yahoo...
$ Product         <chr> "Pivot Deluxe 3x4", "Pivot Economy 3x4 ", "Piv...
$ Benefit         <chr> "$2,500 Deductible", "$3,000 Deductible", "$5,...
$ One-time        <dbl> 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15...
$ Monthly         <dbl> 594.48, 165.18, 266.72, 400.11, 129.50, 80.47,...
$ Method          <chr> "MasterCard", "ACH", "ACH", "Visa", "ACH", "Vi...
$ Paid            <dbl> 1, NA, 1, 1, 1, 1, 1, NA, NA, 1, 1, 1, NA, 1, ...
$ Created         <dttm> 2017-07-01, 2017-07-01, 2017-06-30, 2017-06-3...
$ First Billing   <dttm> 2017-07-01, 2017-07-04, 2017-06-30, 2017-06-3...
$ Active          <dttm> 2017-08-01, 2017-07-04, 2017-07-01, 2017-07-0...
$ Next Billing    <dttm> 2017-09-01, NA, 2017-08-01, 2017-08-01, 2017-...
$ Amount          <dbl> 623.48, 209.18, 295.72, 429.11, 158.50, 109.47...
$ Hold            <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
$ Date Inactive   <dttm> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
$ Inactive Reason <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
$ month_created   <date> 2017-07-01, 2017-07-01, 2017-06-01, 2017-06-0...
$ week_created    <date> 2017-06-26, 2017-06-26, 2017-06-26, 2017-06-2...
$ month_active    <date> 2017-08-01, 2017-07-01, 2017-07-01, 2017-07-0...
$ three_four      <chr> "3x4", "3x4", "3x4", "3x4", "3x4", "3x4", "3x4...
$ product_level   <chr> "Deluxe", "Economy", "Choice", "Choice", "Delu...
$ Count           <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1...
$ region          <chr> "Pennsylvania", "Arizona", "Pennsylvania", "Ar...
```




# Exploration
### Missing values

**Percentage of values missing from each column**

<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>


```
          Agent              ID          Policy            Name 
    0.000000000     0.000000000     0.000000000     0.000000000 
           City           State         Product         Created 
    0.000000000     0.000000000     0.000000000     0.000000000 
  month_created    week_created      three_four   product_level 
    0.000000000     0.000000000     0.000000000     0.000000000 
          Count          region           Phone           Email 
    0.000000000     0.000000000     0.000748503     0.001497006 
        Benefit         Monthly          Amount        One-time 
    0.002994012     0.002994012     0.002994012     0.007485030 
         Method          Active    month_active   First Billing 
    0.015718563     0.055389222     0.055389222     0.089820359 
           Paid    Next Billing   Date Inactive Inactive Reason 
    0.163922156     0.412425150     0.684880240     0.711826347 
           Hold 
    0.948353293 
```



### Unique values
**Number of unique values in each column**

<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>


```
          Count        One-time      three_four   product_level 
              1               2               2               4 
         Method         Product   month_created         Benefit 
              7               8               8               9 
           Paid    month_active Inactive Reason           State 
             10              10              20              26 
         region    week_created            Hold    Next Billing 
             26              29              42              67 
          Agent   Date Inactive         Created          Active 
             72             153             159             174 
  First Billing            City         Monthly          Amount 
            183             929            1214            1249 
          Email           Phone            Name              ID 
           1258            1262            1294            1326 
         Policy 
           1336 
```



## **Graphs**

### Distribution of sales Amount ($ shown for each sale/account)

<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>
<img src="sales_dashboard_files/figure-html/unnamed-chunk-20-1.png" width="576" data-figure-id=fig1 />


### Number of sales by product
<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>
<img src="sales_dashboard_files/figure-html/unnamed-chunk-21-1.png" width="576" data-figure-id=fig2 />

### Sales volume by product (Amount)
<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>



### Number of sales by benefit

<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>
<img src="sales_dashboard_files/figure-html/unnamed-chunk-23-1.png" width="576" data-figure-id=fig3 />

### **STM Web Sales data  - Jan-Jun 2017**


<div class="knitr-options" data-fig-width="576" data-fig-height="1440"></div>
<img src="sales_dashboard_files/figure-html/unnamed-chunk-24-1.png" width="576" data-figure-id=fig4 />

### Web Sales Y variable scatter plots
<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>
<img src="sales_dashboard_files/figure-html/unnamed-chunk-25-1.png" width="576" data-figure-id=fig5 />

<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>
<img src="sales_dashboard_files/figure-html/unnamed-chunk-26-1.png" width="576" data-figure-id=fig6 />

<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>
<img src="sales_dashboard_files/figure-html/unnamed-chunk-27-1.png" width="576" data-figure-id=fig7 />

<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>
<img src="sales_dashboard_files/figure-html/unnamed-chunk-28-1.png" width="576" data-figure-id=fig8 />


## Sales by state

<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>


```
    . Freq
1  TX  244
2  GA  112
3  PA   97
4  AZ   92
5  IL   86
6  OH   84
7  VA   81
8  FL   80
9  MI   71
10 WI   69
11 TN   62
12 AL   48
13 NE   36
14 KY   31
15 AR   23
16 OK   22
17 DE   19
18 IA   18
19 WV   17
20 MS   16
21 IN   11
22 WY    8
23 DC    5
24 SD    2
25 ID    1
26 MD    1
```




## Inactive accounts

This could be an area where we provide more value than just reporting. Maybe some of these inactivities/cancellations can be controlled/reduced?

These columns **Date Inactive** and **Inactive Reason** are usually both filled out together
<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>


```

FALSE  TRUE 
   36  1300 
```



### Top reasons for account inactivity

<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>


```
                        Var1 Freq
1               Changed Mind  111
2  Dissatisfied with Product   56
3             Not Interested   34
4      Policy Term Exhausted   29
5     Cannot use the product   27
6    Received Group Coverage   26
7     Replacing with A1 Plan   21
8               Can't Afford   19
9     Received Major Medical   15
10                Chargeback   13
```



# **Candidate graphs for reporting**

This section contains graphs they can potentially be interested in based on the other sheets they created in the Excel file. 

* Sales by state
* Sales by month
* Sales by product
* Monthly, daily sales


## Sales ($) by month

**The data is from 12/2016 - 07/2017**

<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>
<img src="sales_dashboard_files/figure-html/unnamed-chunk-32-1.png" width="576" data-figure-id=fig9 />

## Sales ($) by week (more granular)

<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>
<img src="sales_dashboard_files/figure-html/unnamed-chunk-33-1.png" width="576" data-figure-id=fig10 />

## Number of sales/accounts by week

<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>
<img src="sales_dashboard_files/figure-html/unnamed-chunk-34-1.png" width="576" data-figure-id=fig11 />

## Sales ($) by state for June (not working yet)

<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>
<img src="sales_dashboard_files/figure-html/unnamed-chunk-35-1.png" width="576" data-figure-id=fig12 />

## States as a proportion of TOTAL sales/accounts over time 
<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>
<img src="sales_dashboard_files/figure-html/unnamed-chunk-36-1.png" width="576" data-figure-id=fig13 />

# Notes, impressions

## Source information

There appear to be **3 main sources** of data that are in the combined sales summary

<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>


```
[1] "Adroit Sales Summary"   "Asst Agencies"         
[3] "STM Web Sales Summary"  "Combined Sales Summary"
[5] "One Page Summary"       "Raw Data From Adroit"  
[7] "Latitude Sales"         "States"                
[9] "Prem by Source"        
```



These 3 sources are **Adroit Sales Summary**, **Asst Agencies**, and **STM Web Sales Summary**. They get added together to calculate totals in the **Combined Sales Summary** sheet. I initially thought that the **Raw Data From Adroit** sheet populated the 3 main sources but some simple checking has shown me that the numbers are off - Specifically i found that there are less entries for plans in Texas in the raw data (244) compared to the combined sales summary (300).

### Web data outlier on 1/31/2017


Removed Web data outlier on 1/31/2017 to better see overall trend of web sales indicators. 

Here are the graphs with the outlier put back 

<div class="knitr-options" data-fig-width="576" data-fig-height="960"></div>
<img src="sales_dashboard_files/figure-html/unnamed-chunk-38-1.png" width="576" data-figure-id=fig14 />

