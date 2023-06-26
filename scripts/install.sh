#!/bin/bash

# Función para mostrar mensajes de error
show_error() {
    echo "Error: $1"
    echo "Descripción: $2"
    exit 1
}

# Comprobar existencia de la carpeta /bin
if [ -d "./bin" ]; then
    echo "La carpeta /bin existe."
else
    echo "La carpeta /bin no existe. Creándola..."
    mkdir bin || show_error "No se pudo crear la carpeta /bin." "Verifica los permisos de escritura."
fi

# Comprobar existencia y versión de PHPBU
if [ -x "./bin/phpbu.phar" ]; then
    echo "PHPBU ya está instalado."
    current_version=$(php ./bin/phpbu.phar --version)
    echo "Versión actual de PHPBU: $current_version"

    # Obtener la última versión disponible de PHPBU
    latest_version=$(wget -qO- https://phar.phpbu.de/latest-version)
    echo "Última versión de PHPBU: $latest_version"

    if [ "$current_version" != "$latest_version" ]; then
        read -p "Hay una nueva versión de PHPBU disponible. ¿Deseas actualizar? (y/n): " choice
        if [[ "$choice" =~ ^[Yy]$ ]]; then
            echo "Descargando la última versión de PHPBU..."
            wget https://phar.phpbu.de/phpbu.phar -O ./bin/phpbu.phar || show_error "No se pudo descargar la última versión de PHPBU." "Verifica tu conexión a Internet."
            chmod +x ./bin/phpbu.phar || show_error "No se pudieron establecer los permisos de ejecución para PHPBU." "Verifica los permisos de archivo."
            echo "PHPBU actualizado a la versión $latest_version."
        fi
    fi
else
    echo "Descargando PHPBU..."
    wget https://phar.phpbu.de/phpbu.phar -O ./bin/phpbu.phar || show_error "No se pudo descargar PHPBU." "Verifica tu conexión a Internet."
    chmod +x ./bin/phpbu.phar || show_error "No se pudieron establecer los permisos de ejecución para PHPBU." "Verifica los permisos de archivo."
fi

# Comprobar existencia y versión de WP-CLI
if [ -x "./bin/wp" ]; then
    echo "WP-CLI ya está instalado."
    current_version=$(./bin/wp cli version --allow-root)
    echo "Versión actual de WP-CLI: $current_version"

    # Obtener la última versión disponible de WP-CLI
    latest_version=$(wget -qO- https://api.github.com/repos/wp-cli/wp-cli/releases/latest | grep "tag_name" | cut -d '"' -f 4)
    echo "Última versión de WP-CLI: $latest_version"

    if [ "$current_version" != "$latest_version" ]; then
        read -p "Hay una nueva versión de WP-CLI disponible. ¿Deseas actualizar? (y/n): " choice
        if [[ "$choice" =~ ^[Yy]$ ]]; then
            echo "Descargando la última versión de WP-CLI..."
            wget https://github.com/wp-cli/wp-cli/releases/latest/download/wp-cli.phar -O ./bin/wp || show_error "No se pudo descargar la última versión de WP-CLI." "Verifica tu conexión a Internet."
            chmod +x ./bin/wp || show_error "No se pudieron establecer los permisos de ejecución para WP-CLI." "Verifica los permisos de archivo."
            echo "WP-CLI actualizado a la versión $latest_version."
        fi
    fi
else
    echo "Descargando WP-CLI..."
    wget https://github.com/wp-cli/wp-cli/releases/latest/download/wp-cli.phar -O ./bin/wp || show_error "No se pudo descargar WP-CLI." "Verifica tu conexión a Internet."
    chmod +x ./bin/wp || show_error "No se pudieron establecer los permisos de ejecución para WP-CLI." "Verifica los permisos de archivo."
fi

echo "Instalación completa."
