##
# OpenStruct
#

class OpenStruct
  def initialize hash=nil
    @table = {}
    if hash
      hash.each do |k,v|
        k = k.to_sym
        @table[k] = v
      end
    end
  end

  def initialize_copy orig
    super
    @table = @table.dup
  end

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

  def each_pair
    @table.each{ |p|
      yield p
    }
  end

  def delete_field name
    table.delete name.to_sym
  end

  def to_h
    table.dup
  end

  def == other
    return false unless other.kind_of?(OpenStruct)
    table == other.table
  end

  def [] key
    @table[key.to_sym]
  end

  def []= key, value
    @table[key.to_sym] = value
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
    name = mid.id2name
    len = args.length
    if name.chomp! '='
      if len != 1
        raise ArgumentError, "wrong number of arguments (#{len} for 1)"
      end
      @table[name.to_sym] = args[0]
    elsif len == 0
      @table[mid]
    else
      raise NoMethodError "undefined method `#{mid}' for #{self}"
    end
  end
end
