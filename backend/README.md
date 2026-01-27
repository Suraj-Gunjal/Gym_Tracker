# Gym Tracker Backend

Self-hosted Node.js/PostgreSQL backend for the Gym Tracker Flutter app.

## Features

- 🔐 JWT Authentication (access + refresh tokens)
- 📱 Multi-device support
- 🔄 Offline-first sync (push/pull)
- 🏋️ Exercise library (system + custom)
- 📊 Workout tracking
- 🏆 Personal records
- 🐳 Docker ready

## Quick Start

### Prerequisites

- Node.js 20+
- PostgreSQL 16+ (or Docker)
- npm or yarn

### Development Setup

1. **Clone and install:**

   ```bash
   cd backend
   npm install
   ```

2. **Configure environment:**

   ```bash
   cp .env.example .env
   # Edit .env with your settings
   ```

3. **Start PostgreSQL:**

   ```bash
   # Using Docker
   docker run -d --name gym_db \
     -e POSTGRES_PASSWORD=postgres \
     -e POSTGRES_DB=gym_tracker \
     -p 5432:5432 \
     postgres:16-alpine
   ```

4. **Run migrations:**

   ```bash
   npm run db:push
   npm run db:seed
   ```

5. **Start dev server:**
   ```bash
   npm run dev
   ```

Server runs at `http://localhost:3000`

### Docker Deployment

```bash
# Set environment variables
export JWT_ACCESS_SECRET="your-secret-32-chars-minimum"
export JWT_REFRESH_SECRET="your-secret-32-chars-minimum"
export DB_PASSWORD="secure-password"

# Start services
docker-compose up -d

# Run migrations
docker-compose exec api npx prisma migrate deploy
docker-compose exec api npm run db:seed
```

## API Endpoints

### Health

- `GET /health` - Full health check
- `GET /health/ready` - Readiness probe
- `GET /health/live` - Liveness probe

### Authentication

- `POST /api/auth/register` - Create account
- `POST /api/auth/login` - Login
- `POST /api/auth/refresh` - Refresh tokens
- `POST /api/auth/logout` - Logout
- `GET /api/auth/me` - Get profile
- `PATCH /api/auth/me` - Update profile
- `DELETE /api/auth/me` - Delete account

### Exercises

- `GET /api/exercises` - List exercises
- `GET /api/exercises/:id` - Get exercise
- `POST /api/exercises` - Create custom exercise
- `PUT /api/exercises/:id` - Update exercise
- `DELETE /api/exercises/:id` - Delete exercise

### Workouts

- `GET /api/workouts` - List workouts
- `GET /api/workouts/:id` - Get workout
- `POST /api/workouts` - Create workout
- `PUT /api/workouts/:id` - Update workout
- `DELETE /api/workouts/:id` - Delete workout
- `GET /api/workouts/stats/summary` - Get stats

### Personal Records

- `GET /api/prs` - List PRs
- `GET /api/prs/exercise/:id` - Get PRs for exercise
- `POST /api/prs` - Create/update PR
- `DELETE /api/prs/:id` - Delete PR

### Sync

- `POST /api/sync/push` - Push local changes
- `POST /api/sync/pull` - Pull server changes
- `GET /api/sync/status` - Get sync status

## Environment Variables

| Variable                  | Description                       | Default                 |
| ------------------------- | --------------------------------- | ----------------------- |
| `DATABASE_URL`            | PostgreSQL connection string      | Required                |
| `JWT_ACCESS_SECRET`       | Access token secret (32+ chars)   | Required                |
| `JWT_REFRESH_SECRET`      | Refresh token secret (32+ chars)  | Required                |
| `JWT_ACCESS_EXPIRATION`   | Access token TTL                  | `15m`                   |
| `JWT_REFRESH_EXPIRATION`  | Refresh token TTL                 | `7d`                    |
| `PORT`                    | Server port                       | `3000`                  |
| `NODE_ENV`                | Environment                       | `development`           |
| `CORS_ORIGINS`            | Allowed origins (comma-separated) | `http://localhost:8080` |
| `RATE_LIMIT_WINDOW_MS`    | Rate limit window                 | `900000` (15 min)       |
| `RATE_LIMIT_MAX_REQUESTS` | Max requests per window           | `100`                   |

## Sync Protocol

The sync system uses a **client-wins with timestamp** strategy:

1. **Push**: Client sends all changes since last sync
   - Server compares timestamps
   - Newer client data overwrites server
   - Conflicts are counted but client wins

2. **Pull**: Client requests all server changes since last sync
   - Returns exercises, workouts, PRs
   - Client merges into local database

3. **Client IDs**: All entities have a `clientId` field
   - Generated on client (UUID)
   - Used to match records across devices

## License

MIT
