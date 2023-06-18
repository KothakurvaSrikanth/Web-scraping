library(rvest)
library(dplyr)
library(xml2)
library(curl)
library(rmarkdown)

APU.fac <- read_html("https://azimpremjiuniversity.edu.in/SitePages/school-of-arts-and-sciences-faculty.aspx")
baseurl.fac <- "https://azimpremjiuniversity.edu.in/SitePages/"
base.image.url <- "https://azimpremjiuniversity.edu.in/SitePages/"

fac.names <- APU.fac %>%
  html_nodes(".col-lg-8.padding-left0 .orange") %>%
  html_attr("href")
fac.links <- paste0(baseurl.fac,fac.names)
total.fac <- length(fac.links)


image.names <- list()
for (i in 1:length(fac.links)) {
  photo <- read_html(fac.links[i]) %>% 
    html_node(".text-redis img") %>% 
    html_attr("src")
  image.names[i] <- photo
}
image.links <- paste0(base.image.url,image.names)



fac.interest <- NULL
fac.image <- NULL
for (i in 1:10) {
  fac.name <- read_html(fac.links[i]) %>% 
    html_nodes("h6:nth-child(2)") %>% 
    html_text()
  
  fac.info <- read_html(fac.links[i]) %>% 
    html_nodes(".col-lg-8") %>% 
    html_children()
  fac.info <- html_text(fac.info)
  #fac.interest <- fac.info[grepl("Areas of Interest|Research Interests|Interests",fac.info)]
  aoi <- which(fac.info=="Areas of Interest")
  ri <- which(fac.info=="Research Interests")
  t <- which(fac.info=="Teaching")
  if(typeof(aoi)=="integer"){Areas.of.interest <- fac.info[aoi+1]}else{Areas.of.interest <- ""}
  if(typeof(aoi)=="integer"){Research.interest <- fac.info[ri+1]}else{Research.interest <- ""}
  if(typeof(aoi)=="integer"){Teaching <- fac.info[t+1]}else{Teaching <- ""}
  
  final.interest <- c('\n','\n','  ', '\nAreas of Interest: ','  ','\n',Areas.of.interest,'\n',
                      '\n Teaching:  ','  ','\n',Research.interest,'\n','\n Research Interests: ','  ','\n',Teaching,'\n')
  curl_download(image.links[i],paste("~/Sem6/Assignment-1, files/",i,".jpg"))
  cat(i,".",fac.name)
  cat(final.interest)
  image.file <- paste0(paste0("![",fac.name,"]"),"( ",paste0(i," .jpg)"))
  
  fac.image <- c(fac.image,image.file) 
  fac.interest <- c(fac.interest,'\n','\n','\n',image.file,'\n',paste0(i,".",fac.name),'\n','\n','\n','\n','\n','\n',final.interest,'\n')
  #fac.interest.image <- cat(fac.interest.image)
 

}

sink("Question-7, Web scraping.Rmd")
cat('---\ntitle: "Question-7"\nauthor: "Srikanth K"\ndate: "29/02/2020"\noutput: pdf_document\n---')
cat(fac.interest)
sink()

rmarkdown::render("Question-7, Web scraping.Rmd")









