require 'simplecov'
SimpleCov.start
require_relative '../lib/sales_engine'
require 'bigdecimal'
require 'time'
require_relative '../lib/invoice'
require 'csv'
require 'minitest/autorun'
require 'minitest/emoji'

class InvoiceTest < Minitest::Test
  def setup
    @se = SalesEngine.from_csv({
              :items => "./data/items.csv",
              :merchants => "./data/merchants.csv",
              :invoice_items => "./data/invoice_items.csv",
              :invoices => "./data/invoices.csv",
              :transactions => "./data/transactions.csv",
              :customers => "./data/customers.csv"
            })
    @i = Invoice.new({
              :id          => 6,
              :customer_id => 7,
              :merchant_id => 8,
              :status      => "pending",
              :created_at  => Time.now,
              :updated_at  => Time.now,
            }, @se.invoices)
    @invoice = @se.invoices.find_by_id(74)
  end

  def test_has_instance_variables
    assert_instance_of InvoiceRepository, @i.invoice_repo
    assert_equal 6, @i.id
    assert_equal 7, @i.customer_id
    assert_equal 8, @i.merchant_id
    assert_equal :pending, @i.status
    assert_instance_of Time, @i.created_at
    assert_instance_of Time, @i.updated_at
  end

  def test_merchant_exists
    assert_instance_of Merchant, @invoice.merchant
  end

  def test_invoice_items_returns_an_array_of_items
    invoice = @se.invoices.find_by_id(14)
    assert_instance_of Array, invoice.items
    assert_equal 8, invoice.items.count
  end

  def test_invoice_transactions_returns_an_array_of_transactions
    invoice = @se.invoices.find_by_id(14)
    assert_instance_of Array, invoice.transactions
    assert_instance_of Transaction, invoice.transactions[0]
    assert_equal 1, invoice.transactions.count
  end

  def test_customer_finds_customer
    invoice = @se.invoices.find_by_id(1)
    assert_instance_of Customer, invoice.customer
  end

  def test_is_paid_in_full?
    invoice = @se.invoices.find_by_id(46)
    assert_equal true, invoice.is_paid_in_full?
  end

  def test_total
    invoice = @se.invoices.find_by_id(2)
    assert_instance_of BigDecimal, invoice.total
  end

end
