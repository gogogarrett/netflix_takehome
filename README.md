# Netflix Take Home

## Document your tradeoffs and be prepared to talk about them during the interview

I took an actor approach to long-poll the apis to keep up to date with their information. While this seems to work well in a small scope, I would like to think heavily about the memory size and performance this may have at large scale.

Depending on the technology available, websockets, or server side events may be better options to achieve real time.

## Explain your architectural choices and how they may differ in a production application that needs to display calendar events in real time as they become available

I would spend time optimizing the db queries/operations. I know there are a few ways I could improve the current code.
I would ensure more things are configurable via ENV vars at a minimum.

## Demos

### First stage proof of concept

Small demo of the DateFetcher actor creating and updating the dates.

- Setting up a watch on pg to see the table in real'ish time.
- Setting up the script that spawns the actor
  - Actor will poll the API every 15 seconds (config'able)
  - With the API date, create/update the CalendarEvents in the DB with the launch date data
  - This pattern could be applied to add N actors to fetch data from different sources and hydrate the db accordingly.

![](adding_date_syncing.gif)

- Wishlist
  - This should build a [Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html) of sorts to only perform 1 update to the DB.
    - At the moment this is hitting the DB a bit too much, before production I'd look to optimize this.


### Full integration

Assuming you've set the ENV vars prior

```sh
DATES_AUTH_TOKEN=$DATES_AUTH_TOKEN \
TITLES_AUTH_TOKEN=$TITLES_AUTH_TOKEN \
THUMBNAILS_AUTH_TOKEN=$THUMBNAILS_AUTH_TOKEN \
./bin/hydrate_calendar_events
```

- This works as an "eventually consistent" system.
- We poll various APIs and make changes to our data to reflect the most up to date from the external source.
- The data can be fetched at a regular interval always keeping up to date with the external system.

![](full_integration.gif)


#### Notes:

How to run in console to test auth_token config:

```
DATES_AUTH_TOKEN=abc TITLES_AUTH_TOKEN=123 THUMBNAILS_AUTH_TOKEN=drm ./bin/rails c
```

How to monitor the actors

```
tail -f log/development.log
```
