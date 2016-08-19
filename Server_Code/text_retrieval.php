<?php
/*$target_path = "";

$target_path = $target_path . basename($_FILES['image']['name']);

try {
    //throw exception if can't move the file
    if (!move_uploaded_file($_FILES['image']['tmp_name'], $target_path)) {
        throw new Exception('Could not move file');
    }

    $command = "matlab -nojvm -nodesktop -nodisplay -r \"formulaRecg('test.jpg');exit\"";
	exec($command);
	echo "<img src='/" . bin . "' alt='error'>";

} catch (Exception $e) {
    die('File did not upload: ' . $e->getMessage());
}*/  


$python =  exec('python G:\d\test.py');








echo  $python;
?>