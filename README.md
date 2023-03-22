# PuppetModuleMetadata

`PuppetModuleMetadata` provides some simple tasks for working with a Puppet modules `metadata.json` file.

## Usage 

For convenience, some items are exposed via rake tasks.

Add the following line to your Rakefile:

``` ruby
require 'puppet_module_metadata/rake_tasks'
```
Then from a shell, you can run commands such as the example below.

``` bash
bundle exec rake metadata::matrix::generate
```

Alternatively, the gem can be used as a normal library.

```ruby
require 'puppet_module_metadata'

matrix= ModuleMetadata::Matrix::Generator.new
matrix.generate
```
