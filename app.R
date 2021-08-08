# Load Libraries
library(shiny)
library(tidyverse)
library(rtweet)
library(httr)
library(tidytext)
library(textclean)
library(sentimentr)
library(sf)
library(leaflet)
library(stopwords)

# Define UI for application
ui <- fluidPage(

    # Application title
    titlePanel("Twitter Sentiments in the USA"),
    
    # Sidebar with inputs for Number of Tweets and Hashtag
    sidebarLayout(position = 'left',
        sidebarPanel(
            numericInput("num_tweets_to_download",
                         "Number of tweets to download:",
                         min = 100,
                         max = 18000,
                         value = 1000,
                         step = 100),
            textInput("hashtag_to_search",
                      "Hashtag to search:",
                      value = "#olympics2021"),
            actionButton("get_tweets", "Generate", class = "btn-primary")
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            leafletOutput("map"),
            splitLayout(cellWidths = c("50%", "50%"),
                        plotOutput(outputId = "common_words"),
                        plotOutput(outputId = "num_words"))
        )
    )
)

# Define server logic 
server <- function(input, output, session) {
    
    # Dataframe with tweets that is generated when the main button is clicked
    tweet_df <- eventReactive(input$get_tweets, {
        search_tweets(q = input$hashtag_to_search, 
                      n = input$num_tweets_to_download, 
                      include_rts = FALSE,
                      lang = "en",
                      geocode = lookup_coords("usa"))
    })
    
    # Filter Twitter data
    tweet_filt <- reactive({
        req(tweet_df()) 
        tweet_df() %>% 
            lat_lng() %>%
            select(user_id, status_id, created_at, text, place_full_name,
                   geo_coords, location, lat, lng) %>% 
            mutate(text = replace_emoji(text)) %>% 
            mutate(sentences = get_sentences(text))
    })
    
    # Convert Twitter data into sentiment and mappable information
    tweet_geo <- reactive({
        req(tweet_filt())
        tweet_filt() %>%
            mutate(sentiment = sentiment_by(sentences)) %>% 
            filter(is.na(lat) == FALSE & is.na(lng) == FALSE) %>% 
            mutate(sentiment_average = sentiment$ave_sentiment) %>% 
            st_as_sf(coords = c("lng", "lat"))
    })
        
    # Color palette
    pal <- reactive({
        req(tweet_geo())
        colorNumeric(palette = "RdYlGn", 
                        domain = tweet_geo()$sentiment_average, 
                        reverse = T)
    })
    
    # Labels for map legend
    labels <- c("Positive", "Neutral", "Negative")
    
    # Map output
    output$map <- renderLeaflet(
        leaflet() %>% 
            setView(lng = -93.85, lat = 37.45, zoom = 4) %>%
            addProviderTiles(providers$CartoDB.Positron) %>% 
            addCircleMarkers(data = tweet_geo(),
                             color = ~pal()(tweet_geo()$sentiment_average),
                             stroke = FALSE,
                             fillOpacity = .6) %>% 
            addLegend("bottomleft", 
                      pal = pal(), 
                      values = tweet_geo()$sentiment_average,
                      labFormat = function(type, cuts, p) {
                          paste0(labels)
                      },
                      title = "Sentiment",
                      opacity = 1)
    )
    
    # Identify Stop Words
    my_stop_words <- reactive({
      stop_words %>% 
        select(-lexicon) %>% 
        bind_rows(data.frame(word = input$hashtag_to_search))
    })
    
    # Get Individual Words
    tweet_words <- reactive({
      req(tweet_filt())
      tweet_filt() %>% 
        select(status_id, text) %>% 
        unnest_tokens(word, text) 
    })
    
    # Get Interesting Words
    tweet_sent <- reactive({
      req(my_stop_words())
      req(tweet_words())
      tweet_words() %>% 
        anti_join(my_stop_words()) %>% 
        left_join(sentiments) %>% 
        filter(!is.na(sentiment)) %>% 
        mutate(sentiment = as.factor(sentiment))
    })
    
    # Twenty Most Commonly Used Words Output
    output$common_words <- renderPlot(
      tweet_sent() %>% 
        group_by(word, sentiment) %>% 
        count(word, sort = TRUE) %>% 
        ungroup() %>% 
        slice(1:20) %>% 
        mutate(word = reorder(word, n)) %>%
        ggplot(aes(n, word, fill = sentiment)) +
        geom_col() +
        scale_fill_manual(values = c("#b02117", "#168738")) +
        ggtitle("Most Commonly Used Words") +
        labs(x = NULL, y = NULL) +
        theme_minimal()
    )
    
    # Number of Words per Tweet Output
    output$num_words <- renderPlot(
      tweet_words() %>%
        count(status_id, name = "total_words") %>% 
        ggplot(aes(total_words)) +
        geom_histogram(fill = "light grey") +
        theme_minimal() +
        ggtitle("Distribution of Words Per Tweet") +
        xlab("Words Per Tweet") +
        labs(y = NULL)
    )
    
}

# Run the application 
shinyApp(ui = ui, server = server)
