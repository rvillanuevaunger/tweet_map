# Load Libraries
library(shiny)
library(tidyverse)
library(rtweet)
library(textclean)
library(sentimentr)
library(sf)
library(leaflet)


# Define UI for application
ui <- fluidPage(

    # Application title
    titlePanel("Map of Twitter Sentiments in the USA"),
    
    # Sidebar with inputs for Number of Tweets and Hashtag
    sidebarLayout(position = 'left',
        sidebarPanel(
            numericInput("num_tweets_to_download",
                         "Number of tweets to download:",
                         min = 100,
                         max = 18000,
                         value = 900,
                         step = 100),
            textInput("hashtag_to_search",
                      "Hashtag to search:",
                      value = "#olympics2021"),
            actionButton("get_tweets", "Generate Map", class = "btn-primary")
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            leafletOutput("map")
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
    
}

# Run the application 
shinyApp(ui = ui, server = server)

pkgs <- scan_packages()
cites <- get_citations(pkgs)
rmd <- create_rmd(cites)
render_citations(rmd, output = "docx")
