dir <- "C:\\Users\\Tina\\Documents\\_School\\stat133\\stat133-spring2016\\"
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

#Credit card plots
rating_distrib_plot <- restaurants_frame %>% ggplot(aes(y=stars, x=Credit_Cards))
rating_distrib_plot + geom_boxplot()

card_by_star <- restaurants_frame %>%
  group_by(stars, Credit_Cards) %>%
  summarise(count = n()) %>%
  group_by(stars) %>%
  mutate(percent_cardtype = count/sum(count))

percent_cardtype_by_star_plot <- ggplot(card_by_star, aes(x=stars, y=percent_cardtype, col=Credit_Cards))
percent_cardtype_by_star_plot + geom_line()
