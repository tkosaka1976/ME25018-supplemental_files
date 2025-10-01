Data and scripts for ME25018
====

## Description
This repository provides data and scripts for ME25018.
  
## Usage
The data folder includes Supplemental Table 2.  
The scripts folder includes scripts for 3 analyses: k-means clustering, TreeCluster_analysis, and Construct colored tree with CCL.  
The script for k-means clustering was written by Julia using a CSV datatable of a pairwise distance matrix.  
The scripts for TreeCluster_analysis were written in Ruby, but Python also requires running using Newick format files.  
The scripts for Construct colored tree with CCL written by Ruby, but R also requires running using sqlite3 database, a Newick file, and cluster info output from TreeCluster analysis. Rackfile can be used for running analysis.  

Before running the scripts, please check all of the paths.  

## Requirement for scripts
datasets:  
  CSV datatable of pairwise distance matrix  
  Newick files from Tree construction tools  
  sqlite3 database for target genes  
  (If you need more information, please ask.)  

computational languages: Ruby, R, Python, Julia  

gems for ruby:  
  sequel, csv, color-generator, optparse, shellwords  

packages for Python:  
  TreeCluster  

packages for R:  
  ggtree (bioconductor), optparse  
  
packages for Julia:  
  Clustering, CSV, DataFrames, Distances, Statistics, Plots  

language installation and gems, and packages. Please follow all of the language programs' homepages.  

