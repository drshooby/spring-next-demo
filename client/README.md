# Client (Frontend)

This directory contains the frontend application built with Next.js, React, and TypeScript.

## Technology Stack

- **Next.js**: React framework with SSR/SSG capabilities
- **React**: Component-based UI library
- **TypeScript**: Type-safe JavaScript development
- **CSS/Styling**: Modern CSS solutions (to be configured)

## Features

- Server-side rendering (SSR) for improved performance and SEO
- Static site generation (SSG) for optimized content delivery
- API routes for backend integration
- Type-safe development with TypeScript
- Modern React hooks and functional components

## Getting Started

### Prerequisites
- Node.js 18+ and npm/yarn
- Docker (for containerized development)

### Local Development

```bash
# Install dependencies
npm install
# or
yarn install

# Start development server
npm run dev
# or
yarn dev

# Open http://localhost:3000 in your browser
```

### Building for Production

```bash
# Build the application
npm run build
# or
yarn build

# Start production server
npm start
# or
yarn start
```

### Docker Development

```bash
# Build the container
docker build -t spring-next-demo-client .

# Run the container
docker run -p 3000:3000 spring-next-demo-client
```

## Project Structure

```
client/
├── components/       # Reusable React components
├── pages/           # Next.js pages and API routes
├── styles/          # CSS and styling files
├── public/          # Static assets
├── types/           # TypeScript type definitions
├── utils/           # Utility functions
├── hooks/           # Custom React hooks
├── services/        # API service functions
├── Dockerfile       # Docker configuration
└── package.json     # Dependencies and scripts
```

## API Integration

The frontend integrates with the Spring Boot backend through:
- RESTful API calls to the server component
- Type-safe API interfaces defined in TypeScript
- Error handling and loading states
- Authentication and authorization (if implemented)

## Environment Configuration

Create a `.env.local` file for local development:

```env
NEXT_PUBLIC_API_URL=http://localhost:8080
# Add other environment variables as needed
```

## Deployment

The client application is containerized and deployed as part of the full-stack application on AWS EC2. The production build is optimized for performance with:

- Static asset optimization
- Code splitting and lazy loading
- Compressed bundle sizes
- CDN-ready static files

## Development Guidelines

- Use TypeScript for all new code
- Follow React best practices and hooks patterns
- Implement responsive design principles
- Write unit tests for components and utilities
- Use ESLint and Prettier for code formatting