df <- read.csv("manutd_tweets.csv",encoding = "UTF-8",header = FALSE)

df <- unique(df)
#df<- as.data.frame(df[!duplicated(df),])
#tweets_sample<- as.data.frame(df$tweet)
names(df) <- "text"
temp<-lookup_emoji.data.frame(df)


#df$tweet_1 <- iconv(df$tweet, from = "latin1", to = "ascii", sub = "byte")
#tweets2 <- data.frame(text = iconv(df$tweet, "latin1", "utf-8", "byte"), 
                     # stringsAsFactors = FALSE)



countdf<-table(map_chr(temp$emoji_name,~as.integer(length(.x))))
countdf <- as.data.frame(countdf)
names(countdf) <- c("count","freq")
countdf$count <- as.integer(countdf$count)
countdf <- countdf[order(countdf$count),]
# 1: uniform color. Color is for the border, fill is for the inside
ggplot(countdf, aes(x=as.factor(count),freq)) +
  geom_bar(fill=rgb(0.1,0.4,0.5,0.7),stat = "identity" )+xlab("No of emojis per tweet")+ ylab("count")+ggtitle("Emoji Distribution")



?map_chr


emoji_data <- rwhatsapp::emojis %>% # data built into package
  mutate(hex_runes1 = gsub("\\sU\\+", "-", hex_runes)) %>% # replace whitespace & U+ with - to creat urls
  mutate(emoji_url = paste0("https://abs.twimg.com/emoji/v2/72x72/", 
                            tolower(hex_runes1), ".png"))

df<- df[!duplicated(df$tweet),]
tweets_sample<- as.data.frame(df$tweet)
names(tweets_sample) <- "text"
temp<-lookup_emoji.data.frame(tweets_sample)

library(ggimage)# EMOJI RANKING
plotEmojis <- temp %>% 
  unnest(c(emoji, emoji_name)) %>% 
  mutate( emoji = str_sub(emoji, end = 1)) %>% 
  mutate( emoji_name = str_remove(emoji_name, ":.*")) %>% 
  dplyr::count(emoji, emoji_name) %>% 
  
  # PLOT TOP 30 EMOJIS
  top_n(10, n) %>% 
  arrange(desc(n)) %>% # CREA UNA URL DE IMAGEN CON EL UNICODE DE EMOJI
  mutate( emoji_url = map_chr(emoji, 
                              ~paste0( "https://abs.twimg.com/emoji/v2/72x72/", as.hexmode(utf8ToInt(.x)),".png")) 
  )


# PLOT OF THE RANKING OF MOST USED EMOJIS
plotEmojis %>%
  ggplot(aes(x=reorder(emoji_name, n), y=n)) +
  geom_col(aes(fill=n), show.legend = FALSE, width = .2) +
  geom_point(aes(color=n), show.legend = FALSE, size = 3) +
  geom_image(aes(image=emoji_url), size=.045) +
  scale_fill_gradient(low="#2b83ba",high="#d7191c") +
  scale_color_gradient(low="#2b83ba",high="#d7191c") +
  ylab("Emoji Count") +
  xlab("EMoji") +
  ggtitle("Top 10 Emojis") +
  coord_flip() #+
  #theme_minimal() +
  theme()

# tweets_sample<- as.data.frame(df$tweet[1:100])
# names(tweets_sample) <- "text"
# 
# temp<-lookup_emoji.data.frame(tweets_sample)
# 
# 
# history <- system.file("extdata", "sample.txt", package = "rwhatsapp")
# 
# chat <- rwa_read(history)
# library(stringi)
# stri_trans_general("Zażółć gęślą jaźń", "Latin-ASCII")
# all(stri_enc_isutf8(tweets_sample$text))
# 
# 
# 
# 
# ggplot(data=df, aes(x=dose, y=len)) +
#   geom_bar(stat="identity")


library("tidyr")
temp2<-
  
  temp %>%
  unnest(emoji) %>%count(emoji, sort = TRUE)%>%ggplot(aes(x=emoji,y=n))+geom_bar(stat="identity")+coord_flip()

