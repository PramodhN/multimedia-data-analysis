'''
Created on Dec 5, 2014

@author: jadiel
'''

import sys
import collections
from collections import OrderedDict
import math
import os
from scipy.integrate import quad

import decisiontree
from decisiontree import Observation

Collection=collections.namedtuple("Collection", "file_path data_structure")

def getFileList(directory):
    """
    Returns a list with the names of a file in a given directory
    """
    from os import walk
    from os.path import join
        
    f=[]
    for (dirpath, dirnames, filenames) in walk(directory):
        f.extend([join(dirpath, a) for a in filenames])
        break
    return f

def readFile(file_p):
    '''
    Reads the file in the following format: a dictionary of states with an array of 
    numbers.
    '''
    with open(file_p, "r") as f:
        counter=0
        dataset=OrderedDict()
        for line in f:
            if counter==0:
                line=line.strip()
                states=line.split(",")
                for i in range(2, len(states)):
                    dataset[states[i]]=list()
            else:
                line=line.strip()
                values=line.split(",")
                for i in range(2, len(values)):
                    dataset[states[i]].append(float(values[i]))
            
            counter+=1
        return dataset;
    

def make_gauss(sigma, mu, N=1):
    """
    Gaussian function
    """
    k=N/(sigma*math.sqrt(2*math.pi))
    s=-1.0/(2*sigma*sigma)
    def f(x):
        return k*math.exp(s*(x-mu)*(x-mu))
    return f



def normalize(datastructure):
    '''
    Takes the data structure read from a file and place every element down to between 0 and 1 
    '''
    min_val=sys.maxint
    max_val=-sys.maxint-1
    
    #1. Finding minimum and maximum
    
    for key in datastructure.keys():
        values=datastructure[key]
        for value in values:
            if value<min_val:
                min_val=value
            if value>max_val:
                max_val=value
    
    #2. Normalizing using the new minimum and maximum
    for key in datastructure.keys():
        values=datastructure[key]
        for i in range(len(values)):
            values[i]=(values[i]-min_val)/(max_val-min_val)
    
         

def calculateBands(r):
    """
    Calculates the bands using the formula from the class, starting from the bottom.
    Example of use of the quad funciton:
    result, error=quad(make_gauss(N=1, sigma=1, mu=0), -float('inf'), float('inf'))
    """
    bands=[0]*r
                
    denominator, error=quad(make_gauss(N=1, sigma=0.25, mu=0.0), 0, 1)
    
    for i in range(1, r+1):
        
        numerator, error=quad(make_gauss(N=1, sigma=0.25, mu=0.0), float(i-1)/r, float(i)/r)
        i_band_length=numerator/denominator
        bands[i-1]=(bands[i-2]+i_band_length)
    
    return bands
   

def switch_values(datastructure, bands):
    """
    Switches the values of the datastructure to the corresponding value at the center of the band where
    the value belongs 
    """
    #1. Calculate the bands centers
    band_centers=[0]*len(bands)
    for i in range(len(bands)):
        if i==0:
            length=bands[0]
            start=0
        else:
            length=abs(bands[i]-bands[i-1])
            start=bands[i-1]
        band_centers[i]=(start+(length/2))
    
    #2. Switch the values of the datastructure to the band centers.
    
    
    for key in datastructure.keys():
        values=datastructure[key]
        for i in range(len(values)):
                
        #Find the closest band and replace by that band's center.
            j=0
            while j<len(bands):
                if values[i]<bands[j]:
                    values[i]=band_centers[j]
                    break
                j+=1
    
    
def readLabels(directory, labels_file):
    
    file_label_d = dict()
    with open(labels_file, "r") as f:
        count = 0
        for line in f:
            if count != 0:
                line = line.strip()
                a = line.find(",")
                filePath = directory + os.sep + line[:a]
                label = line[a+1:]
                file_label_d[filePath]=label
                
            count +=1
    
    return file_label_d


def createObservations(datastructures, file_label_d):
    training_observations = list()
    testing_observations = list()
    
    
    
    for collection in datastructures:
        file_p = collection.file_path
        data_structure = collection.data_structure
        
        data_structure_l = convert_to_list(data_structure)
        
        if file_p in file_label_d:
            training_observations.append(Observation(data_structure_l, file_label_d[file_p]))
            
        else:
            testing_observations.append(Observation(data_structure_l, None))
            
    
    return training_observations, testing_observations

def convert_to_list(data_structure):
    vector_l = list()    
    for key in data_structure:
        vector_l.extend(data_structure[key])
        
    return vector_l

def main():
    directory = sys.argv[1]
    labels_file = sys.argv[2]
    w = int(sys.argv[3])
    h = int(sys.argv[4])
    r = int(sys.argv[5])
    
    print("Reading files")
    #0. Get the names of all the files
    list_of_files=getFileList(directory)
        
    #0. Read the files into an OrderedDict datastructure.
    datastructures=list()
    for file_p in list_of_files:
        
        datastructures.append(Collection(file_path=file_p, data_structure=readFile(file_p)))
    
    print("Normalizing datastructures")
    #1. (1a)For each data file, normalize data to values between 0.0 and 1.0
    
    for collection in datastructures:
        
        data_structure=collection.data_structure
        normalize(data_structure)    
    
    
    
    #2. (1b)Determine the lengths and the ranges for the different bands.
    bands=calculateBands(r)
    
    
    #3. (1b) For each data file, change each of the values by the value of the center
    #of the band to which that value corresponds.
    
    for pair in datastructures:
        datastructure=pair[1]
        switch_values(datastructure, bands);
    
    print("Creating training and testing sets")
    #4. Read labels
    file_label_l = readLabels(directory, labels_file)
    
    (training_observations, testing_observations) = createObservations(datastructures, file_label_l)
    
    
    
    print("training decision tree")
    decision_tree_root = decisiontree.train(training_observations)
    
    
    
    print("testing decision tree")
    predictions = decisiontree.predict(decision_tree_root, testing_observations)   
    print(predictions)
    
    #DO NOT USE THE WINDOW CREATION CODE
    '''    
    #4. For each data file:
    for pair in datastructures:
        file_name=pair.file_path
        a=file_name.rfind(os.sep)
        b=file_name.rfind(".")
        new_file_name=file_name[:a+1]+"epidemic_word_file_"+file_name[a+1:b]
        
        datastructure=pair.data_structure
        new_datastructure=OrderedDict()
        
        #4.1 For each state s:
        for key in datastructure.keys():
            time_series=datastructure[key]
            tuples_list=list()
            new_datastructure[key]=tuples_list
            
            t=0
            while t<len(time_series):
                
                #TODO ******* A question mark here, what if w does not divide len(time_series))? *****
                window=time_series[t:min(t+w, len(time_series)-1)]
                new_datastructure[key].append(((key, t), window))
                t=t+h
                             
        print new_datastructure['US-CT'];
        with open(new_file_name, "w+") as f:
            f.write(str(new_datastructure))
       
       '''     
if __name__=="__main__":
    main();