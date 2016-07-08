require_relative '../../lib/product.rb'

RSpec.describe Product do
  
  context "#initialize" do
    context "#name" do
      it "returns 'Book' when 'Book' given" do
        expect(Product.new('Book', 12, 0.08).name).to eql('Book')
      end

      it "raises error when input is not a string" do
        expect{
          Product.new(45, 12, 0.08)
        }.to raise_error(ArgumentError)
      end

      it "raises error when input is not specified" do
        expect{
          Product.new(nil, 12, 0.08)
        }.to raise_error(ArgumentError)
      end
    end

    context "#price" do
      it "returns 23 when 23 is given" do
        expect(Product.new('Table', 23, 0.23).price).to eql(23)
      end

      it "works for floating point numbers like 19.99" do
        expect(Product.new('Table', 19.90, 0.23).price).to eql(19.90)
      end

      it "returns error when input is not a number" do
        expect{
          Product.new('Table', 'Chair', 0.23)
        }.to raise_error(ArgumentError)
      end

      it "returns error when input is not specified" do
        expect{
          Product.new('Table', nil, 0.23)
        }.to raise_error(ArgumentError)
      end

      it "raises error when number passed is not positive" do
        expect{
          Product.new('Table', 0, 0.23)
        }.to raise_error(ArgumentError)
      end
    end

    context "#vat" do
      it "returns 0.23 when 0.23 is given" do
        expect(Product.new('Map', 199.90, 0.23).vat).to eql(0.23)
      end

      it "returns error when input is not a number" do
        expect{
          Product.new('Map',199.90, 'code')
        }.to raise_error(ArgumentError)
      end

      it "returns error when input is not specified" do
        expect{
          Product.new('Map', 199.90, nil)
        }.to raise_error(ArgumentError)
      end

      it "raises error when number passed is not positive" do
        expect{
          Product.new('Map', 199.90, -0.23)
        }.to raise_error(ArgumentError)
      end
    end

    context "#id" do
      it "difference between products' ids is never 0" do
        p1 = Product.new("Cup", 2.99, 0.23)
        p2 = Product.new("Ball", 8.70, 0.23)
        expect(p1.id - p2.id).to_not eql(0)
      end

      it "2 succeeding products have ids' difference |1|" do
        p1 = Product.new("Cup", 2.99, 0.23)
        p2 = Product.new("Ball", 8.70, 0.23)
        expect((p1.id - p2.id).abs).to eql(1)
      end
    end
  end

  context "#to_s" do
    it "properly transforms to string" do
      product = Product.new("TV set", 2850, 0.23)
      id = product.id
      expect(product.to_s).to eql("#{id}\tTV set\t2850.00")
    end
  end

  context "#reset_id_count" do
    it "resets id counter" do
      p1 = Product.new("Cup", 2.99, 0.23)
      Product.reset_id_count
      expect(Product.new("Ball", 8.70, 0.23).id).to eql(1)
    end
  end

  after :each do
    Product.reset_id_count
  end
end