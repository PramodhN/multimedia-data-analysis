CSE 515 Multimedia and Web Databases Course Project
===================================================

Setup
=====
 - The working directory of Matlab should be shifted to the folder where this codes is present.

Phase 1 Sample Execution
========================

Task 1: Epidemic word file
--------------------------
- Run the method - phase1task1 in Matlab. 
- The arguments for this method are directory of simulation files, resolution, window size, shift length.
- The file 'InputValues.csv' is created after executing phase1task1. Do not delete this file. It is required for phase 2 tasks.
- Example execution - phase1task1('Set_of_Simulation_Files’,10,10,5)

Task 2: Epidemic average and difference files
---------------------------------------------
- Run the method - phase1task2 in Matlab. 
- The arguments for this method are directory of simuation files, connectivity graph file and weight value.
- Example execution – phase1task2( 'Set_of_Simulation_Files’, 'Graphs/LocationMatrix.xlsx', 0.5)
- Now the files 'epidemic_word_file', 'epidemic_word_file_avg', 'epidemic_word_file_diff' are created for each simulation files present in the directory entered.

Task 3: Visualization using heat map
------------------------------------
- Run the method – phase1task3 in Matlab.
- The arguments for this method are the simulation file to be visualized, connectivity graph file and an option (1 or 2 or 3) to use either word, average or difference files.
- Example execution – phase1task3(‘1.csv’,1, 'Graphs/LocationMatrix.csv')

Phase 2 Sample Execution
========================

Task 1 : Time Series Similarity - Execution
-------------------------------------------
- Ensure the word, avg and diff file of corresponding files are present in the working folder

- *Task 1a* - phase2task1a('Demo/Data/1.csv','Demo/Data/2.csv'). The arguments are the files to be compared.
- *Task 1b* - phase2task1b('Demo/Data/1.csv','Demo/Data/2.csv'). The arguments are the files to be compared.
- *Task 1c* - phase2task1c('1.csv','2.csv'). Note - here, the directory structure should not be mentioned for the files.
- *Task 1d* - phase2task1d('1.csv','2.csv'). Note - here, the directory structure should not be mentioned for the files.
- *Task 1e* - phase2task1e('1.csv','2.csv'). Note - here, the directory structure should not be mentioned for the files.
- *Task 1f* - phase2task1e('1.csv','2.csv','Graphs/LocationMatrix.csv'). Note - here, the directory structure should not be mentioned for the files and the location matrix is required as input.
- *Task 1g* - phase2task1e('1.csv','2.csv','Graphs/LocationMatrix.csv'). Note - here, the directory structure should not be mentioned for the files and the location matrix is required as input.
- *Task 1h* - phase2task1e('1.csv','2.csv','Graphs/LocationMatrix.csv'). Note - here, the directory structure should not be mentioned for the files and the location matrix is required as input.

Task 2 : Time Series Search - Execution
---------------------------------------
- Ensure the word, avg and diff file of corresponding files are present in the working folder.

- *Task 2a-h* - phase2task2('query.csv', 'Query_Simulation_File', 4, 'a', 'Set_of_Simulation_Files', 'Graphs/LocationMatrix.csv', 0.2)
- The arguments to be passed for above task are listed below
  - The name of the new query file
  - The directory in which the new query file is placed
  - The number of similar simulations to be visualized
  - The similarity measure to be used ('a'-'h')
  - The directory of existing simulation files
  - The location matrix file. Required for creating word, avg and diff files for the query file.
  - Weight. Value required for creating avg and diff files for the query file.
- *Reading the heatmap* - The first heat map corresponds to the query file. The subsequent heat maps correspond to the 'k' similar simulations.

Task 3 : Latent Epidemic Analysis and Search Tasks#1 - Execution
----------------------------------------------------------------
- *Task 3a* - phase2task3a('Set_of_Simulation_Files',4). The arguments are the directory of simulation files and value of 'r' - the number of latent semantics to be displayed.
- *Task 3b* - phase2task3b('Set_of_Simulation_Files',4). The arguments are the directory of simulation files and value of 'r' - the number of latent semantics to be displayed.
- *Task 3c* - phase2task3c('Set_of_Simulation_Files',4,'a'). The arguments are the directory of simulation files, value of 'r' - the number of latent semantics to be displayed and a choice('a' to 'h') to choose which similarity measure is to be used.
- *Reading the latent semantics* - Based on value of 'r', those many matrices with 2 columns are displayed. Each matrix is in such a way that the first column is the simulation number and the next column is its corresponding score. The simulations are displayed in decreasing order of simulation score for each latent semantic.
- *Task 3d-f* - phase2task3d('query.csv','Query_Simulation_File',4, 'c','Set_of_Simulation_Files','f','Graphs/LocationMatrix.csv')
- The arguments to be passed for above task are listed below
  - The name of the new query file
  - The directory in which the new query file is placed
  - The number of similar simulations to be displayed
  - Choice value 'a' or 'b' or 'c' - to choose either task 3a or 3b or 3c
  - The directory of existing simulation files
  - Choice ('a' to 'h') for similarity measure to be used in case previous choice chosen was 'c'. Otherwise this value can be left empty.
  - Location matrix file for task similarity measure to be used in case previous choice chosen was 'c'. Otherwise this value can be left empty.
- *Note* - The files '3a_S_Matrix.csv', '3a_U_Matrix.csv', '3a_V_Matrix.csv', '3b_DP_Matrix.csv', '3c_S_Matrix.csv', '3c_V_Matrix.csv' and 'UniqueWords.csv' are created after executing tasks 3a, 3b and 3c.

Task 4 : Latent Epidemic Analysis and Search Task#2 - Execution
---------------------------------------------------------------
- *Task 4a* - [X,pivot,map] = phase2task4a('Set_of_Simulation_Files',4,'a','Graphs/LocationMatrix.csv'). The arguments are the directory of simulation files, value of 'r' - the number of latent semantics to be displayed and a choice('a' to 'h') to choose which similarity measure is to be used.
- *Note* - While executing task 4, the values 'X', 'pivot' and 'map' should be stored in a variable as shown above. These values are required for task 4b.
- *Task 4b* - phase2task4b(4,'a',4,'Query_Simulation_File','query.csv',X,pivot,'Set_of_Simulation_Files')
- The arguments to be passed for above task are listed below
  - The number of dimensions in the new space
  - Choice ('a' to 'h') for similarity measure to be used while mapping the query file to the 'r' dimensional space
  - Number of similar simulations to be displayed
  - The directory of query file
  - The name of query file
  - The matrix 'X' obtained from task 4a
  - The matrix 'pivot' obtained from task 4a
  - The directory of existing simulation files

Phase 3 Sample Execution
========================

Task 1: Multi-dimensional index structures and nearest neighbor search task I
-----------------------------------------------------------------------------
- Ensure the word, avg and diff file of corresponding files are present in the working folder
- *Task 1a* – phase3task1a(20,10,’Sample/Data’). The arguments are number of layers, number of hash functions and directory of location of input simulation files.
- *Task 1b* – phase3task1b(‘Query’,’q3.csv’,5,’Sample/Data’). The arguments are directory of query file, the name of the query file, number of similar simulations to be displayed and the directory of existing simulation files.

Task 2: Multi-dimensional index structures and nearest neighbor search task II
------------------------------------------------------------------------------
- *Task 2a* - phase3task2a('Set_of_Simulation_Files',10). The arguments are directory of location of input simulation files, number of bits
- *Task 2b* - phase3task2b('Query','q3.csv',10,5). The arguments are directory of query file, the name of the query file, number of bits and the number of similar simulations to be displayed.

Task 3: Epidemic simulation graph analysis task
-----------------------------------------------
- *Task 3a* - phase3task3a('Input','a',0.8). The arguments are directory of existing similar simulations, choice of similarity measure ('a' to 'h'), threshold value.
- *Task 3b* - phase3task3b('Input','a',5,'Graphs/LocationMatrix.csv'). The arguments are directory of existing similar simulations, choice of similarity measure ('a' to 'h'), number of dominant nodes to be displayed, connectivity graph file.

Task 4: Epidemic simulation classification
------------------------------------------
- *Task 4a* - phase3task4a('Sample/Data','Sample/labels.csv',5). The arguments are directory of existing similar simulations, the location of label file, number of neighbors to look for.
- *Task 4b* - This task has been implemented using python. The execution of task 4b in python console is shown below.
- python discretization.py "Sample/Data" "Sample/labels.csv" 10 10 5
- The arguments passed in command line are directory of existing similar simulations, the location of label file, window size, shift length, resolution