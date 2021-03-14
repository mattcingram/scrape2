# updated 20200130

url <- list()
url[[1]] <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url[[1]])
# identify nodes at url where data are located
namehtml <- html_nodes(html, "h3.gs_ai_name")    # collect name data
authorlink <- html_nodes(html, "a.gs_ai_pho")
name <- html_text(namehtml)
link <- html_attr(authorlink, "href")
namelist <- name
linklist <- link

authordata <- data.frame()

for (b in 1:length(linklist)){
  mybrowser$navigate(paste0("https://scholar.google.com", linklist[b], sep=""))
  # alternative if names are standard
  #mybrowser$findElement(using='link text', str_squish(namelist[b]))$clickElement()
  # str_squish removes extra spaces between words, which will case rselenium to throw error 
  # e.g., "Selenium message:Unable to locate element: Ronald  B Rapoport"
  
  # expand beyond 20 and then to all publication items
  #mybrowser$findElement(using='id', 'gsc_bpf_more')$clickElement()
  #mybrowser$findElement(using='id', 'gsc_bpf_more')$clickElement()
  
  # get url
  url[[2]] <- as.character(mybrowser$getCurrentUrl())
  #get html from url
  html <- read_html(url[[2]])
  ####
  # grab table
  #NOTE: only grabs first 20 entries, even if expanded to see more than 20 items; but, also grabs summary figure at top-right
  
  temphtml <- html_nodes(html, "table")
  
  temp <- html_table(temphtml)

  temp
  
  # grab data
  cites.all <- temp[[1]][,2][1] # first table, col 2, item 1
  cites.5y <- temp[[1]][,3][1] # first table, third col, item 1
  h.all <- temp[[1]][,2][2] # first table, col 2, item 1
  h.5y <- temp[[1]][,3][2] # first table, third col, item 1
  i10.all <- temp[[1]][,2][3] # first table, col 2, item 1
  i10.5y <- temp[[1]][,3][3] # first table, third col, item 1
  
  # write simple text file of page sorted by cites
  # too many formatting problems with names as filenames (e.g., orcid in name, special 
  #characters)
  
  #first <- strsplit(namelist[b], " ")[[1]][1]
  #last <- strsplit(namelist[b], " ")[[1]][length(strsplit(namelist[b], " ")[[1]])]
  
  #write.table(df, file = paste0("./data/working/gspage", "_", fields[a], 
  #                              first, last, "bycites.txt", sep=""), 
  #            append = FALSE, 
  #            quote = FALSE, 
  #            sep = ",",
  #            row.names = FALSE,
  #            col.names = FALSE)
  
  #sort by year
  mybrowser$findElement(using='css selector', "#gsc_a_ha.gsc_a_h")$clickElement()
  #resort by cites
  #mybrowser$findElement(using='css selector', "#gsc_a_ca")$clickElement()
  
  # expand beyond 20 and then to all publication items
  #mybrowser$findElement(using='id', 'gsc_bpf_more')$clickElement()
  #mybrowser$findElement(using='id', 'gsc_bpf_more')$clickElement()
  
  # screenshot
  #mybrowser$screenshot(display = TRUE)
  
  # scroll down to bottom
  #mybrowser$executeScript("window.scrollTo(0,document.body.scrollHeight);")
  # even after expanding to 100 articles and scrolling down, read_html only collects first 20 items, as 
  # if never expanded
  
  # get url
  url[[3]] <- as.character(mybrowser$getCurrentUrl())
  #get html from url
  html <- read_html(url[[3]])
  ####
  # grab table
  #NOTE: only grabs first 20 entries, even if expanded to see more than 20 items; but, also grabs summary figure at top-right
  
  temphtml <- html_nodes(html, "table")
  
  temp <- html_table(temphtml)
  
  temp
  
  # write simple text file of page
  # too many formatting problems with names as filenames (e.g., orcid in name, special 
  #characters)
  
  #write.table(df, file = paste0("./data/working/gspage", "_", fields[a], 
  #                              first, last, "byyr.txt", sep=""), 
  #            append = FALSE, 
  #            quote = FALSE, 
  #            sep = ",",
  #            row.names = FALSE,
  #            col.names = FALSE)
  
  # citations obtained from 20 most recent pubs
  temp5 <- data.frame(temp[[2]])
  temp5 <- subset(temp5, select=c("Var.2", "Var.3"))
  temp5 <- temp5[-1,]
  temp5$Var.2 <- as.numeric(temp5$Var.2)
  temp5$Var.3 <- as.numeric(temp5$Var.3)
  temp5
  # cites from 20 most recent is sum of first column here (Var.2)
  cites.20pubs <- sum(na.omit(temp5)$Var.2)
  # cites to docs publishes since 2015
  temp6 <- subset(temp5, temp5$Var.3>2014)
  cites.pubs2015 <- sum(na.omit(temp6)$Var.2)
  
  # to check percentage of total cites obtained from first 20 most recent pubs
  pcttot <- cites.20pubs/temp[[1]]$All[1]
  pcttot
  
  authorrow <- as.data.frame(cbind(namelist[b], cites.all, cites.5y, h.all, h.5y, i10.all, i10.5y, 
                                   cites.pubs2015, cites.20pubs))
  
  authordata <- rbind.fill(authordata, authorrow)
  
  mybrowser$goBack()
  mybrowser$goBack()
}


