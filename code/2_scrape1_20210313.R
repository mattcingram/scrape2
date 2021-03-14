# main scraping code
# first passes include more commentary; later passes are more succinct

###########################################################
# skip to lines 62-168, and then jump down to 350
###########################################################

# lots of errors with RSelenium on 20160828; shifted to beta version, added geckodriver, and this now worked for chrome but not firefox 
#install.packages("devtools")
#library(devtools)
devtools::install_github("ropensci/Rselenium")
RSelenium::rsDriver(browser="chrome", verbose=TRUE)
rsDriver()[["server"]]$stop()

# start a chrome browser
rD <- rsDriver()
remDr <- rD[["client"]]
remDr$navigate("http://www.google.com/ncr")
remDr$navigate("http://www.bbc.com")
remDr$close()
# stop the selenium server
rD[["server"]]$stop() 

#####################################################
# other notes
## added chromedriver_win32.exe to path; also added geckodriver.exe to path
#
## can also get profile and try
#cprof <- getChromeProfile("C:/Users/mi122167/AppData\\Local\\Google\\Chrome\\User Data", "Profile 1") # /  and \\ are same thing
#mybrowser <- remoteDriver(browserName = "chrome", extraCapabilities = cprof)
#
#
## couldnt use getFirefoxProfile, so used alternative of making one; need Rtools
##fprof <- getFirefoxProfile("C:/Users/mi122167/AppData/Local/Mozilla/Firefox/Profiles/6dd8zuht.default-1402457180169", useBase=TRUE)
#install.packages("Rtools")   # not yet available for R 3.3.1
#library(Rtools)
#fprof <- makeFirefoxProfile(list(browser.download.dir = "C:/temp"))
#remDr <- remoteDriver(extraCapabilities = fprof)
#remDr$open()
#####################################################
#####################################################


# move on with firefox browser; previously tried chrome browser using geckodriver (return later to see if Rtools updated for R 3.3.1)
rD <- rsDriver(browser=c("firefox"), port = 4458L) # just using random port
# do this if get error that port is already in use
#rD <- rsDriver(browser=c("chrome"))

mybrowser <- rD$client
# to stop remote driver, type this in URL: "http://localhost:4444/selenium-server/driver/?cmd=shutDownSeleniumServer"

# get session info
#head(mybrowser$sessionInfo)

# stop session
mybrowser$close()
# stop the selenium server
rD$client$close()
rD$server$stop() 



#######################################################
# loop
######################################################
# loop through the following starting URLs:

# political science URLs (for PS revision)
urls <- c(
  "https://scholar.google.com/citations?mauthors=label%3Apublic_law&hl=en&view_op=search_authors",
  "https://scholar.google.com/citations?mauthors=label%3Ajudicial_politics&hl=en&view_op=search_authors",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:american_politics",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:comparative_politics",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:international_relations",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:political_theory",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:political_methodology",
  "https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:public_policy",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:public_administration",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:political_psychology",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:political_science",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:politics",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:government"
)

# for larger, interdisciplinary search, use these:
urls2 <- c(
  "https://scholar.google.com/citations?mauthors=label%3Apublic_law&hl=en&view_op=search_authors",
  "https://scholar.google.com/citations?mauthors=label%3Ajudicial_politics&hl=en&view_op=search_authors",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:american_politics",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:comparative_politics",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:international_relations",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:political_theory",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:political_methodology",
  "https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:public_policy",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:public_administration",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:political_psychology",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:political_science",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:politics",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:government",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:sociology",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:anthropology",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:history",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:economics",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:philosophy",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:mathematics",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:psychology",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:law",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:physics",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:chemistry",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:biology",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:public_health",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:medicine",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:engineering",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:computer_science",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:religion",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:literature",
  "https://scholar.google.com/citations?hl=en&view_op=search_authors&mauthors=label:linguistics"
)


fields <- c(
  "publaw",
  "judpol",
  "american",
  "comparative",
  "ir",
  "theory",
  "polmeth",
  "policy",
  "pubadmin",
  "polpsych",
  "polsci",
  "politics",
  "government"
)


fields2 <- c(
  "publaw",
  "judpol",
  "american",
  "comparative",
  "ir",
  "theory",
  "polmeth",
  "policy",
  "pubadmin",
  "polpsych",
  "polsci",
  "politics",
  "government",
  "sociology",
  "anthro",
  "history",
  "econ",
  "phil",
  "math",
  "psych",
  "law",
  "physics",
  "chemistry",
  "biology",
  "pubhealth",
  "medicine",
  "engineering",
  "compsci",
  "religion",
  "literature",
  "linguistics"
)


