require 'simplecov'
SimpleCov.start
require_relative '../lib/sales_engine'
require 'bigdecimal'
require 'time'
require_relative '../lib/invoice_item'
require 'csv'
require 'minitest/autorun'
require 'minitest/emoji'

class InvoiceItemTest < Minitest::Test
  def setup
    @se = SalesEngine.from_csv({
              :items => "./data/items.csv",
              :merchants => "./data/merchants.csv",
              :invoice_items => "./data/invoice_items.csv",
              :invoices => "./data/invoices.csv",
              :transactions => "./data/transactions.csv",
              :customers => "./data/customers.csv"
            })
    @ii = InvoiceItem.new({
              :id => 6,
              :item_id => 7,
              :invoice_id => 8,
              :quantity => 1,
              :unit_price => BigDecimal.new(10.99, 4),
              :created_at => Time.now,
              :updated_at => Time.now
            }, @se.invoice_items)
  end

  def test_it_exists
    assert_instance_of InvoiceItem, @ii
  end

  def test_has_attributes
    assert_equal 6, @ii.id
    assert_equal 7, @ii.item_id
    assert_equal 8, @ii.invoice_id
    assert_equal 1, @ii.quantity
    assert_instance_of BigDecimal, @ii.unit_price
    assert_instance_of Time, @ii.created_at
    assert_instance_of Time, @ii.updated_at
  end

  def test_it_has_unit_price_to_dollars
    assert_instance_of BigDecimal, @ii.unit_price_to_dollars
    assert_equal 0.11, @ii.unit_price_to_dollars.round(2)
  end

end
