source("system/initialization.R")
source("system/parallell_programming.R")
source("system/functions.R")

source("functions/measures_distance.R")
setwd("functions/OACC");source("scripts/BDM2D.R");setwd("../../")
source("functions/tests_distance.R")
source("functions/analyse.R")

source("Network-Data/NORdirectors/nordirectors.R")

cl <- start_cluster(sources=c("system/initialization.R","functions/measures_distance.R"))

# Calculating and plotting vulnerabilities
nodes_uu <- as.data.frame(vulnerability_nodes(cl,nordirectors_uu,performance=global_efficiency_unpar)) %>%
  `colnames<-`(c("Vulnerability")) %>%
  `row.names<-`(V(nordirectors_uu)$name) %T>%
  write.csv(.,file="Network-Data/NORdirectors/data/vulnerability_uu.csv") %T>%
  plot_nordirectors(nordirectors_uu,.,"Network-Data/NORdirectors/pdf","nordirectors_uu","NORdirectors")


# Calculating samples of network
analyse_sample_performance(cl,nordirectors_uu,counter=100,sizes=seq.int(10,vcount(nordirectors),10)
                           , use_cluster = FALSE
                           , use_ego = TRUE
                           , file_path = "Network-Data/NORdirectors/pdf/NORdirectors_uu_sample_r"
                           , netname = "NORdirectors"
                           , p_name = "Global Efficiency"
                           , performance = global_efficiency_unpar)

analyse_sample_performance(cl,nordirectors_uu,counter=100,sizes=seq.int(1,40,1)
                           , use_cluster = TRUE
                           , use_ego = TRUE
                           , file_path = "Network-Data/NORdirectors/pdf/NORdirectors_uu_sample_ce"
                           , netname = "NORdirectors"
                           , p_name = "Global Efficiency"
                           , performance = global_efficiency_unpar)

analyse_sample_performance(cl,nordirectors_uu,counter=100,sizes=seq.int(1,40,1)
                           , use_cluster = TRUE
                           , use_ego = FALSE
                           , file_path = "Network-Data/NORdirectors/pdf/NORdirectors_uu_sample_cu"
                           , netname = "NORdirectors"
                           , p_name = "Global Efficiency"
                           , performance = global_efficiency_unpar)

cl <- stop_cluster(cl)

# (Relative) Kolmogorov Complexity 
cl <- start_cluster(sources=c("system/initialization.R","functions/measures_distance.R"))
clusterCall(cl,function(){setwd("functions/OACC");source("scripts/BDM2D.R");setwd("../../")})

vec <- kolmogorov_norm(cl,vcount(nordirectors_uu),ecount(nordirectors_uu),FALSE,1e2)
k <- kolmogorov(nordirectors_uu,1)
k_rel <- c(k/(vec[1]-vec[2]),k/vec[1],k/(vec[1]+vec[2]))



