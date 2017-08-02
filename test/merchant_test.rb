require 'simplecov'
SimpleCov.start
require 'bigdecimal'
require_relative '../lib/sales_engine'
require_relative '../lib/merchant'
require 'csv'
require 'minitest/autorun'
require 'minitest/emoji'
require 'time'
require 'date'

class MerchantTest < Minitest::Test

  def setup
    @se = SalesEngine.from_csv({
              :items => "./data/items.csv",
              :merchants => "./data/merchants.csv",
              :invoice_items => "./data/invoice_items.csv",
              :invoices => "./data/invoices.csv",
              :transactions => "./data/transactions.csv",
              :customers => "./data/customers.csv"
            })
    @merchant = @se.merchants.find_by_id(12334105)
    @merch = Merchant.new({:id => 12334146, :name => "MotankiDarena", :created_at => "2016-02-01"}, @se.merchants)
  end

  def test_it_exists
    assert_instance_of Merchant, @merch
  end

  def test_it_has_an_id
    assert_equal 12334146, @merch.id
  end

  def test_items_returns_array_of_items_objects
    assert_instance_of Array, @merchant.items
    assert_instance_of Item, @merchant.items[0]
    assert_equal 3, @merchant.items.count
  end

  def test_invoices_returns_array_of_invoices_by_merchant
    assert_equal 10, @merchant.invoices.count
    assert_instance_of Invoice, @merchant.invoices[0]
  end

  def test_customers_returns_array_of_merchants_customers
    assert_instance_of Customer, @merchant.customers[0]
    assert_equal 10, @merchant.customers.count
  end

  def test_revenue_for_merchant
    merchant = @se.merchants.find_by_id(12334299)
    assert_equal 0.3217712e5, merchant.revenue_for_merchant.round(2)
  end

end
