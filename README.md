# R tools for acquiring and processing FERC Form 714

The current tool gets the most recent of the [FERC Form 714 data](https://www.ferc.gov/docs-filing/forms/form-714/data.asp)

The getForm714.R file contains the function `getForm714()`. `getForm714()` gets a zip archive that contains data from 2006 to 2017.  
Work continues to include older data which is fragmented by year and geography. The function can be loaded into the R environment by using 

```
> source("getForm714.R")
```

Or using the full path. For example:

```
> source("/home/nicholas/Documents/FERCFORM714/getForm714.R")
```

`getForm714()` takes a single argument, the path to the directory where the user would like the FERC Form 714 files to be writen. 

For instance, I created the following variable:

```
> datadir = "/home/nicholas/Documents/FERCFORM714/dataDownload/"
```

And then ran:

```
> getForm714(datadir)
```

The calc714AnnualLambda.R file contains the function `calc714AnnualLambda()`, which similarly takes a single directory argument and uses files from the download to calculate the annual system lambda for all respondents (utility companies) that have submitted system lambda and load data.  The directory needed is the one that contains the files downloaded by `getForm714()`.  If the directory structure is unaltered, then following the earlier example we use the same datadir variable. 

Checking to see that the datadir has the right value. 

```
> datadir
[1] "/home/nicholas/Documents/FERCFORM714/dataDownload/"
```

Again we can source the file into the R environment.

```
> source("calcForm714AnnualLambda.R")
```

And assign the result of calc714AnnualLambda() to some variable, d for instance.

```
> d = calc714AnnualLambda(datadir)
```

Here is a visualization of the central result of `calc714AnnualLambda()`, a panel of system lambdas, plotted here as a set of time series on a single graph.

![System Lambda](https://github.com/nsbowden/fercform714/blob/master/annualLambda.png){:height="36px" width="36px"}

