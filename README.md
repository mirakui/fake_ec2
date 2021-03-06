# FakeEc2

A mock endpoint of Amazon EC2 for testing

## Installation

```
$ gem install fake_ec2
```

## Usage

### Standalone
```
$ fake_ec2_server -p 4567
```

```ruby
require 'aws-sdk'

ec2 = AWS::EC2.new(
  access_key_id: 'AAA',
  secret_access_key: 'BBB',
  ec2_endpoint: '0.0.0.0:4567',
  ec2_port: 80,
  use_ssl: false
)

# RunInstances
ec2.instances.create( count: 2, ... )
)
# => [<AWS::EC2::Instance id:i-e61c02eb>, <AWS::EC2::Instance id:i-aa463e98>]

# DescribeInstances
ec2.instances.to_a
# => [<AWS::EC2::Instance id:i-e61c02eb>, <AWS::EC2::Instance id:i-aa463e98>]
```

### aws-sdk handler
```ruby
require 'aws-sdk'
require 'fake_ec2'

ec2 = AWS::EC2.new(
  http_handler: FakeEc2::HttpHandler.new
)

ec2.instances.create( count: 2, ... )
ec2.instances.to_a
# => [<AWS::EC2::Instance id:i-e61c02eb>, <AWS::EC2::Instance id:i-aa463e98>]
```

## Supported actions
- RunInstances
- DescribeInstances
- CreateTags
- DescribeTags
