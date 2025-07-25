<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

# Hugo + Tailwind CSS Blog

This is a Hugo static site blog with custom Tailwind CSS styling, designed for deployment on GitHub Pages.

## Project Structure
- `layouts/` - Hugo template files using Tailwind CSS classes
- `content/` - Markdown content files for posts and pages
- `assets/css/` - Tailwind CSS source files
- `static/` - Static assets (images, fonts, etc.)
- `tailwind.config.js` - Tailwind CSS configuration

## Development Workflow
1. Use Hugo's native Tailwind CSS integration (no external CLI needed)
2. Run development server with: `hugo server --buildDrafts` or use VS Code task "Hugo Server (Development)"
3. Hugo automatically processes Tailwind CSS using css.TailwindCSS function
4. Access site at http://localhost:1313

## Tailwind CSS Integration
- Input file: `assets/css/input.css` with @source "hugo_stats.json" directive
- Processed automatically by Hugo's css.TailwindCSS function via `layouts/partials/css.html`
- Hugo buildStats tracks all CSS classes used across templates for dynamic class detection
- Custom utilities and components defined in input.css using @layer directives
- Responsive design with mobile-first approach

## Content Creation
- Blog posts: `content/posts/filename.md`
- Pages: `content/pagename.md`
- Use front matter for metadata (title, date, tags, etc.)

## Deployment
- GitHub Actions workflow deploys to GitHub Pages automatically
- Hugo builds both the site and processes Tailwind CSS natively on push to main branch
- No separate CSS build step required - Hugo handles everything
- Update `baseURL` in hugo.toml for your GitHub Pages URL

## Customization
- Modify `tailwind.config.js` for colors, fonts, and design tokens
- Edit layout files in `layouts/` for structure changes
- Add custom CSS in `assets/css/input.css` using @layer directives
