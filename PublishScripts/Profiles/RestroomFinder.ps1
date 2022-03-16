function Get-Profile {
    $sourceCodeRoot = "..\"
    $gitRepositoryName = "ACTransit.RestroomFinder"
    $gitRepositoryUrl = "https://github.com/actransitorg/ACTransit.RestroomFinder.git"
    $scriptPath = $($pwd.Path)
    $scriptName = "RestroomFinder"
	#$repoPath = [System.IO.Path]::GetFullPath("$scriptPath\..")
    $databaseFilesPath = "$scriptPath\Database"
    $solutionPath = [System.IO.Path]::GetFullPath("$scriptPath\..")
    $vsVersion = 2022
    $targetPath = "$env:temp\ACTransit-dist"
    $startupPath = "$solutionPath\ACTransit.RestroomFinder.Web"
    $appDataPath = "$startupPath\App_Data"
    #$sqlExecutePath = (Get-ChildItem -Path "$repoPath\*SQLExecute.exe" -Recurse | Sort-Object LastAccessTime -Descending | Select-Object -First 1).FullName
    $targetCodeRoot = "$targetPath\$scriptName"
    $targetGitRoot = "$targetPath\$scriptName-git"
    $publishScripts = "$targetCodeRoot\PublishScripts\"
    $sourceCodeDirectories = @(
		"ACTransit.DataAccess.ActiveDirectory",
		"ACTransit.DataAccess.Employee",
		"ACTransit.DataAccess.RestroomFinder",
		"ACTransit.DataAccess.Scheduling",
		"ACTransit.Entities.ActiveDirectory",
		"ACTransit.Entities.Employee", 
		"ACTransit.Entities.Scheduling",
		"ACTransit.Framework",      
		"ACTransit.Framework.DataAccess",
		"ACTransit.Framework.Logging",
		"ACTransit.Framework.Web",
		"ACTransit.RestroomFinder.API",
		"ACTransit.RestroomFinder.API.Test",
		"ACTransit.RestroomFinder.Core.Domain",
		"ACTransit.RestroomFinder.Domain",
		"ACTransit.RestroomFinder.Native",    
		"ACTransit.RestroomFinder.Web",   
        "External.ExifLibrary",
		("docs", "docs"),
		("SSRS", "SSRS"),
		("PublishScripts", "PublishScripts")
    )
    $sourceCodeFiles = 
        @("ACTransit.RestroomFinder.sln",
          ".tfignore",
          ("LICENSE.MD", "LICENSE.MD"),
          ("README.MD", "README.MD")
    )
    $targetRemove = 
        @("*.vspscc","*.vssscc", "*.suo", "*.user", ".vs", "obj", "bin", "Debug", "Nuget", "Release", "packages", ".gradle", ".idea", ".vscode",
            "Training.docx", "SQlExecute.exe.config", "*.pubxml", "Web.Release.config", "Training")
            
    $result = @{ `
        ScriptName = $scriptName
        ScriptPath = $scriptPath
        #SqlExecutePath = $sqlExecutePath
        DatabaseFilesPath = $databaseFilesPath
        SolutionPath = $solutionPath
        StartupPath = $startupPath
        AppDataPath = $appDataPath		
        DbCount = 3
        TestMode = "true"
        PathInDbName = $false
        SourceCodeRoot = $sourceCodeRoot
        VsVersion = $vsVersion
        TargetPath = $targetPath
        TargetCodeRoot = $targetCodeRoot
        TargetGitRoot = $targetGitRoot
        PublishScripts = $publishScripts
        SourceCodeDirectories = $sourceCodeDirectories
        SourceCodeFiles = $sourceCodeFiles
        TargetRemove = $targetRemove
        SearchReplace = @()
        Databases = @("EmployeeDW","SchedulingDW","RestroomFinder2")
        GitRepositoryName = $gitRepositoryName
        GitRepositoryUrl = $gitRepositoryUrl
        Finalize = $null
    } |  ConvertTo-Json |  ConvertFrom-Json 
    $result.SearchReplace = (Get-Content "profiles\$scriptName.json") -join "`n" | ConvertFrom-Json
    $result.Finalize = {
        # Clean unused database files
        Get-ChildItem | Where-Object { $_.Name -notmatch '^RestroomFinder2_DDL_DML.sql|EmployeeDW_DDL_DML.sql|SchedulingDW_DDL_DML.sql$' } | Remove-Item        
    }
    $result
}

Get-Profile