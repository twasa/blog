---
title: "Powershell"
date: 2018-04-21T17:33:21+08:00
tags: [ "Microsoft", "powershell" ]
categories: [ "Shell"]
draft: true
---

# Poweershell
PowerShell Core is a cross-platform (Windows, Linux, and macOS) automation and configuration tool/framework that works well with your existing tools and is optimized for dealing with structured data (e.g. JSON, CSV, XML, etc.), REST APIs, and object models. It includes a command-line shell, an associated scripting language and a framework for processing cmdlets.

## cmdlet
- get all cmdlet

```
Get-Command
Get-Command -Name *IP*
Get-Command -Module ISE -Name *IP*

Get-Help Get-Process
Get-Member
Get-Process | Where-Object {$_.Name -eq "powershell"} #$_ is the current pipeline object
```

- cmdlet combind example: find all file mode = a
```
Get-ChildItem $env:USERPROFILE -Recurse -Force | Where-Object {$_.Mode -like "*a*"}
```

## Using
- get powershell profile path
```
Get-Variable profile | Format-List
```

- set alias
```
Set-Alias ll Get-ChildItem
```

- define variable
```
$sourcedir = "r:\MYDATA" #string
$tmp1 = $sourcedir -join '.rar '
$tmp2 = $tmp1 + ".rar"
$rarfile = $tmp2 -split " "
$targetpath = "e:\", "x:\", "f:\", "y:\" #
```

- get variable type
```
$variable.GetType().FullName
```

- Comparison Operators


| Purpose                  | Operator | Example                   |
|--------------------------|----------|---------------------------|
| Greater than             | -gt      | 1 -gt 2 (Returns $false)  |
| Less than                | -lt      | 1 -lt 2 (Returns $true)   |
| Equals                   | -eq      | 2 -eq 1+1 (Returns $true) |
| Not equals               | -ne      | 3 -ne 1+1 (Returns $true) |
| Greater than or equal to | -ge      | 3 -ge 1+1 (Returns $true) |
| Less than or equal to    | -le      | 2 -le 1+1 (Returns $true) |



- statements: if else
```
if (Test-Path $item){
    if ($? -notmatch "True"){
        #do something
    }
}
Else {
    #do something
}
```

- statements: For loop
```
For ($i=0; $i -le 10; $i++) {
    "10 * $i = " + (10 * $i)
}
```

- statements: foreach
```
$items = 1,2,3,4,5
ForEach ($item in $items){
    #do something
}    
```

- define function

```
function FunctionNAME {
    #do something
}

function FunctionNAME($parm1){
    #do something
}

function FunctionNAME([String] $parm1){
    #do something
}

function FunctionNAME([String] $parm1 = "hello"){
    #do something
    return $parm1
}
```

- call function
```
FunctionNAME
FunctionNAME "test"
FunctionNAME -parm1 "echo"
```

- prevent external Windows subsystem based EXE, for each command to end before starting the next

```
<path to exe> | Out-Null

Start-Process <path to exe> -NoNewWindow -Wait

#powershell 2.0
$job = Start-Job <path to exe>
Wait-Job $job
Receive-Job $job
```