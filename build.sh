#!/bin/bash

# build.sh
# Script para compilar la ISO de Arch.
# Debe ejecutarse desde el directorio del perfil (ej: ./releng)

# --- Configuración ---

# Directorio de trabajo (temporal)
# Se creará aquí: ./out
WORK_DIR="./output"

# Directorio de salida (donde irá la ISO)
# Se creará aquí: ./out
OUT_DIR="output"

# El perfil a usar (el directorio actual)
PROFILE_DIR="."

# --- Script ---

# 1. Salir inmediatamente si un comando falla
set -e

# 2. Verificar si somos root (sudo)
if [[ $EUID -ne 0 ]]; then
   echo "ERROR: Este script debe ser ejecutado con sudo."
   echo "Por favor, ejecuta: sudo ./build.sh"
   exit 1
fi

# 3. Obtener las rutas absolutas
# Esto asegura que todo funcione sin importar desde dónde llames al script
# (Aunque es mejor llamarlo desde adentro del directorio)
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
WORK_PATH="$SCRIPT_DIR/$WORK_DIR"
OUT_PATH="$SCRIPT_DIR/$OUT_DIR"
PROFILE_PATH="$SCRIPT_DIR/$PROFILE_DIR"

# 4. Limpiar el directorio de trabajo anterior
if [ -d "$WORK_PATH" ]; then
    echo ">>> Limpiando directorio de trabajo anterior: $WORK_PATH"
    rm -rf "$WORK_PATH"
fi

# 5. Crear directorios (si no existen)
mkdir -p "$WORK_PATH"
mkdir -p "$OUT_PATH"

# 6. ¡Ejecutar el comando de compilación!
echo ">>> Iniciando la compilación de la ISO..."
echo "    Perfil: $PROFILE_PATH"
echo "    Trabajo: $WORK_PATH"
echo "    Salida:  $OUT_PATH"

mkarchiso -v -w "$WORK_PATH" -o "$OUT_PATH" "$PROFILE_PATH"

# 7. Éxito
echo ""
echo "----------------------------------------------------"
echo "¡Compilación exitosa!"
echo "Tu ISO está en: $OUT_PATH"
ls -lh "$OUT_PATH"
echo "----------------------------------------------------"
