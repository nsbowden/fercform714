### Get the FERC FORM 714 data for 

getForm714 = function(datadir) {

  if(! "RCurl" %in% installed.packages()){
  install.packages("RCurl")
  } 
  library(RCurl)

  if(! "XML" %in% installed.packages()){
  install.packages("XML")
  } 
  library(XML)

  if(!dir.exists(datadir)){
    dir.create(datadir)
  }

  url = "https://www.ferc.gov/docs-filing/forms/form-714/data.asp"
  domain = paste(strsplit(url, "/")[[1]][1], strsplit(url, "/")[[1]][3], sep='//')

  t = getURLContent(url)  # Not sure about the meaning of this warning
  d = htmlParse(t)
  n = getNodeSet(d, "//a")
  p = n[grepl("Form 714 Database", lapply(n, function(x) xmlValue(x, href)))][[1]]
  fdir = xmlGetAttr(p, 'href')
  url2 = paste0(domain, fdir)

  temp = tempfile()
  download.file(url2, temp)
  zfiles = unzip(temp, list=TRUE)
  unzip(temp, files = zfiles$Name, exdir = datadir, junkpaths=TRUE)
  unlink(temp)

}
