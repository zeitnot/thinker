[![Build Status](https://travis-ci.org/zeitnot/thinker.svg?branch=master)](https://travis-ci.org/zeitnot/thinker)
<a href="https://codeclimate.com/github/zeitnot/thinker/maintainability"><img src="https://api.codeclimate.com/v1/badges/a0f2b7cbb3b7109a7a00/maintainability" /></a>
<a href="https://codeclimate.com/github/zeitnot/thinker/test_coverage"><img src="https://api.codeclimate.com/v1/badges/a0f2b7cbb3b7109a7a00/test_coverage" /></a>
# Thinker

Thinker is a tool that finds discrepancies between `Campaign` entity result set and remote ad service data.

### Requirements
ruby `>= 2.3`

### Installation

* `$ git clone git@github.com:zeitnot/thinker.git`
* `$ bundle install`
* `$ rake`

### RDocs
You can view the Thinker documentation in RDoc format here:
https://www.rubydoc.info/github/zeitnot/thinker/

### Usage
Got to `$ bin/console` and then type `FindDiscrepancy.call`. This will produce something like: 
```ruby
[
  { 
      remote_reference: "1",
      remote_existence: true,
      discrepancies: [
          { remote: "Description for campaign 11", local: "Campaign Description", field: "ad_description" }, 
          { remote: "enabled", local: "paused", field: "status" }
      ]
  },
  { remote_reference: "4", remote_existence: false, discrepancies: [] },
  { remote_reference: "5", remote_existence: false, discrepancies: [] },
  { remote_reference: "6", remote_existence: false, discrepancies: [] }
]
```

### Important
If there is exceptions such as connection timeout or parsing malformed JSON data `FindDiscrepancy.call` will return empty array.
This means that `FindDiscrepancy.call` is fault tolerant for known exceptions. 

