#!/bin/bash
# ==============================================================================
# Script: setup_firebase.sh
# Description: Configures Firebase for Dev & Prod environments (Android & iOS)
#              using FlutterFire CLI.
# Package Name / Bundle ID:
#   - Prod: com.prakashbahadurchand.flutter_prakash_core_example / com.prakashbahadurchand.flutterPrakashCoreExample
#   - Dev:  com.prakashbahadurchand.flutter_prakash_core_example.dev / com.prakashbahadurchand.flutterPrakashCoreExample.dev
# Outputs:
#   - Dev:  lib/firebase_options_dev.dart
#   - Prod: lib/firebase_options_prod.dart
# ==============================================================================

set -e

# ANSI Color Codes
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Determine example project root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXAMPLE_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

cd "${EXAMPLE_DIR}"

# Package / Bundle ID Configurations
PROD_ANDROID_PKG="com.prakashbahadurchand.flutter_prakash_core_example"
DEV_ANDROID_PKG="com.prakashbahadurchand.flutter_prakash_core_example.dev"

PROD_IOS_BUNDLE="com.prakashbahadurchand.flutterPrakashCoreExample"
DEV_IOS_BUNDLE="com.prakashbahadurchand.flutterPrakashCoreExample.dev"

DEV_OUT_FILE="lib/firebase_options_dev.dart"
PROD_OUT_FILE="lib/firebase_options_prod.dart"

# Helper print functions
log_info() {
    echo -e "${CYAN}==> ${NC}${BOLD}$1${NC}"
}

