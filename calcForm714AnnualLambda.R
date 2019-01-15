### Calculate Load Weighted Marginal Generation Cost for US Balancing Authories using FERC FORM 714 System Lambda and Load Data

calc714AnnualLambda = function(datadir) { 

  ### We suspect an error in file naming and use "Part 2 Schedule 6 - System Lambda Description.csv" as System Lambad hourly data
  ### Part 2 Schedule 6 - Balancing Authority Hourly System Lambda.csv contains descritptions of data and data collection
  ### Part 2 Schedule 6 - System Lambda Description.csv contains 24 numeric columns (actually 48) that look like system lambda 

  ### Construct paths to Respondent names (fr), System Lambda/Marginal Cost (fd) and System Load (fl)
  fr = paste0(datadir, "Respondent IDs.csv")
  fd = paste0(datadir, "Part 2 Schedule 6 - System Lambda Description.csv")
  fl = paste0(datadir, "Part 3 Schedule 2 - Planning Area Hourly Demand.csv")  

  ### Read and clean the respondent ID to Firm Name key
  r = read.csv(fr, stringsAsFactors=FALSE)
  names(r) = c('ferc714ID', 'respondent', 'eiaID')
  r$respondent = gsub("[[:space:]]+$", "", r$respondent)
  r = r[!r$ferc714ID > 99900,]

  ### Read and clean the system lambda data
  d = read.csv(fd, stringsAsFactors=FALSE)
  d = d[,c(1,6:31)]
  names(d)[1:2] = c('ferc714ID', 'date')
  d = d[!d$ferc714ID > 99900,]

  ### Merge Lambda and Respondent Name
  p = merge(d, r)

  ### Continue to clean the merged set
  p$date = sapply(p$date, function(x) strsplit(x, "[[:space:]]")[[1]][1])
  p$date = as.POSIXlt(p$date, format = "%m/%d/%Y")
  p = p[order(p$ferc714ID, p$date),]
  p = p[c('eiaID', 'ferc714ID', 'respondent', 'date', 'timezone', 'hour01', 'hour02', 'hour03', 'hour04', 'hour05', 'hour06', 'hour07', 'hour08', 'hour09', 'hour10', 'hour11', 'hour12', 'hour13', 'hour14', 'hour15', 'hour16', 'hour17', 'hour18', 'hour19', 'hour20', 'hour21', 'hour22', 'hour23', 'hour24')]

  ### Add Lambda to variable names hourX
  names(p)[6:length(p)] = paste0(names(p)[6:length(p)], "Lambda")  

  ###Read and clean the load data
  l = read.csv(fl, stringsAsFactors=FALSE)
  l = l[,c(1,6:31)]
  names(l)[1:2] = c('ferc714ID', 'date')
  l = l[!l$ferc714ID > 99900,]
  l$date = sapply(l$date, function(x) strsplit(x, "[[:space:]]")[[1]][1])
  l$date = as.POSIXlt(l$date, format = "%m/%d/%Y")

  ### Merge Load and Respondent Name 
  q = merge(l, r)
  q = q[order(q$ferc714ID, q$date),]
  q = q[c('eiaID', 'ferc714ID', 'respondent', 'date', 'timezone', 'hour01', 'hour02', 'hour03', 'hour04', 'hour05', 'hour06', 'hour07', 'hour08', 'hour09', 'hour10', 'hour11', 'hour12', 'hour13', 'hour14', 'hour15', 'hour16', 'hour17', 'hour18', 'hour19', 'hour20', 'hour21', 'hour22', 'hour23', 'hour24')]

  ### Add Load to variable names hourX
  names(q)[6:length(q)] = paste0(names(q)[6:length(q)], "Load")

  ### Merge the lambdas and loads together
  ### Lost lots of loads without lambdas; expected.
  ### Lost a lot of Lambdas without loads, perhaps system loads and lambdas are reported at a different scale.  

  m = merge(p, q)

  #m2 = merge(p, q, all.x=TRUE)
  #m3 = merge(p, q, all.y=TRUE)
  #m4 = merge(p, q, all = TRUE)

  ### nrow(p) + nrow(q) - nrow(m4) - nrow(m) = 4
  ### 4 odd rows

  ### Subset the merged dataframe, calculate the hourly revenue/cost, add it to the df
  pp = m[grepl("Lambda", names(m))]
  qq = m[grepl("Load", names(m))]
  dd = pp*qq
  names(dd) = gsub("Lambda", "Cost", names(dd))
  mm = cbind(m, dd)

  ### Calculate Daily Loads and Revenues/Costs
  mm$dailyLoad = rowSums(mm[grepl("Load", names(mm))])
  mm$dailyCost = rowSums(mm[grepl("Cost", names(mm))])
  ff = mm[c('eiaID', 'ferc714ID', 'respondent', 'date', 'dailyLoad', 'dailyCost')]

  ### Calculate Annual Loads and Revenues/Costs
  la = aggregate(ff$dailyLoad, by=list(ff$ferc714ID, ff$date$year), FUN=sum)
  names(la) = c('ferc714ID', 'year', 'annualLoad')
  ca = aggregate(ff$dailyCost, by=list(ff$ferc714ID, ff$date$year), FUN=sum)
  names(ca) = c('ferc714ID', 'year', 'annualCost')
  dd = merge(la, ca)
  dd$avgCost = dd$annualCost/dd$annualLoad

  ### Add in the respondent name and IDs and fix the date
  ddd = merge(dd, r)
  ddd$year = as.Date(paste0((ddd$year + 1900), "-01-01"))

  ### Drop NAs and cut off for outliers
  ### calc number of obs to cut off, identify units as another quality control)
  ddd = ddd[!is.na(ddd$avgCost),]
  ddd = ddd[(ddd$avgCost < 200 & ddd$avgCost > 1),]

}
 
