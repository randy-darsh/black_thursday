require 'pry'
require_relative '../lib/math_module'
require_relative '../lib/merchant_analysis'
require_relative '../lib/invoice_analysis'

class SalesAnalyst
  include MathModule
  include MerchantAnalysis
  include InvoiceAnalysis

  attr_reader :se

  def initialize(se)
    @se = se
  end

  def set_of_item_prices
    set = []
    @se.items.all.map do |item|
      set << item.unit_price_to_dollars
    end
    set
  end

  def add_to_total_averages_if_not_nil(total_averages, merch_id)
    if average_item_price_for_merchant(merch_id) != nil
      total_averages << average_item_price_for_merchant(merch_id)
    end
  end

  def total_averages
    total_averages = []
    all_merchant_ids.each do |merch_id|
      add_to_total_averages_if_not_nil(total_averages, merch_id)
    end
    total_averages
  end

  def turn_date_to_day(date)
    date = Date.parse(date)
    date.strftime("%A")
  end

  def find_days(mean)
    @day_count.find_all do |day, num|
      (num - mean) > average_sales_per_day_standard_deviation
    end.flatten
  end

  def create_status
    @se.invoices.all.map do |invoice|
      invoice.status
    end
  end

  def create_status_hash(status)
    status.reduce(Hash.new(0)) do |status, num|
      status[num] += 1; status
    end
  end

  def item_date
    @se.items.all.map do |item|
      item.created_at.strftime("%A")
    end
  end

  def total_revenue_by_date(date)
    invoices_by_date(date).inject(0) do |sum, invoice|
      sum + invoice.total
    end
  end

  def top_revenue_earners(num = 20)
    invoices = create_invoices_hash
    sorted_invoices(invoices)[0..(num-1)].map do |array|
      array[0]
    end
  end

  def add_to_most_sold_item_hash(invoice, most_sold_item)
    invoice.invoice_items.map do |invoice_item|
      most_sold_item[invoice_item.item_id] += invoice_item.quantity
    end
  end

  def add_to_best_item_hash(invoice, best_item)
    invoice.invoice_items.map do |invoice_item|
      best_item[invoice_item.item_id] +=
      invoice_item.unit_price*invoice_item.quantity
    end
  end

  def find_best_item(best_items)
    best_item = best_items.max_by do |item|
      item[1]
    end
    @se.items.find_by_id(best_item[0])
  end

  def get_most_sold_items(item_ids)
    item_ids.map do |item|
      @se.items.find_by_id(item[0])
    end
  end

  def create_most_sold_item_hash(hash)
    hash.sort_by do |high_group|
      high_group[1]
    end
  end

  def find_items(most_sold_item_hash, best_items)
    most_sold_item_hash.find_all do |item|
      item[1] == best_items[1]
    end
  end

  def pass_most_sold_item(hash)
    most_sold_item_hash = create_most_sold_item_hash(hash)
    best_items = most_sold_item_hash[-1]
    get_most_sold_items(find_items(most_sold_item_hash, best_items))
  end
end
