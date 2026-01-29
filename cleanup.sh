#!/bin/bash
#
# cleanup.sh - Script for temporary file cleanup
# 
# This script cleans up temporary files and caches commonly accumulated
# on Arch Linux systems.
#
# Usage: ./cleanup.sh [options]
#   -h, --help      Show this help message
#   -n, --dry-run   Show what would be deleted without actually deleting
#   -v, --verbose   Show detailed output
#

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default options
DRY_RUN=0
VERBOSE=0

# Function to print help
print_help() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help      Show this help message"
    echo "  -n, --dry-run   Show what would be deleted without actually deleting"
    echo "  -v, --verbose   Show detailed output"
    echo ""
    echo "This script cleans up:"
    echo "  - Package manager cache (pacman)"
    echo "  - User cache directories"
    echo "  - Thumbnail cache"
    echo "  - Trash"
    echo "  - Old log files"
    echo "  - Temporary files"
}

# Function to log messages
log() {
    if [ $VERBOSE -eq 1 ]; then
        echo -e "${GREEN}[INFO]${NC} $1"
    fi
}

# Function to log warnings
warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Function to log errors
error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            print_help
            exit 0
            ;;
        -n|--dry-run)
            DRY_RUN=1
            shift
            ;;
        -v|--verbose)
            VERBOSE=1
            shift
            ;;
        *)
            error "Unknown option: $1"
            print_help
            exit 1
            ;;
    esac
done

# Check if running as root for system-wide cleanup
if [ "$EUID" -eq 0 ]; then
    warn "Running as root. This will perform system-wide cleanup."
    IS_ROOT=1
else
    log "Running as regular user. This will perform user-level cleanup only."
    IS_ROOT=0
fi

echo "Starting cleanup process..."
[ $DRY_RUN -eq 1 ] && echo "(DRY RUN - no files will be deleted)"
echo ""

# Calculate space before cleanup
SPACE_BEFORE=$(df -h / | awk 'NR==2 {print $4}')
log "Available space before cleanup: $SPACE_BEFORE"

# Clean package manager cache (requires root)
if [ $IS_ROOT -eq 1 ]; then
    log "Cleaning pacman cache..."
    if [ $DRY_RUN -eq 0 ]; then
        # Keep only the last 3 versions of packages
        paccache -rk3 2>/dev/null || warn "paccache not available, skipping"
        # Remove all uninstalled packages from cache
        paccache -ruk0 2>/dev/null || warn "paccache not available, skipping"
    else
        echo "Would clean pacman cache"
    fi
fi

# Clean user cache
if [ -d "$HOME/.cache" ]; then
    log "Cleaning user cache directory..."
    CACHE_SIZE=$(du -sh "$HOME/.cache" 2>/dev/null | cut -f1)
    log "Cache size: $CACHE_SIZE"
    if [ $DRY_RUN -eq 0 ]; then
        find "$HOME/.cache" -type f -atime +30 -delete 2>/dev/null && log "Cache cleaned" || warn "Could not clean some cache files"
    else
        echo "Would clean files in $HOME/.cache older than 30 days"
    fi
fi

# Clean thumbnail cache
if [ -d "$HOME/.cache/thumbnails" ]; then
    log "Cleaning thumbnail cache..."
    THUMB_SIZE=$(du -sh "$HOME/.cache/thumbnails" 2>/dev/null | cut -f1)
    log "Thumbnail cache size: $THUMB_SIZE"
    if [ $DRY_RUN -eq 0 ]; then
        [ -n "$HOME" ] && [ -d "$HOME/.cache/thumbnails" ] && rm -rf "$HOME/.cache/thumbnails"/* 2>/dev/null && log "Thumbnails cleaned" || warn "Could not clean thumbnail cache"
    else
        echo "Would clean thumbnail cache"
    fi
fi

# Clean trash
if [ -d "$HOME/.local/share/Trash" ]; then
    log "Cleaning trash..."
    TRASH_SIZE=$(du -sh "$HOME/.local/share/Trash" 2>/dev/null | cut -f1)
    log "Trash size: $TRASH_SIZE"
    if [ $DRY_RUN -eq 0 ]; then
        [ -n "$HOME" ] && [ -d "$HOME/.local/share/Trash" ] && rm -rf "$HOME/.local/share/Trash"/* 2>/dev/null && log "Trash emptied" || warn "Could not empty trash"
    else
        echo "Would empty trash"
    fi
fi

# Clean old logs (requires root)
if [ $IS_ROOT -eq 1 ]; then
    log "Cleaning old system logs..."
    if [ $DRY_RUN -eq 0 ]; then
        journalctl --vacuum-time=7d 2>/dev/null || warn "Could not clean journal logs"
    else
        echo "Would clean system logs older than 7 days"
    fi
fi

# Clean temporary files
if [ -d "/tmp" ]; then
    log "Cleaning /tmp directory..."
    if [ $DRY_RUN -eq 0 ] && [ $IS_ROOT -eq 1 ]; then
        find /tmp -type f -atime +7 -delete 2>/dev/null || warn "Could not clean some /tmp files"
    else
        echo "Would clean files in /tmp older than 7 days (requires root)"
    fi
fi

# Clean old browser cache if Firefox is installed
if [ -d "$HOME/.mozilla/firefox" ]; then
    log "Checking Firefox cache..."
    FIREFOX_CACHE=$(find "$HOME/.mozilla/firefox" -type d -name "cache2" 2>/dev/null | head -1)
    if [ -n "$FIREFOX_CACHE" ] && [ -d "$FIREFOX_CACHE" ]; then
        FIREFOX_SIZE=$(du -sh "$FIREFOX_CACHE" 2>/dev/null | cut -f1)
        log "Firefox cache size: $FIREFOX_SIZE"
        if [ $DRY_RUN -eq 0 ]; then
            rm -rf "$FIREFOX_CACHE"/* 2>/dev/null && log "Firefox cache cleaned" || warn "Could not clean Firefox cache"
        else
            echo "Would clean Firefox cache"
        fi
    fi
fi

# Calculate space after cleanup
SPACE_AFTER=$(df -h / | awk 'NR==2 {print $4}')
log "Available space after cleanup: $SPACE_AFTER"

echo ""
echo -e "${GREEN}Cleanup completed successfully!${NC}"
[ $DRY_RUN -eq 1 ] && echo "(This was a dry run - no files were deleted)"

exit 0
