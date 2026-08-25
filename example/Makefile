.PHONY: help setup fresh get clean gen gen-clean watch analyze fmt lint fix check outdated upgrade doctor run-dev run-prod build-apk-dev build-apk-prod build-appbundle-dev build-appbundle-prod build-dev-apk build-prod-apk build-dev-aab build-prod-aab app-icon icons-dev icons-prod native-splash splash-dev splash-prod firebase-config firebase-config-dev firebase-config-prod deploy-firebase-dev deploy-firebase-prod deploy-playstore-internal deploy-playstore-beta deploy-playstore-prod deploy-play-internal deploy-play-beta deploy-play-prod

# Default target
.DEFAULT_GOAL := help

# Colors
CYAN    := \033[36m
GREEN   := \033[32m
YELLOW  := \033[33m
RESET   := \033[0m

# Help Target
help: ## Display this help menu
	@echo ""
	@echo "=========================================================================="
	@echo "                   HAMRO MAYA - MAKEFILE WORKFLOW                         "
	@echo "=========================================================================="
	@echo ""
	@echo "$(YELLOW)[ 🛠️  SETUP & MAINTENANCE ]$(RESET)"
	@echo "  $(CYAN)setup$(RESET)                    First-time setup (pub get + codegen + analyze)"
	@echo "  $(CYAN)fresh$(RESET)                    Complete fresh rebuild (clean + pub get + codegen + analyze)"
	@echo "  $(CYAN)get$(RESET)                      Install dependencies (flutter pub get)"
	@echo "  $(CYAN)clean$(RESET)                    Clean build artifacts and cache"
	@echo "  $(CYAN)outdated$(RESET)                 Check for outdated package dependencies"
	@echo "  $(CYAN)upgrade$(RESET)                  Upgrade package dependencies"
	@echo "  $(CYAN)doctor$(RESET)                   Run flutter doctor diagnostics"
	@echo ""
	@echo "$(YELLOW)[ 🔥 FIREBASE CONFIGURATION ]$(RESET)"
	@echo "  $(CYAN)firebase-config$(RESET)          Configure Firebase (Interactive for DEV & PROD)"
	@echo "  $(CYAN)firebase-config-dev$(RESET)      Configure Firebase for DEV environment"
	@echo "  $(CYAN)firebase-config-prod$(RESET)     Configure Firebase for PROD environment"
	@echo ""
	@echo "$(YELLOW)[ ⚡ CODE GENERATION & QUALITY ]$(RESET)"
	@echo "  $(CYAN)gen$(RESET)                      Run build_runner code generation"
	@echo "  $(CYAN)gen-clean$(RESET)                Clean build_runner cache & regenerate code"
	@echo "  $(CYAN)watch$(RESET)                    Run build_runner in watch mode"
	@echo "  $(CYAN)analyze$(RESET)                  Run static code analysis (flutter analyze)"
	@echo "  $(CYAN)fmt$(RESET)                      Format Dart code according to official guidelines"
	@echo "  $(CYAN)lint$(RESET)                     Format Dart code & run static analysis"
	@echo "  $(CYAN)fix$(RESET)                      Apply automatic Dart fixes (dart fix --apply)"
	@echo "  $(CYAN)check$(RESET)                    Run full quality check (lint + analyze)"
	@echo ""
	@echo "$(YELLOW)[ 📱 RUNNING APPLICATION ]$(RESET)"
	@echo "  $(CYAN)run-dev$(RESET)                  Run DEV flavor with .env.dev"
	@echo "  $(CYAN)run-prod$(RESET)                 Run PROD flavor with .env.prod"
	@echo ""
	@echo "$(YELLOW)[ 📦 BUILDING APK ARTIFACTS ]$(RESET)"
	@echo "  $(CYAN)build-apk-dev$(RESET)            Build DEV APK with .env.dev"
	@echo "  $(CYAN)build-apk-prod$(RESET)           Build PROD APK with .env.prod"
	@echo ""
	@echo "$(YELLOW)[ 📦 BUILDING APP BUNDLE ARTIFACTS ]$(RESET)"
	@echo "  $(CYAN)build-appbundle-dev$(RESET)      Build DEV App Bundle (.aab) with .env.dev"
	@echo "  $(CYAN)build-appbundle-prod$(RESET)     Build PROD App Bundle (.aab) with .env.prod"
	@echo ""
	@echo "$(YELLOW)[ 🎨 BRANDING & ASSETS ]$(RESET)"
	@echo "  $(CYAN)app-icon$(RESET)                 Generate Launcher Icons (DEV & PROD)"
	@echo "  $(CYAN)icons-dev$(RESET)                Generate Launcher Icons for DEV"
	@echo "  $(CYAN)icons-prod$(RESET)               Generate Launcher Icons for PROD"
	@echo "  $(CYAN)native-splash$(RESET)             Generate Native Splash Screen (DEV & PROD)"
	@echo "  $(CYAN)splash-dev$(RESET)              Generate Native Splash Screen for DEV"
	@echo "  $(CYAN)splash-prod$(RESET)             Generate Native Splash Screen for PROD"
	@echo ""
	@echo "$(YELLOW)[ 🚢 AUTOMATED FASTLANE CI/CD DEPLOYMENTS ]$(RESET)"
	@echo "  $(CYAN)deploy-firebase-dev$(RESET)      Deploy DEV build to Firebase App Distribution"
	@echo "  $(CYAN)deploy-firebase-prod$(RESET)     Deploy PROD candidate build to Firebase App Distribution"
	@echo "  $(CYAN)deploy-playstore-internal$(RESET) Deploy PROD build to Google Play Internal Testing"
	@echo "  $(CYAN)deploy-playstore-beta$(RESET)     Deploy PROD build to Google Play Beta Track"
	@echo "  $(CYAN)deploy-playstore-prod$(RESET)     Promote build to Google Play Production Track"
	@echo ""

# ==============================================================================
# 🛠️ SETUP & MAINTENANCE
# ==============================================================================

setup: get gen analyze ## First-time project setup (pub get + codegen + analyze)

fresh: clean get gen analyze ## Complete fresh rebuild (clean + pub get + codegen + analyze)

get: ## Install dependencies
	flutter pub get

clean: ## Clean build artifacts and cache
	flutter clean

outdated: ## Check for outdated package dependencies
	flutter pub outdated

upgrade: ## Upgrade package dependencies
	flutter pub upgrade

doctor: ## Run flutter doctor diagnostics
	flutter doctor -v

# ==============================================================================
# ⚡ CODE GENERATION & QUALITY
# ==============================================================================

gen: ## Run build_runner code generation
	dart run build_runner build --delete-conflicting-outputs

gen-clean: ## Clean build_runner cache & regenerate code
	dart run build_runner clean
	dart run build_runner build --delete-conflicting-outputs

watch: ## Run build_runner in watch mode
	dart run build_runner watch --delete-conflicting-outputs

analyze: ## Run static code analysis
	flutter analyze

fmt: ## Format Dart code
	dart format .

lint: fmt analyze ## Format Dart code & run static analysis

fix: ## Apply automatic Dart fixes
	dart fix --apply

check: lint ## Run full quality check (lint + analyze)

# ==============================================================================
# 📱 RUNNING APPLICATION
# ==============================================================================

run-dev: ## Run app in DEV flavor with .env.dev
	flutter run -t lib/main_dev.dart --flavor dev --dart-define-from-file=.env.dev

run-prod: ## Run app in PROD flavor with .env.prod
	flutter run -t lib/main_prod.dart --flavor prod --dart-define-from-file=.env.prod

# ==============================================================================
# 📦 BUILDING APPLICATION ARTIFACTS
# ==============================================================================

build-apk-dev: ## Build DEV APK with .env.dev
	flutter build apk --flavor dev -t lib/main_dev.dart --dart-define-from-file=.env.dev

build-apk-prod: ## Build PROD APK with .env.prod
	flutter build apk --flavor prod -t lib/main_prod.dart --dart-define-from-file=.env.prod

build-appbundle-dev: ## Build DEV App Bundle (.aab) with .env.dev
	flutter build appbundle --flavor dev -t lib/main_dev.dart --dart-define-from-file=.env.dev

build-appbundle-prod: ## Build PROD App Bundle (.aab) with .env.prod
	flutter build appbundle --flavor prod -t lib/main_prod.dart --dart-define-from-file=.env.prod

# Convenience Aliases
build-dev-apk: build-apk-dev
build-prod-apk: build-apk-prod
build-dev-aab: build-appbundle-dev
build-prod-aab: build-appbundle-prod

# ==============================================================================
# 🎨 BRANDING & ASSETS
# ==============================================================================

app-icon: icons-dev icons-prod ## Generate Launcher Icons for both DEV & PROD

icons-dev: ## Generate Launcher Icons for DEV
	dart run flutter_launcher_icons:main -f flutter_launcher_icons-dev.yaml

icons-prod: ## Generate Launcher Icons for PROD
	dart run flutter_launcher_icons:main -f flutter_launcher_icons-prod.yaml

native-splash: splash-dev splash-prod ## Generate Native Splash Screen for both DEV & PROD

splash-dev: ## Generate Native Splash Screen for DEV
	dart run flutter_native_splash:create --path=flutter_native_splash-dev.yaml

splash-prod: ## Generate Native Splash Screen for PROD
	dart run flutter_native_splash:create --path=flutter_native_splash-prod.yaml

# ==============================================================================
# 🔥 FIREBASE CONFIGURATION
# ==============================================================================

firebase-config: ## Interactive Firebase setup for DEV & PROD
	./tools/setup_firebase.sh

firebase-config-dev: ## Configure Firebase for DEV environment
	./tools/setup_firebase.sh dev

firebase-config-prod: ## Configure Firebase for PROD environment
	./tools/setup_firebase.sh prod

# ==============================================================================
# 🚢 AUTOMATED FASTLANE DEPLOYMENTS
# ==============================================================================

deploy-firebase-dev: ## Deploy DEV build to Firebase App Distribution
	cd android && bundle exec fastlane dev_firebase

deploy-firebase-prod: ## Deploy PROD build to Firebase App Distribution
	cd android && bundle exec fastlane prod_firebase

deploy-playstore-internal: ## Deploy PROD build to Google Play Internal Testing
	cd android && bundle exec fastlane internal_testing

deploy-playstore-beta: ## Deploy PROD build to Google Play Beta Track
	cd android && bundle exec fastlane beta

deploy-playstore-prod: ## Promote build to Google Play Production Track
	cd android && bundle exec fastlane production

# Convenience Aliases
deploy-play-internal: deploy-playstore-internal
deploy-play-beta: deploy-playstore-beta
deploy-play-prod: deploy-playstore-prod
