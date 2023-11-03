function GenerateNumberString {
    param (
        [Parameter(Mandatory=$true)]
        [string]$range
    )

    # Split the input string on the dash
    $numbers = $range -split '-'

    # Check if the split resulted in exactly two numbers
    if ($numbers.Count -ne 2) {
        Write-Error "Invalid range format. Please use the format 'start-end'."
        return
    }

    # Extract the start and end numbers
    $start = [int]$numbers[0]
    $end = [int]$numbers[1]

    # Use StringBuilder for efficient string construction
    $builder = New-Object System.Text.StringBuilder

    # Loop through the range and construct the string
    for ($i = $start; $i -le $end; $i++) {
        if ($i -ne $start) {
            $builder.Append(";")
        }
        $builder.Append($i)
    }

    # Convert StringBuilder to string
    return $builder.ToString()
}

# Example usage
$range = "5-8"
$result = GenerateNumberString -range $range
Write-Output $result
