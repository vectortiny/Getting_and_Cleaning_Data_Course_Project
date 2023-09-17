# Getting and Cleaning Data Course Project

## System settings
+ OS: Ventura 13.2
+ R version 4.3.1 (2023-06-16) -- "Beagle Scouts"
+ RStudio 2023.06.1+524 "Mountain Hydrangea"

# Run R-Script: `run_analysis.R`
1. Set working directory if needed
2. Run `run_analysis.R`
   1. load librarys
   2. download and unzip the raw data
   3. set file and folder paths
   4. read feature data
   5. read test data
   6. read train data
   7. combine both test and train data
   8. extract feature with mean and std
   9. add descriptive name to the measurements
   10. calculate the average by group
   11. export tidy data to txt-file
4. The R-Script will create a TXT-file as export of the `tidy_data`: `tidy_data.txt`
