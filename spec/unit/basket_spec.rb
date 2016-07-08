require_relative '../../lib/basket.rb'
require_relative '../../lib/warehouse.rb'
require_relative '../../lib/product.rb'



RSpec.describe Basket do

  before :context do
    Product.reset_id_count
    @p1 = Product.new("Book", 12, 0.08)
    @p2 = Product.new("Ball", 8, 0.23)
    @p3 = Product.new("Table", 102.6, 0.23)
    @wh = Warehouse.new([@p1, @p2, @p3])
  end

  before :example do
    @wh.add(@p1.id, 10)
    @wh.add(@p2.id, 5)
    @wh.add(@p3.id, 1)
  end

  context "#initialize" do
    context "#warehouse" do
      it "returns warehouse if initialized with Warehouse" do
        expect(Basket.new(@wh).warehouse).to eql(@wh)
      end

      it "raises error if not initialized with Warehouse" do
        expect{
          Basket.new(nil)
        }.to raise_error(ArgumentError)
      end

      it "leaves products empty" do
        expect(Basket.new(@wh).products).to eql([])
      end
    end
  end


  context "#add" do
    it "adds to empty basket" do
      expect(Basket.new(@wh).add(1, 10)).to eql([{item: 1, count: 10}])
    end

    it "changes quantity if product is inside" do
      basket = Basket.new(@wh)
      basket.add(1, 2)
      basket.add(1, 2)
      expect(basket.products[0][:count]).to eql(4)
    end

    it "changes quantity in warehouse" do
      basket = Basket.new(@wh)
      basket.add(1, 4)
      expect(basket.warehouse.products[0][:count]).to eql(6)
    end

    it "does not allow to take more than is in storage" do
      basket = Basket.new(@wh)
      basket.add(1, 20)
      expect(basket.products).to eql([])
    end

    it "raises error when wrong number of arguments" do
      expect{
        Basket.new(@wh).add(1)
      }.to raise_error(ArgumentError)
    end

    it "raises error when not positive quantity" do
      expect{
        Basket.new(@wh).add(1, -2)
      }.to raise_error(ArgumentError)
    end

    it "raises error when quantity not number" do
      expect{
        Basket.new(@wh).add(1, "start")
      }.to raise_error(ArgumentError)
    end

    it "raises error when not positive product_id" do
      expect{
        Basket.new(@wh).add(-1, 2)
      }.to raise_error(ArgumentError)
    end

    it "raises error when product_id not number" do
      expect{
        Basket.new(@wh).add(nil, 2)
      }.to raise_error(ArgumentError)
    end

    it "raises error when product_id is not in portfolio" do
      expect{
        Basket.new(@wh).add(7, 2)
      }.to raise_error(ArgumentError)
    end

    it "operates on integer" do
      expect{
        Basket.new(@wh).add(1, 2.3)
      }.to raise_error(ArgumentError)
    end
  end


  context "#remove" do
    it "changes quantity if product inside" do
      basket = Basket.new(@wh)
      basket.add(1, 5)
      basket.remove(1, 3)
      expect(basket.products[0][:count]).to eql(2)
    end

    it "changes quantity in warehouse" do
      basket = Basket.new(@wh)
      basket.add(1, 5)
      basket.remove(1, 3)
      expect(basket.warehouse.products[0][:count]).to eql(8)
    end

    it "removes from basket" do
      basket = Basket.new(@wh)
      basket.add(1, 3)
      basket.remove(1, 3)
      expect(basket.products).to eql([])
    end

    it "does not allow to remove more than is in basket" do
      basket = Basket.new(@wh)
      basket.add(1, 5)
      basket.remove(1, 7)
      expect(basket.products[0][:count]).to eql(5)
    end

    it "raises error when wrong number of arguments" do
      expect{
        Basket.new(@wh).remove(1)
      }.to raise_error(ArgumentError)
    end

    it "raises error when not positive quantity" do
      expect{
        Basket.new(@wh).remove(1, -2)
      }.to raise_error(ArgumentError)
    end

    it "raises error when quantity not number" do
      expect{
        Basket.new(@wh).remove(1, "start")
      }.to raise_error(ArgumentError)
    end

    it "raises error when not positive product_id" do
      expect{
        Basket.new(@wh).remove(-1, 2)
      }.to raise_error(ArgumentError)
    end

    it "raises error when product_id not number" do
      expect{
        Basket.new(@wh).remove(nil, 2)
      }.to raise_error(ArgumentError)
    end

    it "raises error when product_id is not in portfolio" do
      expect{
        Basket.new(@wh).remove(7, 2)
      }.to raise_error(ArgumentError)
    end

    it "operates on integer" do
      expect{
        Basket.new(@wh).remove(1, 2.3)
      }.to raise_error(ArgumentError)
    end
  end


  context "#to_s" do
    it "properly converts to string" do
      basket = Basket.new(@wh)
      basket.add(1, 2)
      expect(basket.to_s).to eql(
        ">>>BASKET\n" +
        "ID\tNAME\tPRICE\tQUANT\t\n" +
        "--------------------------------------\n" +
        "1\tBook\t12.00\t2\t24.00\n" +
        "--------------------------------------\n" +
        "Sum:\t\t24.00\n" +
        "With VAT:\t25.92\n")
    end
  end


  after :example do
    @wh.remove_all
  end

end
