# HouseCounselor

Here we have a fairly simple (naive?) REST API designed to allow service businesses to provide information about themselves and receive ratings and reviews. The resources and outputs of this API don't match the sample data from this assignment 100% just to keep things Rails-y in this Rails app, but the ideas behind them absolutely do.

In this document, we'll first go through setting up the app to run in a Docker container or locally (on a Mac). Then we'll talk about some of the particulars of the API and how to analyze what has been done. There's not much deviation from standard REST patterns executed in Rails' MVC framework.

## Set-up

You have 2 choices for running the project:

1. Build a Docker container with all of the dependencies worked out. This is great if you don't have a Rails environment set up yet, but you won't have a great way to see the HTML output of the test coverage. Also, any data you create in testing will be gone when you stop the container. (In the "real world" you wouldn't run your database in a container like this.)

2. Set up your local environment and run it locally. This is great if you're comfortable with getting a Rails development environment set up or you already have it set up.

Both approaches are described below.

### Docker

```
cd ~/yourdir/housecounselor # the directory the app was cloned into
docker build -t housecounselor .
```

Awesome! Now hop into the container and run the tests:

```
docker run -it housecounselor rspec
```

Run the server:
```
docker run -it -p 3000:3000 housecounselor rails s -b 0.0.0.0
```

Now you can start hitting the API at `http://localhost:3000`. Read on below for the specifics about the API and testing with Postman. When you're done, just `ctrl+c` in the terminal where you started the Docker container. If you're really into Docker, you could run it with the `-d` option to background it.

### Run It Locally

The Ruby version used for this project is `2.6.6`. I use [Ruby Version Manager](https://rvm.io/) to manage my per-project dependencies, and I generally use it to install and manage different versions of Ruby per their documentation. If you're not doing a lot of Rails development, you may not need it. I'm going to assume that you have RVM installed for the first part of the set-up and that you're in the directory above root of this project having just cloned it.

Here we go:

```
rvm install ruby-2.6.6
cd ./housecounselor # this should generate the wrappers for your project dependencies
gem install bundler
bundle
brew install node # I'm running node 14.7.0 for reference
brew install yarn # I'm running 1.22.4 for reference
yarn install --check-files
rails webpacker:install
rails db:migrate
rails db:seed # this will take a minute as it adds all the zip codes and cites in Colorado for testing (more on that later). It also adds some default work types.
```

## Testing and Analysis

Once you have your environment up and running, you can run tests by running `rspec`. Locally, this means typing `rspec` and hitting enter at the root of the project. In the Docker container, you'll run `docker run -it -p 3000:3000 housecounselor rspec`.

After running `rspec`, you can take a look at the test coverage report in `/coverage/index.html` or just take a look at the end of the line from the output from `rspec`. It shows you total coverage percentage. If you want to look at all the test cases, take a peak in the `spec/models` and `spec/controllers` directories.

I've created a [Postman collection](https://www.getpostman.com/collections/c254e77052bb0089a218) for trying out the API if that's of interest. In order to run the calls against the API, you'll need to start the server (`rails s` locally or `docker run -it -p 3000:3000 housecounselor rails s -b 0.0.0.0` for Docker.) before executing any of the calls from Postman. It's also worth noting that there is an order to creating resources that makes sense...For instance, you'd need to create `work_type`s before creating a `business` that uses them. To that end, the database seeding takes care of adding a few default work types.

Speaking of database seeding, the database is seeded with all the cities and ZIP codes for Colorado for testing purposes. I express a few more thoughts on that subject below in my _Wish List_.

Take a look at [Code Climate](https://codeclimate.com/github/johncox00/housecounselor) to dig into the static analysis of the code.


## NOTES

### Resources and Contracts

Here are the routes for the API and their associated controller actions:

```
GET    /work_types                                                                    work_types#index
POST   /work_types                                                                    work_types#create
GET    /work_types/:id                                                                work_types#show
PATCH  /work_types/:id                                                                work_types#update
PUT    /work_types/:id                                                                work_types#update
DELETE /work_types/:id                                                                work_types#destroy
GET    /businesses/:business_id/reviews                                               reviews#index
POST   /businesses/:business_id/reviews                                               reviews#create
GET    /businesses/:business_id/reviews/:id                                           reviews#show
PATCH  /businesses/:business_id/reviews/:id                                           reviews#update
PUT    /businesses/:business_id/reviews/:id                                           reviews#update
DELETE /businesses/:business_id/reviews/:id                                           reviews#destroy
GET    /businesses/:business_id/business_hours                                        business_hours#index
POST   /businesses/:business_id/business_hours                                        business_hours#create
GET    /businesses/:business_id/business_hours/:id                                    business_hours#show
PATCH  /businesses/:business_id/business_hours/:id                                    business_hours#update
PUT    /businesses/:business_id/business_hours/:id                                    business_hours#update
DELETE /businesses/:business_id/business_hours/:id                                    business_hours#destroy
GET    /businesses                                                                    businesses#index
POST   /businesses                                                                    businesses#create
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

Work types, cities, states, and postal codes are all normalized out to their own tables. Is this 100% necessary for keeping up with addresses and types of work? No. But it does help us to maintain structured data and it makes searching for businesses by various geographical data points _much_ easier. So here are some other resource JSON examples...

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

All non-determinant listing requests are paginated. On these requests, the `page` and `per` query string parameters are available to make specifications on which page of data you want and how many results to return per page. The default value for `per` is 20. All paginated results are returned with a standard format with pagination metadata like this:

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
|  `city` | Will look for businesses that operate in the specific city. (case sensitive)  |
| `rating`  | Return any businesses with the given rating or higher.  |

### Sorting

We use the `sort` query string parameter on the `GET /businesses` request to specify the order of the results (carried across pages).

| Value  | Functionality  |
|---------------------|----------------|
| `az` | Sorts by the name of the business from A to Z   |
| `za` |  Sorts by the name of the business from Z to A  |
| `lohi` | Sorts by average rating, low to high  |
| `hilo`  | Sorts by average rating from high to low  |

### Wish List

In an ideal situation, we would include authentication and authorization mechanisms for this API. We would also probably look to facilitate filtering (and maybe sorting) using a tool like Elasticsearch for performance rather than all the joins and sub-queries being executed in this exercise. Lastly, it would probably make sense to integrate with something like Google Maps for verifying address information and assigning latitude and longitude values to be used in our geographic search. Using a tool like Google Maps would eliminate the need(?) for pre-populating cities and postal codes by normalizing city names and zip codes on the fly as data is entered.
