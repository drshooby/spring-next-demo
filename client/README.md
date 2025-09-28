# Client (Next.js Frontend)

This directory contains the Next.js frontend application for the spring-next-demo project. It provides a React-based user interface that communicates with the Spring Boot backend.

## Overview

A Next.js application configured for:
- **Static Site Generation**: Builds to static files for optimal performance
- **TypeScript**: Type-safe development experience  
- **NGINX Deployment**: Served by NGINX in production with API proxying
- **Docker**: Multi-stage build for optimized container images

## Dependencies

### Required Software
- **Node.js 18+**: Download from [nodejs.org](https://nodejs.org/)
- **npm**: Included with Node.js (or use yarn/pnpm)
- **Docker** (for containerized deployment)

### Check Node.js Installation
```bash
node --version
# Should show v18.0.0 or higher

npm --version
# Should show npm version
```

## Project Structure

```
client/
├── app/                   # Next.js App Router directory
│   ├── globals.css        # Global CSS styles
│   ├── layout.tsx         # Root layout component
│   ├── page.tsx          # Home page component (calls Spring Boot API)
│   ├── page.module.css   # Page-specific CSS modules
│   └── favicon.ico       # Site favicon
├── Dockerfile            # Multi-stage Docker build
├── eslint.config.mjs     # ESLint configuration for code quality
├── next.config.ts        # Next.js build configuration
├── package.json          # Dependencies and build scripts
├── package-lock.json     # Locked dependency versions  
├── tsconfig.json         # TypeScript configuration
└── README.md             # This file
```

## Usage Steps

### Local Development

#### 1. Install Dependencies
```bash
cd client/
npm install
```

#### 2. Run Development Server
```bash
npm run dev
```

The application starts on `http://localhost:3000` and features:
- **Hot reload**: Automatic browser refresh on code changes
- **API Integration**: Calls Spring Boot backend at `http://localhost:8080/hello`

#### 3. Build for Production
```bash
npm run build
```
This creates static files in the `out/` directory.

#### 4. Test Production Build Locally
```bash
npm run build
npx serve out
```

### Docker Development

#### Build and Run Container
```bash
cd client/
docker build -t next-client .
docker run -p 3000:80 next-client
```

### Full Stack Development

To run both client and server together:
```bash
cd /path/to/spring-next-demo
docker compose up --build
```

Access:
- **Frontend**: http://localhost:3000
- **Backend**: http://localhost:8080/hello

## Configuration

### `next.config.ts`
```typescript
const nextConfig = {
  output: 'export',          // Generate static files
  trailingSlash: true,       // Add trailing slashes to URLs
  images: {
    unoptimized: true        // Required for static export
  }
}
```

### `package.json` Scripts
```json
{
  "scripts": {
    "dev": "next dev",           # Development server
    "build": "next build",       # Production build
    "start": "next start",       # Production server (not used in static mode)
    "lint": "next lint"          # Code linting
  }
}
```

## API Integration

### Current Integration

The main page (`app/page.tsx`) demonstrates API integration:

```typescript
// Calls Spring Boot backend
const response = await fetch('http://localhost:8080/hello')
const message = await response.text()
```

### Adding New API Calls

#### 1. Create API Service (Recommended)
```typescript
// utils/api.ts
const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8080'

export const api = {
  hello: async () => {
    const response = await fetch(`${API_BASE_URL}/hello`)
    return response.text()
  },
  
  test: async () => {
    const response = await fetch(`${API_BASE_URL}/api/test`)
    return response.text()
  }
}
```

#### 2. Use in Components
```typescript
// app/page.tsx
import { api } from '../utils/api'

export default function Page() {
  const [message, setMessage] = useState('')
  
  useEffect(() => {
    api.hello().then(setMessage)
  }, [])
  
  return <div>{message}</div>
}
```

#### 3. Environment Variables
Create `.env.local` for different environments:
```bash
# .env.local
NEXT_PUBLIC_API_URL=https://your-domain.com
```

## Styling

### CSS Modules
Component-specific styles using CSS Modules:
```css
/* page.module.css */
.container {
  padding: 20px;
}

.title {
  color: blue;
}
```

```typescript
// page.tsx
import styles from './page.module.css'

export default function Page() {
  return <div className={styles.container}>
    <h1 className={styles.title}>Hello</h1>
  </div>
}
```

### Global Styles
Global styles in `app/globals.css` for site-wide styling.

## Docker Configuration

### Multi-stage Build

The `Dockerfile` uses a 3-stage build process:

1. **Dependencies Stage**: Install npm packages
2. **Build Stage**: Build static site
3. **Runtime Stage**: NGINX server with static files

### Key Features
- **Node 24 Alpine**: Minimal base image
- **Static Export**: No Node.js runtime needed in production  
- **NGINX Serving**: Fast static file serving with API proxying
- **Multi-platform**: Supports different CPU architectures

## Production Deployment

In production, the client is served by NGINX which:
- **Serves static files** from `/usr/share/nginx/html`
- **Proxies API requests** to the Spring Boot backend
- **Handles SSL termination** with Let's Encrypt certificates

## Development Tips

### Code Quality
```bash
# Run ESLint
npm run lint

# Fix auto-fixable issues
npm run lint -- --fix
```

### TypeScript
```bash
# Check types
npx tsc --noEmit

# Watch mode for type checking
npx tsc --noEmit --watch
```

### Performance
- Use `next/image` for optimized images (when not using static export)
- Implement code splitting with dynamic imports
- Use React.memo() for expensive components
- Monitor bundle size with `npm run build`

### Debugging
- Use browser DevTools for client-side debugging
- Check Network tab for API call issues
- Use React Developer Tools browser extension

## Common Issues

### API Connection Errors
```bash
# Check if backend is running
curl http://localhost:8080/hello

# Verify CORS configuration on backend
# Check network requests in browser DevTools
```

### Build Failures
```bash
# Clear Next.js cache
rm -rf .next

# Reinstall dependencies
rm -rf node_modules package-lock.json
npm install
```

### TypeScript Errors
```bash
# Check TypeScript configuration
npx tsc --showConfig

# Update TypeScript
npm install --save-dev typescript@latest
```

## Adding Features

### New Pages
Create new files in the `app/` directory following Next.js App Router conventions.

### API Routes (if needed)
Add server-side API routes in `app/api/` directory (though the Spring Boot backend handles most APIs).

### Middleware
Create `middleware.ts` in the root for request/response processing.

### Internationalization
Add `next-intl` or similar packages for multi-language support.
