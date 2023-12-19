# Script de instalación del proxy de la nostalgia
# Para Windows

# Pantalla de inicio
Clear-Host
Write-Host "╔════════════════════════╗"
Write-Host "║                        ║"
Write-Host "║ Instalar WayBackProxy  ║"
Write-Host "║                        ║"
Write-Host "╚════════════════════════╝"
Write-Host "Presiona 'I' para continuar..."
$key = [System.Console]::ReadKey().Key

if ($key -ne 'I') {
    Write-Host "La tecla presionada no es 'I'. Saliendo..."
    exit
}

# Obtiene la ruta actual
$scriptPath = $PSScriptRoot

# Registra el servicio
New-Service -Name "ProxyService" -BinaryPathName "$scriptPath\proxy_server.py" -DisplayName "Proxy Service" -Description "Proxy Server Service"

# Inicia el servicio
Start-Service -Name "ProxyService"

# Limpia la pantalla y muestra el mensaje de instalación correcta
Clear-Host
Write-Host "╔══════════════════════════╗"
Write-Host "║                          ║"
Write-Host "║ Instalado correctamente  ║"
Write-Host "║                          ║"
Write-Host "╚══════════════════════════╝"
