library(jsonlite)
setwd('/mnt/shareddisk/Sophia/testdb/')
load('/mnt/shareddisk/Sophia/testdb/omics.cancer.RData')
first <- sapply(omics.cancer, function(organ){
            sapply(organ, function(dt){
              dt <- dt[order(rownames(dt)),]
              # take only the first 200 columns in decreasing order of their variance:
              dt <- as.data.frame(dt[1:floor(nrow(dt)*55/100),order(apply(dt, 2, sd), decreasing = TRUE)[1:min(200, ncol(dt))]]) 
              ind <- 0
              vars <- lapply(names(dt), function(x){
                ind <<- ind + 1
                list(name=x, entityType='PARTICIPANT', valueType='decimal', isRepeatable='false', index=ind)
              })
              dt <-cbind(rownames(dt), dt)
              names(dt)[1]<- 'PARTICIPANT_ID'
              list(dt = dt, vars = vars) 
            }, simplify = FALSE)
}, simplify = FALSE)

second <- sapply(omics.cancer, function(organ){
  sapply(organ, function(dt){
    dt <- dt[order(rownames(dt)),]
    dt <- as.data.frame(dt[floor(nrow(dt)*55/100 + 1):nrow(dt),order(apply(dt, 2, sd), decreasing = TRUE)[1:min(200, ncol(dt))]])
    dt <-cbind(rownames(dt), dt)
    names(dt)[1]<- 'PARTICIPANT_ID'
    dt 
  }, simplify = FALSE)
}, simplify = FALSE)

str(first$Breast$Survival)
str(second$Breast$Gene)

sapply(names(first), function(organ){
  sapply(names(first[[organ]]), function(dt){
    nm <- paste0(toupper(organ), '_', toupper(dt)) 
    write.csv(first[[organ]][[dt]]$dt, file = paste0(nm, '_1.csv'), sep=', ', row.names = FALSE)
    vars$name <- nm
    vars$entityType <- 'PARTICIPANT'
    write_json(vars, paste0('variables_', nm, '.json'))
  })
})

sapply(names(second), function(organ){
  sapply(names(second[[organ]]), function(dt){
    write.csv(second[[organ]][[dt]], file = paste0(organ, '_', dt, '_2.csv'), sep=', ', row.names = FALSE)
  })
})