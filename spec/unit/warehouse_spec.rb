require_relative '../../lib/warehouse.rb'
require_relative '../../lib/product.rb'

RSpec.describe Warehouse do

	before :context do
		Product.reset_id_count
		@p1 = Product.new("Book", 12, 0.08)
		@p2 = Product.new("Ball", 8, 0.23)
		@p3 = Product.new("Table", 102.6, 0.23)
		p "warehouse", @p1.id, @p2.id, @p3.id
	end


	context "#portfolio" do
		it "returns array of products when initialied with array of products" do
			expect(Warehouse.new([@p1, @p2, @p3]).portfolio).to eql([@p1, @p2, @p3])
		end

		it "raises error when not initialized with array of products" do
			expect{
				Warehouse.new(['Table', 'Book', 'TV set'])
			}.to raise_error(ArgumentError)
		end

		it "raises error when not initialized with array" do
			expect{
				Warehouse.new(3)
			}.to raise_error(ArgumentError)
		end

		it "raises error when parameters not specified" do
			expect{
				Warehouse.new(nil)
			}.to raise_error(ArgumentError)
		end
	end


	context "#add" do
		it "adds product_id and quantity to empty array of products" do
			warehouse = Warehouse.new([@p1])
			warehouse.add(1, 10)
			expect(warehouse.products[0]).to eql({item: 1, count: 10})
		end

		it "changes quantity if product_id is in products" do
			warehouse = Warehouse.new([@p1])
			warehouse.add(1, 10)
			warehouse.add(1, 20)
			expect(warehouse.products[0][:count]).to eql(30)
		end

		it "raises error when wrong number of arguments" do
			expect{
				Warehouse.new([@p1]).add(1)
			}.to raise_error(ArgumentError)
		end

		it "raises error when not positive quantity" do
			expect{
				Warehouse.new([@p1]).add(1, -2)
			}.to raise_error(ArgumentError)
		end

		it "raises error when quantity not number" do
			expect{
				Warehouse.new([@p1]).add(1, "start")
			}.to raise_error(ArgumentError)
		end

		it "raises error when not positive product_id" do
			expect{
				Warehouse.new([@p1]).add(-1, 2)
			}.to raise_error(ArgumentError)
		end

		it "raises error when product_id not number" do
			expect{
				Warehouse.new([@p1]).add(nil, 2)
			}.to raise_error(ArgumentError)
		end

		it "raises error when product_id is not in portfolio" do
			expect{
				Warehouse.new([@p1]).add(7, 2)
			}.to raise_error(ArgumentError)
		end

		it "operates on integer" do
			expect{
				Warehouse.new([@p1]).add(1, 2.3)
			}.to raise_error(ArgumentError)
		end
	end


	context "#remove" do
		it "changes quantity if product_id is in products" do
				warehouse = Warehouse.new([@p1])
				warehouse.add(1, 20)
				warehouse.remove(1, 7)
				expect(warehouse.products[0][:count]).to eql(13)
		end

		it "returns true if succesfully removed" do
				warehouse = Warehouse.new([@p1])
				warehouse.add(1, 20)
				expect(warehouse.remove(1, 7)).to eql(true)
		end

		it "returns false if quantity is to great" do
				warehouse = Warehouse.new([@p1])
				warehouse.add(1, 20)
				expect(warehouse.remove(1, 234)).to eql(false)
		end

		it "raises error when wrong number of arguments" do
			expect{
				Warehouse.new([@p1]).remove(1)
			}.to raise_error(ArgumentError)
		end

		it "raises error when not positive quantity" do
			expect{
				Warehouse.new([@p1]).remove(1, -2)
			}.to raise_error(ArgumentError)
		end

		it "raises error when quantity not number" do
			expect{
				Warehouse.new([@p1]).remove(1, "start")
			}.to raise_error(ArgumentError)
		end

		it "raises error when not positive product_id" do
			expect{
				Warehouse.new([@p1]).remove(-1, 2)
			}.to raise_error(ArgumentError)
		end

		it "raises error when product_id not number" do
			expect{
				Warehouse.new([@p1]).remove(nil, 2)
			}.to raise_error(ArgumentError)
		end

		it "raises error when product_id is not in portfolio" do
			expect{
				Warehouse.new([@p1]).remove(7, 2)
			}.to raise_error(ArgumentError)
		end

		it "operates on integer" do
			expect{
				Warehouse.new([@p1]).remove(1, 2.3)
			}.to raise_error(ArgumentError)
		end
	end

	context "#is_in_portfolio?" do
		it "returns true when product with given id is in portfolio" do
			expect(Warehouse.new([@p1]).is_in_portfolio?(1)).to be true
		end

		it "returns false when product with given id is not in portfolio" do
			expect(Warehouse.new([@p1]).is_in_portfolio?(2)).to be false
		end

		it "raises error if wrong argument" do
			expect{
				Warehouse.new([@p1]).is_in_portfolio?(nil)
			}.to raise_error(ArgumentError)
		end
	end


	context "#remove_all" do
		it "clears products" do
			warehouse = Warehouse.new([@p1, @p2, @p3])
			warehouse.add(1, 7)
			warehouse.add(2, 15)
			warehouse.add(3, 2)
			warehouse.remove_all
			expect(warehouse.products).to eql([])
		end
	end


	context "#display" do
		it "doesn't raise errors" do
			warehouse = Warehouse.new([@p1, @p2])
			warehouse.add(1, 10)
			warehouse.add(2, 20)
			expect{
				warehouse.display
			}.to_not raise_error
		end
	end
	
end


	#context "#find_in" do
	#	it "returns nil if given product_id not found" do
	#		warehouse = Warehouse.new([@p1, @p2])
	#		expect(warehouse.find_in(3)).to eql(nil)
	#	end
	#
	#	it "returns index if given product_id found" do
	#		warehouse = Warehouse.new([@p1, @p2])
	#		warehouse.add(1, 10)
	#		warehouse.add(2, 20)
	#		expect(warehouse.find_in(2)).to eql(1)
	#	end
	#end