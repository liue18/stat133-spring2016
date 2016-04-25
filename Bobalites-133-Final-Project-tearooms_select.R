library(DataComputing)
library(httr)
library(jsonlite)

#Load the files
##replace dir path with location of files on your computer
dir <- "/Users/amaliaskilton/Documents/Coursework/2015-16/133/Final/"
businessesmini <- stream_in(file(paste(dir,"businessesmini.json",sep="")))
businesses <- stream_in(file(paste(dir,"yelp_academic_dataset_business.json",sep="")))
categories <- businesses$categories

#Make a vector with the unique business id's for all the rows where 'categories' contains 'Bubble Tea' or 'Tea Rooms'
tearooms <- c()
for (i in 1:length(categories)) {
  if (sum(grepl("Bubble Tea",categories[[i]]) > 0) | sum(grepl("Tea Rooms",categories[[i]]) > 0)) {
    tearooms <- c(tearooms,businesses[i,1])
  }
}

#Select the rows in the data frame where the row number is in tearooms
businessesnarrow <- data.frame(businesses$business_id,businesses$name,businesses$stars,businesses$attributes$"Parking",businesses$attributes$"Wi-Fi",businesses$attributes$"Outdoor Seating",businesses$attributes$"Good For",businesses$attributes$"Accepts Credit Cards",businesses$attributes$"Price Range")
tearooms_frame <- businessesnarrow %>%
  filter(businesses.business_id %in% tearooms)