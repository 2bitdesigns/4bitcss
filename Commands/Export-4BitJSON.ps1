function Export-4BitJSON {
    <#
    .SYNOPSIS
        Exports 4bitcss data to a json file
    .DESCRIPTION
        Exports 4bitcss data to a json file.  
        
        This is simple wrapper of ConvertTo-Json, with support for writing to a file.
    #>
    param(
    # The input object to convert to JSON
    [Parameter(ValueFromPipeline)]
    [PSObject]
    $InputObject,
    
    # The output path.
    [string]
    $OutputPath
    )

    process {
        $asJson = ConvertTo-Json -Compress  -InputObject $InputObject
        if ($OutputPath) {
            New-Item -Path $outputPath -Force -Value $asJson
        } else {
            $asJson
        }
    }
}