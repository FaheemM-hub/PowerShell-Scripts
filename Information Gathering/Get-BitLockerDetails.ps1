<#
.DESCRIPTION
    This script identifies the protection status for each fixed disk on the system. Also, the operating system drive's BitLocker ID and Recovery Key.
#>

$TargetComputer = "[Insert Computer Name]"

try {
  Invoke-Command -ComputerName "$TargetComputer" -ScriptBlock {Get-BitLockerVolume} | Select-Object ComputerName, MountPoint, EncryptionMethod, EncryptionPercentage, VolumeStatus, ProtectionStatus, KeyProtector

  Write-Host "Recovery ID:" -Foreground Red
  Invoke-Command -ComputerName "$TargetComputer" -ScriptBlock {(Get-BitLockerVolume -MountPoint "C:").KeyProtector | Select-Object -ExpandProperty KeyProtectorID}

  Write-Host -NoNewLine "`n`Recovery Key:" -Foreground Green
  Invoke-Command -ComputerName "$TargetComputer" -ScriptBlock {(Get-BitLockerVolume -MountPoint "C:").KeyProtector.RecoveryPassword}
}
catch {
  Write-Host "BitLocker detail capture failed..."
}
