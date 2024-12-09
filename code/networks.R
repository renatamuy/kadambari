# Kadambari
# This repo is a supplement to the manuscript:
# Muylaert et al., in prep. Connections in the Dark: Network Science and 
# Social-Ecological Networks as Tools for Bat Conservation and Public Health.
# Global Union of Bat Diversity Networks (GBatNet).
# See README for further info: https://github.com/renatamuy/kadambari

# Packages

if(!require(here)){
  install.packages("here")
  library(here)
}

if(!require(ggplot2)){
  install.packages("ggplot2")
  library(ggplot2)
}

if(!require(igraph)){
  install.packages("igraph")
  library(igraph)
}

if(!require(tidyverse)){
  install.packages("tidyverse")
  library(tidyverse)
}

setwd(here())
setwd('data')

interview <- read.xlsx('Interview perceptions and scores_individuals_ref Cashew nut and Bats.xlsx', sheetIndex = 1)

colnames(interview)

unique(interview$state.code)


netprep <- interview %>% select(state.code, seed_clumping,
                     auctions,
                     seed_dispersal,
                     germination,
                     pestcontrol,
                     pollination,
                     good.omen,
                     ripening,
                     labourcost,
                     meat,
                     medicine,
                     droppings,
                     badomen_dislike,
                     loss_damage,
                     discomfort_nuisance)

netprep

netsummary <- netprep %>%
  group_by(state.code) %>%
  summarise(    benefits = sum(seed_clumping +
                    auctions+
                  seed_dispersal+
                  germination+
                  pestcontrol+
                  pollination+
                  good.omen+
                  ripening+
                  labourcost+
                  meat+
                  medicine),
    costs = sum( droppings +
                   badomen_dislike+
                   loss_damage+ 
                   discomfort_nuisance),
    .groups = "drop"
  )
netsummary

# Network aggregated by state

netprep1 <- netprep %>%
  group_by(state.code) %>%
  summarise(across(everything(), sum), .groups = "drop")


colnames(netprep1)[1] <- 'ID'


netmelt <- data.table::melt(netprep1, id.vars=c('ID')) 

netmelt$value

netmelt$type <- c('benefits')
  
netmelt$type <- ifelse(netmelt$variable %in% benefits, 'benefits', 'costs')

netmelt

# there is an NA in from ID (not true for states, so all good)
netmelt$ID 

netmelt$ID[netmelt$ID=='NA'] <- "Unknown ID"

table(is.na(netmelt$ID))

unique(netmelt$ID)

submelt <- subset(netmelt, value > 0)

edge_list <- data.frame(from = netmelt$ID, to = netmelt$variable)

g <- graph_from_data_frame(d = edge_list, directed = FALSE)

# coding nodes


benefits <- c('seed_clumping',
              'auctions',
              'seed_dispersal',
              'germination',
              'pestcontrol',
              'pollination',
              'good.omen',
              'ripening',
              'labourcost',
              'meat',
              'medicine')


interview[, colnames(interview) %in% benefits]

costs <- c('droppings',
           'badomen_dislike',
           'loss_damage',
           'discomfort_nuisance')

# defining layout 
E(g)$weight <- netmelt$value
V(g)$type <- ifelse(V(g)$name %in% netmelt$ID, "ID", "variable")
V(g)$type <- ifelse(V(g)$name %in% benefits, "benefits", V(g)$type)
V(g)$type <- ifelse(V(g)$name %in% costs, "costs", V(g)$type)

V(g)$color <- ifelse(V(g)$type == "ID", "lightskyblue", "salmon")
V(g)$color <- ifelse(V(g)$type == "benefits", "darkseagreen", V(g)$color)

E(g)$color <- ifelse(netmelt$type == "benefits", "darkseagreen", "salmon")
E(g)$width <- netmelt$value / max(netmelt$value) * 10  # Scale link widths
E(g)$curved <- 0.2 


# Plot & Export

setwd("../figures")

png(file = "kadambari_network.png", width = 14, height = 12, unit='cm', res = 400)

par(mar = c(3, 3, 3, 3)) 

plot(
  g,
  vertex.label.family = "Arial", 
  vertex.label.cex = 0.5,   
  layout = layout_in_circle, 
  vertex.size = 22,  
  vertex.label.cex = 1.5,  
  vertex.label.color = "gray30", 
  #vertex.label.dist=1.9,
  vertex.frame.color = "white",  
  edge.width = E(g)$width,
  #edge.color = "gray63",
  edge.color = E(g)$color, 
  main = "Fruit bat costs and benefits per state"
)
dev.off()

#---------------------