# NestedHash

NestedHash is a Hash converter. It will created a simple, key encoded hash, in to a nested hash. For example, the hash:

```ruby
{
  "name" => "guillermo",
  "properties.age" => 29,
  "properties.sex" => "male",
  "parents.1" => "ramon",
  "parents.2" => "gloria"
}
```

will be converted into the hash

```ruby
{
  "name" => "guillermo",
  "properties" => {
    "age" => 29,
    "sex" => "male"
  },
  "parents" => [ "ramon", "gloria" ]
}
```

# Usage

```ruby
require 'nested_hash'

my_normal_hash = {
  "name" => "guillermo",
  "properties.age" => 29,
  "properties.sex" => "male",
  "parents.1" => "ramon",
  "parents.2" => "gloria"
}

my_new_hash = NestedHash.new(my_normal_hash)
my_new_hash # => {"name"=>"guillermo", "properties"=>{"age"=>29, "sex"=>"male"}, "parents"=>["ramon", "gloria"]}
```

NestedHash inherits from *Hash*, so you can use it as a normal hash.


# Installation

```shell
$ gem install nested_hash
```

# Motivations

The reason for creating this ruby gem is to convert Excel files to json files. With the rubygems roo you already can get the rows into a one level hash (colum title as a key). This complement help to create more difficult structures with the same excel file.


# License

Mit
