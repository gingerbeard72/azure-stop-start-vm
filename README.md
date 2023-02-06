# azure-stop-start-vm

Script to stop/start a list of vm's in Azure

1. Update your resourcegroup name on line 5
2. The script will get all of the Virtual Machines in your ResourceGroup and will build the target list dynamically. Optionally, you can use a custom text file  that contains a list of VM names to be targeted.
3. The script will then get each individual VM by name, check if the VM is started and if it is, proceed to stop the VM, Check the status and then start the VM
4. If the VM is stopped, the VM will not be started and will be written to a file in the C:\temp location so that you can review this list and manually take action if required. This location can be changed to wherever you prefer.
5. Each stop or start command will use an ErrorVariable that will then be written to the C:\temp location for review.
6. This code is written without warranty and should be reviewed, understood and then tested in Non Production environments before being used on Production VM's.

Please feel free to add comments on how to improve this code. I would like to learn how to handle the errors better and also do some more intelligent checking of the VM status. As well as learning anything else that will help improve this code.
