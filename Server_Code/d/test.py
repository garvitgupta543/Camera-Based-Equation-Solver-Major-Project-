import numpy as np
import csv
import random
import nltk
from numpy import genfromtxt
import pandas as pd1

import pandas as pd

from sklearn import svm

#print "hello"


#with open('dataset.csv', 'w') as output:
 #   output.write(train_data_contents)
    
#train_dataframe = pd.read_csv('dataset4.csv')



#train_labels = train_dataframe.class_label
#labels = list(set(train_labels))
#train_labels = np.array([labels.index(x) for x in train_labels])
#train_features = train_dataframe.iloc[0:,:1024]

#train_features = np.array(train_features)

#train_labels = train_dataframe.iloc[:,1024:]
#train_labels = list(train_labels)
#labels = np.array(train_labels)

#train_labels = np.array([labels[x][0] for x in range(len(labels))])
#print set(train_labels)

#classifier = svm.SVC(kernel='linear',gamma=0.00001, C=100.0)
#classifier.fit(train_features, train_labels)
#print "hello"
from sklearn.externals import joblib
#joblib.dump(classifier, 'trainfile.pkl')

classifier = joblib.load(r'G:\d\trainfile.pkl')




#print "training done "


test_dataframe = pd.read_csv('G:\d\cvector.csv')


#test_labels = test_dataframe.iloc[:,:]
#train_labels = list(train_labels)
#labels = np.array(test_labels)
#test_labels = np.array([labels[x][0] for x in range(len(labels))])

test_features = test_dataframe.iloc[:,:]
test_features = np.array(test_features)

#print test_features





results = classifier.predict(test_features)
str1 = ""
#print results
for x in range(len(results)):
	if results[x]==10:
		str1 = str1 + '*'
	elif results[x]==11:
		str1 = str1 + '+'
	elif results[x]==12:
		str1 = str1 + '-'
	else:
		str1 = str1 + str(results[x])


print str1
#print results


#num_correct = (results == test_labels).sum()
#print num_correct
#recall =  num_correct*100 / len(test_labels)
#print "model accuracy (%): ", recall, "%"

#print "train labels: "
#print train_labels
#print 
#print "train features:"
#print train_features
    



