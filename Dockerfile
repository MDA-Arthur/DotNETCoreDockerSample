FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /home/netcore

# copy csproj and restore as distinct layers
#COPY *.sln .
COPY ECSTestSolution.ProjectWebAPI/*.csproj ./ECSTestSolution.ProjectWebAPI/
RUN dotnet restore

# copy everything else and build app
COPY ECSTestSolution.ProjectWebAPI/. ./ECSTestSolution.ProjectWebAPI/
WORKDIR /home/netcore/ECSTestSolution.ProjectWebAPI
RUN dotnet publish -c Release -o build

# Build runtime image
FROM microsoft/dotnet:2.1-aspnetcore-runtime AS runtime
RUN cp /usr/share/zoneinfo/Asia/Taipei /etc/localtime
WORKDIR /home/netcore
COPY --from=build /home/netcore/ECSTestSolution.ProjectWebAPI/build ./
#ENTRYPOINT ["dotnet", "aspnetapp.dll"]
ENTRYPOINT ["./ECSTestSolution.ProjectWebAPI"]