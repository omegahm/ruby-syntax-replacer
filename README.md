# Ruby-syntax-replacer package

When run, will replace all old Ruby hash syntax with new, that is:

```ruby
{
  :name     => 'Mads Ohm Larsen',
  :age      => '25',
  :position => 'Lead developer'  
}
```

will become

```ruby
{
  name:     'Mads Ohm Larsen',
  age:      '25',
  position: 'Lead developer'
}
```
