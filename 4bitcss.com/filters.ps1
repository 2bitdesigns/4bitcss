# Filters are PowerShell functions designed to quickly process pipeline input.

# This file contains filters that are useful throughout the build.

#region PowerShell Specific Filters
filter RequireModule {
    <#
    .SYNOPSIS
        Installs a module if it is not already loaded.
    .DESCRIPTION
        Installs a PowerShell module if it is not already loaded.    
    #> 
    $requirementName = $_
    if ($requirementName -is [Management.Automation.ExternalScriptInfo]) {
        $requirementName.ScriptBlock.Ast.ScriptRequirements.RequiredModules.Name | 
            RequireModule
        return
    }
    if (! $requirementName) {
        return
    }
    $alreadyLoaded = Import-Module -Name $requirementName -PassThru -ErrorAction Ignore -Global
    # If they're not already loaded, we'll install them.
    if (-not $alreadyLoaded) {
        Install-Module -AllowClobber -Force -Name $requirementName -Scope CurrentUser
        $alreadyLoaded = Import-Module -Name $requirementName -PassThru -ErrorAction Ignore -Global
        if ($file.FullName) {
            Write-Host "Installed $($alreadyLoaded.Name) for $($file.FullName)"
        }        
    } elseif ($file.FullName) {
        Write-Host "Already loaded $($alreadyLoaded.Name) for $($file.FullName)"
    }
}

Set-Alias Require RequireModule

filter Splat {
    $in = $_
    if ($in -isnot [Management.Automation.CommandInfo]) { return }
    $splat = [Ordered]@{}
    :nextParameter foreach ($parameterName in $in.Parameters.Keys) {
        $parameter = $in.Parameters[$parameterName]
        $potentialType = $parameter.ParameterType
        # PowerShell parameters can have aliases, so lets find all potential names.
        $parameterNames = @($parameter.Name;$parameter.Aliases) -ne ''
        foreach ($PotentialName in $parameterNames) {
            foreach ($arg in $args) {
                if ($arg -isnot [Collections.IDictionary]) { continue }
                if ($arg[$potentialName] -and $arg[$potentialName] -as $potentialType) {
                    if ($potentialType -eq [Collections.IDictionary]) {
                        if (-not $splat[$parameterName]) {
                            $splat[$parameterName] = [Ordered]@{}
                        }
                        foreach ($key in $arg[$potentialName].Keys) {
                            $splat[$parameterName][$key] = $arg[$potentialName][$key]                            
                        }                        
                    } else {
                        $splat[$parameterName] = $arg[$potentialName]
                    }                    
                }
            }
        }
    }
    return $splat
}
#endregion PowerShell Specific Filters

#region Special Filters
filter content {$Content}

filter now {[DateTime]::Now}

filter utc_now {[DateTime]::UtcNow}

filter today {[DateTime]::Today}

filter tomorrow { [DateTime]::Today.AddDays(1) }

filter nextWeek { [DateTime]::Today.AddDays(7) }
filter lastWeek { [DateTime]::Today.AddDays(-7)}

filter nextMonth { [DateTime]::Today.AddMonths(1) }
filter lastMonth { [DateTime]::Today.AddMonths(-1) }

filter nextYear { [DateTime]::Today.AddYears(1) }
filter lastYear { [DateTime]::Today.AddYears(-1) }


filter yaml_header_pattern {
    [Regex]::new('
(?<Markdown_YAMLHeader>
(?m)\A\-{3,}                      # At least 3 dashes mark the start of the YAML header
(?<YAML>(?:.|\s){0,}?(?=\z|\-{3,} # And anything until at least three dashes is the content
))\-{3,}                          # Include the dashes in the match, so that the pointer is correct.
)
','IgnoreCase, IgnorePatternWhitespace')
}

filter yaml_header {
    $in = $_
    if ($in -is [IO.FileInfo]) {
        $in | Get-Content -Raw | yaml_header
        return
    }
    foreach ($match in (yaml_header_pattern).Matches("$in")) {
        $match.Groups['YAML'].Value | from_yaml
    }    
}

filter from_yaml {
    $in = $_
    "YaYaml" | RequireModule
    $in | ConvertFrom-Yaml
}

filter to_yaml {
    $in = $_
    "YaYaml" | RequireModule
    $in | ConvertTo-Yaml
}

filter to_json {
    $in = $_
    $in | ConvertTo-Json -Depth 10
}

filter strip_yaml_header {
    $in = $_
    if ($in -is [IO.FileInfo]) {
        $in | Get-Content -Raw | strip_yaml_header
        return
    }
    $in -replace (yaml_header_pattern)
}

filter from_markdown {
    $in = $_
    if ($in -is [IO.FileInfo]) {
        $in | Get-Content -Raw | from_markdown
        return
    }    
    @(
        $in | 
            strip_yaml_header | 
                ConvertFrom-Markdown |
                    Select-Object -ExpandProperty Html
    ) -replace 'disabled="disabled"'
}

#endregion Special Filters

#region Custom Filters
<#
    Put any function or filter you want here.
    
    (if you want to add more filters inline but don't want to modify any of the other filters)
#>
#endregion Custom Filters