require 'simplecov'
SimpleCov.start
require_relative '../lib/sales_engine'
require 'bigdecimal'
require 'time'
require_relative '../lib/customer'
require 'csv'
require 'minitest/autorun'
require 'minitest/emoji'

class CustomerTest < Minitest::Test
  def setup
    @se = SalesEngine.from_csv({
              :items => "./data/items.csv",
              :merchants => "./data/merchants.csv",
              :invoice_items => "./data/invoice_items.csv",
              :invoices => "./data/invoices.csv",
              :transactions => "./data/transactions.csv",
              :customers => "./data/customers.csv"
            })
    @c = Customer.new({
              :id => 8,
              :first_name => "Loyal",
              :last_name => "Considine",
              :created_at => "2012-03-27",
              :updated_at => "2012-03-27"
            }, @se.customers)
  end

  def test_it_exists
    assert_instance_of Customer, @c
  end

  def test_has_attributes
    assert_equal 8, @c.id
    assert_equal "Loyal", @c.first_name
    assert_equal "Considine", @c.last_name
    assert_instance_of Time, @c.created_at
    assert_instance_of Time, @c.updated_at
  end

  def test_merchants_returns_array_of_merchants
    assert_instance_of Array, @c.merchants
    assert_equal 12334755, @c.merchants.first.id
    assert_instance_of Merchant, @c.merchants.first
  end
end
