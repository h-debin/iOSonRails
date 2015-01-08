def call_with_block
  yield("hello world")
end

dec = proc do |x|
  x -= 1
  return x
end
# ++
# it will cause failure
# ++
puts dec.call(1)

inc = lambda {|x| x+= 1}
puts inc.call(1)

call_with_block do |a|
  puts a
end