log_success() {
    echo -e "${GREEN}✔ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

log_error() {
    echo -e "${RED}✖ $1${NC}"
}

# Banner
print_banner() {
    echo -e "${CYAN}"
    echo "=========================================================================="
    echo "          🔥 FIREBASE ENVIRONMENT SETUP (FLUTTERFIRE CLI) 🔥              "
    echo "=========================================================================="
    echo -e "${NC}"
}

# Check prerequisites
check_prerequisites() {
    log_info "Verifying required tools..."

    # Check Flutter
    if ! command -v flutter &> /dev/null; then
        log_error "Flutter is not installed or not available in PATH."
        exit 1
    fi

    # Check Firebase CLI
    if ! command -v firebase &> /dev/null; then
        log_warning "Firebase CLI ('firebase') is not installed in PATH."
        echo -e "Please install it using: ${BOLD}npm install -g firebase-tools${NC} or ${BOLD}curl -sL https://firebase.tools | bash${NC}"
        echo -e "Proceeding if flutterfire CLI can still function...\n"
    fi

    # Check FlutterFire CLI
    if ! command -v flutterfire &> /dev/null; then
        log_warning "FlutterFire CLI ('flutterfire') is not found in PATH."
        echo -e "${YELLOW}Attempting to activate flutterfire_cli globally via Dart...${NC}"
        dart pub global activate flutterfire_cli
        export PATH="$PATH":"$HOME/.pub-cache/bin"
        
        if ! command -v flutterfire &> /dev/null; then
            log_error "Failed to locate flutterfire CLI after activation. Please add '$HOME/.pub-cache/bin' to your PATH."
            exit 1
        fi
        log_success "flutterfire_cli activated successfully!"
    fi

    log_success "All prerequisite CLI tools are available."
    echo ""
}

# Configure Development Firebase
configure_dev() {
    local project_id="$1"
    
    echo -e "\n${YELLOW}--------------------------------------------------------------------------${NC}"
    echo -e "${BOLD}🚀 Configuring Development Firebase (.dev)${NC}"
    echo -e "${YELLOW}--------------------------------------------------------------------------${NC}"
    echo -e "Android Package Name: ${GREEN}${DEV_ANDROID_PKG}${NC}"
    echo -e "iOS Bundle Identifier: ${GREEN}${DEV_IOS_BUNDLE}${NC}"
    echo -e "Generated Output File: ${GREEN}${DEV_OUT_FILE}${NC}"
    echo -e "Platforms:             ${GREEN}android, ios${NC}"
    echo ""

    if [ -z "$project_id" ]; then
        read -r -p "Enter Firebase DEV Project ID (leave empty to select interactively via CLI): " project_id
    fi

    if [ -n "$project_id" ]; then
        log_info "Running FlutterFire configure for project: ${project_id}"
        flutterfire configure \
            --project="${project_id}" \
            --platforms=android,ios \
            --out="${DEV_OUT_FILE}" \
            --android-package-name="${DEV_ANDROID_PKG}" \
            --ios-bundle-id="${DEV_IOS_BUNDLE}" \
            --yes
    else
        log_info "Launching interactive FlutterFire configuration for DEV..."
        flutterfire configure \
            --platforms=android,ios \
            --out="${DEV_OUT_FILE}" \
            --android-package-name="${DEV_ANDROID_PKG}" \
            --ios-bundle-id="${DEV_IOS_BUNDLE}"
    fi

    log_success "Development Firebase configuration completed: ${DEV_OUT_FILE}"
}

# Configure Production Firebase
configure_prod() {
    local project_id="$1"
    
    echo -e "\n${YELLOW}--------------------------------------------------------------------------${NC}"
    echo -e "${BOLD}🌟 Configuring Production Firebase (prod)${NC}"
    echo -e "${YELLOW}--------------------------------------------------------------------------${NC}"
    echo -e "Android Package Name: ${GREEN}${PROD_ANDROID_PKG}${NC}"
    echo -e "iOS Bundle Identifier: ${GREEN}${PROD_IOS_BUNDLE}${NC}"
    echo -e "Generated Output File: ${GREEN}${PROD_OUT_FILE}${NC}"
    echo -e "Platforms:             ${GREEN}android, ios${NC}"
    echo ""

    if [ -z "$project_id" ]; then
        read -r -p "Enter Firebase PROD Project ID (leave empty to select interactively via CLI): " project_id
    fi

    if [ -n "$project_id" ]; then
        log_info "Running FlutterFire configure for project: ${project_id}"
        flutterfire configure \
            --project="${project_id}" \
            --platforms=android,ios \
            --out="${PROD_OUT_FILE}" \
            --android-package-name="${PROD_ANDROID_PKG}" \
            --ios-bundle-id="${PROD_IOS_BUNDLE}" \
            --yes
    else
        log_info "Launching interactive FlutterFire configuration for PROD..."
        flutterfire configure \
            --platforms=android,ios \
            --out="${PROD_OUT_FILE}" \
            --android-package-name="${PROD_ANDROID_PKG}" \
            --ios-bundle-id="${PROD_IOS_BUNDLE}"
    fi

    log_success "Production Firebase configuration completed: ${PROD_OUT_FILE}"
}

# Main Execution Flow
main() {
    print_banner
    check_prerequisites

    local mode="$1"
    local dev_proj="$2"
    local prod_proj="$3"

    case "$mode" in
        dev)
            configure_dev "$dev_proj"
            ;;
        prod)
            configure_prod "$prod_proj"
            ;;
        all|both)
            configure_dev "$dev_proj"
            configure_prod "$prod_proj"
            ;;
        *)
            echo -e "${BOLD}Select configuration mode:${NC}"
            echo -e "  ${CYAN}1)${NC} Configure Development (.dev)"
            echo -e "  ${CYAN}2)${NC} Configure Production (prod)"
            echo -e "  ${CYAN}3)${NC} Configure Both (Dev & Prod)"
            echo -e "  ${CYAN}4)${NC} Exit"
            echo ""
            read -r -p "Enter choice [1-4]: " choice

            case "$choice" in
                1)
                    configure_dev ""
                    ;;
                2)
                    configure_prod ""
                    ;;
                3)
                    configure_dev ""
                    configure_prod ""
                    ;;
                4)
                    log_info "Exiting setup."
                    exit 0
                    ;;
                *)
                    log_error "Invalid option. Exiting."
                    exit 1
                    ;;
            esac
            ;;
    esac

    echo -e "\n${GREEN}==========================================================================${NC}"
    echo -e "${BOLD}🎉 Firebase Configuration Finished Successfully! 🎉${NC}"
    echo -e "${GREEN}==========================================================================${NC}"
    echo -e "Next steps in your Dart code:"
    echo -e "  • In ${CYAN}main_dev.dart${NC}: Import '${DEV_OUT_FILE}' & initialize with dev options."
    echo -e "  • In ${CYAN}main_prod.dart${NC}: Import '${PROD_OUT_FILE}' & initialize with prod options."
    echo ""
}

main "$@"
