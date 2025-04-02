library(jsonlite)
library(tidyr)
setwd('/mnt/shareddisk/opal-test-data/brca')
#load('omics.cancer.RData')
load('brca.RData')
dfs <- brca[1:3]
  first <- sapply(dfs, function(dt){
            dt <- dt[1:floor(nrow(dt)*55/100),]
            dt<- pivot_longer(data.frame(PersonID=rownames(dt), dt),  !PersonID, names_to = "variable", values_to = "value")
            vars <- list(
                  list(name='PersonID', entityType='PARTICIPANT', valueType='text', isRepeatable=FALSE, index=1),
                  list(name='variable', entityType='PARTICIPANT', valueType='text', isRepeatable=FALSE, index=2),
                  list(name='value', entityType='PARTICIPANT', valueType='decimal', isRepeatable=FALSE, index=3)
             )
            dt <- data.frame(PARTICIPANT_ID=1:nrow(dt), dt)
            list(dt = dt, vars = vars) 
}, simplify = FALSE)

  
  second <- sapply(dfs, function(dt){
    dt <- dt[(floor(nrow(dt)*55/100)+1):nrow(dt),]
    dt<- pivot_longer(data.frame(PersonID=rownames(dt), dt),  !PersonID, names_to = "variable", values_to = "value")
    vars <- list(
      list(name='PersonID', entityType='PARTICIPANT', valueType='text', isRepeatable=FALSE, index=1),
      list(name='variable', entityType='PARTICIPANT', valueType='text', isRepeatable=FALSE, index=2),
      list(name='value', entityType='PARTICIPANT', valueType='decimal', isRepeatable=FALSE, index=3)
    )
    dt <- data.frame(PARTICIPANT_ID=1:nrow(dt), dt)
    list(dt = dt, vars = vars) 
  }, simplify = FALSE)
  
  
#second <- sapply(omics.cancer, function(organ){
#  sapply(organ, function(dt){
#    dt <- dt[order(rownames(dt)),]
#    dt <- as.data.frame(dt[floor(nrow(dt)*55/100 + 1):nrow(dt),order(apply(dt, 2, sd), decreasing = TRUE)[1:min(200, ncol(dt))]])
#    ind <- 0
#    dt <-cbind(rownames(dt), dt)
#    names(dt)[1]<- 'PARTICIPANT_ID'
#    list(dt=dt) 
#  }, simplify = FALSE)
#}, simplify = FALSE)

#str(first$Breast$Survival)
#str(second$Breast$Gene)

#sapply(names(first), function(organ){
  sapply(names(first), function(dt){
    nm <- toupper(dt) 
    write.csv(first[[dt]]$dt, file = paste0(nm, '_1.csv'), row.names = FALSE)
    vars <- first[[dt]]$vars

    vars <- list(name=nm, entityType='PARTICIPANT', variables=vars)
    write_json(vars, paste0('variables_', nm, '.json'), auto_unbox=TRUE)
  })
#})

  sapply(names(second), function(dt){
    nm <- toupper(dt) 
    write.csv(first[[dt]]$dt, file = paste0(nm, '_2.csv'), row.names = FALSE)
    vars <- first[[dt]]$vars
    
    vars <- list(name=nm, entityType='PARTICIPANT', variables=vars)
    write_json(vars, paste0('variables_', nm, '.json'), auto_unbox=TRUE)
  })
  
  
  




