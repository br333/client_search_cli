# Shiftcare Data CLI

  

A Ruby command-line tool for downloading, validating, and analyzing JSON datasets.

It can generate `metadata`, validate data against JSON schemas, and run filters or queries.

---

## Features

- Download JSON files from a configured URL

- Validate JSON data against a schema *

- Generate metadata (keys, size, duplicates, record count)

- Query and filter data

- Detect duplicates with indexes

- Simple, modular architecture

---
## Project Structure
```
cli/
    bin/
        cli.rb
    lib/
        shiftcare/
            data.rb
            data/
                metadata.rb
                query.rb
                schema.rb
            utils/
                base.rb
                downloader.rb
                parser.rb
    spec/
        lib
            fixtures/
                ...
            shiftcare/
                data/
                    metadata_spec.rb
                    query_spec.rb
                utils/
                    parser_spec.rb
    Gemfile
    Gemfile.lock
    README.md

```

---
## Installation
  
2. Install dependencies:

```bash

bundle install

```

---
## Configuration

Set up paths and the base URL:

```ruby

Shiftcare::Utils::Base.configure do |config|

config.url = "https://appassets02.shiftcare.com/manual/"

config.exchange_layer_dir = "./.exchange_layer/" # Storage of all generated files

config.download_dir = "./.exchange_layer/files/"

config.metadata_dir = "./.exchange_layer/metadata/"

config.schema_dir = "./.exchange_layer/schema/"

end

```

---
## Usage
### Generate Metadata
  

### Query Data


Output:

```

Filtering by criteria: {:full_name=>"jane"}

[

{:id=>2, :full_name=>"Jane Smith", :email=>"jane.smith@yahoo.com"},

{:id=>3, :full_name=>"Another Jane Smith", :email=>"jane.smith@yahoo.com"}

]

```

### Find Duplicates

```ruby

duplicates = json_details.query.duplicates

puts duplicates

```

Output:

```

[

{:"1"=>{:id=>2, :full_name=>"Jane Smith", :email=>"jane.smith@yahoo.com"}},

{:"2"=>{:id=>3, :full_name=>"Another Jane Smith", :email=>"jane.smith@yahoo.com"}}

]

```

---
## Running Tests

RSpec is used with sample fixtures.

Run all specs:

```bash

bundle exec rspec

```

---
## Examples

### Generate Metadata

```ruby

data = Shiftcare::Data.new("clients.json")

data.metadata.generate

puts data.metadata.to_h

```
### Filter Records

```ruby

results = data.query.where(id: 1)

puts results

```

### Get Duplicates

```ruby

puts data.query.duplicates

```

---
## Roadmap

- Support large datasets with streaming
- Add multiple criteria filtering (`AND`/`OR`)
- Export data to CSV or YAML
- Interactive CLI using TTY