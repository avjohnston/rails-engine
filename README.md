# Rails Engine

Rails Engine is an API containing data for an E-Commerce Application that can be passed along to the front end to create the application. The data includes merchants, items, invoices, item-invoices, transactions and customer information.

## Summary

  - [Getting Started](#getting-started)
  - [Running the tests](#running-the-tests)
  - [Deployment](#deployment)
  - [Versioning](#versioning)
  - [Authors](#authors)
  - [Acknowledgments](#acknowledgments)

## Getting Started

Fork and clone this repo, then run these commands to get started:
1. `bundle install`
2. `rails db:{create,migrate,seed}`

### Prerequisites

- An understanding of accessing information via API endpoints

## Running the tests

Run `bundle exec rspec` to run the full test suite.

The testing for this repo includes rspec, capybara, faker, factorybot, shoulda-matchers and simplecov, which can all be found in the `Gemfile`.

### Break down into end to end tests

SimpleCov Covergae: 100%

Model Tests: Full testing of all model class and instance methods using shoulda-matchers

Factory Tests: Full testing of all factories used in model and request specs

Request Tests: Fully tested all endpoints, happy path, sad path and edge-cases

## Deployment

After the inital setup, just visit `http://localhost:3000/api/v1/#{end_point}` to get started!

## Versioning

This is Version 1, and is the only available version at the moment. If more versions are made you will find that information updated in the read me of this [original repo](https://github.com/avjohnston/rails-engine).


## Authors

- **Andrew Johnston** - *Sole Dev* - [My Github](https://github.com/avjohnston/)

## Acknowledgments

  - Each and every person in my 2011 Turing BackEnd Cohort for coming together and helping each other out on this project!
