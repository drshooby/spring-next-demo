# Client

Next.js/React/TypeScript frontend application.

## Development

```bash
npm install
npm run dev

# http://localhost:3000
```

## Production

```bash
npm run build
npm start
```

## Docker

```bash
docker build -t spring-next-demo-client .
docker run -p 3000:3000 spring-next-demo-client
```

## Environment

Create `.env.local`:

```env
NEXT_PUBLIC_API_URL=http://localhost:8080
```