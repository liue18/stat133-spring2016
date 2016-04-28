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
restaurants <- c()
for (i in 1:length(categories)) {
  if (sum(grepl("Restaurants",categories[[i]]) > 0)) {
    restaurants <- c(restaurants,businesses[i,1])
  }
}

#Select the rows in the data frame where the row number is in tearooms
businessesnarrow <- data.frame(businesses$business_id,businesses$name,businesses$stars,businesses$attributes$"Parking",businesses$attributes$"Wi-Fi",businesses$attributes$"Outdoor Seating",businesses$attributes$"Good For",businesses$attributes$"Accepts Credit Cards",businesses$attributes$"Price Range")
restaurants_frame <- businessesnarrow %>%
  filter(businesses.business_id %in% restaurants)
#Remove strange formatting in names
names(restaurants_frame) <- c("business_id","name","stars",names(restaurants_frame)[4:8],"Wi_Fi","Outdoor_Seating",names(restaurants_frame)[11:16],"Credit_Cards","Price_Range")

#Price range plots: Density
p <- restaurants_frame %>% ggplot(aes(x=stars))
p + geom_density() + facet_wrap( ~ Price_Range) #Density faceted by price
p + geom_density(aes(fill=as.factor(Price_Range)),color=NA,alpha=0.4) #Density with fill by price; hard to read
p + geom_density(aes(fill=as.factor(Price_Range)),color=NA,alpha=0.4,position="stack") #Density with fill by price, stacked; still hard to read
p + geom_density(aes(fill=as.factor(Price_Range)),color=NA,alpha=0.4) + facet_wrap( ~ Price_Range) #Easier to read, harder to compare

#Price range plots: Frequency polygon
price_range_labels <- c("1" = "$", "2" = "$$", "3" = "$$$", "4" = "$$$$", "NA" = "No Range")
q <- restaurants_frame %>% ggplot(aes(x=stars,y=..density..))
q <- q + geom_freqpoly(binwidth = .5,aes(col=as.factor(Price_Range))) + facet_grid(.~Price_Range, labeller = labeller(Price_Range = price_range_labels))
q <- q + labs(x="Stars",y="Density",title="Review Distribution by Price Range",legend="Price Range") + 
  scale_colour_discrete(name="Price Range",labels=c("$","$$","$$$","$$$$","No Range")) + 
  theme(plot.title=element_text(size=20),axis.title=element_text(size=15))
q
