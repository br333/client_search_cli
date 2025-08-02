# JSON Data CLI

Command-line tool for downloading, validating, and analyzing JSON datasets.

It can generate `metadata`, validate data against JSON `schemas`, and run `queries`.

---

## Features

- Download JSON files from a configured URL

- Validate JSON data against a schema *

- Generate metadata (keys, size, duplicates, record count)

- Query data

- Detect duplicates with indexes

- Folder generation for data storage

---
## Project Structure
```
cli/
    .exchange_layer/ # Generated
    .exchange_layer_sample/
    bin/
        start.rb
        console.rb
        generate_json.rb
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

1. Download project 
2. Install dependencies:

```bash

bundle install

```
3. `exchange_layer_sample` is provided in this project. You can rename this to `.exchange_layer` in order to test `./bin/start` without downloading `JSON` files and creating `schemas`.

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

```bash
Usage: json-parser [command] [options]

Commands: duplicates, query
    -f, --file FILE                  JSON file name, i.e --file clients.json
    -q, --query KEY=VALUE            Query JSON content i.e --query KEY=VAL
    -m, --metadata                   Force generation of metadata even if it exists
    -s, --schema                     Validate JSON against schema
    -h, --help                       Show help
```

## Samples:

Querying data using a single `key`

```bash
# Query data using `full_name`
./bin/start query -f clients.json -q full_name='jane' 
```

Output:

```bash
Filtering by criteria: {full_name: "jane"}
Found 2 record(s):
[
  [0] {
           :id => 2,
    :full_name => "Jane Smith",
        :email => "jane.smith@yahoo.com"
  },
  [1] {
           :id => 15,
    :full_name => "Another Jane Smith",
        :email => "jane.smith@yahoo.com"
  }
]

```

Querying data using multiple `key`

```bash
# Query data using `full_name` and `email`
./bin/start query -f clients.json -q full_name='jane' -q email='jane' 
```

Output:

```bash
Filtering by criteria: {full_name: "jane", email: "jane"}
Found 2 record(s):
[
  [0] {
           :id => 2,
    :full_name => "Jane Smith",
        :email => "jane.smith@yahoo.com"
  },
  [1] {
           :id => 15,
    :full_name => "Another Jane Smith",
        :email => "jane.smith@yahoo.com"
  }
]

```

### Find Duplicates

```bash
./bin/start duplicates -f clients.json
```

```ruby

Duplicates:
[
    [0] {
        :"1" => {
                   :id => 2,
            :full_name => "Jane Smith",
                :email => "jane.smith@yahoo.com"
        }
    },
    [1] {
        :"14" => {
                   :id => 15,
            :full_name => "Another Jane Smith",
                :email => "jane.smith@yahoo.com"
        }
    }
]

```

### Force metadata generation `-m`

This will generate `metadata` of the `JSON` file provided.

```
./bin/start filter -f clients.json -q full_name=jane -m
```

### Show invalid records using schema validation `-s`

JSON schema of this file is **required** for this to work.

```
./bin/start filter -f clients.json -q full_name=jane -s
```

---
## Running Tests

RSpec is used with sample fixtures.

Run all specs:

```bash
bundle exec rspec
```
---

## Note

**Nice to haves**
- Use indexing using a JSON index and fully utilize the metadata. (efficiency)
- Add multiple criteria filtering (`AND`/`OR`)
- Proper printing
- Environment variables for the configurations