## Installing packages. This will be seen by any jupyter since they are installed in the R environment
install.packages("knitr")
install.packages("remotes")
install.packages("markmyassignment")

remotes::install_github(
                         "avehtari/BDA_course_Aalto" ,
                         subdir = "rpackage"         , 
                         upgrade="never"
                       )
