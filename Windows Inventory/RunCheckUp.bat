powershell -executionpolicy Bypass ".\invScript.ps1 > check.txt"
powershell compare-object (get-content baseOut.txt) (get-content check.txt) > checked.txt