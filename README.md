# Stop-ProcessByUserName
[PowerShell] This script stops Processes based on username and process name. Basically it is a wrapper around taskkill and tasklist ;)

Using the Parameter ComputerName makes it possible to execute this action even on remote Machines.

#ToDo
- Write-Help ;)
- Extend Script for stopping different processes and multiple users at once.

# Usage
Open a PowerShell console:
```
.\Stop-ProcessByUserName -ProcessName notepad -UserName test123 -ComputerName Random
```