rescale <- function(x, digits = 2) {

  if(class(x) %in% 'data.frame') warning('Object x is not a vector \n' , 
'Such ineptitude will not be tolerated \n' ,
'You have seven days to live')  
    
  rng <- range(x, na.rm = TRUE)
  scaled <- (x - rng[1])/(rng[2] - rng[1])
  round(scaled, digits = digits)
  
}



# set.seed(123)
# vec <- runif(10, min = 1, max = 10)
# rescale(vec)
# rescale(mtcars)
