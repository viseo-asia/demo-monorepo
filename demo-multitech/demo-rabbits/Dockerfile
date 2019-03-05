# Build
FROM microsoft/dotnet-framework:4.7.2-sdk AS builder
WORKDIR /src
COPY . .
RUN dotnet build -c Release -o /app
RUN dotnet publish -c Release -o /app

# Production
FROM microsoft/dotnet-framework:4.7.2-sdk AS production
WORKDIR /app
COPY --from=builder /app .
COPY entrypoint.bat .
ENTRYPOINT ["dotnet", "demoRabbits.dll"]