<?php

/* EqSolverSolve.php */
/*   Takes given input equation and evalute in Matlab */

/* Get input and configuration parameters */
$bData = file_get_contents('php://input');

/* Setup time stamp for different queries */
//$fTimeStamp = time(true);
//$sTimeStamp = sprintf('%.0f', $fTimeStamp*100);

/* Setup time stamp for different queries */
 $fCurrTime  = time(true); 
 $fJune01    = 1338447600;
 $fDiffSec   = $fCurrTime - $fJune01;
 $fHour      = floor( ($fDiffSec%86400)/3600);
 $fMinute    = floor( ($fDiffSec%3600)/60 );
 $sTimeStamp = sprintf('%02d%02d_%.0f', $fHour, $fMinute, $fDiffSec%10);


/* Setup file names and upload paths */
$sInputEqnFile 		= './equation'.$sTimeStamp.'.txt';
$photo_upload_path 	= 'C:/wamp/www/upload/'.$sInputEqnFile;
$sOutputFileBase        = 'C:/wamp/www/upload/EqSolverOutput'.$sTimeStamp;
$sOutputFile            = $sOutputFileBase.'.txt';

/* Save the uploaded equation to file */
file_put_contents( $photo_upload_path, $bData);
sleep(3);

/* Solve given equation in MATLAB */
$command = "matlab -nojvm -nodesktop -nodisplay -r \"EqSolverSolve('$photo_upload_path', '$sOutputFile');exit\"";
exec($command);

/* Read the final results */
/* $file = 'C:/wamp/www/upload/EqSolverFinal.txt'; */
$file = $sOutputFile;
$cnt = 0;
while(!file_exists($file) && ($cnt < 25)) {
	sleep(1);
	$cnt = $cnt+1;
} 
sleep(1);

if (!file_exists($file)) {
	echo "File was not created.";
}
else{
	echo file_get_contents($file ); 
}


$command = "del /F C:\wamp\www\upload\tessLineImg.txt"; 
exec($command);
$command = "del /F C:\wamp\www\upload\lineImgCorr.jpg";
exec($command);
$command = "del /F C:\wamp\www\upload\TessOutput.txt";
exec($command);
$command = "del /F C:\wamp\www\upload\svmOutput.txt";
exec($command);

?>
