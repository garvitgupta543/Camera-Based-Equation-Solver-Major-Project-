<?php
echo $_FILES['image']['name'] . '<br/>';


//ini_set('upload_max_filesize', '10M');
//ini_set('post_max_size', '10M');
//ini_set('max_input_time', 300);
//ini_set('max_execution_time', 300);

$myfile = fopen("testfile.txt", "w");
fwrite($myfile, '0');
fclose($myfile);

$target_path = "";

$target_path = $target_path . basename($_FILES['image']['name']);

try {
    //throw exception if can't move the file
    if (!move_uploaded_file($_FILES['image']['tmp_name'], $target_path)) {
        throw new Exception('Could not move file');
    }

    $command = "matlab -nojvm -nodesktop -nodisplay -r \"EqSolverProcessWritten('test.jpg');exit\"";
	exec($command);
	$n = 0;
while($n==0)
{
	$file = fopen("testfile.txt", "r");
	$num=fgets($file);
	$n = (int)$num;
	fclose($file);


}



system("python train.py");


	echo "<img src='/" . bin . "' alt='error'>";

} catch (Exception $e) {
    die('File did not upload: ' . $e->getMessage());
}








?>