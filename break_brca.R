library(jsonlite)
library(tidyr)
setwd('/mnt/shareddisk/opal-test-data/')
#load('omics.cancer.RData')
load('brca.RData')
dfs <- brca[1:3]
  first <- sapply(dfs, function(dt){
  
             
             dt<- pivot_longer(data.frame(PersonID=rownames(dt), dt),  !PersonID, names_to = "variable", values_to = "value")
            vars <- list(
                  list(name='PersonID', entityType='PARTICIPANT', valueType='text', isRepeatable=FALSE, index=ind),
                  list(name='variable', entityType='PARTICIPANT', valueType='text', isRepeatable=FALSE, index=ind),
                  list(name='value', entityType='PARTICIPANT', valueType='decimal', isRepeatable=FALSE, index=ind)
             )
            dt <- data.frame(PARTICIPANT_ID=1:nrow(dt), dt)
            list(dt = dt, vars = vars) 
}, simplify = FALSE)

second <- sapply(omics.cancer, function(organ){
  sapply(organ, function(dt){
    dt <- dt[order(rownames(dt)),]
    dt <- as.data.frame(dt[floor(nrow(dt)*55/100 + 1):nrow(dt),order(apply(dt, 2, sd), decreasing = TRUE)[1:min(200, ncol(dt))]])
    ind <- 0
    dt <-cbind(rownames(dt), dt)
    names(dt)[1]<- 'PARTICIPANT_ID'
    list(dt=dt) 
  }, simplify = FALSE)
}, simplify = FALSE)

str(first$Breast$Survival)
str(second$Breast$Gene)

sapply(names(first), function(organ){
  sapply(names(first[[organ]]), function(dt){
    nm <- paste0(toupper(organ), '_', toupper(dt)) 
    write.csv(first[[organ]][[dt]]$dt, file = paste0(nm, '_1.csv'), sep=', ', row.names = FALSE)
    vars <- first[[organ]][[dt]]$vars

    vars <- list(name=nm, entityType='PARTICIPANT', variables=vars)
    write_json(vars, paste0('variables_', nm, '.json'), auto_unbox=TRUE)
  })
})

nms <-sapply(names(second), function(organ){
  sapply(names(second[[organ]]), function(dt){
    nm <- paste0(toupper(organ), '_', toupper(dt)) 
    write.csv(second[[organ]][[dt]]$dt, file = paste0(nm, '_2.csv'), sep=', ', row.names = FALSE)
    nm
  })
})
write.table(t(as.vector(nms)), file='./names', quote = FALSE, row.names = FALSE, col.names = FALSE, sep = ' ')
# and the total, for opal3
sapply(names(omics.cancer), function(organ){
  sapply(names(omics.cancer[[organ]]), function(dt){
    all.together <- rbind(first[[organ]][[dt]]$dt, second[[organ]][[dt]]$dt)
    nm <- paste0(toupper(organ), '_', toupper(dt)) 
    write.csv(all.together, file = paste0(nm, '_3.csv'), sep=', ', row.names = FALSE)
  })
})



