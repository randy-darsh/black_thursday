require 'simplecov'
SimpleCov.start
require_relative '../lib/sales_engine'
require_relative '../lib/sales_analyst'
require 'minitest/autorun'
require 'minitest/emoji'
require 'bigdecimal'
require 'pry'
require_relative '../lib/math_module'
require_relative '../lib/merchant_analysis'

class SalesAnalystTest < Minitest::Test
  def setup
    @se = SalesEngine.from_csv({
              :items => "./data/items.csv",
              :merchants => "./data/merchants.csv",
              :invoice_items => "./data/invoice_items.csv",
              :invoices => "./data/invoices.csv",
              :transactions => "./data/transactions.csv",
              :customers => "./data/customers.csv"
            })
    @sa = SalesAnalyst.new(@se)
  end

  def test_class_exists
    assert_instance_of SalesAnalyst, @sa
  end

  def test_average_items_per_merchant
    assert_equal 2.88, @sa.average_items_per_merchant
  end

  def test_average_items_per_merchant_standard_deviation
    assert_equal 3.26, @sa.average_items_per_merchant_standard_deviation
  end

  def test_merchants_with_high_item_count
    assert_instance_of Array, @sa.merchants_with_high_item_count
    assert_equal 52, @sa.merchants_with_high_item_count.count
  end

  def test_average_item_price_for_merchant
    assert_instance_of BigDecimal, @sa.average_item_price_for_merchant(12334105)
    assert_equal 16.66, @sa.average_item_price_for_merchant(12334105).to_f.round(2)
  end

  def test_average_average_price_per_merchant
    assert_instance_of BigDecimal, @sa.average_average_price_per_merchant
    assert_equal 350.29, @sa.average_average_price_per_merchant.to_f.round(2)
  end

  def test_golden_items
    assert_instance_of Array, @sa.golden_items
    assert_instance_of Item, @sa.golden_items[0]
  end

  def test_average_invoices_per_merchant
    assert_equal 10.49, @sa.average_invoices_per_merchant
  end

  def test_average_invoices_per_merchant_standard_deviation
    assert_equal 3.29, @sa.average_invoices_per_merchant_standard_deviation
  end

  def test_top_merchants_by_invoice_count
    assert_instance_of Array, @sa.top_merchants_by_invoice_count
    assert_instance_of Merchant, @sa.top_merchants_by_invoice_count[0]
    assert_equal 12, @sa.top_merchants_by_invoice_count.count
  end

  def test_bottom_merchants_by_invoice_count
    assert_instance_of Array, @sa.bottom_merchants_by_invoice_count
    assert_instance_of Merchant, @sa.bottom_merchants_by_invoice_count[0]
    assert_equal 4, @sa.bottom_merchants_by_invoice_count.count
  end

  def test_turn_date_to_day
    assert_equal "Thursday", @sa.turn_date_to_day("2017-07-27")
  end

  def test_top_days_by_invoice_count
    assert_instance_of Array, @sa.top_days_by_invoice_count
    assert_equal "Wednesday", @sa.top_days_by_invoice_count[0]
  end


  def test_merchants_with_only_one_item
    assert_instance_of Array, @sa.merchants_with_only_one_item
    assert_instance_of Merchant, @sa.merchants_with_only_one_item[0]
    assert_equal 243, @sa.merchants_with_only_one_item.count
  end

  def test_merchants_with_only_one_item_registered_in_a_month
    assert_instance_of Array, @sa.merchants_with_only_one_item_registered_in_month("January")
    assert_instance_of Merchant, @sa.merchants_with_only_one_item_registered_in_month("January")[0]
    assert_equal 19, @sa.merchants_with_only_one_item_registered_in_month("January").count
  end

  def test_revenue_by_date
    date = Time.parse("2009-02-07")
    assert_equal 21067.77, @sa.total_revenue_by_date(date)
  end

  def test_top_revenue_earners
    assert_equal 5, @sa.top_revenue_earners(5).count
    assert_instance_of Merchant, @sa.top_revenue_earners(5)[0]
    assert_instance_of Array, @sa.top_revenue_earners(5)
  end

  def test_merchant_ranked_by_revenue
    assert_instance_of Merchant, @sa.merchants_ranked_by_revenue[0]
    assert_instance_of Array, @sa.merchants_ranked_by_revenue
  end

  def test_merchants_with_pending_invoices
    assert_instance_of Merchant, @sa.merchants_with_pending_invoices[0]
    assert_instance_of Array, @sa.merchants_with_pending_invoices
  end

  def test_revenue_for_merchant
    assert_instance_of BigDecimal, @sa.revenue_by_merchant(12334105)
  end

  def test_most_sold_item_for_merchant_returns_the_most_sold_item
    item = @sa.most_sold_item_for_merchant(12334105).count
    assert_equal 5, item
  end

end
