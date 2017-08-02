require 'simplecov'
SimpleCov.start
require 'bigdecimal'
require_relative '../lib/invoice_repository'
require_relative '../lib/sales_engine'
require 'csv'
require 'minitest/autorun'
require 'minitest/emoji'

class InvoiceRepositoryTest < Minitest::Test
  def setup
    @se = SalesEngine.from_csv({
              :items => "./data/items.csv",
              :merchants => "./data/merchants.csv",
              :invoice_items => "./data/invoice_items.csv",
              :invoices => "./data/invoices.csv",
              :transactions => "./data/transactions.csv",
              :customers => "./data/customers.csv"
            })
    @ir = @se.invoices
  end

  def test_it_initializes_sales_engine
    assert_instance_of SalesEngine, @se
  end

  def test_invoice_repo_exists
    assert_instance_of InvoiceRepository, @ir
  end

  def test_find_by_id
    assert_instance_of Invoice, @ir.find_by_id(2)
    assert_equal 2, @ir.find_by_id(2).id
  end

  def test_find_all_by_customer_id
    assert_instance_of Array, @ir.find_all_by_customer_id(2)
    assert_instance_of Invoice, @ir.find_all_by_customer_id(2)[0]
    assert_equal 4, @ir.find_all_by_customer_id(2).count
  end

  def test_find_all_by_merchant_id
    assert_instance_of Array, @ir.find_all_by_merchant_id(12334185)
    assert_instance_of Invoice, @ir.find_all_by_merchant_id(12335311)[0]
    assert_equal 9, @ir.find_all_by_merchant_id(12335311).count
  end

  def test_find_all_by_status
    assert_instance_of Array, @ir.find_all_by_status("pending")
    assert_instance_of Invoice, @ir.find_all_by_status("pending")[0]
    assert_equal 1473, @ir.find_all_by_status("pending").count
  end

end
