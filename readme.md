# PowerShell convert csv to json

## Parameters

`-Path`
: Directory containing CSVs or CSV file path

`-OutPath`
: Output Directory for json files or output json filename

`-Force`
: Treat Path as a csv file even if it doesn't have .csv or .txt extension

## Examples

```ps1

# copy all .csv or .txt files in .\artifacts directory as .json files
Start

# copy .csv or .txt file as .json
Start .\foo\foo.csv

# copy all .csv or .txt files in target directory as .json files
Start .\foo

# copy all CSV files in foo as json files in bar
Start .\foo .\bar

# treat path as csv even though it doesn't have .csv or .txt extension
Start .\foo
```
