try {
    $exe = (Get-Command emacs.exe -Erroraction Stop).source
    }
catch {
    "Not a file $exe"
    break
}
invoke-expression "$exe -Q"
