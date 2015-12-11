The `rMoore` package is a wrapper to the [euPMC](https://github.com/cstubben/euPMC) package and finds publications mentioning a genome project funded by the Gordon and Betty Moore Moore Foundation.  The main function `citations` requires a Moore project table with three columns containing valid Europe PMC search [queries](https://europepmc.org/Help#directsearch).  An example table from [GBMF521](https://www.moore.org/grants/list/GBMF521) is included in the package or you can load one using `read.xls` in the `gdata` package. 



```r
data(mg)
mg <- read.xls("Moore_521.xlsx", stringsAsFactors=FALSE)
```

The project table should contain a bioproject title, ID, accessions, PubMed ID of the genome publication, synonyms and three search columns.


```r
t(mg[5,])
                                                                    
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

The `cites`, `keywords` and `accs` columns are usually generated automatically using the Excel functions below.  If needed, these can be replaced by specific queries to narrow or broaden searches.

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
Algoriphagus machipongonensis PR1      alpha proteobacterium BAL199 
                               27                                12 
```

```r
table(x[[1]]$search)
*KA   G  GK   K  KA 
  1   3   4  18   1 
```

This code returns all 177 project citations.


```r
mg2 <- citations(mg)
```

Five additional functions work with the list of data.frames from the `citations` output.   `combine_pubs` merges all tables into a single data.frame while `unique_pubs` groups the publications by project and includes columns listing the number and names of any cited project. An option can be used to limit the results to matches in the search column. 


```r
x1 <- combine_pubs(mg2)
#5606 rows
x2 <- unique_pubs(mg2)
#2370 rows
x4 <- unique_pubs(mg2, "A")
#174 rows
```
`summary_pubs` counts the number of citations by genome, keyword and accession.  Since papers may be found by multiple searches, the total citations may be less than the sum of the last three columns.


```r
summary_pubs(mg2, mg)[1:7,]

                            Project Citations Genome Keywords Accessions
1      Acaryochloris sp. CCMEE 5410        15      9        7          1
2      Aciduliprofundum boonei T469        27      9       18          0
3               Ahrensia sp. R2A130         5      0        5          0
4             Alcanivorax sp. DG881         6      0        6          0
5 Algoriphagus machipongonensis PR1        27      7       24          2
6      alpha proteobacterium BAL199        12      0       11          2
7     alpha proteobacterium HIMB114        43     32       12          0
```

This function includes a format option to output a DataTable or Excel file with links to files generated by `write_pubs` and citation, keyword and accession searches at Europe PMC.  The genome publication may optionally be included in the tables..


```r
summary_pubs(mg2, mg, format="DT")
summary_pubs(mg2, mg, format="Excel")
```

`write_pubs` loops through the `citations` output and writes DataTables to a file for each project.  Use `setwd` to change the working directory to a location where you would like to write 177 HTML files.  


```r
setwd("path/to/DT")
write_pubs(mg2)
```

Finally, `plot_pubs` creates a  `xts` object and plots an interactive dygraph (best viewed in RStudio).  In this example, only the genome citations from 87 projects are plotted.


```r
plot_pubs(mg2, "G")
```



