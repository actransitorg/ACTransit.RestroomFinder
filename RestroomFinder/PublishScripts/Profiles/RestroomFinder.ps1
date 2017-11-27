function Get-Profile {
    $sourceCodeRoot = "P:\ACTransit.Projects\trunk\ACTransitToolbelt\"
    $targetPath = "C:\github\ACTransit.RestroomFinder-merge"
    $gitRepositoryName = "ACTransit.RestroomFinder"
    $gitRepositoryUrl = "https://github.com/actransitorg/ACTransit.RestroomFinder.git"
    $scriptPath = $($pwd.Path)
    $scriptName = "RestroomFinder"
	$repoPath = [System.IO.Path]::GetFullPath("$scriptPath\..")
    $databaseFilesPath = "$scriptPath\Database"
    $solutionPath = [System.IO.Path]::GetFullPath("$scriptPath\..")
    $startupPath = "$solutionPath\ACTransit.RestroomFinder.Web"
    $appDataPath = "$startupPath\App_Data"
    #$sqlExecutePath = (Get-ChildItem -Path "$repoPath\*SQLExecute.exe" -Recurse | Sort-Object LastAccessTime -Descending | Select-Object -First 1).FullName
    $targetCodeRoot = "$targetPath\$scriptName\"
    $publishScripts = "$targetCodeRoot\PublishScripts\"
    $sourceCodeDirectories = @(
		"..\ACTransit.Framework\ACTransit.Framework",
		"..\ACTransit.Framework\ACTransit.Framework.DataAccess",
		"..\ACTransit.Framework\ACTransit.Framework.Logging",
		"..\ACTransit.Framework\ACTransit.Framework.Web",
		"..\ACTransit.Entities\Entities.ActiveDirectory",
		"..\ACTransit.Entities\Entities.Employee",
		"..\ACTransit.Entities\Entities.Scheduling",
		"..\ACTransit.Entities\DataAccess.ActiveDirectory",
		"..\ACTransit.Entities\DataAccess.Employee",
		"..\ACTransit.Entities\DataAccess.Scheduling",
		"ACTransit.Mobile.Apps",
		"DataAccess",
		"ACTransit.RestroomFinder.Domain",
		"ACTransit.RestroomFinder.Web",
		"RestroomFinderAPI",
		"RestroomFinderApi.Test",
        "Native",
        ("..\..\Github_trunk\.nuget", ".nuget"),
		("..\..\Github_trunk\docs", "docs"),
		("..\..\Github_trunk\SSRS", "SSRS"),
		("..\..\Github_trunk\PublishScripts", "PublishScripts")
    )
    $sourceCodeFiles = 
        @("RestroomFinder.sln",
          ".tfignore",
          ("..\..\Github_trunk\LICENSE.MD", "..\LICENSE.MD"),
          ("README.MD", "..\README.MD")
    )
    $targetRemove = 
        @("*.vspscc","*.vssscc", "*.suo", "*.user", ".vs", "obj", "bin", "Debug", "Nuget", "Release", "packages", ".gradle", ".idea", ".vscode",
            "Training.docx", "Training_DDL_DML.sql", "MaintenanceDW_DDL_DML.sql", "SQlExecute.exe.config", "*.pubxml", "Web.Release.config", "Training")
            
    $result = @{ `
        ScriptPath = $scriptPath
        #SqlExecutePath = $sqlExecutePath
        DatabaseFilesPath = $databaseFilesPath
        SolutionPath = $solutionPath
        StartupPath = $startupPath
        AppDataPath = $appDataPath		
        DbCount = 3
        TestMode = "false"
        PathInDbName = $false
        SourceCodeRoot = $sourceCodeRoot
        TargetPath = $targetPath
        TargetCodeRoot = $targetCodeRoot
        PublishScripts = $publishScripts
        SourceCodeDirectories = $sourceCodeDirectories
        SourceCodeFiles = $sourceCodeFiles
        TargetRemove = $targetRemove
        SearchReplace = @()
        Databases = @("EmployeeDW","SchedulingDW","Restroom")
        GitRepositoryName = $gitRepositoryName
        GitRepositoryUrl = $gitRepositoryUrl
    } |  ConvertTo-Json |  ConvertFrom-Json 
    $result.SearchReplace = (Get-Content "profiles\$scriptName.json") -join "`n" | ConvertFrom-Json
    $result
}

Get-Profile