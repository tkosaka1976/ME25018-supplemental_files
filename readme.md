Data and scripts for ME25018
====

## Description
This repository provide data and scripts for ME25018.
  
## Usage
data folder includes Supplemental Table 2.  
scripts folder includes scripts for 3 analyses, k-mean clustering, TreeCluster_analyais, and Construct colored tree with CCL.  
The script for k-mean clustring written by Julia using CSV datatable of pairwise distance matrix.  
The scripts for TreeCluster_analyais written by Ruby but python also require for run using Newick format files.  
The scripts for Construct colored tree with CCL written by ruby but r alos require for run using sqlite3 database, Newick file, cluster info output from TreeCluster analysis. Rackfile can be used for run analysis.  

Before the run the scripts, please chack all of the path.  

## Requirement for scripts
datasets:  
  CSV datatable of pairwise distance matrix  
  Newick files from Tree construction tools  
  sqlite3 database for taget genes  
  (if you need itself or more information, please ask)  

computational languages: ruby, R, python, Julia  

gems for ruby:  
  sequel, csv, color-generator, optparse, shellwords  

packages for python:  
  TreeCluster  

packages for r:  
  ggtree (bioconductor), optparse  
  
packages for Julia:  
  Clustering, CSV, DataFrames, Distances, Statistics, Plots  

langage installation and gems and packages please follow all of the lanuage programs homepages.  

