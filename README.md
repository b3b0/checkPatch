# checkPatch
Checks Windows Servers for patching in the last 40 days.

![alt text](https://i.imgur.com/ZEAKHIi.png "checkPatch in action!")

## Requires
- RSAT tools

## Instructions

- Run **checkPatch.ps1** as a domain administrator
- You did it!

## Possible output

**Looking good**: server has had an update applied to it in the last 40 days.

**Server appears to be offline**: server is not pingable on the network. All proceeding checks are cancelled.

**...Check WinRM**: Ping has suceeded, but the PSSession portion of the connection could not be executed. 

*Make sure that:*
- WINRM is enabled on the remote machine
- no network ACLs or system ACLs are blocking you
- and that you have appropriate permissions to engage with the remote machine over WinRM.

**...needs to be patched**: Obvious. Also tells you when last patch was executed. 
