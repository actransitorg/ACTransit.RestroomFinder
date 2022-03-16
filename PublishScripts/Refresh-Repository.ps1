﻿[CmdletBinding()]
Param(
    #[Parameter(Mandatory=$true)]
    [string]$Profile = 'RestroomFinder',
    [switch]$NoPublish = $false
)

$DebugPreference = "Continue"

#Clear-Host
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
        [parameter(Mandatory=$true, HelpMessage="Enter VS version as 2010, 2012, 2013, 2015, 2017, 2019, 2022")]
        [ValidateSet(2010,2012,2013,2015,2017,2019,2022)]
        [int]$version
    )
    $VS_VERSION = @{ 2010 = "10.0"; 2012 = "11.0"; 2013 = "12.0"; 2015 = "14.0"; 2017 = ""; 2019 = "16.0"; 2022 = "17.0" }
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
    elseif ($version -eq 2022)
    {
        Push-Location
        $targetDir = "C:\Program Files\Microsoft Visual Studio"
        Set-Location $targetDir
        $vcvars = Get-ChildItem -r VsDevCmd.bat | Resolve-Path -Relative
        Pop-Location
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
    $publishScripts = "$($config.PublishScripts)"
    
    Write-Debug "* BEGIN Search/Replace"
    
    foreach ($itemDir in $config.SourceCodeDirectories) {
        if ($itemDir.Length -eq 2) {
            $target = "$($config.TargetCodeRoot)\$($itemDir[1])"    
        } else {
            $target = "$($config.TargetCodeRoot)\$itemDir"  
        }    
        $changes = $($config.SearchReplace)
        foreach ($item in $changes) {
            $filespec = "$($item.Filespec)"
            $filespecRegex = "$($item.FilespecRegex)"
            $files = Get-ChildItem -Path $target -Filter $filespec -Exclude $publishScripts -Recurse | Where-Object { !$_.PSIsContainer -and $_.Name -match $filespecRegex }
            foreach ($file in $files) {
                Invoke-SearchReplace $file $item
            }
        }
    }
    
    foreach ($item in $config.SourceCodeFiles) {
        if ($item.Length -eq 2) {
            $target = "$($config.TargetCodeRoot)\$($item[1])"    
        } else {
            $target = "$($config.TargetCodeRoot)\$item"  
        }       
        $changes = $($config.SearchReplace)
        foreach ($item in $changes) {
            $filespec = "$($item.Filespec)"
            $filespecRegex = "$($item.FilespecRegex)"
            $files = Get-ChildItem -Path $target -Include $filespec -Exclude $publishScripts -Recurse | Where-Object { !$_.PSIsContainer -and $_.Name -match $filespecRegex }
            foreach ($file in $files) {
                Invoke-SearchReplace $file $item
            }
        }
    }    

    # Delete profiles, except $Profile.ps1 which is still needed by publish.ps1 for post-compile
    $scriptName = "$($config.ScriptName)"
    $publishScriptProfiles = "$publishScripts\Profiles"
    Write-Debug "* Cleaning up $publishScriptProfiles for $scriptName"
    Remove-Item $publishScriptProfiles -Exclude *$scriptName* -Force -Recurse
    "[ ]" | Out-File "$publishScriptProfiles\*.json"

	# Finalize profile activity
    $databasePath = "$publishScripts\Database"
    Push-Location 
    Set-Location $databasePath
    Write-Debug "* Finalizing $Profile profile" 
    $config.Finalize.Invoke()
    Pop-Location

    Write-Debug "* Check directory contents before compiling."
    Pause

    # Stage 4 - Restore dependencies and compile
    Push-Location
    $solution = $($config.SourceCodeFiles) | Select-String -Pattern ".sln"
    #$solution = "$($config.TargetCodeRoot)\$solution"
    Set-Location "$($config.TargetCodeRoot)"
    Write-Debug "* Current Directory $(Get-Location)"
    
    #Set-Location "$($config.TargetCodeRoot)\.nuget"
    #& .\nuget.exe restore $solution
    Write-Debug "* Reading Visual Studio environment variables"
    Set-VsCmd -version $config.VsVersion
    if (!(Test-Path .\nuget.exe)){
        if (Test-Path "$($config.PublishScripts)\nuget.exe"){
            Copy-Item "$($config.PublishScripts)\nuget.exe" .
        }
        else {
            Write-Debug "* Downloading nuget.exe"
            Invoke-WebRequest -Uri "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe" -OutFile .\nuget.exe
        }
    }
    .\nuget.exe restore
    Write-Debug "* Compiling $solution"
    & devenv /Rebuild Debug $solution
    & echo .
    & echo .
    Write-Debug "*** Check for no errors with compilation ***"
    #cd "$($config.TargetPath)"
    & $publishScripts\Cleanup.bat 
    Pop-Location
    Write-Debug "DONE"
    Write-Debug "##################################################################"     
    Pause
}

function Invoke-Git
{
    param(
        [Parameter(Mandatory)]
        [string] $Command )

    $exit = 0
    try {
        $path = [System.IO.Path]::GetTempFileName()
        Invoke-Expression "git $Command 2> $path"
        $exit = $LASTEXITCODE
        if ( $exit -gt 0 )
        {
            Write-Error (Get-Content $path).ToString()
        }
        else
        {
            Write-Debug (Get-Content $path | Select-Object -First 1)
        }
    }
    catch
    {
        Write-Host "Error: $_`n$($_.ScriptStackTrace)"
    }
    finally
    {
        if ( Test-Path $path )
        {
            Remove-Item $path
        }
        $exit
    }
}

function Merge-GitHub 
{
    # Stage 5 - Push to github directory 
    # http://mikefrobbins.com/2016/02/09/configuring-the-powershell-ise-for-use-with-git-and-github/

    $gitRepositoryName = "$($config.GitRepositoryName)"
    $gitRepositoryUrl = "$($config.GitRepositoryUrl)"
    $source = "$($config.TargetCodeRoot)"
    Write-Debug "* Merge Directory (source): $source"
    $target = "$($config.TargetGitRoot)\$gitRepositoryName"
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
    git config --global http.version HTTP/1.1
    git config --global core.compression 0
    git config http.postBuffer 524288000
    
    git config --list
    Write-Debug "*** Verify credentials (make sure Git is installed) ***"
    Pause
    $Error.Clear()

    Write-Debug "* Cloning $gitRepositoryUrl into $target"
    $callRes = Invoke-Git "clone $gitRepositoryUrl $target"
    if ($callRes -ne 0) {
        Push-Location
        cd $target
        git init
        Pop-Location
    }
    Write-Debug "* Copying $source to $target"
    robocopy $source $target /MIR /MT /XD .git
    cd $target
    git status
    git add -f *
    $commitMessage = Read-Host -Prompt 'Commit message'
    git commit -m $commitMessage
    git push -u origin master    
    git config --global http.version HTTP/2
}

Try
{    
    cd $currentPath
    Write-Debug "* Current Path: $currentPath" 
    $config = Get-Config
}
Catch
{
    Set-PSReadLineOption -Colors @{Operator = "Yellow"; Parameter = "Yellow"; Command = "Blue";String = "DarkYellow"}
    Write-Debug "Caught an exception, rolling back."
    Write-Debug "Exception Type: $($_.Exception.GetType().FullName)" 
    Write-Debug "Exception Message: $($_.Exception.Message)"
    return -2
}
$config

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
