## Perform Variable Lag Granger Causality (VLGC) on all user data.
# This script runs VLGC on each user's data (i.e. each CSV file),
# and saves the results to file as an .RDS file.
# The output files are processed in another R script:
# `Import_VLGranger_results_all_users.R`

library(parallel)
library(snow)

# MAKE THIS THE PATH TO WHERE THE USER CSV DATA IS LOCATED
to_process <- list.files("/mnt/volume1/jenny_reddit/user_data/")

# SPECIFY NUMBER OF CORES TO USE FOR PARALLEL PROCESSING
# IF YOU DON'T WANT TO DO PARALLELISED COMPUTATION, 
n.cores <- detectCores() - 1 # we use all cores minus one 
n.cores
# UNCOMMENT THIS IF YOU DON'T WANT TO DO PARALLEL:
# n.cores <- 1

clust <- makeCluster(n.cores, outfile="")
clusterExport(clust, "to_process")

out <- parLapply(clust, to_process, function(x) {
  library(VLTimeCausality)
  require(vader)
  test_user <- read.csv(paste0("/mnt/volume1/jenny_reddit/user_data/",x),stringsAsFactors = F)
  print(dim(test_user))
  print(paste0("\nWorking on user: ",x,"..."))
  test_user <- na.omit(test_user) # remove any NA values for whatever reason they exist 
  if(nrow(test_user) < 50){
    print("User has less than 50 comments. Skipping...")
    return(NULL)
  } # if the user has less than 500 comments, we exclude them from analysis
  test_user$created_fixed <- as.POSIXct(strptime(test_user$created, "%Y-%m-%dT%H:%M:%S"))
  test_user <- test_user[rev(order(test_user$created_fixed)),]
  # create username index column
  # test_user$username <- gsub("\\_comments.csv","",to_process[i])
  # calculate sentiment scores
  skipUser <- F
  tryCatch(
    expr = {
      sentiment_vader_test <- vader_df(test_user$body)
    },
    error = function(e){ 
      print("vader sentiment caught an error... skipping user...")
      skipUser <<- T
    }
  )
  if(skipUser) {
    return(NULL) # we skip this user 
  }
  test_user$compound_sentiment_score <- sentiment_vader_test$compound
  out_test <- VLTimeCausality::VLGrangerFunc(Y=test_user$compound_sentiment_score,X=test_user$score)
  saveRDS(out_test, file = paste0("user_",x,"_VLGranger_results_out.rds"))
})

stopCluster(clust)
