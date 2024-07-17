# Define variables
$branchName = "myBranch"
$searchText = "the story number 123 was resolved"

# Fetch the branch to ensure we have the latest commits
git fetch

# Get the commit log for the specific branch and search for the commit message
$commits = git log $branchName --pretty=format:"%H %s"

# Search for the commit message containing the specific text
$commitId = $commits | ForEach-Object {
    if ($_ -match $searchText) {
        $_.Split(" ")[0]
    }
}

# Output the commit ID
if ($commitId) {
    Write-Output "Commit ID: $commitId"
} else {
    Write-Output "No commit found with the specified message in the branch $branchName"
}
