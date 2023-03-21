################################################################
#                                                              #
#      Expend Volumes in Storage Space Direct Cluster          #
#                By Cary Sun - MVP                             #
#                                                              #
################################################################

###Resize the virtual disk
##Log in to S2D Cluster server
#Open PowerShell Run as Administrator
#Run the below command to check Virtual Disk information
Get-VirtualDisk

#Run the below command to get association between objects ion the stack information
Get-VirtualDisk CSV01 | Get-Disk | Get-Partition | Get-Volume

#Run the below command verify the Virtual Disk use storage tiers, or not use
Get-VirtualDisk CSV01 | Get-StorageTier

##If the cmdlet returns nothing, the virtual disk doesn't use storage tiers
#Run the below command to Resize Virtual Disks
#Get-VirtualDisk <FriendlyName> | Resize-VirtualDisk -Size <Size>
Get-VirtualDisk CSV01 | Resize-VirtualDisk -Size 500GB

##If the virtual disk uses storage tiers
#Run the below command to resize each tier separately. In my case, increate the CSV01-NestedMirror storage tier size from 200GB to 300GB
Get-VirtualDisk CSV01 | Get-StorageTier | Select FriendlyName
Get-StorageTier CSV01-NestedMirror | Resize-StorageTier -Size 300GB

#Run the below command to verify storage tier size
Get-VirtualDisk CSV01 | Get-StorageTier
Get-VirtualDisk

###Resize the partition
#Run the below command to choose virtual disk
$VirtualDisk = Get-VirtualDisk CSV01

#Run the below command to get its partition
$Partition = $VirtualDisk | Get-Disk | Get-Partition | Where PartitionNumber -Eq 2

#Run the below command to resize to its maximum supported size
$Partition | Resize-Partition -Size ($Partition | Get-PartitionSupportedSize).SizeMax

##Refresh and verify the Volume size status from Storage Disks of Failover Cluster Manager