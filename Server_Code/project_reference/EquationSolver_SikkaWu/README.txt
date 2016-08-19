Camera Based Equation Solver on the Android
Aman Sikka and Benny Wu
June 2012


AndroidCode:
  EqSolver: Project for Equation Solver App on Android Device.
  TrainSVM: Project for generating libSVM training data from camera images of single characters.

ServerCode:
  Server code needs to be extracted to ...\www\ folder of a server running PHP.  We used wamp.
  Requires 4 additional folders to be downloaded.
    GML_RANSAC_Matlab_Toolbox_0.2 from http://graphics.cs.msu.ru/en/science/research/machinelearning/ransactoolbox
    libSVM from http://www.csie.ntu.edu.tw/~cjlin/libsvm/
    Tesseract-OCR from http://code.google.com/p/tesseract-ocr/
    vlfeat-0.9.14 from http://www.vlfeat.org/
   
  Our SVM prediction model is included in the libSVM folder.  
  Our Tesseract configuration file is included in Tesseract-OCR\tessdata\config\
  Please see the project report for more details.
