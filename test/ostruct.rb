assert 'OpenStruct' do
  assert_equal(Class, OpenStruct.class)
end

assert 'OpenStruct superclass' do
  assert_equal(Object, OpenStruct.superclass)
end

assert 'OpenStruct.new' do
  o = OpenStruct.new
  assert_equal(OpenStruct, o.class)

  h = {name: "foo", age:27}
  assert_equal h, OpenStruct.new(h).to_h
end

assert 'OpenStruct#==' do
  o1 = OpenStruct.new
  o2 = OpenStruct.new

  assert_equal(o1,o2)

  o1.a = 'a'
  assert_not_equal(o1,o2)

  o2.a = 'a'
  assert_equal(o1,o2)

  o1.a = 'b'
  assert_not_equal(o1,o2)

  o1.a = 1
  o2.a = 1.0
  assert_equal(o1,o2)
end

assert 'OpenStruct#inspect' do
  o = OpenStruct.new
  assert_equal("#<OpenStruct>", o.inspect)
  
  o.foo = 1
  assert_equal("#<OpenStruct foo=1>", o.inspect)
end

assert 'OpenStruct#delete_field' do
  o = OpenStruct.new
 
  assert_equal('foo', o.foo = 'foo')
  assert_equal('foo', o.foo)
  foo = o.delete_field(:foo)
  assert_equal(nil, o.foo)

  obj = Object.new
  def obj.to_sym
    :foo
  end
  o[obj] = true
  assert_equal(true, o.foo)
  o.delete_field obj
  assert_equal(nil, o.foo)
end

assert 'OpenStruct#setter' do
  o = OpenStruct.new
  o[:foo] = :bar
  assert_equal(:bar, o.foo)
  o['foo'] = :baz
  assert_equal(:baz, o.foo)
end

assert 'OpenStruct#to_h' do
  h = {name: "foo", age:27}
  o = OpenStruct.new h
  to_h = o.to_h
  assert_equal(h, to_h)

  to_h[:age] = 29
  assert_equal(27, o.age)
  assert_equal(27, h[:age])
end

assert 'OpenStruct#each_pair' do
  h = {name: "foo"}
  o = OpenStruct.new h
  str = ''
  o.each_pair do |k,v|
    str << "#{k}=#{v}"
  end
  assert_equal("name=foo", str)
end

assert 'OpenStruct#eql' do
  o1 = OpenStruct.new age: 27
  o2 = OpenStruct.new age: 27.0
  assert_equal o1, o2
  assert_false o1.eql?(o2)
  assert_true o1.eql?(o1.dup)
end

assert 'OpenStruct#hash' do
  o1 = OpenStruct.new age: 27
  o2 = OpenStruct.new age: 27.0
  assert_not_equal o1.hash, o2.hash
  assert_equal o1.hash, o1.dup.hash
end

assert 'OpenStruct#method_missing' do
  o = OpenStruct.new
  assert_raise(NoMethodError) { o.nomethod true }
  assert_raise(ArgumentError) { o.send :nomethod=, true, true }
end
