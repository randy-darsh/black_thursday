require 'simplecov'
SimpleCov.start
require 'bigdecimal'
require_relative '../lib/sales_engine'
require 'csv'
require 'minitest/autorun'
require 'minitest/emoji'

class SalesEngineTest < Minitest::Test

  def setup
    @se = SalesEngine.from_csv({
              :items => "./data/items.csv",
              :merchants => "./data/merchants.csv",
              :invoice_items => "./data/invoice_items.csv",
              :invoices => "./data/invoices.csv",
              :transactions => "./data/transactions.csv",
              :customers => "./data/customers.csv"
            })
  end

  def test_it_exists
    assert_instance_of SalesEngine, @se
  end

  def test_it_has_an_item_repository
    assert_instance_of ItemRepository, @se.items
  end

  def test_it_has_a_merchant_repository
    assert_instance_of MerchantRepository, @se.merchants
  end

  def test_it_has_an_invoice_repository
    assert_instance_of InvoiceRepository, @se.invoices
  end

  def test_it_has_an_invoice_items_repository
    assert_instance_of InvoiceItemRepository, @se.invoice_items
  end

  def test_it_has_a_transactions_repository
    assert_instance_of TransactionRepository, @se.transactions
  end

  def test_it_has_a_customer_repository
    assert_instance_of CustomerRepository, @se.customers
  end

end
