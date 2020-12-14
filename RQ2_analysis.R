# Analysis of replies and votes scores (RQ2)

# Set this directory to your working directory 
setwd('/Users/grahamtj/Documents/Research/2019/Reddit ratings Jenny/')

# import data and get number of replies for each comment
df0 <- read.csv('paper-data-october-2018000000000000.csv')
df1 <- read.csv('paper-data-october-2018000000000001.csv')
df2 <- read.csv('paper-data-october-2018000000000002.csv')
df3 <- read.csv('paper-data-october-2018000000000003.csv')
df4 <- read.csv('paper-data-october-2018000000000004.csv')
df5 <- read.csv('paper-data-october-2018000000000005.csv')
df6 <- read.csv('paper-data-october-2018000000000006.csv')
df7 <- read.csv('paper-data-october-2018000000000007.csv')
df8 <- read.csv('paper-data-october-2018000000000008.csv')
df9 <- read.csv('paper-data-october-2018000000000009.csv')

df <- rbind(df0,df1,df2,df3,df4,df5,df6,df7,df8,df9)
dim(df)

# convert factors to character 
df$id <- as.character(df$id)
df$parent_id <- as.character(df$parent_id)

# remove 't3_' parent ids (which denotes it is a 'post')
toDel <- grep('t3_',df$parent_id)
length(toDel)
df <- df[-toDel,]

# remove individual df objects to save memory
rm(df0,df1,df2,df3,df4,df5,df6,df7,df8,df9)

View(df)

# get number of replies for each comment

# the t1 prefix denotes comments, and we create a new column with this prefix removed, so we can match id to parent_id directly
df$parent_id_fixed <- gsub("t1_","",df$parent_id)

# CONVERT TO DATA TABLE FOR SPEED
require(data.table)
df_datatable <- as.data.table(df)
setkey(df_datatable,"id") # set a key for speed 

View(df_datatable) # note that after setting a key on the datatable, it sorts the rows, so it's thereby different from original dataframe 

# test for the 14th one 
# (i.e. which [fixed] parent IDs match the id of this comment? in other words, how many direct replies did this comment get?)
nrow(df_datatable[parent_id_fixed==df_datatable[14,id]])

# test for the first 50 
for (i in 1:50) {
  print(nrow(df_datatable[parent_id_fixed==df_datatable[i,id]]))
}

testFirst50 <- sapply(df_datatable[1:50,id],function(x){
  nrow(df_datatable[parent_id_fixed==x])
})

# run for all of the comments
totalReplies <- sapply(df_datatable[,id],function(x){
  nrow(df_datatable[parent_id_fixed==x])
})

# add the total replies for each comment back into the datatable
df_datatable <- cbind(df_datatable,totalReplies)

## now, we can ask what is the average number of replies for downvoted vs upvoted comments

# first, we look at distribution stats overall:
summary(df_datatable$totalReplies)
# and also the distribution for vote scores
summary(df_datatable$score)

# downvoted summary stats of total replies
summary(df_datatable[score < 1]$totalReplies)

# upvoted summary stats
summary(df_datatable[score > 1]$totalReplies)

# slightly downvoted 
summary(df_datatable[score < 1 & score > -10]$totalReplies)
# moderately downvoted 
summary(df_datatable[score <= -11 & score > -50]$totalReplies)
# greatly downvoted 
summary(df_datatable[score <= -50 & score > -200]$totalReplies)
# very greatly downvoted 
summary(df_datatable[score <= -200 & score > -1000]$totalReplies)
# extremely downvoted 
summary(df_datatable[score <= -1000]$totalReplies)

# slightly downvoted 
length(df_datatable[score < 1 & score > -10]$totalReplies)
# moderately downvoted 
length(df_datatable[score <= -11 & score > -50]$totalReplies)
# greatly downvoted 
length(df_datatable[score <= -50 & score > -200]$totalReplies)
# very greatly downvoted 
length(df_datatable[score <= -200 & score > -1000]$totalReplies)
# extremely downvoted 
length(df_datatable[score <= -1000]$totalReplies)

# slightly upvoted 
summary(df_datatable[score > 2 & score <= 10]$totalReplies)
# moderately upvoted 
summary(df_datatable[score > 11 & score <= 50]$totalReplies)
# greatly upvoted 
summary(df_datatable[score > 51 & score <= 200]$totalReplies)
# very greatly upvoted 
summary(df_datatable[score > 201 & score <= 1000]$totalReplies)
# extremely upvoted 
summary(df_datatable[score > 1000]$totalReplies)

# slightly upvoted 
length(df_datatable[score > 2 & score <= 10]$totalReplies)
# moderately upvoted 
length(df_datatable[score > 11 & score <= 50]$totalReplies)
# greatly upvoted 
length(df_datatable[score > 51 & score <= 200]$totalReplies)
# very greatly upvoted 
length(df_datatable[score > 201 & score <= 1000]$totalReplies)
# extremely upvoted 
length(df_datatable[score > 1000]$totalReplies)

# significance tests
t.test(df_datatable[score < 1 & score > -10]$totalReplies,df_datatable[score > 2 & score <= 10]$totalReplies)
t.test(df_datatable[score <= -11 & score > -50]$totalReplies,df_datatable[score > 11 & score <= 50]$totalReplies)
t.test(df_datatable[score <= -50 & score > -200]$totalReplies,df_datatable[score > 51 & score <= 200]$totalReplies)
t.test(df_datatable[score <= -200 & score > -1000]$totalReplies,df_datatable[score > 201 & score <= 1000]$totalReplies)
t.test(df_datatable[score <= -1000]$totalReplies,df_datatable[score > 1000]$totalReplies)