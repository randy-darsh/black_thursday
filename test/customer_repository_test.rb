require 'simplecov'
SimpleCov.start
require_relative '../lib/customer_repository'
require 'minitest/autorun'
require 'minitest/emoji'
require_relative '../lib/sales_engine'
require 'csv'
require 'bigdecimal'

class CustomerRepositoryTest < Minitest::Test
  def setup
    @se = SalesEngine.from_csv({
              :items => "./data/items.csv",
              :merchants => "./data/merchants.csv",
              :invoice_items => "./data/invoice_items.csv",
              :invoices => "./data/invoices.csv",
              :transactions => "./data/transactions.csv",
              :customers => "./data/customers.csv"
            })
    @c = @se.customers
  end

  def test_all_returns_array_of_all_customers
    assert_instance_of Array, @c.all
    assert_equal 1000, @c.all.count
  end

  def find_by_id
    assert_instance_of Customer, @c.find_by_id(6)
    assert_equal 5, @c.find_by_id(6).count
  end

  def test_find_all_by_first_name
    assert_instance_of Array, @c.find_all_by_first_name("Mariah")
    assert_equal "Mariah", @c.find_all_by_first_name("Mariah")[0].first_name
  end

  def test_find_all_by_last_name
    assert_instance_of Array, @c.find_all_by_last_name("Ondricka")
    assert_equal "Ondricka", @c.find_all_by_last_name("Ondricka")[0].last_name
  end

end
