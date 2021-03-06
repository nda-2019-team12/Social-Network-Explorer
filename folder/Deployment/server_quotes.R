library(shiny)
library(markdown)
library(shinydashboard)
library(data.table)     
library(ggplot2)        
library(stringr)
library(dygraphs)
library(plyr)
library(scales)
library(plotly)
library(shinyWidgets)
library(igraph)
load("dt.reddit.time.RData")

server <- shinyServer(function(input, output) {
  
  # ---------------------------------------------------------------------------------
  # Please *name* each function beforehand using this to make the codes more readable
  # Preferably same *name* as the *separate function file*
  # ---------------------------------------------------------------------------------
  
  # ---------------------------------------------------------------------------------
  # Descriptions
  # ---------------------------------------------------------------------------------
  output$description_reddit <- renderUI({
    HTML("\"Reddit is an American social news aggregation, web content rating, and discussion website. Registered members submit content to the site such as links, text posts, and images, which are then voted up or down by other members. Posts are organized by subject into user-created boards called 'subreddits', which cover a variety of topics including news, science, movies, video games, music, books, fitness, food, and image-sharing. Submissions with more up-votes appear towards the top of their subreddit and, if they receive enough votes, ultimately on the site's front page. Despite strict rules prohibiting harassment, Reddit's administrators spend considerable resources on moderating the site.\" (Reddit, Wikipedia, n.d)"
    )})
  output$description_orlando <- renderText({
    HTML("\"On June 12, 2016, Omar Mateen, a 29-year-old security guard, killed 49 people and wounded 53 others in a mass shooting inside Pulse, a gay nightclub in Orlando, Florida, United States. Orlando Police Department officers shot and killed him after a three-hour standoff. 
         
         In a 9-1-1 call shortly after the shooting began, Mateen swore allegiance to the leader of the Islamic State of Iraq and the Levant, Abu Bakr al-Baghdadi, and said the U.S. killing of Abu Waheeb in Iraq the previous month 'triggered' the shooting. He later told a negotiator he was 'out here right now' because of the American-led interventions in Iraq and in Syria and that the negotiator should tell the United States to stop the bombing. The incident was deemed a terrorist attack by FBI investigators.
         
         Pulse was hosting a 'Latin Night', and most of the victims were Hispanic. It is the deadliest incident of violence against LGBT people in U.S. history and the deadliest terrorist attack in the U.S. since the September 11 attacks in 2001. At the time, it was the deadliest mass shooting by a single shooter in U.S. history, being surpassed by the Las Vegas shooting a year later. By June 2018, the FBI had declined to classify the incident as an anti-gay hate crime, as evidence suggested that Mateen had scouted several different targets before choosing Pulse, without knowing that it was a gay nightclub.\" (Orlando nightclub shooting, Wikipedia, n.d)"
    )})
  output$description_ferguson <- renderText({
    HTML("\"The Ferguson unrest, sometimes called the Ferguson Uprising or simply Ferguson, involved protests and riots that began the day after the fatal shooting of Michael Brown by police officer Darren Wilson on August 9, 2014, in Ferguson, Missouri. The unrest sparked a vigorous debate in the United States about the relationship between law enforcement officers and African Americans, the militarization of police, and the use-of-force law in Missouri and nationwide. Continued activism expanded the issues to include modern-day debtors prisons, for-profit policing,and school segregation.
         As the details of the original shooting emerged, police established curfews and deployed riot squads to maintain order. Along with peaceful protests, there was significant looting and violent unrest in the vicinity of the original shooting, as well as across the city. According to media reports, there was reactionary police militarization when dealing with violent protests in Ferguson. The unrest continued on November 24, 2014, after a grand jury did not indict Officer Wilson. It briefly continued again on the one-year anniversary of Brown's shooting. The U.S. Department of Justice concluded Wilson shot Brown in self-defense.
         In response to the shooting and subsequent unrest, the U.S. Department of Justice (DOJ) conducted an investigation into the policing practices of the Ferguson Police Department (FPD). In March 2015, the DOJ announced that they had determined that the FPD had engaged in misconduct against the citizenry of Ferguson by among other things discriminating against African Americans and applying racial stereotypes, in a 'pattern or practice of unlawful conduct.' The DOJ also found that Ferguson depended on fines and other charges generated by police.\" (Ferguson unrest, Wikipedia, n.d)
         ")
  })
  output$description_obama <- renderText({
    HTML("\"President Barack Obama arrived to small but cheering crowds on Sunday at the start of a historic visit to Cuba that opened a new chapter in U.S. engagement with the island's Communist government after decades of hostility between the former Cold War foes.
         The three-day trip, the first by a U.S. president to Cuba in 88 years, is the culmination of a diplomatic opening announced by Obama and Cuban President Raul Castro in December 2014, ending an estrangement that began when the Cuban revolution ousted a pro-American government in 1959.\"    
         (Reuters, https://in.reuters.com/article/usa-cuba-idINKCN0WN050)")
  })
  output$description_trump <- renderText({
    HTML("\"On Wednesday, Time magazine announced Donald Trump as its 'Person of the Year.' On the cover, Time wrote that he'd become president of the 'divided states of America.'
         While some Trump supporters greeted the announcement with joy, others noted that the editorial was highly critical of him and the type of damage he's already caused. NeverTrumpers and Clinton supporters noted that Hitler and Putin had both received the award before and that this was no honor.
         At a loss for words, the social media responded with jokes, GIFs and outrage.\" (Mashable, https://mashable.com/2016/12/07/twitter-reacts-time-person-year/)
         ")
  })
  output$description_dataset1 <- renderText({
    HTML("\"The hyperlink network represents the directed, weighted connections between two subreddits (communities of Reddit). The network is extracted from publicly available Reddit data of 2.5 years from Jan 2014 to April 2017. The subreddit-to-subreddit hyperlink network is extracted from the posts that create hyperlinks from one subreddit to another. We say a hyperlink originates from a post in the source community and links to a post in the target community. Each hyperlink is annotated with three properties: the timestamp, the sentiment of the source community post towards the target community post, and the text property vector of the source post. The network is directed, signed, temporal, and attributed.\"
         ")
  })  
  output$description_dataset2 <- renderText({
    HTML("
         The data consists of two sets (title lines and body texts, each >300k samples) with identical columns. Useful properties (such as sentiment and readability index) were maintained while other features were excluded in order to fulfil our value proposition. 
         <br/><br/>
         <strong>SOURCE_SUBREDDIT: </strong>the subreddit where the link is originated.
         <br/><br/>
         <strong>TARGET_SUBREDDIT: </strong>the subreddit towards which the link is directed.
         <br/><br/>
         <strong>POST_ID: </strong>the post in the source subreddit that starts the link
         <br/><br/>
         <strong>TIMESTAMP: </strong>time of the post
         <br/><br/>
         <strong>LINK_SENTIMENT: </strong>value indicating if the source post is explicitly negative towards the target post. The value is -1 if the source is negative towards the target, and 1 if it is neutral or positive. However, we will be using the raw VADER score in the data (positive/ negative/ compound sentiment). VADER is sentiment reasoner based on a lexicon of over 7000 manually validated features.
         <br/><br/>
         <strong>Automated readability index: </strong>label indicating the confidence of sentiment categorization.
         We will concatenate the two datasets and use ???POST_ID??? to match the titles to the post bodies.
         "
    )
  }) 
  # ================================================================================
  # histogram plots
  # ================================================================================
  output$plot.histogram.orlando <- renderPlotly ({
    plot_ly(x = dt.r.orlando.15d.f[date >= input$dateRange.orlando[1] &
                                    date <= input$dateRange.orlando[2]]$date,
            type = "histogram", autobinx = F)
  })#end of output orlando
  output$plot.histogram.ferguson <- renderPlotly ({
    plot_ly(x = dt.r.ferguson.15d.f[date >= input$dateRange.ferguson[1] &
                                     date <= input$dateRange.ferguson[2]]$date,
            type = "histogram", autobinx = F)
  })#end of output ferguson
  output$plot.histogram.obama <- renderPlotly ({
    plot_ly(x = dt.r.obama.15d.f[date >= input$dateRange.obama[1] &
                                  date <= input$dateRange.obama[2]]$date,
            type = "histogram", autobinx = F)
  })#end of output obama
  output$plot.histogram.trump <- renderPlotly ({
    plot_ly(x = dt.r.trump.15d.f[date >= input$dateRange.trump[1] &
                                  date <= input$dateRange.trump[2]]$date,
            type = "histogram", autobinx = F)
  })#end of output trump
  
  
  # ================================================================================
  # Sentiment analysis I
  # ================================================================================
  # combo chart of orlando starts
  filterData_orlando_combo <- reactive({
    combo.orlando <- switch(input$Time_Selection_Orlando_Combo,
                            "Before" = f.combochart(dt.r.orlando.15d.b),
                            "After" = f.combochart(dt.r.orlando.15d.a),
                            "Entire" = f.combochart(dt.r.orlando.15d.f)
    ) # end of switch
    return(combo.orlando)
  }) # end of filterData_orlando_combo
  output$plot.combo.orlando <- renderPlot({
    combo.orlando <- filterData_orlando_combo()
    combo.orlando
  }) # end of renderPlot

  
  # combo chart of ferguson starts
  filterData.ferguson.combo <- reactive({
    combo.ferguson <- switch(input$Time_Selection_Ferguson_Combo, 
                             "Before" = f.combochart(dt.r.ferguson.15d.b),
                             "After" = f.combochart(dt.r.ferguson.15d.a), 
                             "Entire" = f.combochart(dt.r.ferguson.15d.f)
    ) # end of switch
    return(combo.ferguson)
  }) # end of filterData.ferguson.combo
  output$plot.combo.ferguson <- renderPlot({
    combo.ferguson <- filterData.ferguson.combo()
    combo.ferguson
  }) # end of renderPlot
  
  # combo chart of obama starts
  filterData.obama.combo <- reactive({
    combo.obama <- switch(input$Time_Selection_Obama_Combo, 
                          "Before" = f.combochart(dt.r.obama.15d.b),
                          "After" = f.combochart(dt.r.obama.15d.a), 
                          "Entire" = f.combochart(dt.r.obama.15d.f)
    ) # end of switch
    return(combo.obama)
  }) # end of filterData.obama.combo
  output$plot.combo.obama <- renderPlot({
    combo.obama <- filterData.obama.combo()
    combo.obama
  }) # end of renderPlot
  
  # combo chart of trump starts
  filterData.trump.combo <- reactive({
    combo.trump <- switch(input$Time_Selection_Trump_Combo, 
                          "Before" = f.combochart(dt.r.trump.15d.b),
                          "After" = f.combochart(dt.r.trump.15d.a), 
                          "Entire" = f.combochart(dt.r.trump.15d.f)
    ) # end of switch
    return(combo.trump)
  }) # end of filterData.trump.combo
  output$plot.combo.trump <- renderPlot({
    combo.trump <- filterData.trump.combo()
    combo.trump
  }) # end of renderPlot

  # =================================================================================
  # Sentiment analysis II
  # ================================================================================
  output$value.outbound.orlando <- renderText({input$select.subreddit.orlando})
  output$plot.scatter.sentiment.orlando <- renderPlotly ({
    # Create scatter plot of outbound subreddits
    plot.sentiment.orlando <- 
      plot_ly(data = dt.g.r.sentiment.filter.out.orlando,
              x = ~ positive_outbound,
              y = ~ negative_outbound,
              marker = list(color = 
                              ifelse(dt.g.r.sentiment.filter.out.orlando$name == input$select.subreddit.orlando, 
                                     'rgba(152, 0, 0, .8)', 'rgba(63, 127, 191)'),
                              size = dt.g.r.sentiment.filter.out.orlando$out_degree / 5),
                              hoverinfo = 'text',
                              text = ~ paste(dt.g.r.sentiment.filter.out.orlando$name,
                              '</br></br>', positive_outbound, '</br>', negative_outbound)
              ) # end of plot_ly
    plot.sentiment.orlando
  }) # end of output of orlando
  output$plot.scatter.sentiment.ferguson <- renderPlotly ({
    # Create scatter plot of outbound subreddits
    plot.sentiment.ferguson <- 
      plot_ly(data = dt.g.r.sentiment.filter.out.ferguson,
              x = ~ positive_outbound,
              y = ~ negative_outbound,
              marker = list(color = 
                              ifelse(dt.g.r.sentiment.filter.out.ferguson$name == input$select.subreddit.ferguson, 
                                     'rgba(152, 0, 0, .8)', 'rgba(63, 127, 191)'),
                              size = dt.g.r.sentiment.filter.out.ferguson$out_degree / 5),
                              hoverinfo = 'text',
                              text = ~ paste(dt.g.r.sentiment.filter.out.ferguson$name,
                              '</br></br>', positive_outbound, '</br>', negative_outbound)
              ) # end of plot_ly
    plot.sentiment.ferguson
  }) # end of output of ferguson
  output$plot.scatter.sentiment.obama <- renderPlotly ({
    # Create scatter plot of outbound subreddits
    plot.sentiment.obama <- 
      plot_ly(data = dt.g.r.sentiment.filter.out.obama,
              x = ~ positive_outbound,
              y = ~ negative_outbound,
              marker = list(color = ifelse(dt.g.r.sentiment.filter.out.obama$name == input$select.subreddit.obama, 
                                           'rgba(152, 0, 0, .8)', 'rgba(63, 127, 191)'),
                                    size = dt.g.r.sentiment.filter.out.obama$out_degree / 5),
                                    hoverinfo = 'text',
                                    text = ~ paste(dt.g.r.sentiment.filter.out.obama$name,
                                    '</br></br>', positive_outbound, '</br>', negative_outbound)
              ) # end of plot_ly
    plot.sentiment.obama
  }) # end of output of obama
  output$plot.scatter.sentiment.trump <- renderPlotly ({
    # Create scatter plot of outbound subreddits
    plot.sentiment.trump <- 
      plot_ly(data = dt.g.r.sentiment.filter.out.trump,
              x = ~ positive_outbound,
              y = ~ negative_outbound,
              marker = list(color = ifelse(dt.g.r.sentiment.filter.out.trump$name == input$select.subreddit.trump, 
                                           'rgba(152, 0, 0, .8)', 'rgba(63, 127, 191)'),
                                    size = dt.g.r.sentiment.filter.out.trump$out_degree / 5),
                                    hoverinfo = 'text',
                                    text = ~ paste(dt.g.r.sentiment.filter.out.trump$name,
                                    '</br></br>', positive_outbound, '</br>', negative_outbound)
              ) # end of plot_ly
    plot.sentiment.trump
  }) # end of output of trump
  
  # =================================================================================
  # Degree Distribution
  # =================================================================================
  output$orlando_distribution <- renderPlotly({
    degree.orlando <- ggplot(f.degree.distribution(dt.r.orlando.15d.f), aes(x = l.ddistribution)) + 
      geom_histogram(binwidth = 1)
    degree.orlando
  }) # end of output of orlando
  output$ferguson_distribution <- renderPlotly({
    degree.ferguson <- ggplot(f.degree.distribution(dt.r.ferguson.15d.f), aes(x = l.ddistribution)) + 
      geom_histogram(binwidth = 1)
    degree.ferguson
  }) # end of output of ferguson
  output$obama_distribution <- renderPlotly({
    degree.obama <- ggplot(f.degree.distribution(dt.r.obama.15d.f), aes(x = l.ddistribution)) + 
      geom_histogram(binwidth = 1)
    degree.obama
  }) # end of output of obama
  output$trump_distribution <- renderPlotly({
    degree.trump <- ggplot(f.degree.distribution(dt.r.trump.15d.f), aes(x = l.ddistribution)) + 
      geom_histogram(binwidth = 1)
    degree.trump
  }) # end of output of trump

  
  })#end of ShinyServer

server