FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["Challenger2.csproj", ""]
RUN dotnet restore "./Challenger2.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "Challenger2.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Challenger2.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Challenger2.dll"]