#GetErrorLogs.ps1
#This will collect the system and application errors from an array of servers.  
#You can add any other logs you wish by changing or -LogName System to whatever logs you wish to pull.
#To get more than one type of log, a new loop will need to be added.  
#Just copy an existing one, change the type of log and the export name to the type of log so nothing is overwritten.
#There is an example of how my filename is formatted for reference in the loop.



#Gets the date for yesterday and sets it to a variable to be called in the script.  
#It is used for telling powershell what days to grab event logs from.
#Change the .AddDays(-x) to tell it how far back you want to search.  
#-1 is 24 hours ago from the time run, -2 is 48, ect...
$Yesterday = (get-date).AddDays(-1)



#Array of servers to be parsed through for logs.  Put your servers in here, seperated by commas (server1,server2,ect)
$serverArray = @(
)



#Gets the current date and sets the filename for the exported file 
#to be x:\ServerLogs _______ where _______ = current date
$currentday = Get-Date -Format yyyy-MM-dd



#Get the SYSTEM event log for each server in the array, format, and explort to *.csv file
foreach ($server in $serverArray)
{
    #$filename is a variable for the location that the files will be saved for.  
    #It includes the $server & $currentday variables so those are included in the filename.  
    #filenames can be anything you wish or any location.  
    #In my environment, it is x:\server logs\application logs\*server* logs *date*
    #EXAMPLE: $filename = "x:\server logs\System logs\$server System Logs $currentday.csv"
    
    
    $filename = "x:\server logs\Application Logs\$server Application Logs $currentday.csv"
    Get-EventLog -EntryType Error -LogName System -ComputerName $server -After $Yesterday | 
    Select-Object machinename,timewritten,source,eventID,message | Export-Csv $filename
    Write-Host "System log '$filename' written to server" -foreground Green
}

#Get the APPLICATION event log for each server in the array, format, and explort to *.csv file
foreach ($server in $serverArray)
{
    #$filename is a variable for the location that the files will be saved for.  
    #It includes the $server & $currentday variables so those are included in the filename.  
    #filenames can be anything you wish or any location.  
    #In my environment, it is I:\server logs\application logs\*server* logs *date*
    #EXAMPLE: $filename = "x:\server logs\System logs\$server System Logs $currentday.csv"
    
    
    $filename = "x:\server logs\Application Logs\$server Application Logs $currentday.csv"
    Get-EventLog -EntryType Error -LogName Application -ComputerName $server -After $Yesterday | 
    Select-Object machinename,timewritten,source,eventID,message | Export-Csv $filename
    Write-Host "Application log '$filename' written to server" -foreground Green
}
