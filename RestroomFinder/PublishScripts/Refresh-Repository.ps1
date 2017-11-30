[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)]
    [string]$Profile,
    [switch]$NoPublish
)

$DebugPreference = "Continue"

Clear-Host
Write-Debug "##################################################################" 
Write-Debug "* Using $Profile profile" 

function Get-CurrentPath {
	return "$(Split-Path $PSCommandPath -Parent)";
}
$currentPath = Get-CurrentPath

function Get-Config {
    $configFile = "$currentPath\profiles\$Profile.ps1"
	if (!(test-path $configFile)) { throw [Exception] "Cannot find $configFile" }
	return Get-Content $configFile | Out-String | Invoke-Expression
}

function Set-VsCmd
{
    param(
        [parameter(Mandatory=$true, HelpMessage="Enter VS version as 2010, 2012, 2013, 2015, 2017")]
        [ValidateSet(2010,2012,2013,2015,2017)]
        [int]$version
    )
    $VS_VERSION = @{ 2010 = "10.0"; 2012 = "11.0"; 2013 = "12.0"; 2015 = "14.0"; 2017 = "" }
    if ($version -eq 2017)
    {
        Push-Location
        $targetDir = "C:\Program Files (x86)\Microsoft Visual Studio"
        Set-Location $targetDir
        $vcvars = Get-ChildItem -r VsMSBuildCmd.bat | Resolve-Path -Relative
        Pop-Location
    }
    elseif ($version -eq 2015)
    {
        $targetDir = "C:\Program Files (x86)\Microsoft Visual Studio $($VS_VERSION[$version])\Common7\Tools"
        $vcvars = "VsMSBuildCmd.bat"
    }
    else
    {
        $targetDir = "C:\Program Files (x86)\Microsoft Visual Studio $($VS_VERSION[$version])\VC"
        $vcvars = "vcvarsall.bat"
    }
  
    if (!(Test-Path (Join-Path $targetDir $vcvars))) {
        "Error: Visual Studio $version not installed"
        return
    }
    Push-Location $targetDir
    cmd /c $vcvars + "&set" |
    ForEach-Object {
      if ($_ -match "(.*?)=(.*)") {
        Set-Item -force -path "ENV:\$($matches[1])" -value "$($matches[2])"
      }
    }
    Pop-Location
    write-host "`nVisual Studio $version Command Prompt variables set." -ForegroundColor Yellow
}

function Set-GitPrompt
{
    if (-not($Error[0])) {
        $DefaultTitle = $Host.UI.RawUI.WindowTitle
        $GitPromptSettings.BeforeText = '('
        $GitPromptSettings.BeforeForegroundColor = [ConsoleColor]::Cyan
        $GitPromptSettings.AfterText = ')'
        $GitPromptSettings.AfterForegroundColor = [ConsoleColor]::Cyan
        function prompt {
            if (-not(Get-GitDirectory)) {
                $Host.UI.RawUI.WindowTitle = $DefaultTitle
                "PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "   
            }
            else {
                $realLASTEXITCODE = $LASTEXITCODE
    
                Write-Host 'PS ' -ForegroundColor Green -NoNewline
                Write-Host "$($executionContext.SessionState.Path.CurrentLocation) " -ForegroundColor Yellow -NoNewline
    
                Write-VcsStatus
    
                $LASTEXITCODE = $realLASTEXITCODE
                return "`n$('$' * ($nestedPromptLevel + 1)) "   
            }
        }
    }
    else {
        Write-Warning -Message 'Unable to load the Posh-Git PowerShell Module'
    }
}

function Invoke-SearchReplace {
    [CmdletBinding()]    
    param(
        [string] $file,
        [object] $item
    )
    $DebugPreference = "Continue"
    if ((Get-Item $file).length -eq 0) {
        return
    } 
    if ($item.DeleteFile -eq $TRUE)
    {
        Write-Debug "*   Deleting $file" 
        Remove-Item $file
        return
    }
    $content = Get-Content $file -Raw
    $saveContent = $content
    foreach ($change in $item.Changes) {
        $preChangeContent = $content
        $searchFor = $change.SearchFor
        $searchFor = "(?smi)$searchFor"
        $replaceWith = $change.ReplaceWith
        if ($change.RegexOptions -ne $NULL) {
            $regexOptions = $change.RegexOptions
        }
        $regex = [Regex]::new($searchFor, $regexOptions)
        $match = $regex.Matches($content)
        if ($match.Success -eq $TRUE) {
            $count = $match.Count
            Write-Debug "* $file" 
            Write-Debug "*   Matching ($count) $searchFor"
            Write-Debug "*   Replacing with $replaceWith"               
            $content = $content -replace $searchFor, $replaceWith
            if ($content -ne $preChangeContent) {
                Write-Debug "*   REPLACED"
            }
        }
    }
    if ($content -ne $saveContent) {
        $content | Out-File $file -Encoding utf8
    }
}


