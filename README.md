# Airtable API Wrapper for Ruby

For when Airrecord is just too much.

# Note on library status

This is a fork of an abandoned [previous wrapper](https://github.com/nesquena/airtable-ruby). There's still plenty to do to get it up to speed with the current Airtable API.

## Installation

Add this line to your application's Gemfile:

    gem 'airtable2'

And then execute:

    $ bundle

## Usage

### Creating a Client

First, be sure to register for an [airtable](https://airtable.com) account,  setup a base, and create a token with the desired permissions for your base. Now, setup your Airtable client:

```ruby
# Pass in api key to client
@client = Airtable::Client.new('your.token.goes.here')
```

### Simple Usage

#### Reading

Now we can access our base

```ruby
# Retrieve with a specific ID
@base = @client.base('appExAmPlE')
# or
@base = @client.bases.first
```

and its tables

```ruby
# Retrieve with a specific ID
@table = @base.table('tblExAmPle')
# or
@table = @base.tables.first
```

and a table's records,

```ruby
# Retrieve with a specific ID
@record = @table.record('recExAmPle')
# or
@record = @table.records.first
```

so you can navigate the belongs_to/has_many relationships the way God intended:

```ruby
@record = @client.bases.first.tables.first.records.first
@base = @record.table.base
```

Note that objects' child records are memoized to avoid unnecessary API calls. If sensitive to stale data, be sure to use the objects instantiated most recently.

To get the fields of a table, its simply

```ruby
@fields = @table.fields
```

#### Writing

Create a table in a base like so

```ruby
@table = @base.create_table({ name: 'Names', description: 'A list of names', fields: [{ name: 'name', type: 'singleLineText' }] })
```

You can update at a table's metadata with the `update` method:

```ruby
@table.update({ description: 'Updated description' })
```

You can add a column to a table...

```ruby
@field = @table.add_field({'description': 'Whether I have visited this apartment yet.', 'name': 'Visited', 'type': 'checkbox', 'options': { 'color': 'greenBright', 'icon': 'check'} })
```

...and update it

```ruby
@field = @field.update({'description': 'Whether I have rented this apartment yet.', 'name': 'Rented'})
```

A single record or an array of records can be inserted using the `create_records` method on a table (max 10 at a time):

```ruby
# Single
@table.create_records({ 'Name': 'name value', 'Age': 35 })
# Array
@table.create_records([{ 'Name': 'name value', 'Age': 35 }, { 'Name': 'another name value', 'Age': 40 }])
```

A single record or an array of records can be destroyed by passing their ids to the `delete_records` method on a table (max 10 at a time):

```ruby
@records = @table.records
# Single
@table.delete_records(@records.first.id)
# Array
@table.delete_records(@records.map(&:ids))
```

Or as a convenience, you can delete all records with the `dump` method, which will abide by the API's rate limiting.

```ruby
@table.dump
```

## Complete documentation

YARD-generated documentation is hosted on [GitHub Pages](https://aseroff.github.io/airtable-ruby/).

## Contributing

1. Fork it ( https://github.com/aseroff/airtable-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
