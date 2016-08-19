<?php

$command = "del /F C:\wamp\www\upload\tessLineImg.txt"; 
exec($command);
$command = "del /F C:\wamp\www\upload\lineImgCorr.jpg";
exec($command);
$command = "del /F C:\wamp\www\upload\TessOutput.txt";
exec($command);
$command = "del /F C:\wamp\www\upload\svmOutput.txt";
exec($command);

/* Get input and configuration parameters */
$bData = file_get_contents('php://input');

/* Setup time stamp for different queries */
 $fCurrTime  = time(true); 
 $fJune01    = 1338447600;
 $fDiffSec   = $fCurrTime - $fJune01;
 $fHour      = floor( ($fDiffSec%86400)/3600);
 $fMinute    = floor( ($fDiffSec%3600)/60 );
 $sTimeStamp = sprintf('%02d%02d_%.0f', $fHour, $fMinute, $fDiffSec%10);

//$sTimeStamp = time();

/* Setup file names and upload paths */
$sInputFileJpg 		= './inputImg_'.$sTimeStamp.'.jpg';
$photo_upload_path 	= './upload/'.$sInputFileJpg;

/* Save the uploaded jpg image to file */
file_put_contents( $photo_upload_path, $bData);

/* Read the final results */

$command = "matlab -nojvm -nodesktop -nodisplay -r \"EqSolverProcessWritten('$photo_upload_path');exit\"";
	exec($command);
	
$file = 'C:/wamp/www/upload/svmOutput.txt';
$cnt = 0;
while(!file_exists($file) && ($cnt < 20)) {
	sleep(1);
	$cnt = $cnt+1;
} 
sleep(2);

/* Check to see if image is on server */
if (!file_exists($file)) {
	echo "Bad image.  Please try again.";
}
else {
	echo file_get_contents($file); 
}
?>
