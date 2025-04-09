function Clo {
    param (
        [string]$f,
        [string]$c,
        [string]$o
    )
    [void] (Invoke-Expression("chcp 65001"))
    $OFS = "`n"
    $a = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/+="
    $f = (gl).path+'\'+ $f;$c = (gl).path+'\'+ $c;$o = (gl).path+'\'+ $o
    if ($f -and (Test-Path $f)) {
        $b = [Convert]::ToBase64String([IO.File]::ReadAllBytes($f))
        try {
            $ca = Get-Content $c -Encoding UTF8
        } catch {
            Write-Host "ReadEr"
            return
        }
        if ($o) {
            try {
                $sb = New-Object -TypeName "System.Text.StringBuilder"
                $b.ToCharArray() | ForEach-Object { [void]$sb.Append($ca[$a.IndexOf($_)] + $OFS) }
                $sb.Remove($sb.Length - 1, 1)
                Out-File -FilePath $o -InputObject $sb.ToString() -Encoding UTF8
            } catch {
                Write-Host "ErWr"
            }
        } else {
            $b.ToCharArray() | ForEach-Object { Write-Host $ca[$a.IndexOf($_)] }
        }
    } else {
        Write-Host "F"
    }
}
