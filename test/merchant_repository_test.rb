require 'simplecov'
SimpleCov.start
require_relative '../lib/merchant_repository'
require_relative '../lib/sales_engine'
require 'csv'
require 'minitest/autorun'
require 'minitest/emoji'
require 'bigdecimal'

class MerchantRepositoryTest < Minitest::Test

  def setup
    @se = SalesEngine.from_csv({
              :items => "./data/items.csv",
              :merchants => "./data/merchants.csv",
              :invoice_items => "./data/invoice_items.csv",
              :invoices => "./data/invoices.csv",
              :transactions => "./data/transactions.csv",
              :customers => "./data/customers.csv"
            })
    @mr = @se.merchants
  end

  def test_it_exists
    assert_instance_of MerchantRepository, @mr
  end

  def test_it_can_return_array_of_known_merchant_instances
    assert_equal 475, @mr.all.count
  end

  def test_find_by_id_return_id_or_nil
    assert_instance_of Merchant, @mr.find_by_id(12334132)
    assert_nil @mr.find_by_id("12478678")
    assert_equal "perlesemoi", @mr.find_by_id(12334132).name
  end

  def test_find_by_name
    assert_instance_of Merchant, @mr.find_by_name("GoldenRayPress")
    assert_nil @mr.find_by_id("akshfkh")
    assert_equal 12334135, @mr.find_by_name("GoldenRayPress").id
  end

  def test_find_all_by_name
    assert_equal 26, @mr.find_all_by_name("Shop").count
    assert_equal [], @mr.find_all_by_name("skjdfhjg")
    assert_equal "Shopin1901", @mr.find_all_by_name("Shop").first.name
  end

end