function Create-MergeDir 
{   
    # Stage 1 - Copy code directories for distribution
    
    Write-Debug "* BEGIN Copy to distribution directory"
    
    foreach ($item in $config.SourceCodeDirectories) {
        if ($item.Length -eq 2) {
            $source = Join-Path -Path "$($config.SourceCodeRoot)" -ChildPath "$($item[0])"
            $source = (Resolve-Path $source).Path
            $target = Join-Path -Path "$($config.TargetCodeRoot)" -ChildPath "$($item[1])"        
        } else {
            $source = Join-Path -Path "$($config.SourceCodeRoot)" -ChildPath "$item"
            $source = (Resolve-Path $source).Path
            $target = Join-Path -Path "$($config.TargetCodeRoot)" -ChildPath "$item"
        }
        Write-Debug "* Cleaning $target" 
        if (!(Test-Path $target)) {
            mkdir $target | Out-Null
        }        
        Get-ChildItem $target -Recurse | foreach {$_.Attributes = @()}
        $target = (Resolve-Path $target)
        Remove-Item -Recurse $target
        Write-Debug "* Copying $source to $target" 
        Copy-Item $source $target -Recurse
        Get-ChildItem $target -Recurse | foreach {$_.Attributes = @()}
    }
    
    foreach ($item in $config.SourceCodeFiles) {
        if ($item.Length -eq 2) {
            $source = Join-Path -Path "$($config.SourceCodeRoot)" -ChildPath "$($item[0])"
            $source = (Resolve-Path $source).Path
            $target = Join-Path -Path "$($config.TargetCodeRoot)" -ChildPath "$($item[1])"        
        } else {
            $source = Join-Path -Path "$($config.SourceCodeRoot)" -ChildPath "$item"
            $source = (Resolve-Path $source).Path
            $target = Join-Path -Path "$($config.TargetCodeRoot)" -ChildPath "$item"
        }
        Write-Debug "* Copying $source to $target" 
        Copy-Item $source $target
        $f = Get-Item $target -Force 
        $f.Attributes = @()
    }
    
    Write-Debug "* DONE Copy to distribution directory"
    
    # Stage 1.B - Cleanup
    
    Write-Debug "* BEGIN Cleanup"
    
    foreach ($itemDir in $config.SourceCodeDirectories) {
        if ($itemDir.Length -eq 2) {
            $target = Join-Path -Path "$($config.TargetCodeRoot)" -ChildPath "$($itemDir[1])"
            $target = (Resolve-Path $target).Path 
        } else {
            $target = Join-Path -Path "$($config.TargetCodeRoot)" -ChildPath "$itemDir"  
            $target = (Resolve-Path $target).Path  
        }
    
        $targetToRemove = $config.TargetRemove
        $files = Get-ChildItem -Recurse $target -Include $targetToRemove
        foreach ($item in $files) {
            if (Test-Path $item) {
                Write-Debug "* Removing $item"   
                Remove-Item -Recurse $item
            }
        }
    }
    
    Write-Debug "* DONE Cleanup"
    
    # Stage 2 - Collect databases for distribution
    
    # Scan EDMX files?
    
    # Stage 3 - Generify embedded strings to be replaced by developer
    
    $regexOptions = @('SingleLine', 'IgnoreCase', 'MultiLine')
    $exclude = "$($config.PublishScripts)"
    
    Write-Debug "* BEGIN Search/Replace"
    
    foreach ($itemDir in $config.SourceCodeDirectories) {
        if ($itemDir.Length -eq 2) {
            $target = "$($config.TargetCodeRoot)$($itemDir[1])"    
        } else {
            $target = "$($config.TargetCodeRoot)$itemDir"  
        }    
        $changes = $($config.SearchReplace)
        foreach ($item in $changes) {
            $filespec = "$($item.Filespec)"
            $filespecRegex = "$($item.FilespecRegex)"
            $files = Get-ChildItem -Path $target -Filter $filespec -Exclude $exclude -Recurse | Where-Object { !$_.PSIsContainer -and $_.Name -match $filespecRegex }
            foreach ($file in $files) {
                Invoke-SearchReplace $file $item
            }
        }
    }
    
    foreach ($item in $config.SourceCodeFiles) {
        if ($item.Length -eq 2) {
            $target = "$($config.TargetCodeRoot)$($item[1])"    
        } else {
            $target = "$($config.TargetCodeRoot)$item"  
        }       
        $changes = $($config.SearchReplace)
        foreach ($item in $changes) {
            $filespec = "$($item.Filespec)"
            $filespecRegex = "$($item.FilespecRegex)"
            $files = Get-ChildItem -Path $target -Include $filespec -Exclude $exclude -Recurse | Where-Object { !$_.PSIsContainer -and $_.Name -match $filespecRegex }
            foreach ($file in $files) {
                Invoke-SearchReplace $file $item
            }
        }
    }    

    # Delete profiles
    $publishScriptProfiles = "$($config.PublishScripts)\Profiles"
    "[ ]" | Out-File "$publishScriptProfiles\*.json"

	# Finalize profile activity
    $databasePath = "$($config.PublishScripts)\Database"
    Push-Location 
    Set-Location $databasePath
    Write-Debug "* Finalizing $Profile profile" 
    $config.Finalize.Invoke()
    Pop-Location

    # Stage 4 - Restore dependencies and compile

    $solution = $($config.SourceCodeFiles) | Select-String -Pattern ".sln"
    $solution = "$($config.TargetCodeRoot)\$solution"
    Push-Location
    Set-Location "$($config.TargetCodeRoot)\.nuget"
    & .\nuget.exe restore $solution
    Set-VsCmd -version 2017
    & devenv /Rebuild Debug $solution
    Write-Debug "*** Check for no errors with compilation ***"
    Pause
    cd ..
    & $currentPath\Cleanup.bat
    Write-Debug "DONE"
    Write-Debug "##################################################################"     
}

