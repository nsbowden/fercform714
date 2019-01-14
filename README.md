R tools for acquiring and processing FERC Form 714

The current tool gets the most recent of the FERC Form 714 data from https://www.ferc.gov/docs-filing/forms/form-714/data.asp.

getForm714() gets a zip archive that contains data from 2006 to 2017.  
Work continues to include older data which is fragmented by year and geography. 

The getForm714.R file contains the function getForm714().  The function can be loaded into the R environment by using 

\> source("getForm714.R")

Or using the full path. For example:

\> source("/home/nicholas/Documents/FERCFORM714/getForm714.R")

getForm714() takes a single argument, the path to the directory where the user would like the FERC Form 714 files to be writen. 

For instance, I created the following variable:

\> datadir = "/home/nicholas/Documents/FERCFORM714/dataDownload/"

And then ran:

\> getForm714(datadir)