# now move on to remaining pages and repeat

i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  
  url[[1]] <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url[[1]])
  # identify nodes at url where data are located
  namehtml <- html_nodes(html, "h3.gs_ai_name")    # collect name data
  authorlink <- html_nodes(html, "a.gs_ai_pho")
  name <- html_text(namehtml)
  link <- html_attr(authorlink, "href")
  namelist <- name
  linklist <- link
  
  for (b in 1:length(linklist)){
    mybrowser$navigate(paste0("https://scholar.google.com", linklist[b], sep=""))
    # alternative if names are standard
    #mybrowser$findElement(using='link text', str_squish(namelist[b]))$clickElement()
    # str_squish removes extra spaces between words, which will case rselenium to throw error 
    # e.g., "Selenium message:Unable to locate element: Ronald  B Rapoport"
    
    # expand beyond 20 and then to all publication items
    #mybrowser$findElement(using='id', 'gsc_bpf_more')$clickElement()
    #mybrowser$findElement(using='id', 'gsc_bpf_more')$clickElement()
    
    # get url
    url[[2]] <- as.character(mybrowser$getCurrentUrl())
    #get html from url
    html <- read_html(url[[2]])
    ####
    # grab table
    #NOTE: only grabs first 20 entries, even if expanded to see more than 20 items; but, also grabs summary figure at top-right
    
    temphtml <- html_nodes(html, "table")
    
    temp <- html_table(temphtml)
    
    temp
    
    # grab data
    cites.all <- temp[[1]][,2][1] # first table, col 2, item 1
    cites.5y <- temp[[1]][,3][1] # first table, third col, item 1
    h.all <- temp[[1]][,2][2] # first table, col 2, item 1
    h.5y <- temp[[1]][,3][2] # first table, third col, item 1
    i10.all <- temp[[1]][,2][3] # first table, col 2, item 1
    i10.5y <- temp[[1]][,3][3] # first table, third col, item 1
    
    # write simple text file of page sorted by cites
    # too many formatting problems with names as filenames (e.g., orcid in name, special 
    #characters)
    
    #first <- strsplit(namelist[b], " ")[[1]][1]
    #last <- strsplit(namelist[b], " ")[[1]][length(strsplit(namelist[b], " ")[[1]])]
    #
    #write.table(df, file = paste0("./data/working/gspage", "_", fields[a], 
    #                              first, last, "bycites.txt", sep=""), 
    #            append = FALSE, 
    #            quote = FALSE, 
    #            sep = ",",
    #            row.names = FALSE,
    #            col.names = FALSE)
    
    #sort by year
    mybrowser$findElement(using='css selector', "#gsc_a_ha.gsc_a_h")$clickElement()
    #resort by cites
    #mybrowser$findElement(using='css selector', "#gsc_a_ca")$clickElement()
    
    # get url
    url[[3]] <- as.character(mybrowser$getCurrentUrl())
    #get html from url
    html <- read_html(url[[3]])
    ####
    # grab table
    #NOTE: only grabs first 20 entries, even if expanded to see more than 20 items; but, also grabs summary figure at top-right
    
    temphtml <- html_nodes(html, "table")
    
    temp <- html_table(temphtml)
    
    temp
    
    # write simple text file of page
    # too many formatting problems with names as filenames (e.g., orcid in name, special 
    #characters)
    
    #write.table(df, file = paste0("./data/working/gspage", "_", fields[a], 
    #                              first, last, "byyr.txt", sep=""), 
    #            append = FALSE, 
    #            quote = FALSE, 
    #            sep = ",",
    #            row.names = FALSE,
    #            col.names = FALSE)
    
    # citations obtained from 20 most recent pubs
    temp5 <- data.frame(temp[[2]])
    temp5 <- subset(temp5, select=c("Var.2", "Var.3"))
    temp5 <- temp5[-1,]
    temp5$Var.2 <- as.numeric(temp5$Var.2)
    temp5$Var.3 <- as.numeric(temp5$Var.3)
    temp5
    # cites from 20 most recent is sum of first column here (Var.2)
    cites.20pubs <- sum(na.omit(temp5)$Var.2)
    # cites to docs publishes since 2015
    temp6 <- subset(temp5, temp5$Var.3>2014)
    cites.pubs2015 <- sum(na.omit(temp6)$Var.2)
    
    # to check percentage of total cites obtained from first 20 most recent pubs
    pcttot <- cites.20pubs/temp[[1]]$All[1]
    pcttot
    
    authorrow <- as.data.frame(cbind(namelist[b], cites.all, cites.5y, h.all, h.5y, i10.all, i10.5y, 
                                     cites.pubs2015, cites.20pubs))
    
    authordata <- rbind.fill(authordata, authorrow)
    
    mybrowser$goBack()
    mybrowser$goBack()
  }
  
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

