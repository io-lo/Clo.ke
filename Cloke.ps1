function Clo {
    param (
        [string]$f,
        [string]$c,
        [string]$o
    )
    [void] (Invoke-Expression("chcp 65001"))
    $OFS = "`n"
    $a = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/+="
    if ($f -and (Test-Path $f)) {
        if ($f.IndexOf("\") -lt 0) { $f = $f }
        $b = [Convert]::ToBase64String([IO.File]::ReadAllBytes($f))
        try {
            $ca = Get-Content $c -Encoding UTF8
        } catch {
            Write-Host "ReadErP"
            return
        }
        if ($o) {
            try {
                $sb = New-Object -TypeName "System.Text.StringBuilder"
                $b.ToCharArray() | ForEach-Object { [void]$sb.Append($ca[$a.IndexOf($_)] + $OFS) }
                $sb.Remove($sb.Length - 1, 1)
                Out-File -FilePath $o -InputObject $sb.ToString() -Encoding UTF8
            } catch {
                Write-Host "ErrWr '$o'."
                Write-Host $_.Exception.Message
            }
        } else {
            $b.ToCharArray() | ForEach-Object { Write-Host $ca[$a.IndexOf($_)] }
        }
    } else {
        Write-Host "oops"
    }
}