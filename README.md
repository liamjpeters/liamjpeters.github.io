# Personal Blog

A modern, responsive personal blog built with Hugo static site generator and styled with Tailwind CSS. Features a custom hand-rolled theme with full dark/light mode support, responsive design, and blog series organization.

## Features

-   ⚡ **Hugo Static Site Generator**: Lightning-fast static site generation
-   🎨 **Custom Theme**: Hand-rolled responsive design with Tailwind CSS CLI
-   🌓 **Smart Theme Switching**: Light/dark mode with system preference detection
-   📱 **Fully Responsive**: Mobile-first design with adaptive navigation
-   � **Blog Series Support**: Organize posts into multi-part series
-   🎯 **Syntax Highlighting**: Dracula theme for beautiful code blocks
-   � **VS Code Integration**: Prettier and Headwind extensions for formatting
-   🚀 **GitHub Pages Ready**: Automated deployment workflow

## Quick Start

### Prerequisites

-   [Hugo](https://gohugo.io/installation/) (extended version)
-   [Tailwind CSS CLI](https://tailwindcss.com/blog/standalone-cli) standalone executable
-   VS Code with recommended extensions (optional but recommended)

### Development

1. **Clone and setup**:

    ```bash
    git clone <your-repo-url>
    cd <your-repo-name>
    ```

2. **Start development server**:

    ```bash
    hugo server --buildDrafts
    ```

3. **Visit your site**: `http://localhost:1313`

### VS Code Development (Recommended)

The project includes VS Code tasks for streamlined development:

-   **Hugo Server (Development)**: Starts server with draft posts
-   **Hugo Server (Production Preview)**: Production preview mode
-   **Build Site**: Full production build

Press `Ctrl+Shift+P` → "Tasks: Run Task" to access these.

## Project Structure

```
hugo-blog/
├── .github/
│   └── workflows/
│       └── hugo.yml              # GitHub Pages deployment
├── .vscode/
│   ├── extensions.json           # Recommended VS Code extensions
│   └── settings.json             # Code formatting preferences
├── assets/
│   ├── css/
│   │   ├── input.css             # Tailwind CSS source
│   │   ├── base.css              # Base styles
│   │   ├── utilities.css         # Custom utilities
│   │   ├── components/           # Component styles
│   │   └── themes/
│   │       └── dracula.css       # Syntax highlighting theme
│   ├── icons/                    # SVG icon collection
│   └── img/                      # Images and media
├── content/
│   ├── posts/                    # Blog posts
│   │   └── series-name/          # Series posts grouped by folder
│   ├── series/                   # Series definitions
│   └── about.md                  # About page
├── layouts/
│   ├── _default/
│   │   ├── baseof.html           # Base template with theme system
│   │   ├── list.html             # Archive/listing pages
│   │   └── single.html           # Individual post pages
│   ├── partials/
│   │   ├── css.html              # CSS processing
│   │   ├── icon.html             # Icon system
│   │   └── series-badge.html     # Series navigation
│   ├── posts/                    # Post-specific templates
│   ├── series/                   # Series-specific templates
│   └── shortcodes/               # Custom Hugo shortcodes
├── static/                       # Static assets (served as-is)
├── .prettierrc                   # Prettier configuration
├── hugo.toml                     # Hugo configuration
├── tailwind.config.js            # Tailwind CSS configuration
└── README.md
```

## Content Management

### Creating a New Post

Create a new Markdown file in the `content/posts/` directory:

```bash
# Create the file
touch content/posts/my-new-post.md
```

**Example front matter**:

```yaml
---
title: "Getting Started with Hugo"
date: 2025-01-15T10:00:00Z
draft: true
tags: ["hugo", "web-development", "tutorial"]
featured_image: "images/hugo-getting-started.jpg"
description: "A beginner's guide to building websites with Hugo static site generator"
# Optional series fields
series: "hugo-basics"
series_part: 1
---
Your post content here using Markdown...
```

**Front matter fields**:

-   `title`: Post title displayed on the page
-   `date`: Publication date in ISO 8601 format
-   `draft`: Set to `true` for unpublished posts, `false` to publish
-   `tags`: Array of tags for categorization
-   `featured_image`: Path to the post's featured image
-   `description`: Short snippet shown on list pages and meta descriptions
-   `series`: (Optional) Links post to a series by series filename
-   `series_part`: (Optional) Numeric order within the series

### Creating a Series

Create a new Markdown file in the `content/series/` directory:

```bash
# Create the series definition file
touch content/series/hugo-basics.md
```

**Series front matter example**:

```yaml
---
title: "Hugo Basics"
description: "A comprehensive guide to building static sites with Hugo"
color: "#FF6B6B"
order: 1
visible: true
draft: false
---
This series covers everything you need to know about Hugo, from installation to advanced templating techniques.
```

**Series front matter fields**:

-   `title`: Display name for the series
-   `description`: Brief overview of what the series covers
-   `color`: Hex color code for series branding/badges
-   `order`: Numeric order for series display (lower numbers first)
-   `visible`: Set to `true` to show in production, `false` to keep hidden
-   `draft`: Keep as `false` so Hugo processes the file

**Development vs Production**:

-   **Development**: `hugo server --buildDrafts` shows all series (including `visible: false`)
-   **Production**: `hugo` only shows series with `visible: true`

**Note**: The series filename (e.g., `hugo-basics.md`) serves as the unique identifier that posts reference in their `series` field.

## Building and Deployment

### Local Development

```bash
# Start Hugo development server
hugo server --buildDrafts
```

Hugo automatically:

-   Renders HTML templates and generates `hugo_stats.json`
-   Processes Tailwind CSS using the stats file for class detection
-   Serves the site with live reload at `http://localhost:1313`

### Production Build

```bash
# Build site (Hugo handles CSS processing automatically)
hugo --minify
```

Hugo automatically:

-   Generates optimized HTML and `hugo_stats.json`
-   Processes and minifies Tailwind CSS based on detected classes
-   Creates fingerprinted/thumbprinted assets for cache busting
-   Outputs everything to the `public/` directory

### GitHub Pages Deployment

The site automatically deploys to GitHub Pages when you push to the main branch:

1. **Enable GitHub Pages** in repository settings
2. **Set source to "GitHub Actions"**
3. **Update `baseURL`** in `hugo.toml` to your GitHub Pages URL
4. **Push to main branch** - deployment is automatic

The workflow handles both CSS building and Hugo site generation.

## Theme Features

### Theme Switching System

The site supports three theme modes:

-   **System** (default): Follows your device's preference
-   **Light**: Force light mode
-   **Dark**: Force dark mode

**How it works**:

-   JavaScript detects system preference via `prefers-color-scheme`
-   Theme choice persists in localStorage
-   Prevents flash of unstyled content (FOUC)
-   Icons update to reflect current state
-   Keyboard shortcut: `Ctrl+Shift+D` (or `Cmd+Shift+D` on Mac)

### Responsive Navigation

**Desktop**: Horizontal menu with theme toggle
**Mobile**: Collapsible hamburger menu with mobile-optimized theme toggle

**Features**:

-   Smooth animations and transitions
-   Keyboard navigation support
-   ARIA accessibility attributes
-   Auto-closes on window resize
-   Backdrop blur effects

### Code Syntax Highlighting

Uses **Dracula theme** for syntax highlighting with:

-   Copy-to-clipboard functionality
-   Line number support
-   Multiple language support
-   Dark/light mode compatibility

## Development Tools

### VS Code Extensions

The project recommends these extensions (auto-suggested when you open the project):

-   **Hugo Language Support**: Template syntax highlighting
-   **Prettier**: Code formatting
-   **Headwind**: Tailwind CSS class sorting
-   **Tailwind CSS IntelliSense**: Autocomplete and previews

### Formatting Configuration

-   **4 spaces** for indentation
-   **120 character** line limit
-   **Format on save** enabled
-   **Tailwind class sorting** with Headwind
-   **Prettier** for CSS, JS, JSON, and Markdown

## Customization

### Colors and Design

Edit `tailwind.config.js`:

```javascript
module.exports = {
    theme: {
        extend: {
            colors: {
                primary: {
                    // Your brand colors
                },
            },
        },
    },
};
```

### Layout Templates

Customize templates in `layouts/`:

-   `baseof.html`: Overall site structure
-   `single.html`: Individual post layout
-   `list.html`: Archive and listing pages

### Custom Styles

Add styles to `assets/css/input.css`:

```css
@layer components {
    .custom-component {
        @apply bg-white dark:bg-gray-800 rounded-lg shadow;
    }
}
```

## Troubleshooting

**CSS not updating**: Rebuild CSS with Tailwind CLI and restart Hugo server
**Template errors**: Check Hugo template syntax in layouts
**Series not linking**: Ensure series name matches between content/series/ and post front matter

## Attributions

### Icons

Icons throughout this site are from [Heroicons](https://heroicons.com/):

-   **Created by**: Tailwind Labs
-   **License**: MIT License
-   **Source**: https://heroicons.com/
-   **GitHub**: https://github.com/tailwindlabs/heroicons

Beautiful hand-crafted SVG icons, organized in `assets/icons/` and accessible via the `{{< icon >}}` partial.

## License

This project is open source and available under the [MIT License](LICENSE).

## Note:

_README Written by GitHub Copilot_
