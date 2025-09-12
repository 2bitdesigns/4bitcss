# Thank you Microsoft!  Thank you PowerShell!  Thank you Docker!
FROM mcr.microsoft.com/dotnet/sdk:9.0

# Set the module name to the name of the module we are building
ARG ModuleName=4bitcss
ARG ModuleDomain=4bitcss.com
ENV ModuleName=$ModuleName
ENV ModuleDomain=$ModuleDomain 

# Copy the module into the container
RUN --mount=type=bind,src=./,target=/Initialize /bin/pwsh -nologo -command /Initialize/Container.init.ps1
# Set the entrypoint to the script we just created.
ENTRYPOINT [ "pwsh","-nologo","-noexit","-file","/Container.start.ps1" ]