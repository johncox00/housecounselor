# Housecounselor

Here we have a fairly simple (naive?) REST API designed to allow service business to provide information about themselves and receive ratings and reviews. The resources and outputs of this API don't match the sample data from this assignment 100% just to keep things Rails-y in this Rails app, but the ideas behind them absolutely do.

In this document, we'll first go through setting up the app to run on a Mac. Then we'll talk about some of the particulars of the API and how to analyze what has been done. There's not much deviation from standard REST patterns executed in Rails' MVC framework.

## Set-up

The Ruby version used for this project is `2.6.5`. I use [Ruby Version Manager](https://rvm.io/) to keep manage my per-project dependencies, and I generally use it to install and manage different versions of Ruby per their documentation. If you're not doing a lot of Rails development, you may not need it. I'm going to assume that you have RVM installed for the first part of the set-up and that you're in the directory above root of this project having just cloned it.

Here we go:

```
rvm install 2.6.5
cd ./housecounselor # this should generate the wrappers for your project dependencies
gem install bundler
bundle
brew install node
rails webpacker:install
rails db:migrate
rails db:seed # this will take a minute as it adds all the zip codes and cites in Colorado for testing...more on that later
```

## Testing and Analysis

Once you have your environment up and running, you can run tests by running `rspec`.

After running Rspec, you can take a look at the test coverage report in `/coverage/index.html`.

I've created a [Postman collection](https://www.getpostman.com/collections/c254e77052bb0089a218) for trying out the API if that's of interest. In order to run the calls against the API, you'll need to start the server by running `rails s` before executing any of the calls from Postman.

Take a look at [Code Climate](https://codeclimate.com/github/johncox00/housecounselor) to dig into the static analysis of the code.


## NOTES

### Resources and Contracts

Here are the routes for the API and their associated controller actions:

```
GET    /work_types                                                                    work_types#index
POST   /work_types                                                                    work_types#create
GET    /work_types/new                                                                work_types#new
GET    /work_types/:id/edit                                                           work_types#edit
GET    /work_types/:id                                                                work_types#show
PATCH  /work_types/:id                                                                work_types#update
PUT    /work_types/:id                                                                work_types#update
DELETE /work_types/:id                                                                work_types#destroy
GET    /businesses/:business_id/reviews                                               reviews#index
POST   /businesses/:business_id/reviews                                               reviews#create
GET    /businesses/:business_id/reviews/new                                           reviews#new
GET    /businesses/:business_id/reviews/:id/edit                                      reviews#edit
GET    /businesses/:business_id/reviews/:id                                           reviews#show
PATCH  /businesses/:business_id/reviews/:id                                           reviews#update
PUT    /businesses/:business_id/reviews/:id                                           reviews#update
DELETE /businesses/:business_id/reviews/:id                                           reviews#destroy
GET    /businesses/:business_id/business_hours                                        business_hours#index
POST   /businesses/:business_id/business_hours                                        business_hours#create
GET    /businesses/:business_id/business_hours/new                                    business_hours#new
GET    /businesses/:business_id/business_hours/:id/edit                               business_hours#edit
GET    /businesses/:business_id/business_hours/:id                                    business_hours#show
PATCH  /businesses/:business_id/business_hours/:id                                    business_hours#update
PUT    /businesses/:business_id/business_hours/:id                                    business_hours#update
DELETE /businesses/:business_id/business_hours/:id                                    business_hours#destroy
GET    /businesses                                                                    businesses#index
POST   /businesses                                                                    businesses#create
GET    /businesses/new                                                                businesses#new
GET    /businesses/:id/edit                                                           businesses#edit
GET    /businesses/:id                                                                businesses#show
PATCH  /businesses/:id                                                                businesses#update
PUT    /businesses/:id                                                                businesses#update
DELETE /businesses/:id                                                                businesses#destroy
```

Here's sample JSON for creating a business:

```
{
	"business": {
		"name": "Awesome Sauce 19",
		"address_attributes": {
			"line1": "123 Main St",
			"line2": "Suite 300",
			"city": "Littleton",
			"state": "CO",
			"postal_code": "80126"
		},
		"work_types": [
			"Kungfu",
			"Karate"
		],
		"operating_cities": [
			"Highlands Ranch",
			"Littleton",
			"Centennial",
			"Denver"
		]
	}
}
```

It should be noted that `address_attributes`, `work_types`, and `operating_cities` are all indicative of nested resources being passed into the businesses controller and then validated and persisted in relation to the business in question. While we could have added `business_hours` as a nested resource in this request, I opted to have those added separately through a scoped path. On the subject of scoped paths, it's also worth noting that reviews work through a scoped path as well, being that they will always be in relation to a specific business.

Work types, cities, states, and postal codes are all normalized out to their own tables. Is this 100% necessary for keeping up with addresses and types or work? No. But it does help us to maintain structured data and it makes searching for businesses by various geographical data points _much_ easier. So here are some other resource JSON examples...

Review:
```
{
    "review": {
  		"rating": 3,
  		"comment": "mediocre job"
  	}
}
```

Work type:
```
{
    "work_type": {
  		"name": "Taekwondo"
  	}
}
```

Business hours:
```
{
    "business_hour": {
  		"open": 9,
  		"close": 17,
  		"week_day": "Monday"
  	}
}
```
NOTE ON BUSINESS HOURS:

Time is 24-hr based rather than AM/PM. Business hours are very simplistic with `open` and `close` being designated with just an integer and assuming that businesses are not operating overnight (i.e. the `open` time will always be a smaller number than the `close` time).

### Pagination

All non-determinant listing requests are paginated. On these requests, the `page` and `per` query string parameters are available to make specifications on which page of data you want and how many results to return per page. The default value for `per` is 10. All paginated results are returned with a standard format with pagination metadata like this:

```
{
    "total_pages": 1,
    "total_count": 1,
    "current_page": 1,
    "results": [
        ...
    ]
}
```

### Filters

You can filter the `GET /businesses` request using the query string parameters outlined below.

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

We use the `sort` query string parameter on the `GET /businesses` request to specify the order of the results (carried across pages).

| Value  | Functionality  |
|---------------------|----------------|
| `az` | Sorts by the name of the business from A to Z   |
| `za` |  Sorts by the name of the business from Z to A  |
| `lohi` | Sorts by average rating, low to high  |
| `hilo`  | Sorts by average rating from high to low  |
