results <- rep(NA, 1000)

for(j in 1:1000){
  seats <- 1:100
  taken <- rep(0, 100)
  
  # first person randomly chooses a seat
  choice <- sample(seats, 1)
  taken[choice] <- 1
  for(i in 2:99){
    choice <- ifelse(taken[i] == 0, i, 
                     sample(seats[taken == 0], 1))
    taken[choice] <- 1
    # if(taken[i] == 0){
    #   taken[i] <- 1
    # } else {
    #   choice <- sample(seats[taken == 0], 1)
    #   taken[choice] <- 1
    # }
  }
  
  #taken
  
  results[j] <- taken[100]
}

mean(results)



a <- 20
boxes <- sample(1:a, a, replace=F)
seen <- rep(0, a)

for(i in 1:a){
  selected_boxes <- sample(boxes, a/2, replace=F)
  seen[i] <- i %in% selected_boxes
}
seen



a <- 20
boxes <- sample(1:a, a, replace=F)
seen <- rep(0, a)

for(i in 1:a){
  selected_boxes <- sample(boxes, a/2, replace=F)
  seen[i] <- i %in% selected_boxes
  if(seen[i] == 0){
    seen[i] <- rbinom(1, 1, 0.5)
  }
}
seen




huber <- function(x){
  huber_val <- ifelse(abs(x) <= 1, x^2, 2*abs(x) - 1)
  return(huber_val)
}

quant_resid <- function(mod){
  yhat <- log_reg$fitted.values
  y <- log_reg$y
  u <- ifelse(y == 1, runif(length(y), 1-yhat, 1),
              runif(length(y), 0, 1-yhat))
}


# HW 3
a <- 20
boxes <- sample(1:a, a, replace=F)
seen <- rep(0, a)

for(i in 1:a){
  marker <- i
  for(j in 1:5){
    print(paste(marker, boxes[marker]))
    if(boxes[marker] == i){
      seen[i] <- 1
    }
    marker <- boxes[marker]
  }
}
seen
