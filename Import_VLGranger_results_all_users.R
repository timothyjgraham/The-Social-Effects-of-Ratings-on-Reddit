## Import results of VL granger on all users,
## wrangle data and 

to_process_VLGranger <- list.files("/mnt/volume1/jenny_reddit/VLCausalityResults_per_user/", full.names = T)
to_process_VLGranger_filenames_short <- list.files("/mnt/volume1/jenny_reddit/VLCausalityResults_per_user/", full.names = F)

## run on all files and write to file

pb <- txtProgressBar(0, length(to_process_VLGranger), style = 3)
for (i in 1:length(to_process_VLGranger)) {
  setTxtProgressBar(pb, i)
  tempVar <- readRDS(to_process_VLGranger[i])
  # what is the username?
  gsub("user_|_comments.csv_VLGranger_results_out.rds","",to_process_VLGranger_filenames_short[i])
  # results of regular granger with variable lag results (f-test)
  tempVar$XgCsY_ftest
  tempVar$p.val
  # write to file
  df_temp <- data.frame(
  username = gsub("user_|_comments.csv_VLGranger_results_out.rds","",to_process_VLGranger_filenames_short[i]),
  XgCsY_ftest = tempVar$XgCsY_ftest,
  p.val = tempVar$p.val
  )
  write.table(df_temp, "/mnt/volume1/jenny_reddit/VLCausality_results_out.csv", sep = ",", col.names = F, append = T)
}

# import and analyse results for first 5000 users, as per paper.
df_results <- read.csv("VLCausality_results_out.csv",header=F)
table(df_results$V3[1:5000])
table(df_results$V3[1:5000]) / nrow(df_results[1:5000,])

# Results are as follows (as per paper):
#FALSE  TRUE
#4749   817
#FALSE     TRUE
#0.853216 0.146784
