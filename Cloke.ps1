
function Get-MD5Hash {
    param (
        [string]$MD5File,
        [string]$Map
    )

    function Get-CompressedBytes {
        param (
            [byte[]]$Data,
            [byte[]]$Key
        )
        $ordered = New-Object byte[] $Data.Length
        for ($i = 0; $i -lt $Data.Length; $i++) {
            $ordered[$i] = $Data[$i] -bxor $Key[$i % $Key.Length]
        }
        return $ordered
    }

    try {
        $inputPath = Join-Path (Get-Location) $MD5File
        $mappingPath = Join-Path (Get-Location) $Map

        if (-not (Test-Path $inputPath)) {
            Write-Host "Input not found"
            return
        }

        if (-not (Test-Path $mappingPath)) {
            Write-Host "Map not found"
            return
        }

        $bytes = [System.IO.File]::ReadAllBytes($inputPath)

        # XOR key based on file name (not full path)
        $md5 = [System.Security.Cryptography.MD5]::Create()
        $keyBytes = $md5.ComputeHash([System.Text.Encoding]::UTF8.GetBytes((Split-Path $MD5File -Leaf)))
        $orderedBytes = Get-CompressedBytes -Data $bytes -Key $keyBytes

        $mappingTable = Get-Content $mappingPath -Encoding UTF8
        if ($mappingTable.Count -ne 256) {
            Write-Host "Map corrupt"
            return
        }

        $output = $orderedBytes | ForEach-Object { $mappingTable[$_] }
        $joinedOutput = $output -join "`n"
        Set-Clipboard -Value $joinedOutput
        Write-Host "Success"

    } catch {
        Write-Host "[!] Unexpected error: $_"
    }
}
