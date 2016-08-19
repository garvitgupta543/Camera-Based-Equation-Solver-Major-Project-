<?php

/* Get input and configuration parameters */
$bData = file_get_contents('php://input');
/* Setup file names and upload paths */
$sInputFileJpg 		= './img.jpg';
$photo_upload_path 	= 'C:/Users/Miffi/Dropbox/EE368 Project/Project Code/images/'.$sInputFileJpg;

/* Save the uploaded jpg image to file */
file_put_contents( $photo_upload_path, $bData);

/* Read the final results */

$command = "matlab -nojvm -nodesktop -nodisplay -r \"train();exit\"";
	exec($command);
	
?>
