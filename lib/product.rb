class Product
  attr_accessor :name, :price, :vat, :id
  @@id = 0

  def initialize(name, price, vat)
    @id = next_id
    @name = add_name(name)
    @price = add_price(price)
    @vat = add_vat(vat)
  end

  def to_s
    "#{@id}\t#{@name}\t" + "%.2f" % @price
  end

  def self.reset_id_count
    @@id = 0
  end

private
  def next_id
    @@id += 1
  end

    def add_name(name)
    raise ArgumentError unless name.is_a?(String)
    name
  end

  def add_price(price)
    raise ArgumentError unless price.is_a?(Numeric)
    raise ArgumentError if price <= 0
    price
  end

  def add_vat(vat)
    raise ArgumentError unless vat.is_a?(Numeric)
    raise ArgumentError if vat <= 0
    vat
  end
end