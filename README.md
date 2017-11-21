# Notes:

- How to run in console to test auth_token config:

```
DATES_AUTH_TOKEN=abc TITLES_AUTH_TOKEN=123 THUMBNAILS_AUTH_TOKEN=drm ./bin/rails c
```

- How to monitor the actors

```
tail -f log/development.log
```

## Demo of DateFecter Actor
Small demo of the DateFecter actor creating and updating the dates.

- Setting up a watch on pg to see the table in real'ish time.
- Setting up the script that spawns the actor
  - Actor will poll the API every 15 seconds (config'able)
  - With the API date, create/update the CalendarEvents in the DB with the launch date data
  - This pattern could be applied to add N actors to fetch data from different sources and hydrate the db accordingly.

![](adding_date_syncing.gif)

- Wishlist
  - This should build a [Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html) of sorts to only perform 1 update to the DB.
    - At the moment this is hitting the DB a bit too much, before production I'd look to optimize this.
