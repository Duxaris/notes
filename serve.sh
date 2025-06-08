#!/bin/bash
# MkDocs Development Server Script
# Usage: ./serve.sh

cd "$(dirname "$0")"
source mkdocs-env/bin/activate
echo "Starting MkDocs development server..."
echo "Site will be available at: http://127.0.0.1:8001/notes/"
mkdocs serve --dev-addr 127.0.0.1:8001
