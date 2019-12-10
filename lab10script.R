## Visualize textual tweet information, by Paige Dickson, adapted from Joseph Holler, 2019
############# TEXT / CONTEXTUAL ANALYSIS ############# 

dorian$text <- plain_tweets(dorian$text)

dorianText <- select(dorian,text)
dorianWords <- unnest_tokens(dorianText, word, text)

# how many words do you have including the stop words?
count(dorianWords)

#create list of stop words (useless words) and add "t.co" twitter links to the list
data("stop_words")
stop_words <- stop_words %>% add_row(word="t.co",lexicon = "SMART")

dorianWords <- dorianWords %>%
  anti_join(stop_words) 

# how many words after removing the stop words?
count(dorianWords)

dorianWords %>%
  count(word, sort = TRUE) %>%
  top_n(15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
  labs(x = "Count",
       y = "Unique words",
       title = "Count of unique words found in tweets")

dorianWordPairs <- dorian %>% select(text) %>%
  mutate(text = removeWords(text, stop_words$word)) %>%
  unnest_tokens(paired_words, text, token = "ngrams", n = 2)

dorianWordPairs <- separate(dorianWordPairs, paired_words, c("word1", "word2"),sep=" ")
dorianWordPairs <- dorianWordPairs %>% count(word1, word2, sort=TRUE)

#graph a word cloud with space indicating association. you may change the filter to filter more or less than pairs with 10 instances
dorianWordPairs %>%
  filter(n >= 30) %>%
  graph_from_data_frame() %>%
  ggraph(layout = "fr") +
  # geom_edge_link(aes(edge_alpha = n, edge_width = n)) +
  geom_node_point(color = "darkslategray4", size = 3) +
  geom_node_text(aes(label = name), vjust = 1.8, size = 3) +
  labs(title = "Word Network: Tweets relating to Hurricane Dorian",
       subtitle = "Hurricane Dorian Tweets - Text mining twitter data ",
       x = "", y = "") +
  theme_void()

############# SPATIAL ANALYSIS ############# 

#get a Census API here: https://api.census.gov/data/key_signup.html
#replace the key text 'yourkey' with your own key!
Counties <- get_estimates("county",product="population",output="wide",geometry=TRUE,keep_geo_vars=TRUE, key="")



############### UPLOAD RESULTS TO POSTGIS DATABASE ###############

#Connecting to Postgres
#Create a con database connection with the dbConnect function.
#Change the database name, user, and password to your own!
con <- dbConnect(RPostgres::Postgres(), dbname='', host='', user='', password='') 

#list the database tables, to check if the database is working
dbListTables(con) 

#create a simple table for uploading
dorian <- select(dorian,c("user_id","status_id","text","lat","lng"),starts_with("place"))

#write data to the database
#replace new_table_name with your new table name
#replace dorian with the data frame you want to upload to the database 
dbWriteTable(con,'dorian',dorian, overwrite=TRUE)

#repeat with data from november 
november <- select(november,c("user_id","status_id","text","lat","lng"),starts_with("place"))
dbWriteTable(con,'november',november, overwrite=TRUE)

#disconnect from the database
dbDisconnect(con)



