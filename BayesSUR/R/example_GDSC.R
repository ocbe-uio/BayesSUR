#' Sample dataset from the GDSC database to test the package 
#'
#' Contains 'n' observations of 's' continuous responses
#' and 'p' covariates
#' 
#' n = 498 ; p = 850 ; s = 7
#'
#' Loading the data will load the associated 
#' blockList and strucutreGraph
#' needed to run the algorithm.
#' 
#' @examples
#' \donttest{
#' 
#' #===============
#' # This script is to do preprocessing of GDSC data and obtain a complete dataset.
#' # You need load the datasets from ftp://ftp.sanger.ac.uk/pub4/cancerrxgene/releases/release-5.0/. 
#' # But downloading and transforming the three used datasets below to *.csv files first.
#' #===============
#' 
#' ## Not run
#' 
#' rm(list=ls())
#' 
#' ##================
#' ##================
#' ## clean the data
#' ##================
#' ##================
#' features <- data.frame(read.csv("/Users/zhiz/Downloads/release-current/gdsc_en_input_w5.csv", head=T))
#' names.fea <- strsplit(rownames(features), "")
#' features <- t(features)
#' p <- c(13321, 13747-13321, 13818-13747)
#' Cell.Line <- rownames(features)
#' features <- data.frame(Cell.Line, features)
#' 
#' ic50_00 <- data.frame(read.csv("/Users/zhiz/Downloads/release-current/gdsc_drug_sensitivity_fitted_data_w5.csv", head=T))
#' ic50_0 <- ic50_00[,c(1,4,7)]
#' drug.id <- data.frame(read.csv("/Users/zhiz/Downloads/release-current/gdsc_tissue_output_w5.csv", head=T))[,c(1,3)]
#' drug.id2 <- drug.id[!duplicated(drug.id$drug.id),]
#' drug.id2 <- drug.id2[drug.id2$drug.id!=1066,] # delete drug.id=1066 since ID1066 and ID156 both correspond drug AZD6482, and no ID1066 in the "suppl.Data1" 
#' drug.id2$drug.name <- as.character(drug.id2$drug.name)
#' drug.id2$drug.name <- substr(drug.id2$drug.name, 1, nchar(drug.id2$drug.name)-6)
#' drug.id2$drug.name <- gsub(" ", "-", drug.id2$drug.name)
#' 
#' library(plyr)
#' ic50 <- ic50_0
#' # mapping the drug_id to drug names in drug sensitivity data set
#' ic50$drug_id <- mapvalues(ic50$drug_id, from = drug.id2[,2], to = drug.id2[,1])
#' colnames(ic50) <- c("Cell.Line", "compound", "IC50")
#' 
#' # transform drug sensitivity overall cell lines to a data matrix
#' y0 <- reshape(ic50, v.names="IC50", timevar="compound", idvar="Cell.Line", direction="wide")
#' y0$Cell.Line <- gsub("-", ".", y0$Cell.Line)
#' 
#' #===============
#' # select nonmissing pharmacological data
#' #===============
#' y00 <- y0
#' m0 <- dim(y0)[2]-1
#' eps <- 0.05
#' # r1.na is better to be not smaller than r2.na
#' r1.na <- 0.3
#' r2.na <- 0.2
#' k <- 1
#' while(sum(is.na(y0[,2:(1+m0)]))>0){
#'   r1.na <- r1.na - eps/k
#'   r2.na <- r1.na - eps/k
#'   k <- k + 1
#'   ## select drugs with <30% (decreasing with k) missing data overall cell lines
#'   na.y <- apply(y0[,2:(1+m0)], 2, function(xx) sum(is.na(xx))/length(xx))
#'   while(sum(na.y<r1.na)<m0){
#'     y0 <- y0[,-c(1+which(na.y>=r1.na))]
#'     m0 <- sum(na.y<r1.na)
#'     na.y <- apply(y0[,2:(1+m0)], 2, function(xx) sum(is.na(xx))/length(xx))
#'   }
#'   
#'   ## select cell lines with treatment of at least 80% (increasing with k) drugs
#'   na.y0 <- apply(y0[,2:(1+m0)], 1, function(xx) sum(is.na(xx))/length(xx))
#'   while(sum(na.y0<r2.na)<(dim(y0)[1])){
#'     y0 <- y0[na.y0<r2.na,]
#'     na.y0 <- apply(y0[,2:(1+m0)], 1, function(xx) sum(is.na(xx))/length(xx))
#'   }
#'   num.na <- sum(is.na(y0[,2:(1+m0)]))
#'   cat("#{NA}=", num.na, "\n", "r1.na =", r1.na, ", r2.na =", r2.na, "\n")
#' }
#' 
#' #===============
#' # combine drug sensitivity, tissues and molecular features
#' #===============
#' yx <- merge(y0, features, by="Cell.Line")
#' names.cell.line <- yx$Cell.Line
#' names.drug <- colnames(yx)[2:(dim(y0)[2])]
#' names.drug <- substr(names.drug, 6, nchar(names.drug))
#' # numbers of gene expression features, copy number festures and muatation features
#' p <- c(13321, 13747-13321, 13818-13747) 
#' num.nonpen <- 13
#' yx <- data.matrix(yx[,-1])
#' y <- yx[,1:(dim(y0)[2]-1)]
#' x <- cbind(yx[,dim(y0)[2]-1+sum(p)+1:num.nonpen], yx[,dim(y0)[2]-1+1:sum(p)])
#' 
#' # delete genes with only one mutated cell line
#' x <- x[,-c(num.nonpen+p[1]+p[2]+which(colSums(x[,num.nonpen+p[1]+p[2]+1:p[3]])<=1))]
#' p[3] <- ncol(x) - num.nonpen - p[1] - p[2]
#' 
#' GDSC <- list(y=y, x=x, p=p, num.nonpen=num.nonpen, names.cell.line=names.cell.line, names.drug=names.drug)
#' 
#' 
#' ##================
#' ##================
#' ## select a small set of drugs
#' ##================
#' ##================
#' 
#' name_drugs <- c("Methotrexate","RDEA119","PD-0325901","CI-1040","AZD6244","Nilotinib","Axitinib")
#' 
#' # extract the drugs' pharmacological profiling and tissue dummy
#' # delete the cell line with extreme log(IC50)=-36.49 for drug "AP-24534"
#' YX0 <- cbind(GDSC$y[-166,colnames(GDSC$y) %in% paste("IC50.",name_drugs,sep="")][,c(1,3,6,4,7,2,5)], GDSC$x[-166,1:GDSC$num.nonpen])
#' colnames(YX0) <- c(name_drugs, colnames(GDSC$x)[1:GDSC$num.nonpen])
#' # extract the genetic information of CNV & MUT
#' X23 <- GDSC$x[-166, GDSC$num.nonpen+GDSC$p[1]+1:(p[2]+p[3])]
#' colnames(X23)[1:p[2]] <- paste(substr(colnames(X23)[1:p[2]], 1, nchar(colnames(X23)[1:p[2]] )-3), ".CNV", sep="")
#' 
#' # locate all genes with CNV or MUT information
#' name_genes_duplicate <- c( substr(colnames(X23)[1:p[2]], 1, nchar(colnames(X23)[1:p[2]])-4),
#'                            substr(colnames(X23)[p[2]+1:p[3]], 1, nchar(colnames(X23)[p[2]+1:p[3]])-4) )
#' name_genes <- name_genes_duplicate[!duplicated(name_genes_duplicate)]
#' 
#' # select the GEX which have the common genes with CNV or MUT
#' X1 <- GDSC$x[-166,GDSC$num.nonpen+which(colnames(GDSC$x)[GDSC$num.nonpen+1:p[1]] %in% name_genes)]
#' p[1] <- ncol(X1)
#' X1 <- log2(X1)
#' 
#' # summary the data information
#' example_GDSC <- list( data=cbind( YX0, X1, X23 ) )
#' example_GDSC$blockList <- list(1:length(name_drugs), length(name_drugs)+1:GDSC$num.nonpen, ncol(YX0)+1:sum(p))
#' 
#' #========================
#' # construct the G matrix: edge potentials in the MRF prior
#' #========================
#' 
#' # edges between drugs: Group1 ("RDEA119","17-AAG","PD-0325901","CI-1040" and "AZD6244") indexed as (2:5)
#' pathway_genes <- read.table("MAPK_pathway.txt")[[1]]
#' Idx_Pathway1 <- which(c(colnames(X1),name_genes_duplicate) %in% pathway_genes)
#' Gmrf_Group1Pathway1 <- t(combn(rep(Idx_Pathway1,each=length(2:5)) + rep((2:5-1)*sum(p),times=length(Idx_Pathway1)), 2))
#' 
#' # edges between drugs: Group2 ("Nilotinib","Axitinib") indexed as (6:7)
#' library(data.table)
#' Idx_Pathway2 <- which( c(colnames(X1),name_genes_duplicate) %like% "BCR" | c(colnames(X1),name_genes_duplicate) %like% "ABL" )[-c(3,5)] # delete gene ABL2
#' Gmrf_Group2Pathway2 <- t(combn(rep(Idx_Pathway2,each=length(6:7)) + rep((6:7-1)*sum(p),times=length(Idx_Pathway2)), 2))
#' 
#' # edges between the common gene in different data sources
#' Gmrf_CommonGene <- NULL
#' list_CommonGene <- list(0)
#' k <- 1
#' for(i in 1:length(name_genes)){
#'   Idx_CommonGene <- which(  c(colnames(X1),name_genes_duplicate) == name_genes[i] )
#'   if(length(Idx_CommonGene) > 1){
#'     Gmrf_CommonGene <- rbind(Gmrf_CommonGene, t(combn(rep(Idx_CommonGene,each=length(name_drugs)) + rep((1:length(name_drugs)-1)*sum(p),times=length(Idx_CommonGene)), 2)))
#'     k <- k+1
#'   }
#' }
#' Gmrf_duplicate <- rbind(  Gmrf_Group1Pathway1, Gmrf_Group2Pathway2, Gmrf_CommonGene )
#' Gmrf <- Gmrf_duplicate[!duplicated(Gmrf_duplicate),]
#' example_GDSC$mrfG <- Gmrf
#' 
#' save(example_GDSC, file="example_GDSC.rda")
#' 
#' # create the target gene names of the two groups of drugs
#' targetGenes <- matrix(Idx_Pathway1,nrow=1)
#' colnames(targetGenes) <- colnames(example_GDSC$data)[length(name_drugs)+GDSC$num.nonpen+targetGenes]
#' write.table(targetGenes,file="targetGeneGroup1.txt",na = "NAN",col.names=TRUE,row.names=FALSE)
#' 
#' targetGenes <- matrix(Idx_Pathway2,nrow=1)
#' colnames(targetGenes) <- colnames(example_GDSC$data)[length(name_drugs)+GDSC$num.nonpen+targetGenes]
#' write.table(targetGenes,file="targetGeneGroup2.txt",na = "NAN",col.names=TRUE,row.names=FALSE)
#' 
#' ## End(Not run)
#' 
#' }
#'
"example_GDSC"