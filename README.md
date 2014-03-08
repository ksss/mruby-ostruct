# mruby-ostruct

OpenStruct binding in mruby.

```ruby
o = OpenStruct.new
o.foo = 1
o.bar = "baz"
p o.foo #=> 1
p o.to_h #=> {:foo => 1, :bar => "baz"}
```

## Installation

### use github repository

Write in /mruby/build_config.rb

```ruby
MRuby::Build.new do |conf|
  conf.gem :github => 'ksss/mruby-ostruct', :branch => 'master'
end
```

### or use mgem

```
mgem add mruby-ostruct
```

### build

and exec in your /mruby.

```
rake clean
rake
rake test
```

## License

MIT
