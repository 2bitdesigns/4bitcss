FROM mcr.microsoft.com/powershell

# Set the module name to the name of the module we are building
ARG ModuleName=4bitcss
# Copy the module into the container
COPY . ./usr/local/share/powershell/Modules/$ModuleName
# Create a profile that imports the module, so it is available when the container starts.
RUN pwsh -c "New-Item -Path \$Profile -ItemType File -Force | Out-Null"
RUN pwsh -c "Add-Content -Path \$Profile -Value 'Import-Module $ModuleName' -Force"
