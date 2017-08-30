# fluent-logger-crystal

A [Fluentd](https://www.fluentd.org/) client for Crystal.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  fluent-logger:
    github: TobiasGSmollett/fluent-logger-crystal
```

## Usage

### Simple
```crystal
require "fluent-logger"

log = Fluent::Logger::FluentLogger.new
log.post("myapp.access", {"agent" => "foo"})

# output: myapp.access {"agent":"foo"}
```

## Contributing

1. Fork it ( https://github.com/TobiasGSmollett/fluent-logger-crystal/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [TobiasGSmollett](https://github.com/TobiasGSmollett)  - creator, maintainer

## Thanks
Thanks to FURUHASHI Sadayuki for his awesome work on [fluent-logger-ruby](https://github.com/fluent/fluent-logger-ruby).
