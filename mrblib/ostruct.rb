##
# OpenStruct
# This code is based on https://github.com/ruby/ruby/blob/trunk/lib/ostruct.rb

class OpenStruct
  def initialize hash=nil
    @table = {}
    if hash
      hash.each do |k,v|
        k = k.to_sym
        @table[k] = v
        new_ostruct_member(k)
      end
    end
  end

  def initialize_copy orig
    super
    @table = @table.dup
    @table.each_key{|key| new_ostruct_member(key)}
  end

  def to_h
    @table.dup
  end

  def each_pair
    return to_enum __method__ unless block_given?
    @table.each{|p| yield p}
  end

  def new_ostruct_member name
    name = name.to_sym
    unless respond_to?(name)
      define_singleton_method(name){ @table[name] }
      define_singleton_method("#{name}=".to_sym){ |x| @table[name] = x }
    end
    name
  end
  protected :new_ostruct_member

  def inspect
    str = "#<#{self.class}"
    ary = []
    @table.each do |k,v|
      ary << "#{k}=#{v}"
    end
    if 0 < ary.length
      str << ' '
      str << ary.join(', ')
    end
    str << '>'
  end
  alias :to_s :inspect

  def delete_field name
    sym = name.to_sym
    singleton_class.__send__ :remove_method, sym, "#{sym}=".to_sym
    @table.delete sym
  end

  def == other
    return false unless other.kind_of?(OpenStruct)
    @table == other.table
  end

  def [] key
    @table[key.to_sym]
  end

  def []= key, value
    @table[new_ostruct_member(key)] = value
  end

  def eql? other
    return false unless other.kind_of?(OpenStruct)
    @table.eql?(other.table)
  end

  def hash
    @table.hash
  end

  attr_reader :table
  protected :table

  def method_missing mid, *args
    mname = mid.to_s
    len = args.length
    if mname.chomp! '='
      if len != 1
        raise ArgumentError, "wrong number of arguments (#{len} for 1)"
      end
      @table[new_ostruct_member(mname)] = args[0]
    elsif len == 0
      @table[mid]
    else
      raise NoMethodError, "undefined method `#{mid}' for #{self}"
    end
  end
end
