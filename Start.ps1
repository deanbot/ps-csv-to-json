# make a copy of any .csv in artifacts as .json

[CmdletBinding()]
param (
  # Directory containing CSVs or CSV file path
  [Parameter(Mandatory = $false, Position = 0)]
  [string]$Path,

  # Output Directory for json files or output json filename
  [Parameter(Mandatory = $false, Position = 1)]
  [string]$OutPath,

  # Treat Path as a csv file even if it doesn't have .csv or .txt extension
  [Parameter(Mandatory = $false, Position = 2)]
  [bool]$Force = $false
)

# Construct input path or file path
$DefaultPath = "$PSScriptRoot\artifacts"
if (($Path -and $Force) -or ($Path -and $Path -match ".csv" -or $Path -match ".txt")) {
  $FilePath = $Path
} elseif (!$Path) {
  $Path = $DefaultPath
}

# Construct output path or file path
$DefaultOutPath = "$PSScriptRoot\artifacts"
if ($OutPath -and $OutPath -match ".json") {
  $OutFilePath = $OutPath
} if (!$Outpath) {
  if (($Path -and $Force) -or ($Path -and $Path -match ".csv" -or $Path -match ".txt")) {
    $OutPath = [System.IO.Path]::GetDirectoryName($Path)
  } elseif ($Path) {
    $OutPath = $Path
  } else {
    $OutPath = $DefaultOutPath
  }
}

function ConvertCsvToJson {
  param (
    # Parameter help description
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$InFile,

    [Parameter(Mandatory = $true, Position = 1)]
    [string]$OutFile
  )
  if (Test-Path $InFile -PathType Leaf) {
    import-csv $InFile | ConvertTo-Json | Add-Content -Path $OutFile
  }
  else {
    Write-Error "$InFile not found"
  }
}

# Write-Output "in: $Path out: $OutPath"
if ($FilePath) {
  # exit early if input file not found
  if (!Test-Path $InFile -PathType Leaf) {
    Write-Error "CSV file not found"
    exit
  }

  # construct output file path
  $File = Get-ChildItem $FilePath
  if (!$OutFilePath) {
    $OutFilePath = "$($OutPath)$($File.BaseName).json"
  }

  # convert CSV
  Write-Output "Converting $FilePath to $OutFilePath..."
  ConvertCsvToJson $FilePath $OutFilePath
} else {
  # Get all files in input directory
  $Files = Get-ChildItem -Path $Path
  if ($Files.Length -eq 0) {
    Write-Output "No CSV files in $Path to convert"
    exit
  }

  foreach ($File in $Files) {
    # check if file is a CSV
    if ($File.Name -match ".csv" -or $File.Name -match ".txt") {

      # construct file paths
      $InFile = "$Path\$($File.Name)"
      $OutFile = ""
      $CurrentFile = Get-ChildItem "$Path\$($File.Name)"
      if ($CurrentFile) {
        $OutFile = "$Path\$($CurrentFile.BaseName).json"
      }

      #convert CSV
      if ($OutFile) {
        Write-Output "Converting $Infile to $OutFile..."
        ConvertCsvToJson $InFile $OutFile
      }
    }
  }
}