function Merge-GitHub 
{
    # Stage 5 - Push to github directory 
    # http://mikefrobbins.com/2016/02/09/configuring-the-powershell-ise-for-use-with-git-and-github/

    $gitRepositoryName = "$($config.GitRepositoryName)"
    $gitRepositoryUrl = "$($config.GitRepositoryUrl)"
    $source = "$($config.TargetPath)"
    Write-Debug "* Merge Directory (source): $source"
    $targetParent = (Get-Item $source).Parent.FullName
    $target = "$targetParent\$gitRepositoryName"
    Write-Debug "* Git Repository Directory (target): $target"
    if (!(Get-Module -ListAvailable -Name posh-git)) {
        Install-Module -Name posh-git -Force    
    }
    Import-Module -Name posh-git -ErrorAction SilentlyContinue
    git config --global user.name "$env:USERNAME-act"
    git config --global user.email "$env:USERNAME@actransit.org"
    git config --global push.default simple
    git config --global core.autocrlf false
    git config --global credential.helper wincred
    git config --list
    Write-Debug "*** Verify credentials (make sure Git is installed) ***"
    Pause
    $Error.Clear()

    cd $targetParent
    git clone $gitRepositoryUrl
    cd $gitRepositoryName
    Write-Debug "* Copying $source to $target"
    robocopy $source $target /MIR /MT /XD .git
    git status
    git remove -v
    git add *
    $commitMessage = Read-Host -Prompt 'Commit message'
    git commit -m $commitMessage
    git push    
}

Try
{    
    cd $currentPath
    Write-Debug "* Current Path: $currentPath" 
    $config = Get-Config
}
Catch
{
    Write-Debug "Caught an exception, rolling back." -ForegroundColor Red
    Write-Debug "Exception Type: $($_.Exception.GetType().FullName)" -ForegroundColor Red
    Write-Debug "Exception Message: $($_.Exception.Message)" -ForegroundColor Red
    return -2
}

if ([string]::IsNullOrEmpty($config.SearchReplace)) {
    Write-Debug "SearchFile profile json not found"
    return -3
}

Create-MergeDir 
if (!($NoPublish)){
    Merge-GitHub 
}

# Stage 6 - DONE

Pop-Location
