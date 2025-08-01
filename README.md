# Personal Blog

The sources for [https://liampeters.co.uk](https://liampeters.co.uk) - A modern,
responsive personal blog built with Hugo static site generator and
styled with Tailwind CSS. Features a custom hand-rolled theme with full
dark/light mode support, responsive design, and blog series organization.

## Quick Start

### Prerequisites

-   [Hugo](https://gohugo.io/installation/) (extended version)
-   [Tailwind CSS CLI](https://tailwindcss.com/blog/standalone-cli) standalone
    executable
-   [Image Magick](https://imagemagick.org/index.php) for favicon generation
    (_optional_)
-   VS Code with recommended extensions (optional but recommended)

### Development

1. **Clone and setup**:

    ```powershell
    git clone https://github.com/liamjpeters/liamjpeters.github.io.git
    cd liamjpeters.github.io
    ```

2. **Start development server**:

    ```powershell
    hugo server --buildDrafts
    ```

3. **Visit site**: `http://localhost:1313`

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
├── hugo.json                     # Hugo configuration
├── tailwind.config.js            # Tailwind CSS configuration
├── GenerateFavicons.ps1          # Favicon generation script
└── README.md
```

## Content Management

### Creating a New Post

Create a new Markdown file in the `content/posts/` directory:

```powershell
New-Item content/posts/my-new-post.md
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

# Optional AI disclosures
ai_generated_image: true
ai_tool: "Google Pixel Studio (Imagen 3)"
ai_prompt: "Prompt used to generate the image"
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
-   `ai_generated_image`: (Optional) Set to `true` if the feature image is an
    AI-generated image
-   `ai_tool`: (Optional) Name of the AI tool used for image generation
-   `ai_prompt`: (Optional) Prompt used to generate the image

---

### Creating a Series

Create a new Markdown file in the `content/series/` directory:

```powershell
# Create the series definition file
New-Item content/series/hugo-basics.md
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
This series covers everything you need to know about Hugo, from installation to
advanced templating techniques.
```

**Series front matter fields**:

-   `title`: Display name for the series
-   `description`: Brief overview of what the series covers
-   `color`: Hex color code for series branding/badges
-   `order`: Numeric order for series display (lower numbers first)
-   `visible`: Set to `true` to show in production, `false` to keep hidden

**Development vs Production**:

-   **Development**: `hugo server --buildDrafts` shows all series (including
    `visible: false`)
-   **Production**: `hugo` only shows series with `visible: true`

**Note**: The series filename (e.g., `hugo-basics.md`) serves as the unique
identifier that posts reference in their `series` field.

## Building and Deployment

### Local Development

```powershell
# Start Hugo development server
hugo server --buildDrafts
```

Hugo automatically:

-   Renders HTML templates and generates `hugo_stats.json`
-   Processes Tailwind CSS using the stats file for class detection
-   Serves the site with live reload at `http://localhost:1313`

### Production Build

```powershell
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
3. **Update `baseURL`** in `hugo.json` to your GitHub Pages URL
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

The project recommends these extensions (auto-suggested when you open the
project):

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

_README mostly written by GitHub Copilot_
