$windowsUpdate = Get-Item Registry::HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU
Set-ItemProperty -Path $windowsUpdate.PSPath -Name "UseWUServer" -Value 0
Restart-Service -Name "wuauserv"

$rsatTools = (
  "Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0",
  "Rsat.BitLocker.Recovery.Tools~~~~0.0.1.0",
  "Rsat.CertificateServices.Tools~~~~0.0.1.0",
  "Rsat.DHCP.Tools~~~~0.0.1.0",
  "Rsat.ServerManager.Tools~~~~0.0.1.0"
)
 
foreach ($tool in $rsatTools) {
  $toolInfo = Get-WindowsCapability -Name "$tool" -Online
  if ($toolInfo.State -eq "NotPresent") {
    echo "Installing '$($toolInfo.DisplayName)'..."
    Add-WindowsCapability -Name "$tool" -Online
  }
}

Set-ItemProperty -Path $windowsUpdate.PSPath -Name "UseWUServer" -Value 1
Restart-Service -Name "wuauserv"
