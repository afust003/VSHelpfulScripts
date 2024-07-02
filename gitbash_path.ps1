function Convert-ToGitBashPath {
    param (
        [string]$windowsPath
    )

    # Check if the input is a valid Windows path
    if (-not (Test-Path $windowsPath)) {
        Write-Error "The provided path is not valid."
        return
    }

    # Convert the backslashes to forward slashes
    $bashPath = $windowsPath -replace '\\', '/'

    # Convert drive letter to lowercase and prepend with '/'
    if ($bashPath -match '^[a-zA-Z]:') {
        $driveLetter = $bashPath.Substring(0, 1).ToLower()
        $bashPath = $bashPath.Substring(2)
        $bashPath = "/$driveLetter$bashPath"
    }

    return $bashPath
}

# Example usage:
$windowsPath = "C:\users\xyz\"
$gitBashPath = Convert-ToGitBashPath -windowsPath $windowsPath
Write-Output $gitBashPath
