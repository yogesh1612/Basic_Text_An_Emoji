shinyServer(function(input, output){
  
  
  emoji_df <- reactive({
    if (is.null(input$file)) { return(NULL) }
    else{
      Dataset <- readr::read_csv(input$file$datapath)
      Dataset <-unique(Dataset)
      names(Dataset) <- "text"
      emoji_df <- lookup_emoji.data.frame(Dataset)
      return(emoji_df)
    }
  })
  
  
 output$plotsummary <- renderPlot({
                     countdf<-table(map_chr(emoji_df()$emoji_name,~as.integer(length(.x))))
                     countdf <- as.data.frame(countdf)
                     names(countdf) <- c("count","freq")
                     countdf$count <- as.integer(countdf$count)
                     countdf <- countdf[order(countdf$count),]
                     # 1: uniform color. Color is for the border, fill is for the inside
                     ggplot(countdf, aes(x=as.factor(count),freq)) +
                       geom_bar(fill=rgb(0.1,0.4,0.5,0.7),stat = "identity" )+xlab("No of emojis per tweet")+ ylab("count")+ggtitle("Emoji Distribution")
                     
                     
                                        
                       })
 
emoji_count_df <- reactive({
                  plotEmojis <- emoji_df() %>% 
                  unnest(c(emoji, emoji_name)) %>% 
                  mutate( emoji = str_sub(emoji, end = 1)) %>% 
                  mutate( emoji_name = str_remove(emoji_name, ":.*")) %>% 
                  dplyr::count(emoji, emoji_name) %>% 
  
                  # PLOT TOP 30 EMOJIS
                  top_n(input$obs, n) %>% 
                  arrange(desc(n)) %>% # CREA UNA URL DE IMAGEN CON EL UNICODE DE EMOJI
                  mutate( emoji_url = map_chr(emoji, 
                                              ~paste0( "https://abs.twimg.com/emoji/v2/72x72/", as.hexmode(utf8ToInt(.x)),".png")) 
  )})
 

output$plotemoji <- renderPlot({emoji_count_df() %>%
                      ggplot(aes(x=reorder(emoji_name, n), y=n)) +
                      geom_col(aes(fill=n), show.legend = FALSE, width = .2) +
                      geom_point(aes(color=n), show.legend = FALSE, size = 3) +
                      geom_image(aes(image=emoji_url), size=.045) +
                      scale_fill_gradient(low="#2b83ba",high="#d7191c") +
                      scale_color_gradient(low="#2b83ba",high="#d7191c") +
                      ylab("Emoji Count") +
                      xlab("EMoji") +
                      ggtitle(paste0("Top-",input$obs, " Emojis")) +
                      coord_flip() +
                      #theme_minimal() +
                      theme()
})
  
output$downloadData1 <- downloadHandler(
  filename = function() { "man_utd_tweets.csv" },
  content = function(file) {
    readr::write_csv(readr::read_csv("data/manutd_tweets.csv"), file)#,row.names = FALSE)#,fileEncoding = "UTF-8")
  }
)
  
})