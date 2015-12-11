

The `rMoore` package is a wrapper to the [euPMC](https://github.com/cstubben/euPMC) package and finds publications mentioning a genome project funded by the Gordon and Betty Moore Foundation.  The main function `citations` requires a Moore project table with three columns containing valid Europe PMC search [queries](https://europepmc.org/Help#directsearch).  An example table from [GBMF521](https://www.moore.org/grants/list/GBMF521) is included in the package or you can load one using `read.xls` in the `gdata` package. 



```r
data(mg)
mg <- read.xls("Moore_521.xlsx", stringsAsFactors=FALSE)
```

The project table should contain a bioproject title, ID, accessions, PubMed ID of the genome publication, synonyms and three search columns.


```r
t(mg[5,])
```

```
             5                                                                       
Project      "Algoriphagus machipongonensis PR1"                                     
ID           "PRJNA18947"                                                            
WGS          "AAXU"                                                                  
GenBank      "CM001023"                                                              
RefSeq       "NZ_CM001023"                                                           
SRA          ""                                                                      
PubMed       "21183675"                                                              
Synonyms     "Algoriphagus sp. PR1"                                                  
Investigator "Nicole King"                                                           
Notes        ""                                                                      
cites        "cites:21183675_MED"                                                    
keywords     "((Algoriphagus machipongonensis PR1) OR (Algoriphagus sp. PR1)) genome"
accs         "AAXU0* OR CM001023 OR NZ_CM001023"                                     
```

The `cites`, `keywords` and `accs` columns are usually generated automatically by using Excel functions.  If needed, these can be replaced by specific queries to narrow or broaden searches.

```
=IF(G6="", "", CONCATENATE("cites:", G6, "_MED"))
=IF(H6="", CONCATENATE(A6, " genome"), CONCATENATE("((", A6, ") OR (", H6, ")) genome"))
=IF(C6="",IF(D6="","",CONCATENATE(D6," OR ",E6)),IF(D6="",CONCATENATE(C6,"0*"), CONCATENATE(C6,"0* OR ",D6," OR ",E6)))
```

The `citations` functions uses the Moore table as input and searches for the genome paper, citations, keywords and accession numbers.  For each project, the results are combined into a single table with an additional column containing the search criteria used to find the paper, where *=genome paper, G=cites Genome paper, K=matches Keywords, and A=mentions Accession.  Mutliple projects are combined into a list of data.frames.


```r
x <- citations(mg[5:6,])
```

```
ROW 1. Algoriphagus machipongonensis PR1
Searching EXT_ID:21183675
1 Result
Searching cites:21183675_MED
7 Results
Searching ((Algoriphagus machipongonensis PR1) OR (Algoriphagus sp. PR1)) genome
24 Results
Searching AAXU0* OR CM001023 OR NZ_CM001023
2 Results
ROW 2. alpha proteobacterium BAL199
Searching alpha proteobacterium BAL199 genome
11 Results
Searching ABHC0*
2 Results
```

```r
sapply(x, nrow)
```

```
Algoriphagus machipongonensis PR1      alpha proteobacterium BAL199 
                               27                                12 
```

```r
table(x[[1]]$search)
```

```

*KA   G  GK   K  KA 
  1   3   4  18   1 
```

This code returns all 177 project citations.


```r
mg2 <- citations(mg)
```

Additional functions will be included to output publications lists with the search criteria,  write summary tables to Excel or Javascript datatables, group publications by project or create large `xts` objects for plotting dygraphs.




