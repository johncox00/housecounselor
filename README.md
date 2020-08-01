# README

This README would normally document whatever steps are necessary to get the
application up and running.

## NOTES

Time is 24-hr based rather than AM/PM. Business hours are very simplistic with `open` and `close` being designated with just an integer and assuming that businesses are not operating overnight (i.e. the `open` time will always be a smaller number than the `close` time).

### Filters

| Query string param  | Functionality  |
|---------------------|----------------|
| `name` | Will execute a case-insensitive `LIKE` query on the business name with the pattern `%{value}%`   |
| `open_at` |  Checks to see if the hour of the day given as the value is during the open hours of the business on any day |
| `open_days` | Takes a comma-delimited string of numbers representing days of the week that you want to see businesses open. (0 is Sunday)  |
| `work_type`  | Will show business that do this type of work.  |
|  `postal_code` | Will map the give zip code to any related cities and return businesses that operate in those cities.  |
|  `city` | Will look for businesses that operate int he specific city. (case sensitive)  |
| `rating`  | Return any businesses with the given rating or higher.  |

### Sorting

We use the `sort` query string parameter to specify the order of the results (carried across pages).

| Value  | Functionality  |
|---------------------|----------------|
| `az` | Sorts by the name of the business from A to Z   |
| `za` |  Sorts by the name of the business from Z to A  |
| `lohi` | Sorts by average rating, low to high  |
| `hilo`  | Sorts by average rating from high to low  |

Things you may want to cover:

* Ruby version

* System dependencies

Install node: `brew install node`

* Configuration

```
gem install bundler
bundle
rails webpacker:install
rails db:migrate
rails db:seed
```

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
