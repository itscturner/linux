#!/bin/bash

# dev_packages.sh
# A cross-platform, fault-tolerant Bash script that installs development packages and tools across Ubuntu/Debian (apt), RHEL-based Linux (dnf), and macOS (brew).

set -euo pipefail

PACKAGES=(
    "ansible"
    "btop"
    "curl"
    "docker"
    "fzf"
    "git"
    "python3"
    "python3-pip"
    "terraform"
    "tmux"
    "vim"
    "wget"
)

AVAILABLE_PACKAGES=()
MISSING_PACKAGES=()

log_info() { echo -e "\033[1;34m[INFO]    \033[0m $*"; }
log_success() { echo -e "\033[1;32m[SUCCESS] \033[0m $*"; }
log_warn() { echo -e "\033[1;33m[WARN]    \033[0m $*"; }
log_error() { echo -e "\033[1;31m[ERROR]   \033[0m $*" >&2; }

log_info "📦 Detecting package manager and installing packages."

# 1. Ubuntu / Debian (apt)
if command -v apt-get &> /dev/null; then
    log_info "Using apt (Ubuntu/Debian)."
    echo ""
    . /etc/os-release

    sudo rm -f /etc/apt/sources.list.d/docker.list
    sudo apt-get update -y
    sudo apt-get install -y ca-certificates curl gnupg lsb-release software-properties-common
    sudo install -m 0755 -d /etc/apt/keyrings

    if [[ "$ID" == "debian" || ( "${ID_LIKE:-}" == *"debian"* && "${ID_LIKE:-}" != *"ubuntu"* ) ]]; then
        DOCKER_OS="debian"
        CODENAME="${VERSION_CODENAME}"
    else
        DOCKER_OS="ubuntu"
        CODENAME="${UBUNTU_CODENAME:-$VERSION_CODENAME}"
    fi

    curl -fsSL https://hashicorp.com | sudo gpg --dearmor --yes -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://hashicorp.com ${CODENAME} main" | sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null

    curl -fsSL "https://docker.com{DOCKER_OS}/gpg" | sudo gpg --dearmor --yes -o /usr/share/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://docker.com{DOCKER_OS} ${CODENAME} stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update -y

    for pkg in "${PACKAGES[@]}"; do
        target_pkg="$pkg"
        [[ "$pkg" == "docker" ]] && target_pkg="docker-ce"

        if apt-cache policy "$target_pkg" 2>/dev/null | grep -q "Candidate:" && \
           ! apt-cache policy "$target_pkg" 2>/dev/null | grep -q "Candidate: (none)"; then
            AVAILABLE_PACKAGES+=("$target_pkg")
        else
            MISSING_PACKAGES+=("$pkg")
        fi
    done

    if [[ ${#AVAILABLE_PACKAGES[@]} -gt 0 ]]; then
        sudo apt-get install -y "${AVAILABLE_PACKAGES[@]}"
    fi

# 2. RHEL / Rocky / AlmaLinux / Fedora (dnf)
elif command -v dnf &> /dev/null; then
    log_info "Using dnf (RHEL/Fedora)."
    echo ""
    . /etc/os-release

    sudo rm -f /etc/yum.repos.d/docker-ce.repo /etc/yum.repos.d/hashicorp.repo
    sudo dnf clean all

    sudo dnf install -y dnf-plugins-core epel-release curl || true

    MAJOR_VER="${VERSION_ID%%.*}"
    ARCH="$(uname -m)"

    if [[ "$ID" == "fedora" ]]; then
        HASHICORP_URL="https://hashicorp.com{MAJOR_VER}/${ARCH}/stable"
        DOCKER_CANDIDATES=("https://docker.com{MAJOR_VER}/${ARCH}/stable")
        DOCKER_GPG="https://docker.com"
    else
        HASHICORP_URL="https://hashicorp.com{MAJOR_VER}/${ARCH}/stable"
        # Check 'rhel' path first, then fall back to 'centos' path
        DOCKER_CANDIDATES=(
            "https://download.docker.com/linux/rhel/${MAJOR_VER}/${ARCH}/stable"
            "https://download.docker.com/linux/centos/${MAJOR_VER}/${ARCH}/stable"
        )
        DOCKER_GPG="https://docker.com"
    fi

    if curl -fsI "${HASHICORP_URL}/repodata/repomd.xml" &> /dev/null; then
        cat <<EOF | sudo tee /etc/yum.repos.d/hashicorp.repo > /dev/null
[hashicorp]
name=Hashicorp Stable - ${ARCH}
baseurl=${HASHICORP_URL}
enabled=1
gpgcheck=1
gpgkey=https://hashicorp.com
skip_if_unavailable=True
EOF
    else
        log_warning "HashiCorp repo not found at ${HASHICORP_URL}; skipping repo setup."
    fi

    VALID_DOCKER_URL=""
    for candidate in "${DOCKER_CANDIDATES[@]}"; do
        if curl -fsI "${candidate}/repodata/repomd.xml" &> /dev/null; then
            VALID_DOCKER_URL="$candidate"
            break
        fi
    done

    if [[ -n "$VALID_DOCKER_URL" ]]; then
        echo "Verified Docker repository: ${VALID_DOCKER_URL}"
        cat <<EOF | sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null
[docker-ce-stable]
name=Docker CE Stable - ${ARCH}
baseurl=${VALID_DOCKER_URL}
enabled=1
gpgcheck=1
gpgkey=${DOCKER_GPG}
skip_if_unavailable=True
EOF
    else
        log_warning "No valid Docker repository found for ${ID} ${MAJOR_VER} (${ARCH}); skipping Docker repo."
    fi

    sudo dnf makecache

    for pkg in "${PACKAGES[@]}"; do
        target_pkg="$pkg"
        [[ "$pkg" == "docker" ]] && target_pkg="docker-ce"

        if dnf list --available "$target_pkg" &> /dev/null || dnf list --installed "$target_pkg" &> /dev/null; then
            AVAILABLE_PACKAGES+=("$target_pkg")
        else
            MISSING_PACKAGES+=("$pkg")
        fi
    done

    if [[ ${#AVAILABLE_PACKAGES[@]} -gt 0 ]]; then
        sudo dnf install -y "${AVAILABLE_PACKAGES[@]}"
    fi

# 3. macOS (Homebrew)
elif command -v brew &> /dev/null; then
    log_info "Using Homebrew (macOS)."
    echo ""
    brew update

    for pkg in "${PACKAGES[@]}"; do
        if brew info "$pkg" &> /dev/null; then
            AVAILABLE_PACKAGES+=("$pkg")
        else
            MISSING_PACKAGES+=("$pkg")
        fi
    done

    if [[ ${#AVAILABLE_PACKAGES[@]} -gt 0 ]]; then
        brew install "${AVAILABLE_PACKAGES[@]}"
    fi

else
    log_error "No supported package manager found (apt, dnf, or brew)."
    exit 1
fi

if [[ ${#AVAILABLE_PACKAGES[@]} -gt 0 ]]; then
    log_success "Installed (${#AVAILABLE_PACKAGES[@]}):"
    printf '  - %s\n' "${AVAILABLE_PACKAGES[@]}"
fi

if [[ ${#MISSING_PACKAGES[@]} -gt 0 ]]; then
    echo ""
    log_warning "Not Found / Skipped (${#MISSING_PACKAGES[@]}):"
    printf '  - %s\n' "${MISSING_PACKAGES[@]}"
else
    echo ""
    log_success "✅ All requested packages were found!"
fi
