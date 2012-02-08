#!/usr/bin/env ruby

require 'rocketamf'
require 'rocketamf_ext'

#=begin
class Asinbow

  attr_accessor :name
  attr_accessor :age

  def initialize(name=nil, age=nil)
    @name = name
    @age = age
  end

  def read_external(des)
    @name = des.read_utf8
    @age = des.read_int
  end

  def write_external(ser)
    ser.write_utf8(@name)
    ser.write_int(@age)
  end

end
#=end

RocketAMF::ClassMapping.reset
RocketAMF::ClassMapping.define do |m|
  m.map :as => 'ASB', :ruby => 'Asinbow'
end

o = [Asinbow.new('asinbow', 26), {:name => 'asinbow', :age => 26}, ['asinbow', 26]]

binary = RocketAMF.serialize(o, 3)
puts binary.inspect
oo = RocketAMF.deserialize(binary, 3)
puts oo.inspect

File.open("nodes/mynode/files/amf_test.bin", "w") do |f|
  f.write(binary)
end


