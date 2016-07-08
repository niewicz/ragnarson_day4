require_relative "./warehouse"

class Basket
  attr_reader :products, :warehouse

  def initialize(warehouse)
    @products = []
    @warehouse = add_warehouse(warehouse)
  end

  def add(product_id, quantity)
    raise ArgumentError unless quantity.is_a?(Integer) && quantity > 0
    raise ArgumentError unless (product_id.is_a?(Integer) && product_id > 0 && @warehouse.is_in_portfolio?(product_id))
    if warehouse.remove(product_id, quantity)
      index = find_in(product_id)
      if index == nil
        @products << {item: product_id, count: quantity}
      else
        @products[index][:count] += quantity
      end
    end
  end

  def remove(product_id, quantity)
    raise ArgumentError unless quantity.is_a?(Integer) && quantity > 0
    raise ArgumentError unless (product_id.is_a?(Integer) && product_id > 0 && @warehouse.is_in_portfolio?(product_id))
    index = find_in(product_id)
    if index != nil && @products[index][:count] >= quantity
      @products[index][:count] -= quantity
      warehouse.add(product_id, quantity)
      if @products[index][:count] == 0
        @products.delete_at(index)
      end
    end
  end

  def to_s
    sum, sum_with_vat, s_tmp = compute_bill()
    s = ">>>BASKET\n"
    s += "ID\tNAME\tPRICE\tQUANT\t\n"
    s += "--------------------------------------\n"
    s += s_tmp
    s += "--------------------------------------\n"
    s += "Sum:\t\t" + "%.2f" % sum + "\n"
    s += "With VAT:\t" + "%.2f" % sum_with_vat + "\n"
    return s
  end

  private
  def add_warehouse(warehouse)
    raise ArgumentError unless warehouse.instance_of?(Warehouse)
    warehouse
  end

  def compute_bill
    sum, sum_with_vat = 0, 0
    s = ""
    @products.each do |item|
      product = warehouse.portfolio.find{|prod| prod.id == item[:item]}
      s += product.to_s + "\t" + item[:count].to_s + "\t%.2f" % (product.price * item[:count]) + "\n"
      sum += product.price * item[:count]
      sum_with_vat += product.price * (1 + product.vat) * item[:count]
    end
    return sum, sum_with_vat, s
  end

  def find_in(product_id)
    @products.each_with_index do |item, index|
      return index if item[:item] == product_id 
    end
    nil
  end

end