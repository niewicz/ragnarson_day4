require_relative './product.rb'

class Warehouse
  attr_accessor :products
  attr_reader :portfolio

  def initialize(portfolio)
    @products = []
    @portfolio = add_portfolio(portfolio)
  end

  def add(product_id, quantity)
    raise ArgumentError unless product_id.is_a?(Integer) && product_id > 0 && is_in_portfolio?(product_id)
    raise ArgumentError unless quantity.is_a?(Integer) && quantity > 0
    if is_in_portfolio?(product_id)
      index = find_in(product_id)
      if index == nil
        @products << {item: product_id, count: quantity}
      else
        @products[index][:count] += quantity
      end
    end
  end

  def is_in_portfolio?(product_id)
    raise ArgumentError unless product_id.is_a?(Integer) && product_id > 0
    @portfolio.each do |item|
      return true if item.id == product_id
    end
    false
  end

  def remove(product_id, quantity)
    raise ArgumentError unless product_id.is_a?(Integer) && product_id > 0 && is_in_portfolio?(product_id)
    raise ArgumentError unless quantity.is_a?(Integer) && quantity > 0
    if is_in_portfolio?(product_id)
      index = find_in(product_id)
      if index != nil && @products[index][:count] >= quantity
        @products[index][:count] -= quantity
        return true
      else 
        return false
      end
    end
  end

  def remove_all
    @products = []
  end

  def display
    @products.each do |item|
      puts "ID:\t#{item[:item]}\tQUANTITY:\t#{item[:count]}"
    end
  end

  private
  def add_portfolio(portfolio)
    if portfolio.is_a?(Array)
        portfolio.each do |item|
          raise ArgumentError unless item.instance_of?(Product)
        end
    else
      raise ArgumentError
    end
    portfolio
  end

    def find_in(product_id)
    @products.each_with_index do |item, index|
      return index if item[:item] == product_id 
    end
    nil
  end
  
end

