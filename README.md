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

### Accessing Data

Now we can access our base

```ruby
@base = @client.base('appExAmPlE')
```

and its tables

```ruby
@tables = @base.tables
```

and a table's records, so you can navigate the has_many chain the way God intended:

```ruby
@client.bases.first.tables.first.records.first
```

### Manipulating Tables

Create a new table with:

```ruby
@table = @base.create_table({ name: 'Names', description: 'A list of names', fields: [{ name: 'name', type: 'singleLineText' }] })
```

You can update at a table's metadata with the `update` method:

```ruby
@table.update({ description: 'Updated description' })
```

### Querying Records

Once you have access to a table from above, we can query a set of records in the table with:

```ruby
@records = @table.records
```

### Inserting Records

A single record or an array of records can be inserted using the `create_records` method on a table (max 10 at a time):

```ruby
@table.create_records({ 'Name': 'name value', 'Age': 35 })
```

### Deleting Records

A single record or an array of records can be destroyed by passing their ids to the `delete_records` method on a table:

```ruby
@record = @table.records[0]
@table.delete_records(@record.id)
```

Or as a convenience, you can delete all records with the `dump` method

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
