fopen('all') % List all open files
fclose('all')
system('G:\project_reference\libsvm\windows\svm-scale -l -1 -u 1 -s range G:\xampp\htdocs\major\datasetlib.txt > G:\xampp\htdocs\major\NewDatasetlib');
system('G:\project_reference\libsvm\windows\svm-train NewDatasetlib');