filter Convert-4BitName
{
    <#
    .SYNOPSIS
        Converts a 4Bit Name into a path
    .DESCRIPTION
        Converts a 4Bit Color Scheme Name into a path
    #>
    $_ -replace '\s','-' -replace '\p{P}','-' -replace '-+','-' -replace '-$'
}
