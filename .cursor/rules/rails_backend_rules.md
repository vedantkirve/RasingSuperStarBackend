Architecture rules:

1. Controllers must inherit from:
   class ApplicationController < ActionController::API

2. Controllers must stay thin. Controllers may only:
   - read params
   - call a service
   - render JSON response

3. Business logic must never exist inside controllers.

4. All business logic must live in service classes inside:
   app/services/

5. Each action must be implemented in a separate service file.

Example structure:
app/services/coaches/create_service.rb
app/services/coaches/update_service.rb
app/services/coaches/list_service.rb
app/services/coaches/delete_service.rb

6. Service classes must follow naming pattern:
   Resource::ActionService

Example:
Coaches::CreateService
Coaches::UpdateService

7. Every service must expose a single public entry method:
   .call

Example usage:
Coaches::CreateService.call(params)

8. Routes must be defined manually in config/routes.rb.
   Do not use automatic `resources`.

Example:
post "/coaches", to: "coaches#create"
get "/coaches", to: "coaches#index"
patch "/coaches/:id", to: "coaches#update"

9. Controller method names should remain REST-like:
   create
   index
   show
   update
   destroy

10. Models should only contain:

- associations
- validations
- simple scopes

11. Models must not contain heavy business logic.

12. All API responses must be JSON.

13. All database tables must include:
    created_at
    updated_at
    status

14. Status must store string values:
    "active" or "inactive".

15. Booking lifecycle states must be:
    confirmed
    cancelled
    completed

16. Always use strong parameters in controllers.

17. Avoid N+1 queries. Use eager loading when necessary.

18. Prefer ActiveRecord scopes instead of raw SQL.

19. Always add database indexes for frequently queried fields.

20. Code must follow standard Rails naming conventions.
