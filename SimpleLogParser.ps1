# Define the path to the log file
$logFilePath = "C:\path\to\your\log.txt"

# Use a regex to match the specified pattern
$pattern = "=:>\d{4}-\d{2}-\d{2} \d{2}: \d{2}:\d{2}\.\d{4}: \|:"

# Parse the log file and extract the desired lines
Get-Content -Path $logFilePath | ForEach-Object {
    if ($_ -match $pattern) {
        # Extract the rest of the line after the matched pattern
        $result = $_.Substring($_.IndexOf($matches[0]) + $matches[0].Length)
        # Output the result
        $result
    }
}
