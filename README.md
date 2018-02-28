# sidekiq_monitoring_bitcrowd [![Build Status](https://travis-ci.org/bitcrowd/sidekiq_monitoring.svg?branch=master)](https://travis-ci.org/bitcrowd/sidekiq_monitoring)

Rails engine that provides a JSON API which serves Sidekiq
status information from a HTTP-auth protected endpoint.
This status information is gathered by scheduling a frequently
running job that saves timestamps in Redis.

## Installation

Add gem to your project:

```ruby
gem 'sidekiq_monitoring_bitcrowd'
```

Mount engine in `routes.rb`:
```ruby
Rails.application.routes.draw do
  mount SidekiqMonitoring::Engine => '/sidekiq_monitoring'
end
```

Schedule job in `whenever`'s `schedule.rb`:

```ruby
every 5.minutes do
  runner 'SidekiqMonitoring::Status.refresh'
end
```

Be sure that your parent app provides HTTP basic authentication credentials
using an initializer

```ruby
# app/config/initializers/sidekiq_monitoring.rb
SidekiqMonitoring.http_auth_name = 'user'
SidekiqMonitoring.http_auth_password = 'password'
```

This engine's controller inherits from `ApplicationController` by default. You
can change this using the `parent_controller` option

```ruby
SidekiqMonitoring.parent_controller = 'SomeOtherController'
```

## Usage

Navigate to `/sidekiq_monitoring/status` and receive Sidekiq status information:

    {
      "timestamps": {
        "whenever_ran": "2018-01-23 15:05:02",
        "sidekiq_performed": "2018-01-23 15:05:02",
        "requested": "2018-01-23 15:08:28"
      },
      "sidekiq": {
        "active_workers": 0,
        "queue_sizes": {
          "mailers": 0,
          "default": 0,
          "scheduled": 0,
          "retries": 0,
          "dead": 0
        },
        "recent_history": {
          "processed": {
            "2018-01-23": 18,
            "2018-01-22": 0,
            "2018-01-21": 0,
            "2018-01-20": 0,
            "2018-01-19": 0
          },
          "failed": {
            "2018-01-23": 0,
            "2018-01-22": 0,
            "2018-01-21": 0,
            "2018-01-20": 0,
            "2018-01-19": 0
          }
        },
        "totals": {
          "processed": 18,
          "failed": 0
        }
      }
    }
