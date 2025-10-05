# Disable JavaScript in Adobe Acrobat DC, Reader 2017, and Acrobat 2017 via Registry
# Sets bDisableJavaScript to 1 (disabled and locked)
# Targets both 32-bit (WOW6432Node) and 64-bit registry paths

$RegistryBases = @(
    @{ Product = "Adobe Acrobat"; Version = "DC" },
    @{ Product = "Acrobat Reader"; Version = "2017" },
    @{ Product = "Adobe Acrobat"; Version = "2017" }
)

$PropertyName = "bDisableJavaScript"
$PropertyValue = 1

foreach ($Base in $RegistryBases) {
    $RegistryPaths = @(
        "HKLM:\SOFTWARE\Policies\Adobe\$($Base.Product)\$($Base.Version)\FeatureLockDown",
        "HKLM:\SOFTWARE\WOW6432Node\Policies\Adobe\$($Base.Product)\$($Base.Version)\FeatureLockDown"
    )

    foreach ($RegistryPath in $RegistryPaths) {
        try {
            # Create the registry path if it doesn't exist
            if (-not (Test-Path $RegistryPath)) {
                New-Item -Path $RegistryPath -Force | Out-Null
                Write-Output "Created registry path: $RegistryPath"
            }

            # Set the DWORD value to disable JavaScript
            Set-ItemProperty -Path $RegistryPath -Name $PropertyName -Value $PropertyValue -Type DWord -Force
            Write-Output "Successfully set $PropertyName to $PropertyValue in $RegistryPath. JavaScript is now disabled for $($Base.Product) $($Base.Version)."
        }
        catch {
            Write-Error "Failed to update registry path $RegistryPath : $($_.Exception.Message)"
        }
    }
}

exit 0