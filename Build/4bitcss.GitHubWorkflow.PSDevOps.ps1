#requires -Module PSDevOps
Push-Location ($PSScriptRoot | Split-Path)
Import-BuildStep -SourcePath (
    Join-Path $PSScriptRoot 'GitHub'
) -BuildSystem GitHubWorkflow

New-GitHubWorkflow -Name "Build 4bitcss" -On Push, PullRequest, Demand -Job TestPowerShellOnLinux, TagReleaseAndPublish, Build4BitCss -Environment @{
    NoCoverage = $true
    REGISTRY = "ghcr.io"
    IMAGE_NAME = '${{ github.repository }}'
} -OutputPath (Join-Path $pwd .github\workflows\Build4bitcss.yml)

Pop-Location