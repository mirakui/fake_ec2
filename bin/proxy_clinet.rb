#!/usr/bin/env ruby
require 'aws-sdk'

def ec2
  @ec2 ||= AWS::EC2.new(
    :access_key_id => ENV["AMAZON_ACCESS_KEY_ID"],
    :secret_access_key => ENV["AMAZON_SECRET_ACCESS_KEY"],
    :logger => Logger.new($stdout),
    :proxy_uri => 'http://0.0.0.0:8000',
    :log_level => :debug,
    :ec2_endpoint => 'ap-northeast-1.ec2.amazonaws.com',
    :ec2_port => 80,
    :use_ssl => false
  )
end

def sg(vpc_id, *names)
  names = [names].flatten
  ec2.security_groups.select {|s| s.vpc? && s.vpc.id == vpc_id && names.include?(s.name) }
end


if __FILE__ == $0
  ec2.instances.to_a
end
