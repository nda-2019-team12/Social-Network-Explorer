library(data.table)
library(ggplot2)
library(igraph)
load("reddit.masters.RData")

# Aggrated sentiment : Ferguson
dt.ferguson.sentiment <- dt.reddit.ferguson[,list(unique(SOURCE_SUBREDDIT))]

setnames(dt.ferguson.sentiment, c("V1"), c("SOURCE_SUBREDDIT"))
total_sentiment_ferguson <- setDT(dt.reddit.ferguson)[, .(total_sentiment_ferguson = sum(Compound_Sentiment)), by = SOURCE_SUBREDDIT]

# Update Event 
dt.ferguson.sentiment <- merge(dt.reddit.ferguson, total_sentiment_ferguson, by = "SOURCE_SUBREDDIT")

#Plot Network degree distribution
g.ferguson <- graph.data.frame(dt.reddit.ferguson, directed= TRUE)
V(g.ferguson)$ag_sentiment <- as.numeric(dt.ferguson.sentiment$total_sentiment_ferguson[match(V(g.ferguson)$name,dt.reddit.ferguson$SOURCE_SUBREDDIT)])

degree.dist.ferguson <- degree_distribution(g.ferguson, cumulative=T, mode="all")

plot( x=0:max(degree(g.ferguson)), y=1-degree.dist.ferguson, pch=19, cex=1.2, col="orange", 
      xlab="Degree", ylab="Cumulative Frequency")


# Agregated sentiment and most connected component
cl.ferguson <- clusters(g.ferguson)
g.biggest.component.ferguson <- induced.subgraph(g.ferguson, which(cl.ferguson$membership == which.max(cl.ferguson$csize)))

# Freq for each sentiment
dt.component.sentiment.ferguson <- as.data.table(table((V(g.biggest.component.ferguson)$ag_sentiment)))


# Graph: Distribution of emotion for most active users

# This function allows me to show the negative values in log way 
# Create custom log-style y axis transformer (0,1,3,10,...)
custom_log_y_trans <- function()
  trans_new("custom_log_y",
            transform = function (x) ( log(abs(x)+1) ),
            inverse = function (y) ( exp(abs(y))-1 ),
            domain = c(0,Inf))

# Custom log y breaker (0,1,3,10,...)

ggplot(dt.component.sentiment.ferguson, aes(x=N, y=V1)) + 
  geom_point(size= ifelse(dt.component.sentiment.ferguson$V1 < 0.5 & dt.component.sentiment.ferguson$V1 > -0.5, 0, 
                          ifelse(dt.component.sentiment.ferguson$V1 < 1.5 & dt.component.sentiment.ferguson$V1 > -1.5, 1,
                                 ifelse(dt.component.sentiment.ferguson$V1 < 2.5 & dt.component.sentiment.ferguson$V1 > -2.5, 2, 3
                                 ))), 
             col = ifelse(dt.component.sentiment.ferguson$V1 < 0, "deepskyblue", "tomato")
) + 
  geom_line() + 
  geom_smooth(se=F) + 
  xlab("Frequency") + 
  ylab("Sentiment") +
  scale_x_continuous(breaks = round(seq(min(dt.component.sentiment.ferguson$N), max(dt.component.sentiment.ferguson$N), by = 30), 1)) +
  scale_y_discrete(breaks = c(min(dt.component.sentiment.ferguson$V1), 0, 5, max(dt.component.sentiment.ferguson$V1)))



  
  

                     
                     
                     
                     
  





