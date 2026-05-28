#!/usr/bin/env bash
# Exit immediately if any command fails
set -o errexit

# Establish a local binary folder in the repository directory
BIN_DIR="$(pwd)/bin"
mkdir -p "$BIN_DIR"

echo "=== System Architecture ==="
echo "Node version: $(node -v)"
echo "NPM version: $(npm -v)"
echo "Target directory: $BIN_DIR"

echo "=== Installing n8n & Node dependencies ==="
npm install

echo "=== Installing FFmpeg (Static Linux Build) ==="
if [ ! -f "$BIN_DIR/ffmpeg" ]; then
    cd "$BIN_DIR"
    # Download reliable static build compiled for 64-bit Linux environments
    wget https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz
    
    echo "Extracting FFmpeg package..."
    tar -xf ffmpeg-release-amd64-static.tar.xz --strip-components=1
    
    echo "Cleaning up temporary tar archives..."
    rm -rf ffmpeg-release-amd64-static.tar.xz readme.txt manpages/
    chmod +x ffmpeg ffprobe
    cd ..
    echo "FFmpeg binaries configured successfully."
else
    echo "FFmpeg binaries already exist. Skipping download."
fi

echo "=== Installing yt-dlp (Standalone Linux Binary) ==="
if [ ! -f "$BIN_DIR/yt-dlp" ]; then
    echo "Fetching latest yt-dlp build..."
    curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o "$BIN_DIR/yt-dlp"
    chmod a+rx "$BIN_DIR/yt-dlp"
    echo "yt-dlp binary configured successfully."
else
    echo "yt-dlp binary already exist. Skipping download."
fi

echo "=== Validation Check ==="
echo "Local path contents:"
ls -la "$BIN_DIR"

echo "=== Custom Native Build Pipeline Complete ==="
