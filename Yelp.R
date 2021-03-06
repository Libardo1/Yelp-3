require(igraph)
require(Matrix)
rm(list=ls(all=TRUE))
edgelist <- read.csv('C:\\Users\\esavin\\Documents\\Academic articles\\network_graph.txt',sep = " ",header = FALSE, col.names = c('user','review','business','date'))
sample <- edgelist[1:1000,]
sample$date <- as.Date(sample$date)
sample <- sample[order(sample$date),]
m<-mean(as.Date(edgelist$date))
s<-split(sample, sample$date < m)
sample_a<-as.data.frame(s[1]) #after data frame
sample_b<-as.data.frame(s[2]) #before data frame
#g <- graph.data.frame(sample[,c(1,3)],directed = FALSE)
g <- graph.data.frame(sample[,c(1,3)],directed = FALSE)
V(g)$type <- V(g)$name %in% sample[,1]
#get.edgelist(g, names=TRUE) to verify this was done properly
adj <- get.adjacency(g, sparse = TRUE)
eig <- eigen(adj)
ex<-expm(adj)
#isSymmetric(as.matrix(adj))
#calculate the eigenvalues and eigenvectors using ARPACK algorithm
f2 <- function(x, extra=NULL) { cat("."); as.vector(adj %*% x) }
Sys.time()
baev <- arpack(f2, sym=TRUE, options=list(n=vcount(g), nev=100, ncv=120,
                                          which="LM", maxiter=200))
Sys.time()
g_b <- graph.data.frame(sample_b[,c(1,3)],directed = FALSE)
V(g_b)$type <- V(g_b)$name %in% sample[,1]
#get.edgelist(g, names=TRUE) to verify this was done properly
adj <- get.adjacency(g_b, sparse = TRUE)
#isSymmetric(as.matrix(adj))
#calculate the eigenvalues and eigenvectors using ARPACK algorithm
f2 <- function(x, extra=NULL) { cat("."); as.vector(adj %*% x) }
Sys.time()
baev_b <- arpack(f2, sym=TRUE, options=list(n=vcount(g_b), nev=100, ncv=120,
                                            which="LM", maxiter=200))
Sys.time()
plot(baev_b$values,baev$values,xlab = 'lamda_i before',ylab = 'lamda_i before and after',type = "p")
#eigen - the regular method
