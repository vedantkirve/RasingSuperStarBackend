# Raising Superstars API

Rails 8 JSON API for zones, availability, users, coaches, and bookings. Supports coaching session scheduling with automatic coach assignment by zone and load balancing.

## Prerequisites

- **Ruby** 3.4.8 (see `.ruby-version`)
- **PostgreSQL** 9.3+
- **Bundler** 2.x

## Quick Start

```bash
# Install dependencies
bundle install

# Create and migrate databases
bin/rails db:create db:migrate

# Start the server
bin/rails server
```

API: `http://localhost:3000`  
Swagger docs: `http://localhost:3000/api-docs`

## Database Configuration

### Default database names

| Environment | Database |
|-------------|----------|
| Development | `backend_development` |
| Test        | `backend_test`        |
| Production  | `backend_production`  |

### Changing the database name

Edit `config/database.yml`:

```yaml
development:
  <<: *default
  database: your_app_development   # Change this

test:
  <<: *default
  database: your_app_test          # Change this

production:
  primary: &primary_production
    <<: *default
    database: your_app_production  # Change this
```

### Production: connection URL

Use `DATABASE_URL` to override the config file:

```bash
DATABASE_URL="postgres://user:password@host:5432/dbname"
```

Production also expects `BACKEND_DATABASE_PASSWORD` for the `backend` user when not using `DATABASE_URL`. For custom credentials, set `url: <%= ENV["MY_APP_DATABASE_URL"] %>` in your production block.

### Custom host, port, credentials

Uncomment and set in `config/database.yml`:

```yaml
development:
  host: localhost
  port: 5432
  username: your_user
  password: your_password
```

## Environment variables

| Variable | Purpose |
|----------|---------|
| `DATABASE_URL` | Full PostgreSQL connection URL (overrides config) |
| `BACKEND_DATABASE_PASSWORD` | Production DB password (when using `database.yml` config) |
| `RAILS_MAX_THREADS` | Puma thread pool (default: 5) |

## Running the application

```bash
# Development
bin/rails server
# or
bin/rails s -p 3000

# Production (precompile assets first)
RAILS_ENV=production bin/rails assets:precompile
RAILS_ENV=production bundle exec puma -C config/puma.rb
```

Health check: `GET /up` — returns 200 if the app boots successfully.

## API endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/zones` | List zones |
| POST | `/zones` | Create zone |
| GET | `/availability?zone_id=1` | Get availability for a zone (next 7 days) |
| POST | `/users` | Create user |
| POST | `/coaches` | Create coach |
| POST | `/bookings` | Create booking |

### Request body shapes

All POST bodies expect JSON with a nested wrapper:

**Booking** (`POST /bookings`):

```json
{
  "booking": {
    "user_id": 1,
    "zone_id": 1,
    "session_date": "2026-03-15",
    "start_time": "10:00"
  }
}
```

Valid `start_time` values: `10:00`, `11:30`, `13:00`, `14:30`, `16:00`, `17:30` (see `config/initializers/booking_slots.rb`).

**User** (`POST /users`): `{ "user": { "name": "...", "phone_number": "+..." } }`  
**Coach** (`POST /coaches`): `{ "coach": { "name": "...", "phone_number": "+...", "zone_id": 1, "start_time": "09:00", "end_time": "17:00" } }`  
**Zone** (`POST /zones`): `{ "zone": { "name": "Zone A", "status": "active" } }`

## API documentation

Interactive Swagger UI: **http://localhost:3000/api-docs**

OpenAPI spec: `swagger/v1/swagger.yaml`

## Running tests

```bash
# Full suite
bundle exec rspec

# Run specs and regenerate Swagger
bundle exec rspec spec/requests
bundle exec rake rswag:specs:swaggerize
```

## CORS

CORS is configured to allow all origins (`config/initializers/cors.rb`). Frontend apps on any origin (e.g. `localhost:5173`, LAN devices) can call the API. Restrict origins in production if needed.

## Project structure

```
app/
  controllers/     # API controllers
  models/         # User, Zone, Coach, Booking
  services/       # Bookings::CreateBooking, Availability::GetZoneAvailability
config/
  database.yml    # DB config
  initializers/
    booking_slots.rb   # Time slugs (10:00, 11:30, …)
    cors.rb
db/
  schema.rb       # Current schema
  migrate/        # Migrations
swagger/v1/       # OpenAPI spec
```

## Production checklist

- [ ] Set `DATABASE_URL` or `BACKEND_DATABASE_PASSWORD`
- [ ] Run `bin/rails db:migrate` in production
- [ ] Configure `config.time_zone` in `config/application.rb` if needed
- [ ] Restrict CORS origins in `config/initializers/cors.rb` for security
- [ ] Use HTTPS in production
