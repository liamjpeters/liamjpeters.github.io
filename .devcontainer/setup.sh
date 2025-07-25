#!/bin/bash

echo "🚀 Setting up Hugo + Tailwind CSS development environment..."

# Ensure Hugo is installed and working
echo "📦 Checking Hugo installation..."
hugo version

# Install Tailwind CSS standalone CLI for the container
echo "🎨 Installing Tailwind CSS standalone CLI..."
curl -sLO https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-x64
chmod +x tailwindcss-linux-x64
sudo mv tailwindcss-linux-x64 /usr/local/bin/tailwindcss

# Verify Tailwind installation
echo "✅ Tailwind CSS version:"
tailwindcss --help | head -1

# Set up git configuration if not already set
echo "🔧 Configuring git..."
if [ -z "$(git config --global user.name)" ]; then
    echo "Please set your git user name: git config --global user.name 'Your Name'"
fi
if [ -z "$(git config --global user.email)" ]; then
    echo "Please set your git email: git config --global user.email 'your.email@example.com'"
fi

echo "✨ Setup complete! Run 'hugo server --buildDrafts' to start development."
echo "🌐 Your site will be available at http://localhost:1313"
