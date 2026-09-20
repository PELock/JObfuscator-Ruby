# JObfuscator — Ruby Web API SDK

Ruby SDK for [JObfuscator](https://www.pelock.com/products/jobfuscator).

API: https://www.pelock.com/api/jobfuscator/v1

Author: Bartosz Wójcik / PELock — https://www.pelock.com

## Installation

This gem is not published on RubyGems. Build it locally:

```bash
gem build jobfuscator.gemspec
gem install jobfuscator-*.gem
```

Or from a clone without installing:

```ruby
$LOAD_PATH.unshift(File.expand_path("lib", __dir__))
require "jobfuscator"
```

Uses Ruby stdlib `Net::HTTP` only (no Faraday).

## Usage

```ruby
require "jobfuscator"

client = JObfuscator.new("YOUR-WEB-API-KEY")
result = client.obfuscate_java_source("class Hello { }")

if result && result["error"] == JObfuscator::ERROR_SUCCESS
  puts result["output"]
end
```

See `examples/`.

Defaults match the PHP SDK (`split_strings` is off; other strategies on; source compression on).

## License

Apache-2.0. Copyright Bartosz Wójcik / PELock.
