<# 
1. Update your resourcegroup name on line 5
2. The script will get all of the Virtual Machines in your ResourceGroup and will build the target list dynamically
3. The script will then get each individual VM by name, check if the VM is started and if it is, proceed to stop, wait and then start the VM
4. If the VM is stopped, the VM will not be started and will be written to a file in the C:\temp location. This location can be changed to wherever you prefer.
5. Each stop or start command will use an ErrorVariable that will then be written to the C:\temp location for review.
6. This code is written without warranty and should be reviewed, understood and then tested in Non Production environments before being used on Production VM's.
#>

$rg = "Your ResouceGroup Name"

# You can change this section to use a script or get all VMs in a RescourceGroup by changing the following lines as needed. Remove the # if you want to use a custom file and add the # to the start of line 14. 
# $vms = (get-content -Path C:\temp\test.txt)
$vms = (get-azvm -ResourceGroupName $rg).name

Foreach ($vm in $vms) {
    
    get-azvm -Name $vm -ResourceGroupName $rg
    $vmstatus = (get-azvm -Name $vm -ResourceGroupName $rg -Status).Statuses.displayStatus[1]
    
    if ($vmstatus -eq "VM deallocated") {
        Write-Host "Virtual Machine $vm is stopped. No further action will be taken" -foregroundColor Red
        add-Content -Value $vm -Path c:\temp\stoppedvms.txt
    }

    if ($vmstatus -eq "VM running") {
    
        Write-Host "Stopping vm $vm............" -ForegroundColor DarkYellow
    
        Stop-AzVM -Name $vm -ResourceGroupName $rg -force -ErrorAction Continue -ErrorVariable failedStop
          
        Write-Host VM $vm has stopped, moving to starting the VM -ForegroundColor Green
        
        Write-Host "Starting vm $vm............" -ForegroundColor DarkYellow
    
        Start-AzVM -Name $vm -ResourceGroupName $rg -Confirm:$false -ErrorAction Continue -ErrorVariable failedStart

        Get-AzVM -name $vm -ResourceGroupName $rg -Status
        }
    }

  add-Content -Value $failedStop -Path C:\temp\failedStop.txt
  add-Content -Value $failedStart -Path C:\temp\failedStart.txt
  
