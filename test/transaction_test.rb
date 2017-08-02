require 'simplecov'
SimpleCov.start
require_relative '../lib/sales_engine'
require 'bigdecimal'
require 'time'
require_relative '../lib/transaction'
require 'csv'
require 'minitest/autorun'
require 'minitest/emoji'

class TransactionTest < Minitest::Test
  def setup
    @se = SalesEngine.from_csv({
              :items => "./data/items.csv",
              :merchants => "./data/merchants.csv",
              :invoice_items => "./data/invoice_items.csv",
              :invoices => "./data/invoices.csv",
              :transactions => "./data/transactions.csv",
              :customers => "./data/customers.csv"
            })
    @t = Transaction.new({
              :id => 6,
              :invoice_id => 8,
              :credit_card_number => "4242424242424242",
              :credit_card_expiration_date => "0220",
              :result => "success",
              :created_at => Time.now,
              :updated_at => Time.now
            }, @se.transactions)
  end

  def test_it_exists
    assert_instance_of Transaction, @t
  end

  def test_it_has_attributes
    assert_equal 6, @t.id
    assert_equal 8, @t.invoice_id
    assert_equal 4242424242424242, @t.credit_card_number
    assert_equal "0220", @t.credit_card_expiration_date
    assert_equal "success", @t.result
    assert_instance_of Time, @t.created_at
    assert_instance_of Time, @t.updated_at
  end

  def test_invoice_finds_invoice
    assert_instance_of Invoice, @t.invoice
    assert_equal 8, @t.invoice.id
  end
end
