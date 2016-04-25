library(DataComputing)
library(httr)
library(jsonlite)

dir<-"C:\\Users\\Tina\\Documents\\_School\\stat133\\stat133-spring2016\\"
smalldocument <- stream_in(file(paste(dir,"businessesmini.json", sep="")))
document <- stream_in(file(paste(dir, "yelp_academic_dataset_business.json", sep="")))
View(smalldocument)

#bobaDataFrameatt %>% select("attributes.Parking.garage", "attributes.Parking.street", "attributes.Parking.lot", "stars", "review_count", "attributes.Outdoor Seating", "attributes.Accepts Credit Cards", "attributes.Price range", "attributes.Wi-Fi")

bobaDataFrame <- document %>%
  select(stars)  


AttributesDF <- smalldocument$attributes
Parking <- AttributesDF$Parking

cat <- document$categories
cat
Boba <- document[5] %>%
  filter("Automotive" %in% categories)

df<-data.frame(categories = unlist(categories))

y <-  lapply(cat, grepl("Boba",cat))



