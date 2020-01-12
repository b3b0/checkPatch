# checkPatch
Checks Windows Servers for patching in the last 40 days.

![alt text](https://i.imgur.com/ZEAKHIi.png "checkPatch in action!")

## Instructions
- Put this script and .txt list of files in a secure location!
- Add servers, one line at a time to **WindowsDomainServers.txt**
- Run **checkPatch.ps1** as a domain administrator *(or local administrator, depending on your use case)* after making sure that **WindowsDomainServers.txt** is in the same directory as the script.
- You did it!

## Possible output

**Looking good**: server has had an update applied to it in the last 40 days.

**Server appears to be offline**: server is not pingable on the network. All proceeding checks are cancelled.

**...Check WinRM**: Ping has suceeded, by the PSSession portion of the connection could not be executed. Make sure WINRM is enabled, no network ACLs or system ACLs are blocing youm and that you have appropriate permissions to engage with the remote machine over WinRM.

**...needs to be patched**: Obvious. Also tells you when last patch was executed. 
