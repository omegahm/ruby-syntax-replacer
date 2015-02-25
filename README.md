# Ruby-syntax-replacer package

When run (by pressing <kbd>cmd</kbd>+<kbd>alt</kbd>+<kbd>x</kbd>), will replace all old Ruby hash syntax in the current file with new, that is:

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

It also does selection-wise replacements.
