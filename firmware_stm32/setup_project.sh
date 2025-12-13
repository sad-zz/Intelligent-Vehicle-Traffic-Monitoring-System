#!/bin/bash

###############################################################################
# Vehicle Traffic Monitoring System - Project Setup Script
#
# This script copies custom driver and middleware files to your generated
# STM32CubeMX project directory.
#
# Usage:
#   ./setup_project.sh /path/to/generated/VehicleTrafficMonitor
#
# Example:
#   ./setup_project.sh ~/STM32_Projects/VehicleTrafficMonitor
#   ./setup_project.sh /mnt/d/STM32_Projects/VehicleTrafficMonitor
###############################################################################

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Print header
echo ""
echo "=========================================="
echo " Vehicle Traffic Monitoring System"
echo " Project Setup Script"
echo "=========================================="
echo ""

# Check if target directory is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: No target directory specified${NC}"
    echo ""
    echo "Usage: $0 <target_project_directory>"
    echo ""
    echo "Example:"
    echo "  $0 ~/STM32_Projects/VehicleTrafficMonitor"
    echo "  $0 /mnt/d/STM32_Projects/VehicleTrafficMonitor"
    echo ""
    exit 1
fi

TARGET_DIR="$1"

# Check if target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${RED}Error: Target directory does not exist: $TARGET_DIR${NC}"
    echo ""
    echo "Please generate code from STM32CubeMX first!"
    echo ""
    exit 1
fi

# Check if target looks like a valid STM32 project
if [ ! -d "$TARGET_DIR/Core" ] || [ ! -d "$TARGET_DIR/Drivers" ]; then
    echo -e "${RED}Error: Target directory doesn't appear to be a valid STM32 project${NC}"
    echo "Expected to find 'Core' and 'Drivers' subdirectories."
    echo ""
    exit 1
fi

echo "Source directory: $SCRIPT_DIR"
echo "Target directory: $TARGET_DIR"
echo ""

# Confirmation prompt
read -p "Continue with setup? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Setup cancelled."
    exit 0
fi

echo ""
echo "Setting up project..."
echo ""

# Function to copy files with error checking
copy_file() {
    local src="$1"
    local dst="$2"

    if [ -f "$src" ]; then
        cp "$src" "$dst"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓${NC} Copied $(basename "$src")"
            return 0
        else
            echo -e "${RED}✗${NC} Failed to copy $(basename "$src")"
            return 1
        fi
    else
        echo -e "${YELLOW}!${NC} Source file not found: $(basename "$src")"
        return 1
    fi
}

# Counter for successful operations
SUCCESS_COUNT=0
TOTAL_OPERATIONS=0

# 1. Create BSP directory
echo "[1/7] Creating Drivers/BSP directory..."
mkdir -p "$TARGET_DIR/Drivers/BSP"
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} Created Drivers/BSP"
    ((SUCCESS_COUNT++))
fi
((TOTAL_OPERATIONS++))
echo ""

# 2. Copy BSP driver source files
echo "[2/7] Copying BSP driver files (.c)..."
for file in "$SCRIPT_DIR/Drivers/BSP"/*.c; do
    if [ -f "$file" ]; then
        copy_file "$file" "$TARGET_DIR/Drivers/BSP/"
        ((SUCCESS_COUNT++))
        ((TOTAL_OPERATIONS++))
    fi
done
echo ""

# 3. Copy BSP driver header files
echo "[3/7] Copying BSP driver files (.h)..."
for file in "$SCRIPT_DIR/Drivers/BSP"/*.h; do
    if [ -f "$file" ]; then
        copy_file "$file" "$TARGET_DIR/Drivers/BSP/"
        ((SUCCESS_COUNT++))
        ((TOTAL_OPERATIONS++))
    fi
done
echo ""

# 4. Create Middleware directory
echo "[4/7] Creating Middleware directory..."
mkdir -p "$TARGET_DIR/Middleware"
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} Created Middleware"
    ((SUCCESS_COUNT++))
fi
((TOTAL_OPERATIONS++))
echo ""

# 5. Copy Middleware files
echo "[5/7] Copying Middleware files..."
for file in "$SCRIPT_DIR/Middleware"/*.h; do
    if [ -f "$file" ]; then
        copy_file "$file" "$TARGET_DIR/Middleware/"
        ((SUCCESS_COUNT++))
        ((TOTAL_OPERATIONS++))
    fi
done
echo ""

# 6. Copy config.h to Core/Inc
echo "[6/7] Copying config.h..."
copy_file "$SCRIPT_DIR/Core/Inc/config.h" "$TARGET_DIR/Core/Inc/"
if [ $? -eq 0 ]; then
    ((SUCCESS_COUNT++))
fi
((TOTAL_OPERATIONS++))
echo ""

# 7. Copy main.c to Core/Src (with backup)
echo "[7/7] Copying main.c..."
if [ -f "$TARGET_DIR/Core/Src/main.c" ]; then
    # Backup existing main.c
    BACKUP_FILE="$TARGET_DIR/Core/Src/main.c.backup_$(date +%Y%m%d_%H%M%S)"
    cp "$TARGET_DIR/Core/Src/main.c" "$BACKUP_FILE"
    echo -e "${YELLOW}!${NC} Backed up existing main.c to: $(basename "$BACKUP_FILE")"
fi

copy_file "$SCRIPT_DIR/Core/Src/main.c" "$TARGET_DIR/Core/Src/"
if [ $? -eq 0 ]; then
    ((SUCCESS_COUNT++))
fi
((TOTAL_OPERATIONS++))
echo ""

# Print summary
echo "=========================================="
echo " Setup Summary"
echo "=========================================="
echo "Successful operations: $SUCCESS_COUNT / $TOTAL_OPERATIONS"
echo ""

if [ $SUCCESS_COUNT -eq $TOTAL_OPERATIONS ]; then
    echo -e "${GREEN}✓ Setup completed successfully!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Open your project in STM32CubeIDE or Keil"
    echo "  2. Add include paths:"
    echo "     - ../Drivers/BSP"
    echo "     - ../Middleware"
    echo "  3. Refresh/rebuild the project"
    echo "  4. Flash to your STM32F407 board"
    echo ""
    echo "See FIRMWARE_BUILD_GUIDE.md for detailed instructions."
    echo ""
    exit 0
else
    echo -e "${YELLOW}⚠ Setup completed with warnings${NC}"
    echo ""
    echo "Some files may not have been copied successfully."
    echo "Please check the output above and copy missing files manually."
    echo ""
    exit 1
fi