#start loop
for (a in 1:length(urls)){

rD <- rsDriver(browser=c("firefox"), port=4458L)
#rD <- rsDriver(browser=c("chrome"))
  
mybrowser <- rD$client
  
print(fields[a])
#print(urls[a])

Sys.sleep(5)  # pause 5 seconds while page loads
# navigate to page
mybrowser$navigate(urls[a])

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
                          # still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
namelist
afflist
emaillist
citationnum
fieldlist
fieldpagelist

#for (i in 1:8){
i <- 10
  while (i > 9){                    # this keep below loop going until last page with less than 10 entries
    # now swtich to rSelenium to click button to advance to next 10 entries
    # first, create button object
    #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
    button <- mybrowser$findElements("button", using = 'css selector')
    # click on button using clickElement for button object: 
    button[[3]]$clickElement()
    # get new url
    url <- as.character(mybrowser$getCurrentUrl())
    html <- read_html(url)
    namehtml <- html_nodes(html, ".gs_ai_name")    
    affhtml <- html_nodes(html, ".gs_ai_aff")
    emailhtml <- html_nodes(html, ".gs_ai_eml")
    citationhtml <- html_nodes(html, ".gs_ai_cby") 
    fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
    fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
    name <- html_text(namehtml)
    aff <- html_text(affhtml)
    email <- html_text(emailhtml)
    citation <- html_text(citationhtml)
    fieldentry <- html_text(fieldbyentryhtml)
    fieldpage <- html_text(fieldnotbyentryhtml)
    lastword <- word(citation, -1)
    email2 <- word(email, -1)
    
    namelist <- append(namelist, name)
    afflist <- append(afflist, aff)
    emaillist <- append(emaillist, email2)
    citationnum <- append(citationnum, as.numeric(lastword))
    fieldlist <- append(fieldlist, tolower(fieldentry))
    fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
    #print(namelist)
    #print(afflist)
    #print(emaillist)
    #print(citationnum)
    #print(fieldlist)
    #print(fieldpagelist)
    i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
  }

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

df[1:5,c(1:3,6)]

#save data

write.table(df, file = paste0("./data/working/citations", "_", fields[a], ".csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

write.table(df, file = "./data/working/citations_all.csv", 
            append = TRUE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

}


########################################################################
# kept getting an error so I broke this down in individual parts by field
########################################################################

# public law

a=1

rD <- rsDriver(browser=c("firefox"), port=4461L)
#rD <- rsDriver(browser=c("chrome"))

mybrowser <- rD$client

print(fields[a])
#print(urls[a])

# navigate to page
mybrowser$navigate(urls[a])

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
namelist
afflist
emaillist
citationnum
fieldlist
fieldpagelist

for (i in 1:39){
# prefer "while" command below; but this gets stuck if there are exactly 10 items on
# last page, e.g., 401-410, and process stalls;
# if use while, uncomment line 442 below (about 40 lines down)

#i <- 10
#while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gs_ai_name")    
  affhtml <- html_nodes(html, ".gs_ai_aff")
  emailhtml <- html_nodes(html, ".gs_ai_eml")
  citationhtml <- html_nodes(html, ".gs_ai_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  #print(namelist)
  #print(afflist)
  #print(emaillist)
  #print(citationnum)
  #print(fieldlist)
  #print(fieldpagelist)
  
  #uncomment next line if use while command
  #i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

df[1:5,c(1:3,6)]

#save data

date="20210310"
write.table(df, file = paste0("./data/working/citations", "_", 
                              fields[a], 
                              date,
                              ".csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

write.table(df, file = paste0("./data/working/citations_all",
                                          date,
                                          ".csv", sep=""), 
            append = TRUE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)


###############################

# judicial politics

a=2

rD <- rsDriver(browser=c("firefox"),port=4400L)
#rD <- rsDriver(browser=c("chrome"))

mybrowser <- rD$client

print(fields[a])
#print(urls[a])

# navigate to page
mybrowser$navigate(urls[a])

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
namelist
afflist
emaillist
citationnum
fieldlist
fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gs_ai_name")    
  affhtml <- html_nodes(html, ".gs_ai_aff")
  emailhtml <- html_nodes(html, ".gs_ai_eml")
  citationhtml <- html_nodes(html, ".gs_ai_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  #print(namelist)
  #print(afflist)
  #print(emaillist)
  #print(citationnum)
  #print(fieldlist)
  #print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

df[1:5,c(1:3,6)]
tail(df[,c(1:3,6)])
# tail rows show 0 citations

#save data

date="20210310"
write.table(df, file = paste0("./data/working/citations", "_", 
                              fields[a], 
                              date,
                              ".csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

write.table(df, file = paste0("./data/working/citations_all",
                              date,
                              ".csv", sep=""), 
            append = TRUE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)


############################
###############################

# american politics

a=3

rD <- rsDriver(browser=c("firefox"), port=4401L)
#rD <- rsDriver(browser=c("chrome"))

mybrowser <- rD$client

print(fields[a])
#print(urls[a])

# navigate to page
mybrowser$navigate(urls[a])

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
namelist
afflist
emaillist
citationnum
fieldlist
fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gs_ai_name")    
  affhtml <- html_nodes(html, ".gs_ai_aff")
  emailhtml <- html_nodes(html, ".gs_ai_eml")
  citationhtml <- html_nodes(html, ".gs_ai_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  #print(namelist)
  #print(afflist)
  #print(emaillist)
  #print(citationnum)
  #print(fieldlist)
  #print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

df[1:5,c(1:3,6)]
tail(df[,c(1:3,6)])
# zeroes there, so complete

#save data

date="20210310"
write.table(df, file = paste0("./data/working/citations", "_", 
                              fields[a], 
                              date,
                              ".csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

write.table(df, file = paste0("./data/working/citations_all",
                              date,
                              ".csv", sep=""), 
            append = TRUE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

###############################
###############################

# comparative politics

a=4

rD <- rsDriver(browser=c("firefox"), port=4301L)
#rD <- rsDriver(browser=c("chrome"), chromever = "89.0.4389.23", port=4408L)
#rD <- rsDriver(browser=c("phantomjs"), port=4409L)

mybrowser <- rD$client

print(fields[a])
#print(urls[a])

# navigate to page
mybrowser$navigate(urls[a])

#mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:comparative_politics&after_author=b2oWAPP-__8J&astart=640")
# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
namelist
afflist
emaillist
citationnum
fieldlist
fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gs_ai_name")    
  affhtml <- html_nodes(html, ".gs_ai_aff")
  emailhtml <- html_nodes(html, ".gs_ai_eml")
  citationhtml <- html_nodes(html, ".gs_ai_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  #print(namelist)
  #print(afflist)
  #print(emaillist)
  #print(citationnum)
  #print(fieldlist)
  #print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

df[1:5,c(1:3,6)]
tail(df[,c(1:3,6)])

#save data

date="20210310"
write.table(df, file = paste0("./data/working/citations", "_", 
                              fields[a], 
                              date,
                              ".csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

write.table(df, file = paste0("./data/working/citations_all",
                              date,
                              ".csv", sep=""), 
            append = TRUE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

##########################################
###############################

# international relations

a=5

rD <- rsDriver(browser=c("firefox"), port=4420L)
#rD <- rsDriver(browser=c("chrome"))

mybrowser <- rD$open()

print(fields[a])
#print(urls[a])

# navigate to page
mybrowser$navigate(urls[a])

#https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:international_relations&after_author=D237qALL__8J&astart=1970

#https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:international_relations&after_author=2WEiAOnx__8J&astart=200
#https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:international_relations&after_author=gLgAAKj3__8J&astart=310
#https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:international_relations&after_author=hcoHAEf6__8J&astart=420

#mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:international_relations&after_author=XKzMAGz9__8J&astart=600")

#https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:international_relations&after_author=XKzMAGz9__8J&astart=600

mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:international_relations&after_author=drxjANX___8J&astart=1790")
#mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:international_relations&before_author=PQ6R_yAAAAAJ&astart=1980")
#mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:international_relations&after_author=kGfqAOX___8J&astart=2150")

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
namelist
afflist
emaillist
citationnum
fieldlist
fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gs_ai_name")    
  affhtml <- html_nodes(html, ".gs_ai_aff")
  emailhtml <- html_nodes(html, ".gs_ai_eml")
  citationhtml <- html_nodes(html, ".gs_ai_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  #print(namelist)
  #print(afflist)
  #print(emaillist)
  #print(citationnum)
  #print(fieldlist)
  #print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

df[1:5,c(1:3,6)]
tail(df[,c(1:3,6)])

#save data

date="20210310"
write.table(df, file = paste0("./data/working/citations", "_", 
                              fields[a], 
                              date,
                              "b.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

write.table(df, file = paste0("./data/working/citations_all",
                              date,
                              ".csv", sep=""), 
            append = TRUE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)


##########################################
###############################

# theory

a=6

rD <- rsDriver(browser=c("firefox"), port=4420L)
#rD <- rsDriver(browser=c("chrome"))

mybrowser <- rD$client

print(fields[a])
#print(urls[a])

# navigate to page
mybrowser$navigate(urls[a])

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
namelist
afflist
emaillist
citationnum
fieldlist
fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gs_ai_name")    
  affhtml <- html_nodes(html, ".gs_ai_aff")
  emailhtml <- html_nodes(html, ".gs_ai_eml")
  citationhtml <- html_nodes(html, ".gs_ai_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  #print(namelist)
  #print(afflist)
  #print(emaillist)
  #print(citationnum)
  #print(fieldlist)
  #print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

df[1:5,c(1:3,6)]
tail(df[,c(1:3,6)])

#save data

date="20210310"
write.table(df, file = paste0("./data/working/citations", "_", 
                              fields[a], 
                              date,
                              ".csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

write.table(df, file = paste0("./data/working/citations_all",
                              date,
                              ".csv", sep=""), 
            append = TRUE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)




#########################################
###############################

# pol methodology

a=7

rD <- rsDriver(browser=c("firefox"), port=4430L)
#rD <- rsDriver(browser=c("chrome"))

mybrowser <- rD$client

print(fields[a])
#print(urls[a])

# navigate to page
mybrowser$navigate(urls[a])

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
namelist
afflist
emaillist
citationnum
fieldlist
fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gs_ai_name")    
  affhtml <- html_nodes(html, ".gs_ai_aff")
  emailhtml <- html_nodes(html, ".gs_ai_eml")
  citationhtml <- html_nodes(html, ".gs_ai_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  #print(namelist)
  #print(afflist)
  #print(emaillist)
  #print(citationnum)
  #print(fieldlist)
  #print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

df[1:5,c(1:3,6)]
tail(df[,c(1:3,6)])

#save data

date="20210310"
write.table(df, file = paste0("./data/working/citations", "_", 
                              fields[a], 
                              date,
                              ".csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

write.table(df, file = paste0("./data/working/citations_all",
                              date,
                              ".csv", sep=""), 
            append = TRUE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)


###############################

# public policy

a=8

rD <- rsDriver(browser=c("firefox"), port=4440L)
#rD <- rsDriver(browser=c("chrome"), port=4440L, chromever="89.0.4389.23")

mybrowser <- rD$client

print(fields[a])
#print(urls[a])

# navigate to page
mybrowser$navigate(urls[a])

# second run
#mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:public_policy&before_author=hdZ2_zsAAAAJ&astart=1550")

# third run
#mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:public_policy&after_author=VZrgAPr___8J&astart=2570")

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
namelist
afflist
emaillist
citationnum
fieldlist
fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gs_ai_name")    
  affhtml <- html_nodes(html, ".gs_ai_aff")
  emailhtml <- html_nodes(html, ".gs_ai_eml")
  citationhtml <- html_nodes(html, ".gs_ai_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  #print(namelist)
  #print(afflist)
  #print(emaillist)
  #print(citationnum)
  #print(fieldlist)
  #print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

df[1:5,c(1:3,6)]
tail(df[,c(1:3,6)])

#save data

date="20210310"
write.table(df, file = paste0("./data/working/citations", "_", 
                              fields[a], 
                              date,
                              ".csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

write.table(df, file = paste0("./data/working/citations_all",
                              date,
                              ".csv", sep=""), 
            append = TRUE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)


#############################################
#
# public administration
#

a=30

rD <- rsDriver(browser=c("firefox"), version="latest", port=4450L)
#rD <- rsDriver(browser=c("chrome"), chromever="79.0.3945.36")
#rD <- rsDriver(browser=c("chrome"))
#rD <- rsDriver(browser=c("internet explorer"))
#rD <- rsDriver(browser=c("phantomjs"))

mybrowser <- rD$client

#print(fields[a])
#print(urls[a])

# navigate to page
mybrowser$navigate(urls[a])

#other runs
#mybrowser$navigate(url)

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
#namelist
#afflist
#emaillist
#citationnum
#fieldlist
#fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gs_ai_name")    
  affhtml <- html_nodes(html, ".gs_ai_aff")
  emailhtml <- html_nodes(html, ".gs_ai_eml")
  citationhtml <- html_nodes(html, ".gs_ai_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  #print(namelist)
  #print(afflist)
  #print(emaillist)
  #print(citationnum)
  #print(fieldlist)
  #print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

df[1:5,c(1:3,6)]
tail(df[,c(1:3,6)])

# subscript to scrape data and advance through pages
#source(file="./code/2subscriptscrape.R", echo = TRUE, local = TRUE)

#save data

date="20210310"
write.table(df, file = paste0("./data/working/citations", "_", 
                              fields[a], 
                              date,
                              ".csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

write.table(df, file = paste0("./data/working/citations_all",
                              date,
                              ".csv", sep=""), 
            append = TRUE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)


#############################################
#
# political psychology
#

a=31

rD <- rsDriver(browser=c("firefox"), version="latest", port=4460L)
#rD <- rsDriver(browser=c("chrome"), chromever="79.0.3945.36")
#rD <- rsDriver(browser=c("chrome"))
#rD <- rsDriver(browser=c("internet explorer"))
#rD <- rsDriver(browser=c("phantomjs"))

mybrowser <- rD$client

#print(fields[a])
#print(urls[a])

# navigate to page
mybrowser$navigate(urls[a])

#other runs
#mybrowser$navigate(url)

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
#namelist
#afflist
#emaillist
#citationnum
#fieldlist
#fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gs_ai_name")    
  affhtml <- html_nodes(html, ".gs_ai_aff")
  emailhtml <- html_nodes(html, ".gs_ai_eml")
  citationhtml <- html_nodes(html, ".gs_ai_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  #print(namelist)
  #print(afflist)
  #print(emaillist)
  #print(citationnum)
  #print(fieldlist)
  #print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

df[1:5,c(1:3,6)]
tail(df[,c(1:3,6)])

# subscript to scrape data and advance through pages
#source(file="./code/2subscriptscrape.R", echo = TRUE, local = TRUE)

#save data

date="20210310"
write.table(df, file = paste0("./data/working/citations", "_", 
                              fields[a], 
                              date,
                              ".csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

write.table(df, file = paste0("./data/working/citations_all",
                              date,
                              ".csv", sep=""), 
            append = TRUE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)



############################################
############################################

#Polsci, politics, and government

###########################################

# polsci

a=9

rD <- rsDriver(browser=c("firefox"), port=4470L)
#rD <- rsDriver(browser=c("chrome"))

mybrowser <- rD$client

print(fields[a])
#print(urls[a])

# navigate to page
mybrowser$navigate(urls[a])

#first pass stopped at citations=43
#second pass:
#mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:political_science&after_author=sKqKAMz___8J&astart=1620")

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
namelist
afflist
emaillist
citationnum
fieldlist
fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gs_ai_name")    
  affhtml <- html_nodes(html, ".gs_ai_aff")
  emailhtml <- html_nodes(html, ".gs_ai_eml")
  citationhtml <- html_nodes(html, ".gs_ai_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  #print(namelist)
  #print(afflist)
  #print(emaillist)
  #print(citationnum)
  #print(fieldlist)
  #print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

df[1:5,c(1:3,6)]
tail(df[,c(1:3,6)])

#save data

date="20210310"
write.table(df, file = paste0("./data/working/citations", "_", 
                              fields[a], 
                              date,
                              ".csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

write.table(df, file = paste0("./data/working/citations_all",
                              date,
                              ".csv", sep=""), 
            append = TRUE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# politics

a=10

rD <- rsDriver(browser=c("firefox"), port=4480L)
#rD <- rsDriver(browser=c("chrome"))

mybrowser <- rD$client

print(fields[a])
#print(urls[a])

# navigate to page
mybrowser$navigate(urls[a])

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
namelist
afflist
emaillist
citationnum
fieldlist
fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gs_ai_name")    
  affhtml <- html_nodes(html, ".gs_ai_aff")
  emailhtml <- html_nodes(html, ".gs_ai_eml")
  citationhtml <- html_nodes(html, ".gs_ai_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  #print(namelist)
  #print(afflist)
  #print(emaillist)
  #print(citationnum)
  #print(fieldlist)
  #print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

df[1:5,c(1:3,6)]
tail(df[,c(1:3,6)])

#save data

date="20210310"
write.table(df, file = paste0("./data/working/citations", "_", 
                              fields[a], 
                              date,
                              ".csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

write.table(df, file = paste0("./data/working/citations_all",
                              date,
                              ".csv", sep=""), 
            append = TRUE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)


# government

a=11

rD <- rsDriver(browser=c("firefox"), port=4490L)
#rD <- rsDriver(browser=c("chrome"))

mybrowser <- rD$client

print(fields[a])
#print(urls[a])

# navigate to page
mybrowser$navigate(urls[a])

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
namelist
afflist
emaillist
citationnum
fieldlist
fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gs_ai_name")    
  affhtml <- html_nodes(html, ".gs_ai_aff")
  emailhtml <- html_nodes(html, ".gs_ai_eml")
  citationhtml <- html_nodes(html, ".gs_ai_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  #print(namelist)
  #print(afflist)
  #print(emaillist)
  #print(citationnum)
  #print(fieldlist)
  #print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

df[1:5,c(1:3,6)]
tail(df[,c(1:3,6)])

#save data

date="20210310"
write.table(df, file = paste0("./data/working/citations", "_", 
                              fields[a], 
                              date,
                              ".csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

write.table(df, file = paste0("./data/working/citations_all",
                              date,
                              ".csv", sep=""), 
            append = TRUE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)



########################################################################
# OTHER DISCIPLINES
########################################################################
#
# sociology
#

a=12

rD <- rsDriver(browser=c("firefox"))
#rD <- rsDriver(browser=c("chrome"))

mybrowser <- rD$client

print(fields[a])
#print(urls[a])

# navigate to page
mybrowser$navigate(urls[a])

# first run stopped after 1380 items
#second run
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:sociology&after_author=6h8NAIL-__8J&astart=1300")

# third run:
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:sociology&after_author=1cOOAJn___8J&astart=2150")

# fourth run:
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:sociology&after_author=5KU4AOb___8J&astart=3010")

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
namelist
afflist
emaillist
citationnum
fieldlist
fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gs_ai_name")    
  affhtml <- html_nodes(html, ".gs_ai_aff")
  emailhtml <- html_nodes(html, ".gs_ai_eml")
  citationhtml <- html_nodes(html, ".gs_ai_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  #print(namelist)
  #print(afflist)
  #print(emaillist)
  #print(citationnum)
  #print(fieldlist)
  #print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

df[1:5,c(1:3,6)]

#save data

write.table(df, file = paste0("./data/working/citations", "_", fields[a], ".csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# second file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "2.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# third file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "3.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# fourth file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "4.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)


##########################################
#
# anthropology
#

a=13

rD <- rsDriver(browser=c("firefox"))
#rD <- rsDriver(browser=c("chrome"))

mybrowser <- rD$client

print(fields[a])
#print(urls[a])

# navigate to page
mybrowser$navigate(urls[a])

# first run stopped after 1380 items
#second run
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:anthropology&after_author=HY4UAJr___8J&astart=1450")

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
namelist
afflist
emaillist
citationnum
fieldlist
fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gs_ai_name")    
  affhtml <- html_nodes(html, ".gs_ai_aff")
  emailhtml <- html_nodes(html, ".gs_ai_eml")
  citationhtml <- html_nodes(html, ".gs_ai_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  #print(namelist)
  #print(afflist)
  #print(emaillist)
  #print(citationnum)
  #print(fieldlist)
  #print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

df[1:5,c(1:3,6)]

#save data

write.table(df, file = paste0("./data/working/citations", "_", fields[a], ".csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# second file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "2.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)


#############################################
#
# history
#

a=14

rD <- rsDriver(browser=c("firefox"))
#rD <- rsDriver(browser=c("chrome"))

mybrowser <- rD$client

print(fields[a])
#print(urls[a])

# navigate to page
mybrowser$navigate(urls[a])

# first run stopped after 1380 items
#second run
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:history&after_author=3IYJAK3___8J&astart=1520https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:history&after_author=3IYJAK3___8J&astart=1520")

# third run
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:history&after_author=Ps4TAPP___8J&astart=2750")

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
namelist
afflist
emaillist
citationnum
fieldlist
fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gs_ai_name")    
  affhtml <- html_nodes(html, ".gs_ai_aff")
  emailhtml <- html_nodes(html, ".gs_ai_eml")
  citationhtml <- html_nodes(html, ".gs_ai_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  #print(namelist)
  #print(afflist)
  #print(emaillist)
  #print(citationnum)
  #print(fieldlist)
  #print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

df[1:5,c(1:3,6)]

#save data

write.table(df, file = paste0("./data/working/citations", "_", fields[a], ".csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# second file:
  
write.table(df, file = paste0("./data/working/citations", "_", fields[a], "2.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# third file:

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "3.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

#############################################
#
# economics
#

a=15

rD <- rsDriver(browser=c("firefox"))
#rD <- rsDriver(browser=c("chrome"))

mybrowser <- rD$client

print(fields[a])
#print(urls[a])

# navigate to page
mybrowser$navigate(urls[a])

# first run stopped after 1380 items
#second run
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:economics&after_author=hh6TALz5__8J&astart=1440")

# third run
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:economics&after_author=kGhnAIz-__8J&astart=2890")

# fourth run
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:economics&after_author=hLWIAKH___8J&astart=4580")

# fifth run
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:economics&after_author=cDVVAOL___8J&astart=6060")

# sixth run
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:economics&after_author=ezazAPf___8J&astart=7630")

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
namelist
afflist
emaillist
citationnum
fieldlist
fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gs_ai_name")    
  affhtml <- html_nodes(html, ".gs_ai_aff")
  emailhtml <- html_nodes(html, ".gs_ai_eml")
  citationhtml <- html_nodes(html, ".gs_ai_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  #print(namelist)
  #print(afflist)
  #print(emaillist)
  #print(citationnum)
  #print(fieldlist)
  #print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

df[1:5,c(1:3,6)]

#save data

write.table(df, file = paste0("./data/working/citations", "_", fields[a], ".csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# second file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "2.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# third file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "3.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# fourth file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "4.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# fifth file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "5.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# sixth file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "6.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)


#############################################
#
# philosophy
#

a=16

rD <- rsDriver(browser=c("firefox"))
#rD <- rsDriver(browser=c("chrome"), chromever="79.0.3945.36")
#rD <- rsDriver(browser=c("internet explorer"))
#rD <- rsDriver(browser=c("phantomjs"))

mybrowser <- rD$client

print(fields[a])
#print(urls[a])

# navigate to page
mybrowser$navigate(urls[a])

# first run stopped after 1380 items
#second run
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:philosophy&after_author=ZQuEALT___8J&astart=1490")

#third run
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:philosophy&after_author=TtSEAPr___8J&astart=2850")

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
namelist
afflist
emaillist
citationnum
fieldlist
fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gs_ai_name")    
  affhtml <- html_nodes(html, ".gs_ai_aff")
  emailhtml <- html_nodes(html, ".gs_ai_eml")
  citationhtml <- html_nodes(html, ".gs_ai_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  #print(namelist)
  #print(afflist)
  #print(emaillist)
  #print(citationnum)
  #print(fieldlist)
  #print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

df[1:5,c(1:3,6)]

#save data

write.table(df, file = paste0("./data/working/citations", "_", fields[a], ".csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# second file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "2.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# third file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "3.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)


#############################################
#
# math
#

a=17

rD <- rsDriver(browser=c("firefox"), version="latest")
#rD <- rsDriver(browser=c("chrome"), chromever="79.0.3945.36")
#rD <- rsDriver(browser=c("internet explorer"))
#rD <- rsDriver(browser=c("phantomjs"))

mybrowser <- rD$client

#print(fields[a])
#print(urls[a])

# navigate to page
mybrowser$navigate(urls[a])

# first run stopped after 1650 items
#second run
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:mathematics&after_author=NKIBADX-__8J&astart=1650")

#third run
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:mathematics&after_author=VkbCAMb___8J&astart=3340")

#fourth run
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:mathematics&after_author=ai3bAO____8J&astart=4310")

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
namelist
afflist
emaillist
citationnum
fieldlist
fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gs_ai_name")    
  affhtml <- html_nodes(html, ".gs_ai_aff")
  emailhtml <- html_nodes(html, ".gs_ai_eml")
  citationhtml <- html_nodes(html, ".gs_ai_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  #print(namelist)
  #print(afflist)
  #print(emaillist)
  #print(citationnum)
  #print(fieldlist)
  #print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

df[1:5,c(1:3,6)]

#save data

write.table(df, file = paste0("./data/working/citations", "_", fields[a], ".csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# second file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "2.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# third file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "3.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# fourth file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "4.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)


#############################################
#
# psychology
#

a=18

rD <- rsDriver(browser=c("firefox"), version="latest")
#rD <- rsDriver(browser=c("chrome"), chromever="79.0.3945.36")
#rD <- rsDriver(browser=c("internet explorer"))
#rD <- rsDriver(browser=c("phantomjs"))

mybrowser <- rD$client

#print(fields[a])
#print(urls[a])

# navigate to page
mybrowser$navigate(urls[a])

# first run stopped after 1450 items
#second run
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:psychology&after_author=rYw1AKT6__8J&astart=1450")

#third run
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:psychology&after_author=1cstANz-__8J&astart=2950")

#fourth run
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:psychology&after_author=-0OXAHr___8J&astart=3810")

# fifth run
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:psychology&after_author=KFPJALn___8J&astart=4520")

# sixth run
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:psychology&after_author=vGV_AN3___8J&astart=5290")

# 7th run
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:psychology&after_author=kmuUAPn___8J&astart=7000")

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
namelist
afflist
emaillist
citationnum
fieldlist
fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gs_ai_name")    
  affhtml <- html_nodes(html, ".gs_ai_aff")
  emailhtml <- html_nodes(html, ".gs_ai_eml")
  citationhtml <- html_nodes(html, ".gs_ai_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  #print(namelist)
  #print(afflist)
  #print(emaillist)
  #print(citationnum)
  #print(fieldlist)
  #print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

df[1:5,c(1:3,6)]

#save data

write.table(df, file = paste0("./data/working/citations", "_", fields[a], ".csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# second file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "2.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# third file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "3.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# fourth file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "4.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# fifth file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "5.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# sixth file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "6.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

#7th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "7.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)


#############################################
#
# law
#

a=19

rD <- rsDriver(browser=c("firefox"), version="latest")
#rD <- rsDriver(browser=c("chrome"), chromever="79.0.3945.36")
#rD <- rsDriver(browser=c("internet explorer"))
#rD <- rsDriver(browser=c("phantomjs"))

mybrowser <- rD$client

#print(fields[a])
#print(urls[a])

# navigate to page
mybrowser$navigate(urls[a])

#second run
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:law&after_author=a_uUAKH___8J&astart=1120")

#third run
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:law&after_author=OLiTAPv___8J&astart=2740")

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
#namelist
#afflist
#emaillist
#citationnum
#fieldlist
#fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gs_ai_name")    
  affhtml <- html_nodes(html, ".gs_ai_aff")
  emailhtml <- html_nodes(html, ".gs_ai_eml")
  citationhtml <- html_nodes(html, ".gs_ai_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  #print(namelist)
  #print(afflist)
  #print(emaillist)
  #print(citationnum)
  #print(fieldlist)
  #print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

# subscript to scrape data and advance through pages
#source(file="./code/2subscriptscrape.R", echo = TRUE, local = TRUE)

#save data

write.table(df, file = paste0("./data/working/citations", "_", fields[a], ".csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# second file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "2.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# third file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "3.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

#############################################
#
# physics
#

a=20

rD <- rsDriver(browser=c("firefox"), version="latest")
#rD <- rsDriver(browser=c("chrome"), chromever="79.0.3945.36")
#rD <- rsDriver(browser=c("chrome"))
#rD <- rsDriver(browser=c("internet explorer"))
#rD <- rsDriver(browser=c("phantomjs"))

mybrowser <- rD$client

#print(fields[a])
#print(urls[a])

# navigate to page
mybrowser$navigate(urls[a])

#second run
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:physics&after_author=J9hLACvx__8J&astart=1590")

#third run
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:physics&after_author=rsYGAML1__8J&astart=2040")

#4th
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:physics&after_author=MJEfAAv7__8J&astart=3140")

#5th
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:physics&after_author=W_cIAFT9__8J&astart=4150")

#6th
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:physics&after_author=M6KLAAX-__8J&astart=4640")

#7th
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:physics&after_author=LamfAHf-__8J&astart=5010")

#8th
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:physics&after_author=dgdlAND-__8J&astart=5440")

#9th
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:physics&after_author=zaM1ABH___8J&astart=5830")

#10th
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:physics&after_author=1Q66AHP___8J&astart=6640")

#11th
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:physics&after_author=mXwLANT___8J&astart=8220")

#12th
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:physics&after_author=FotoAPH___8J&astart=9300")

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
#namelist
#afflist
#emaillist
#citationnum
#fieldlist
#fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gs_ai_name")    
  affhtml <- html_nodes(html, ".gs_ai_aff")
  emailhtml <- html_nodes(html, ".gs_ai_eml")
  citationhtml <- html_nodes(html, ".gs_ai_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  #print(namelist)
  #print(afflist)
  #print(emaillist)
  #print(citationnum)
  #print(fieldlist)
  #print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

# subscript to scrape data and advance through pages
#source(file="./code/2subscriptscrape.R", echo = TRUE, local = TRUE)

#save data

write.table(df, file = paste0("./data/working/citations", "_", fields[a], ".csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# second file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "2.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# third file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "3.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 4th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "4.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 5th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "5.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 6th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "6.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 7th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "7.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 8th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "8.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 9th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "9.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

#10th

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "10.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

#11th

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "11.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

#12th

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "12.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)



#############################################
#
# chemistry
#

a=21

rD <- rsDriver(browser=c("firefox"), version="latest")
#rD <- rsDriver(browser=c("chrome"), chromever="79.0.3945.36")
#rD <- rsDriver(browser=c("chrome"))
#rD <- rsDriver(browser=c("internet explorer"))
#rD <- rsDriver(browser=c("phantomjs"))

mybrowser <- rD$client

#print(fields[a])
#print(urls[a])

# navigate to page
mybrowser$navigate(urls[a])

#second run
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:chemistry&after_author=MBUfAOf2__8J&astart=1570")

#third run
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:chemistry&after_author=leyrAAf8__8J&astart=2750")

#4th
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:chemistry&after_author=WEQRAFj-__8J&astart=4390")

#5th
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:chemistry&after_author=I5hNADL___8J&astart=5820")

#6th
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:chemistry&after_author=a25rAJT___8J&astart=7150")

#7th
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:chemistry&after_author=295WANP___8J&astart=8670")

#8th
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:chemistry&after_author=tb6CAPL___8J&astart=10140")

#9th
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:chemistry&after_author=amzcAPr___8J&astart=11000")


# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
#namelist
#afflist
#emaillist
#citationnum
#fieldlist
#fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gs_ai_name")    
  affhtml <- html_nodes(html, ".gs_ai_aff")
  emailhtml <- html_nodes(html, ".gs_ai_eml")
  citationhtml <- html_nodes(html, ".gs_ai_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  #print(namelist)
  #print(afflist)
  #print(emaillist)
  #print(citationnum)
  #print(fieldlist)
  #print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

# subscript to scrape data and advance through pages
#source(file="./code/2subscriptscrape.R", echo = TRUE, local = TRUE)

#save data

write.table(df, file = paste0("./data/working/citations", "_", fields[a], ".csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# second file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "2.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# third file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "3.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 4th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "4.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 5th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "5.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 6th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "6.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 7th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "7.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 8th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "8.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 9th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "9.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)


#############################################
#
# biology
#

a=22

rD <- rsDriver(browser=c("firefox"), version="latest")
#rD <- rsDriver(browser=c("chrome"), chromever="79.0.3945.36")
#rD <- rsDriver(browser=c("chrome"))
#rD <- rsDriver(browser=c("internet explorer"))
#rD <- rsDriver(browser=c("phantomjs"))

mybrowser <- rD$client

#print(fields[a])
#print(urls[a])

# navigate to page
mybrowser$navigate(urls[a])

#second run
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:biology&after_author=RY9hAC_6__8J&astart=1210")

#third run
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:biology&before_author=oVbD_wwBAAAJ&astart=2830")

#4th
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:biology&after_author=HDWMALf___8J&astart=4240")

#5th
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:biology&after_author=wEWmAPH___8J&astart=5680")


# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
#namelist
#afflist
#emaillist
#citationnum
#fieldlist
#fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gs_ai_name")    
  affhtml <- html_nodes(html, ".gs_ai_aff")
  emailhtml <- html_nodes(html, ".gs_ai_eml")
  citationhtml <- html_nodes(html, ".gs_ai_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  #print(namelist)
  #print(afflist)
  #print(emaillist)
  #print(citationnum)
  #print(fieldlist)
  #print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

# subscript to scrape data and advance through pages
#source(file="./code/2subscriptscrape.R", echo = TRUE, local = TRUE)

#save data

write.table(df, file = paste0("./data/working/citations", "_", fields[a], ".csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# second file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "2.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# third file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "3.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 4th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "4.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 5th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "5.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)


#############################################
#
# pubhealth
#

a=23

rD <- rsDriver(browser=c("firefox"), version="latest")
#rD <- rsDriver(browser=c("chrome"), chromever="79.0.3945.36")
#rD <- rsDriver(browser=c("chrome"))
#rD <- rsDriver(browser=c("internet explorer"))
#rD <- rsDriver(browser=c("phantomjs"))

mybrowser <- rD$client

#print(fields[a])
#print(urls[a])

# navigate to page
mybrowser$navigate(urls[a])

#second run
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:public_health&after_author=9uR7AKf3__8J&astart=1180")

#third run
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:public_health&after_author=FxQDALz6__8J&astart=1590")

#4th
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:public_health&after_author=kT5VAJP9__8J&astart=2520")

#5th
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:public_health&after_author=R6TaAJr-__8J&astart=3290")

#6th
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:public_health&after_author=LkWOAAL___8J&astart=3820")

#7th
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:public_health&after_author=uPYTAF____8J&astart=4530")

#8th
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:public_health&after_author=Fo2eAJr___8J&astart=5260")

#9th 
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:public_health&after_author=zwCLALn___8J&astart=5850")

#10th
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:public_health&after_author=XYqcANX___8J&astart=6600")

#11th
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:public_health&after_author=Way6AOT___8J&astart=7240")

#12th
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:public_health&after_author=uEHMAOr___8J&astart=7540")

#13th
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:public_health&after_author=Cn4UAPb___8J&astart=8410")

#14th
mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:public_health&after_author=1KHrAPz___8J&astart=9710")

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
#namelist
#afflist
#emaillist
#citationnum
#fieldlist
#fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gs_ai_name")    
  affhtml <- html_nodes(html, ".gs_ai_aff")
  emailhtml <- html_nodes(html, ".gs_ai_eml")
  citationhtml <- html_nodes(html, ".gs_ai_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  #print(namelist)
  #print(afflist)
  #print(emaillist)
  #print(citationnum)
  #print(fieldlist)
  #print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

# subscript to scrape data and advance through pages
#source(file="./code/2subscriptscrape.R", echo = TRUE, local = TRUE)

#save data

write.table(df, file = paste0("./data/working/citations", "_", fields[a], ".csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# second file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "2.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# third file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "3.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 4th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "4.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 5th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "5.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 6th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "6.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 7th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "7.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 8th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "8.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 9th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "9.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 10th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "10.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 11th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "11.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 12th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "12.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

#13th

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "13.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

#14th

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "14.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)


#############################################
#
# medicine
# authors with zero citations are incomplete

a=24

rD <- rsDriver(browser=c("firefox"), version="latest")
#rD <- rsDriver(browser=c("chrome"), chromever="79.0.3945.36")
#rD <- rsDriver(browser=c("chrome"))
#rD <- rsDriver(browser=c("internet explorer"))
#rD <- rsDriver(browser=c("phantomjs"))

mybrowser <- rD$client

#print(fields[a])
#print(urls[a])

# navigate to page
mybrowser$navigate(urls[a])

#other runs
mybrowser$navigate(url)

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
#namelist
#afflist
#emaillist
#citationnum
#fieldlist
#fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gs_ai_name")    
  affhtml <- html_nodes(html, ".gs_ai_aff")
  emailhtml <- html_nodes(html, ".gs_ai_eml")
  citationhtml <- html_nodes(html, ".gs_ai_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  #print(namelist)
  #print(afflist)
  #print(emaillist)
  #print(citationnum)
  #print(fieldlist)
  #print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

# subscript to scrape data and advance through pages
#source(file="./code/2subscriptscrape.R", echo = TRUE, local = TRUE)

#save data

write.table(df, file = paste0("./data/working/citations", "_", fields[a], ".csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# second file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "2.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# third file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "3.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 4th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "4.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 5th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "5.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)



#############################################
#
# engineering
#

a=25

rD <- rsDriver(browser=c("firefox"), version="latest")
#rD <- rsDriver(browser=c("chrome"), chromever="79.0.3945.36")
#rD <- rsDriver(browser=c("chrome"))
#rD <- rsDriver(browser=c("internet explorer"))
#rD <- rsDriver(browser=c("phantomjs"))

mybrowser <- rD$client

#print(fields[a])
#print(urls[a])

# navigate to page
mybrowser$navigate(urls[a])

#other runs
mybrowser$navigate(url)

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
#namelist
#afflist
#emaillist
#citationnum
#fieldlist
#fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gs_ai_name")    
  affhtml <- html_nodes(html, ".gs_ai_aff")
  emailhtml <- html_nodes(html, ".gs_ai_eml")
  citationhtml <- html_nodes(html, ".gs_ai_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  #print(namelist)
  #print(afflist)
  #print(emaillist)
  #print(citationnum)
  #print(fieldlist)
  #print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

# subscript to scrape data and advance through pages
#source(file="./code/2subscriptscrape.R", echo = TRUE, local = TRUE)

#save data

write.table(df, file = paste0("./data/working/citations", "_", fields[a], ".csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# second file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "2.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# third file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "3.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)


#############################################
#
# computer science
#

a=26

rD <- rsDriver(browser=c("firefox"), version="latest")
#rD <- rsDriver(browser=c("chrome"), chromever="79.0.3945.36")
#rD <- rsDriver(browser=c("chrome"))
#rD <- rsDriver(browser=c("internet explorer"))
#rD <- rsDriver(browser=c("phantomjs"))

mybrowser <- rD$client

#print(fields[a])
#print(urls[a])

# navigate to page
mybrowser$navigate(urls[a])

#other runs
mybrowser$navigate(url)

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
#namelist
#afflist
#emaillist
#citationnum
#fieldlist
#fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gs_ai_name")    
  affhtml <- html_nodes(html, ".gs_ai_aff")
  emailhtml <- html_nodes(html, ".gs_ai_eml")
  citationhtml <- html_nodes(html, ".gs_ai_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  #print(namelist)
  #print(afflist)
  #print(emaillist)
  #print(citationnum)
  #print(fieldlist)
  #print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

# subscript to scrape data and advance through pages
#source(file="./code/2subscriptscrape.R", echo = TRUE, local = TRUE)

#save data

write.table(df, file = paste0("./data/working/citations", "_", fields[a], ".csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# second file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "2.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# third file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "3.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 4th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "4.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 5th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "5.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 6th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "6.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 7th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "7.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 8th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "8.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)


#############################################
#
# religion
# authors with zero citations are incomplete
#

a=27

rD <- rsDriver(browser=c("firefox"), version="latest")
#rD <- rsDriver(browser=c("chrome"), chromever="79.0.3945.36")
#rD <- rsDriver(browser=c("chrome"))
#rD <- rsDriver(browser=c("internet explorer"))
#rD <- rsDriver(browser=c("phantomjs"))

mybrowser <- rD$client

#print(fields[a])
#print(urls[a])

# navigate to page
mybrowser$navigate(urls[a])

#other runs
mybrowser$navigate(url)

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
#namelist
#afflist
#emaillist
#citationnum
#fieldlist
#fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gs_ai_name")    
  affhtml <- html_nodes(html, ".gs_ai_aff")
  emailhtml <- html_nodes(html, ".gs_ai_eml")
  citationhtml <- html_nodes(html, ".gs_ai_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  #print(namelist)
  #print(afflist)
  #print(emaillist)
  #print(citationnum)
  #print(fieldlist)
  #print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

# subscript to scrape data and advance through pages
#source(file="./code/2subscriptscrape.R", echo = TRUE, local = TRUE)

#save data

write.table(df, file = paste0("./data/working/citations", "_", fields[a], ".csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# second file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "2.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)


#############################################
#
# literature
#

a=28

rD <- rsDriver(browser=c("firefox"), version="latest")
#rD <- rsDriver(browser=c("chrome"), chromever="79.0.3945.36")
#rD <- rsDriver(browser=c("chrome"))
#rD <- rsDriver(browser=c("internet explorer"))
#rD <- rsDriver(browser=c("phantomjs"))

mybrowser <- rD$client

#print(fields[a])
#print(urls[a])

# navigate to page
mybrowser$navigate(urls[a])

#other runs
mybrowser$navigate(url)

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
#namelist
#afflist
#emaillist
#citationnum
#fieldlist
#fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gs_ai_name")    
  affhtml <- html_nodes(html, ".gs_ai_aff")
  emailhtml <- html_nodes(html, ".gs_ai_eml")
  citationhtml <- html_nodes(html, ".gs_ai_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  #print(namelist)
  #print(afflist)
  #print(emaillist)
  #print(citationnum)
  #print(fieldlist)
  #print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

# subscript to scrape data and advance through pages
#source(file="./code/2subscriptscrape.R", echo = TRUE, local = TRUE)

#save data

write.table(df, file = paste0("./data/working/citations", "_", fields[a], ".csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# second file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "2.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)



#############################################
#
# linguistics
#

a=29

rD <- rsDriver(browser=c("firefox"), version="latest")
#rD <- rsDriver(browser=c("chrome"), chromever="79.0.3945.36")
#rD <- rsDriver(browser=c("chrome"))
#rD <- rsDriver(browser=c("internet explorer"))
#rD <- rsDriver(browser=c("phantomjs"))

mybrowser <- rD$client

#print(fields[a])
#print(urls[a])

# navigate to page
mybrowser$navigate(urls[a])

#other runs
mybrowser$navigate(url)

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gs_ai_name")    # collect name data
affhtml <- html_nodes(html, ".gs_ai_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gs_ai_eml")    # collect email data
citationhtml <- html_nodes(html, ".gs_ai_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gs_ai_int")      # collect field data by each entry (person can report up to 5)
#fieldbyentryhtml <- html_nodes(html, ".gs_ai_one_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_1usr")        # collect all field data on page


# notes:
#fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
#fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
#the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
#i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry


# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# note: wrote field data to field to check structure if written to csv
#write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
#            row.names = FALSE,
#            col.names = TRUE)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)
fieldpagelist <- tolower(fieldpage)
# print
#namelist
#afflist
#emaillist
#citationnum
#fieldlist
#fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  #button <- mybrowser$findElements(using = 'css selector', ".gsc_btnPR .gs_in_ib .gs_btn_half .gs_btn_lsb .gs_btn_slt .gsc_pgn_ppr")
  button <- mybrowser$findElements("button", using = 'css selector')
  # click on button using clickElement for button object: 
  button[[3]]$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gs_ai_name")    
  affhtml <- html_nodes(html, ".gs_ai_aff")
  emailhtml <- html_nodes(html, ".gs_ai_eml")
  citationhtml <- html_nodes(html, ".gs_ai_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gs_ai_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gs_1usr")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  #print(namelist)
  #print(afflist)
  #print(emaillist)
  #print(citationnum)
  #print(fieldlist)
  #print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}

mybrowser$close()

#print(namelist[1:5])
#print(citationnum[1:5])

# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))

data3 <- as.data.table(afflist)
data3 <- as.data.table(cbind(data3, as.numeric(row.names(data3))))

data4 <- as.data.table(fieldlist)
data4 <- as.data.table(cbind(data4, as.numeric(row.names(data4))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"
names(data3)[names(data3)=="V2"] <- "id"
names(data4)[names(data4)=="V2"] <- "id"

#data1
#data2

df <- merge(data1, data2, by="id", all=TRUE)
df <- merge(df, data3, by="id", all=TRUE)
df <- merge(df, data4, by="id", all=TRUE)
df[is.na(df)] <- 0
#data

df$field <- fields[a]

# subscript to scrape data and advance through pages
#source(file="./code/2subscriptscrape.R", echo = TRUE, local = TRUE)

#save data

write.table(df, file = paste0("./data/working/citations", "_", fields[a], ".csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# second file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "2.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 3rd file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "3.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

# 4th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "4.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)



# 5th file

write.table(df, file = paste0("./data/working/citations", "_", fields[a], "5.csv", sep=""), 
            append = FALSE, 
            quote = FALSE, 
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)






#############################################
#save.image("./data/working/citations20191213.Rdata")




# fieldpagelist appears in different format
#fieldpagelist
#fieldpagelist2 <- as.factor(fieldpagelist)
#fieldpagelist2
#fieldpagelist3 <- as.numeric(fieldpagelist2)
#fieldpagelist3

#citationnum <- na.omit(citationnum)
#namelist <- na.omit(namelist)


'''
summary(citationnum)
summary(namelist)

length(citationnum)
length(citationnum[citationnum<106]) # my citation count was 106 on June 1, 2016


hist(citationnum, breaks=200, density=FALSE)
# looking at median and below
hist(citationnum[citationnum<median(citationnum)], breaks=median(citationnum), density=FALSE)
hist(citationnum[citationnum<1000], breaks=200, density=FALSE)
hist(citationnum[citationnum<2000], breaks=200, density=FALSE)
'''

'''
pctile <- length(citationnum[citationnum<106])/length(citationnum)
pctile
print(paste("Your citation count is greater than ", as.character(length(citationnum[citationnum<106])), " of ", as.character(length(citationnum)), ", or ", as.character(pctile*100), "%, of people in 'public law' with at least 1 citation.", sep=""))

# adding zeroes
# on May 27, 2016, there were a total of 103 people on Google Scholar who listed 'public law' as one of 5 areas
# since there were 76 with at least 1 citation, this means there were 27 with 0 citations

citationnum <- append(citationnum, rep(0, 27))

pctile <- length(citationnum[citationnum<106])/length(citationnum)
pctile
print(paste("Your citation count is greater than ", as.character(length(citationnum[citationnum<101])), " of ", as.character(length(citationnum)), ", or ", as.character(pctile*100), "%, of people on Google Scholar who listed 'public law' as one of 5 areas of interest.", sep=""))
'''

########################
# JUDICIAL POLITICS
########################

mybrowser$navigate("https://scholar.google.com/citations?mauthors=label%3Ajudicial_politics&hl=en&view_op=search_authors")

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gsc_1usr_name")    # collect name data
affhtml <- html_nodes(html, ".gsc_1usr_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gsc_1usr_eml")    # collect email data
citationhtml <- html_nodes(html, ".gsc_1usr_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gsc_1usr_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_co_int")        # collect all field data on page
'''
# notes:
fieldbyentry grabs all field labels in a single string for each individual entry; each individual field would have to then be identified within this string
fieldnotbyentry grabs all field labels on the page, and does not associate them with any individual entry
the discrete fields associated with each person could be distilled by comparing fieldbyentry to fieldnotbyentry
i.e., could iterate through fieldnotbyentry, deleting each field as it is found within string fieldbyentry
'''

# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)

'''
# to generate text data for tm package, can either:
  (1) load text files from dir, or
  (2) load using other methods that id source type within data in memory (e.g., VectorSource)

# load files from directory:
setwd("C:/Users/mi122167/Dropbox/SUNY Albany/Methods Mats/Web Scraping/Google Citations Scrape/Fields-as-text")
dir()
write.table(fieldpage, file="fieldpage-jp.txt", sep=" ")
cname <- file.path("C:/Users/mi122167/Dropbox/SUNY Albany/Methods Mats/Web Scraping/Google Citations Scrape/Fields-as-text")   
dir(cname)

fields <- Corpus(cname)   
'''

'''
# load text data to tm package from data in memory
fields <- Corpus(VectorSource((fieldpage)))
fields <- tm_map(fields, removePunctuation)
fields <- tm_map(fields, removeNumbers)
fields <- tm_map(fields, tolower)  
'''

'''
# remove special characters, e.g., common characters in emails, tweets, etc.
for(j in seq(docs))   
{   
  docs[[j]] <- gsub("/", " ", docs[[j]])   
  docs[[j]] <- gsub("@", " ", docs[[j]])   
  docs[[j]] <- gsub("\\|", " ", docs[[j]])   
}   

# remove stopwords -- common words with no analytic value
docs <- tm_map(docs, removeWords, stopwords("english")) 
# to see list of stopwords:
# length(stopwords("english"))   
# stopwords("english") 
docs <- tm_map(docs, removeWords, c("department", "email")) # removes specific words in quotes
# remove word stems (e.g., 'ing')
library(SnowballC)   
docs <- tm_map(docs, stemDocument)   
'''

'''
# remove white space
fields <- tm_map(fields, stripWhitespace)   
# treat as plain text
fields <- tm_map(fields, PlainTextDocument) 

# document term matrix
dtm <- DocumentTermMatrix(fields)   
dtm  

freq <- colSums(as.matrix(dtm))   
length(freq)  

ord <- order(freq) # sorts terms by freq

# see structure of key objects
str(freq) 
str(ord)

# see 5 least frequent items
freq[head(ord)]
# or 10 least frequent items
freq[ord[1:10]]

# see 5 most frequent items
freq[tail(ord)]
# or 10 most
freq[ord[10:17]]

# see frequencies of all items (item by item, 1:17) as sorted in ordered object

freq[ord]
# same as
freq[ord[1:2731]]

# can also inspect documenttermmatrix (dtm)
inspect(dtm)
inspect(tdm)

# check frequencies of specific terms
freq[names(freq)=="marriage"]
freq[names(freq)=="adoption"]
freq[names(freq)=="aids"]
freq[names(freq)=="hiv"]

# multiple ways to look at word frequencies

# e.g., create data frame of words and frequencies
wf <- data.frame(word=names(freq), freq=freq)   
head(wf)
wf[1:20,] # first 20 rows of wf
wf

# e.g., look at most frequent terms only
# words that appear at least 10 times
findFreqTerms(dtm, lowfreq=10)   # Change "10" to whatever is most appropriate for your text data.

# plot frequencies
# plot words that appear at least 15 times
library(ggplot2)   
p <- ggplot(subset(wf, freq>15), aes(word, freq))    
p <- p + geom_bar(stat="identity")   
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))   
p 

#######################
# word clouds
#######################

library(wordcloud)   

# plot words that occur at least 10 times.

set.seed(142)   
wordcloud(names(freq), freq, min.freq=10) 

# plot 100 most frequent words
set.seed(142)   
wordcloud(names(freq), freq, max.words=100) 

############################
# hierarchical clustering
############################

library(cluster)

# first, remove sparse (infrequent) terms
dtms <- removeSparseTerms(dtm, 0.15) # This makes a matrix that is only 15% empty space, maximum.   
inspect(dtms) 

d <- dist(t(dtmss), method="euclidian")   
fit <- hclust(d=d, method="ward.D")   
fit   

plot(fit, hang=-1)  

# highlighting a specific number of clusters

plot.new()
plot(fit, hang=-1)
groups <- cutree(fit, k=5)   # "k=" defines the number of clusters you are using   
rect.hclust(fit, k=5, border="red") # draw dendogram with red borders around the 5 clusters   
'''


'''
# note: wrote field data to field to check structure if written to csv
write.table(field, file = "fieldbyentry.csv", append = FALSE, quote = FALSE, sep = "\t",
row.names = FALSE,
col.names = TRUE)
'''

# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)      # makes all entries lower case
fieldpagelist <- append(fieldpagelist, tolower(fieldpage))  # appends to previous fieldpagelist, makes all entries lower case

# print
namelist
afflist
emaillist
citationnum
fieldlist
fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  button <- mybrowser$findElement(using = 'css selector', ".gs_btn_srt")
  # click on button using clickElement for button object: 
  button$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gsc_1usr_name")    
  affhtml <- html_nodes(html, ".gsc_1usr_aff")
  emailhtml <- html_nodes(html, ".gsc_1usr_eml")
  citationhtml <- html_nodes(html, ".gsc_1usr_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gsc_1usr_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gsc_co_int")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  print(namelist)
  print(afflist)
  print(emaillist)
  print(citationnum)
  print(fieldlist)
  print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}


# CAUTION
# affiliations not always present (e.g., Seth Greenfest in public law), and does not register as blank or NA
# rather, skips to next entry, which messes with order of entries across html nodes
# in any one field, field will of course always be present, along with name; citations may not be present, 
# but this does not matter since entries are always in descending order according to citations, so entries
# with no citations will always appear last.
# However, entries with no affiliation need correction.

data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"

data1
data2

data.jp <- merge(data1, data2, by="id", all=TRUE)
data.jp[is.na(data.jp)] <- 0
data.jp

data.jp$field <- "judpol"

'''
setwd("C:/Users/mi122167/Dropbox/SUNY Albany/Methods Mats/Web Scraping/Google Citations Scrape/Judicial Politics")
dir()
write.table(data.jp, file = "judpolcites20160527.csv", append = FALSE, quote = FALSE, sep = ",",
            row.names = FALSE,
            col.names = TRUE)
'''

data.comb <- data.pl
for (i in 1:length(data.jp$id)){          # sets up loop to run as many times as there are items in data
  if (data.jp$namelist[i] %in% data.pl$namelist)  {
    #[delete line in data.jp] or do nothing
    print(data.jp$namelist[i])
  }
  else  {
    data.comb <- rbind(data.comb, data.jp[i,])
  }
    }

data.comb       # output looks good; now have combined group of 180 scholars who identify as public law or judicial politics

fieldpagelist
fieldpagelist2 <- as.factor(fieldpagelist)
fieldpagelist3 <- as.numeric(fieldpagelist2)

hist(fieldpagelist3, breaks=300, cex=0.5, col="blue", border="grey", col.lab="red", labels=fieldpagelist, cex.lab=0.5)

'''
fields.comb <- data.frame(cbind(fieldpagelist, fieldpagelist2, fieldpagelist3))

# sort by fieldpagelist
attach(fields.comb)

# sort by fieldpagelist
fields.comb <- fields.comb[order(fieldpagelist),] 

# sort by fieldpagelist3
fields.comb <- fields.comb[order(fieldpagelist3),] 

# descending sort by fieldpagelist3
fields.comb <- fields.comb[order(-fieldpagelist3),] 

detach(fields.comb)

fields.comb
'''

fields.sorted <- sort(table(fieldpagelist),decreasing=T)
fields.sorted

# BOTTOM LINE
# Among scholars who identify 'public law' or 'judicial politics' among their 5 areas of interest, there are 180 people.
# These 180 people express a total of 290 areas of interest.
# The two most common are by far 'public law' (n=110) and 'judicial politics' (n=91), for a sum of 201 out of 290, or 69% of total.
# The next nearest areas with at least 20 occurrences (less than 10% of total) are 'american politics' (25), 'constitutional law' (21), 
# and 'political science'(20).
# The next nearest areas with at least 10 occurrences (less than 5% of total) are 'administrative law' (11), 'comparative politics' (10), and 'law' (10).
# if you combine 'law and courts' and 'courts' you get 13.



############################
# ADD LAW AND COURTS
############################


# what is relevant frame? social sciences? law and social sciences?

mybrowser$navigate("https://scholar.google.com/citations?mauthors=label%3Alaw_and_courts&hl=en&view_op=search_authors")

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gsc_1usr_name")    # collect name data
affhtml <- html_nodes(html, ".gsc_1usr_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gsc_1usr_eml")    # collect email data
citationhtml <- html_nodes(html, ".gsc_1usr_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gsc_1usr_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_co_int")        # collect all field data on page

# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)

# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)      # makes all entries lower case
fieldpagelist <- append(fieldpagelist, tolower(fieldpage))  # appends to previous fieldpagelist, makes all entries lower case

# print
namelist
afflist
emaillist
citationnum
fieldlist
fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  button <- mybrowser$findElement(using = 'css selector', ".gs_btn_srt")
  # click on button using clickElement for button object: 
  button$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gsc_1usr_name")    
  affhtml <- html_nodes(html, ".gsc_1usr_aff")
  emailhtml <- html_nodes(html, ".gsc_1usr_eml")
  citationhtml <- html_nodes(html, ".gsc_1usr_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gsc_1usr_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gsc_co_int")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  print(namelist)
  print(afflist)
  print(emaillist)
  print(citationnum)
  print(fieldlist)
  print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}


data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"

data1
data2

data.lc <- merge(data1, data2, by="id", all=TRUE)
data.lc[is.na(data.lc)] <- 0
data.lc

data.lc$field <- "law&courts"


data.comb2 <- data.comb
data.comb2
for (i in 1:length(data.lc$id)){          # sets up loop to run as many times as there are items in data
  if (data.lc$namelist[i] %in% data.comb2$namelist)  {
    #[delete line in data.jp] or do nothing
    print(data.lc$namelist[i])
  }
  else  {
    data.comb2 <- rbind(data.comb2, data.lc[i,])
  }
}

data.comb2       # output looks good; now have combined group of 180 scholars who identify as public law or judicial politics

fieldpagelist
fieldpagelist2 <- as.factor(fieldpagelist)
fieldpagelist3 <- as.numeric(fieldpagelist2)

hist(fieldpagelist3, breaks=400, cex=0.5, col="blue", border="grey", col.lab="red", labels=fieldpagelist, cex.lab=0.5)


fields.sorted <- sort(table(fieldpagelist),decreasing=T)
fields.sorted

dim(data.comb2)
dim(fields.sorted)

# BOTTOM LINE THUS FAR
# Among scholars who identify 'public law', 'judicial politics', or 'law and courts' among their 5 areas of interest, there are 190 people.
# These 190 people express a total of 302 areas of interest.
# The two most common are by far 'public law' (n=112) and 'judicial politics' (n=97), for a sum of 209 out of 302, or 69% of total.
# The next nearest areas with at least 20 occurrences (less than 10% of total) are 'american politics' (31), 'law and courts' (25), 'political science' (23)
# and constitutional law' (21).
# The next nearest areas with at least 10 occurrences (less than 5% of total) are 'administrative law' (11), 'comparative politics' (10), and 'law' (10).
# NOTE1: These are not major shifts from just looking at 'public law' and 'judicial politics'.
# NOTE2: if you combine 'law and courts' and 'courts' you get 31.
# NOTE3: there are also a large number of entries that references judiciary, i.e., about 12-15 entries like 'judicial behavior', 'judicial reform', judicial impact', etc.



############################
# ADD LAW
############################

mybrowser$navigate("https://scholar.google.com/citations?view_op=search_authors&hl=en&mauthors=label:law&before_author=jVj1_9UtAAAJ&astart=0")

# swtiching to rvest and stringr packages
# get current url
url <- as.character(mybrowser$getCurrentUrl())
html <- read_html(url)
# identify nodes at url where data are located
namehtml <- html_nodes(html, ".gsc_1usr_name")    # collect name data
affhtml <- html_nodes(html, ".gsc_1usr_aff")      # collect affiliation data
emailhtml <- html_nodes(html, ".gsc_1usr_eml")    # collect email data
citationhtml <- html_nodes(html, ".gsc_1usr_cby") # collect citation data
fieldbyentryhtml <- html_nodes(html, ".gsc_1usr_int")      # collect field data by each entry (person can report up to 5)
fieldnotbyentryhtml <- html_nodes(html, ".gsc_co_int")        # collect all field data on page

# grab data
name <- html_text(namehtml)
aff <- html_text(affhtml)
email <- html_text(emailhtml)
citation <- html_text(citationhtml)
fieldentry <- html_text(fieldbyentryhtml)
fieldpage <- html_text(fieldnotbyentryhtml)


# strip/clean data to get data of interest
# note: from here forward, I have only worked with fieldentry text for fields
lastword <- word(citation, -1)
email2 <- word(email, -1) # note: many email incomplete; contain only home site, not recipient's address at site
# still, can use to verify id or to match individual entries to each other

# reformat
namelist <- name
afflist <- aff
emaillist <- email2
citationnum <- as.numeric(lastword)
fieldlist <- tolower(fieldentry)      # makes all entries lower case
fieldpagelist <- append(fieldpagelist, tolower(fieldpage))  # appends to previous fieldpagelist, makes all entries lower case

# print
namelist
afflist
emaillist
citationnum
fieldlist
fieldpagelist

#for (i in 1:8){
i <- 10
while (i > 9){                    # this keep below loop going until last page with less than 10 entries
  # now swtich to rSelenium to click button to advance to next 10 entries
  # first, create button object
  button <- mybrowser$findElement(using = 'css selector', ".gs_btn_srt")
  # click on button using clickElement for button object: 
  button$clickElement()
  # get new url
  url <- as.character(mybrowser$getCurrentUrl())
  html <- read_html(url)
  namehtml <- html_nodes(html, ".gsc_1usr_name")    
  affhtml <- html_nodes(html, ".gsc_1usr_aff")
  emailhtml <- html_nodes(html, ".gsc_1usr_eml")
  citationhtml <- html_nodes(html, ".gsc_1usr_cby") 
  fieldbyentryhtml <- html_nodes(html, ".gsc_1usr_int") 
  fieldnotbyentryhtml <- html_nodes(html, ".gsc_co_int")        
  name <- html_text(namehtml)
  aff <- html_text(affhtml)
  email <- html_text(emailhtml)
  citation <- html_text(citationhtml)
  fieldentry <- html_text(fieldbyentryhtml)
  fieldpage <- html_text(fieldnotbyentryhtml)
  lastword <- word(citation, -1)
  email2 <- word(email, -1)
  namelist <- append(namelist, name)
  afflist <- append(afflist, aff)
  emaillist <- append(emaillist, email2)
  citationnum <- append(citationnum, as.numeric(lastword))
  fieldlist <- append(fieldlist, tolower(fieldentry))
  fieldpagelist <- append(fieldpagelist, tolower(fieldpage))
  print(namelist)
  print(afflist)
  print(emaillist)
  print(citationnum)
  print(fieldlist)
  print(fieldpagelist)
  i <- length(name)               # here, if pages has less than 10 entries, then it is last page, and loop will not repeat (i.e., i <= 9)
}


data1 <- as.data.table(namelist)
data1 <- as.data.table(cbind(data1, as.numeric(row.names(data1))))

data2 <- as.data.table(citationnum)
data2 <- as.data.table(cbind(data2, as.numeric(row.names(data2))))


names(data1)[names(data1)=="V2"] <- "id"
names(data2)[names(data2)=="V2"] <- "id"

data1
data2

data.law <- merge(data1, data2, by="id", all=TRUE)
data.law[is.na(data.law)] <- 0
data.law

data.law$field <- "law"


data.comb3 <- data.comb2
data.comb3
for (i in 1:length(data.law$id)){          # sets up loop to run as many times as there are items in data
  if (data.law$namelist[i] %in% data.comb2$namelist)  {
    #[delete line in data.jp] or do nothing
    print(data.law$namelist[i])
  }
  else  {
    data.comb3 <- rbind(data.comb3, data.law[i,])
  }
}

'''
these people are in both data.comb2 and law fields
[1] "Jeffrey Segal"
[1] "Andrew D. Martin"
[1] "Christopher Zorn"
[1] "Emerson H. Tiller"
[1] "Jeffrey R. Lax"
[1] "Bojan Ticar"
[1] "Tormod Otter Johansen"
[1] "Juan José Mart??nez Layuno"
[1] "Nasrul Ismail"
'''


data.comb3      # output looks good; now have combined group of 180 scholars who identify as public law or judicial politics

fieldpagelist
fieldpagelist2 <- as.factor(fieldpagelist)
fieldpagelist3 <- as.numeric(fieldpagelist2)

hist(fieldpagelist3, breaks=400, cex=0.5, col="blue", border="grey", col.lab="red", labels=fieldpagelist, cex.lab=0.5)


fields.sorted <- sort(table(fieldpagelist),decreasing=T)
fields.sorted
fields.sorted[1:50]

dim(data.comb3)
dim(fields.sorted)

# ADDING 'LAW' SEEMS TO HAVE QUALITATIVELY CHANGED THE DATA COMPOSITION
# From 190 people with 302 areas of interest, there are now 1555 people with 1399 areas of interest.
# The three most common area is by far 'law' (n=1383), but the core two remain largely unchanged (with 'public law' at n=117, vs. 112 before,
# and 'judicial politics' at n=102, vs. 97 before). 
# That is, where these core two used to account for 69% of people, they now account for only 14%.
# Here are the top areas with at least 20 occurrences:
'''
law              public law       judicial politics       political science               economics            human rights 
1383                     117                     102                      61                      60                      60 
constitutional law                 history                politics              philosophy       american politics   intellectual property 
45                      39                      39                      38                      35                      34 
education               sociology       international law           public policy             criminology                  ethics 
33                      31                      30                      30                      27                      27 
law and courts                  policy                 finance              management              psychology                  gender 
25                      25                      24                      24                      24                      20 
'''
####
# OVERALL, by adding law the group has become much more broad but much more diffuse in terms of interests.
# Whereas it could be argued that the public law/judicial politics/law and courts group of 190 individuals constituted an intellectual community, it is hard to 
# argue the same for these 1555 individuals.
####
# NOTE1: These are not major shifts from just looking at 'public law' and 'judicial politics'.
# NOTE2: if you combine 'law and courts' and 'courts' you get 31.
# NOTE3: there are also a large number of entries that references judiciary, i.e., about 12-15 entries like 'judicial behavior', 'judicial reform', judicial impact', etc.

data.comb3[1:200,]

hist(data.comb3$citationnum[data.comb3$citationnum<2000], breaks=500)

cites.sorted <- sort(table(data.comb3$citationnum), decreasing=T)
cites.sorted

summary(data.comb2)

summary(data.comb3)


