# Description: Given a directory path, find all sub-folders that contain CSharp projects and "cleanup" the BIN and OBJ folders!
# Decisions: 
# 1) is depth 7 acceptable?
# 2) Assumes the solution folder is "outside"; meaning "projects" are in sub-folders.
function CleanupSolutionCSharpProjects {
    [CmdletBinding()]
    param(
    [Parameter(Mandatory=$true)]    
    [string]$SolutionDirectoryToCleanup #"C:\repo\[yoursolutiondir]\";	
    )
    
    #Basic existence check
    if([String]::IsNullOrEmpty($SolutionDirectoryToCleanup) -or (-not (Test-Path -PathType Container -Path $SolutionDirectoryToCleanup))){
        throw "The solution directory you wish to clean up C# projects for must NOT be empty and MUST be a directory!";
    }
    $startDirPath = $SolutionDirectoryToCleanup;
    
    
    $allSubdirectoriesWeWantToProcess= Get-ChildItem "$startDirPath" -recurse -Depth 7;    
    $allSubdirectoriesWeWantToProcessFullNameStringOnly = $allSubdirectoriesWeWantToProcess | ForEach-Object { $_.FullName }
    #Check: ensure at least 1 C# project exists inside!
    If (-not (ContainsCsproj $allSubdirectoriesWeWantToProcessFullNameStringOnly)){
        throw "The solution directory does NOT contain a single .csproj file inside!"
    }else{
        Write-Host -ForegroundColor Green "Good. At least 1 .csproj found in the directory."
    }
    $matchLookup = "bin","obj";

    # Core of the work: match on "folders/directories" ending with specific folder path such as "thePath\bin\debug" and DELETE the FOLDER!!!
    $allSubdirectoriesWeWantToProcess | ForEach-Object {
        if($_.PSIsContainer -eq $true){
            # DEBUG: write-host "Processing: $($_.FullName) ..." 
             for ($i = 0; $i -lt $matchLookup.Count ; $i++) {
                $lkup = $matchLookup[$i]
                #BEBUG: write-host "Processing: $($_.FullName) ... looking for $($lkup).. $($i) of $($matchLookup.Count)!"                 
                # WARN: destructive operation ahead!                  
                # Perform 'case-insensitive' match on the "ending of the path". i.e.: if it contains "*bin\debug" or "*bin"
                if($_.FullName.ToLower() -like "*$($lkup)"){
                    Write-Host -ForegroundColor Red "Deleted folder: $($_.FullName)";
                    remove-item -Force -recurse -path "$($_.FullName)"
                    #NOTE: u will NOT be prompted if it has children!                        
                }
                # else SKIP the directory.
            }
        }
    } #end for-each
} #end func


function ContainsCsproj($stringArray) {
    foreach ($string in $stringArray) {
        if ($string.EndsWith(".csproj")) {
            return $true
        }
    }
    return $false
}

# Test for HasCsProj function.
# $testArray = @("test.txt", "project.csproj", "another.txt")
# $result = ContainsCsproj $testArray
# Write-Output $result  # This will print "True" since one of the strings ends with ".csproj"

# Test it!
# TODO: generate test project at desired test location.
CleanupSolutionCSharpProjects -SolutionDirectoryToCleanup "C:\tmp\testProj101\ConsoleApp1"