require 'pry'

class SalesAnalyst

  attr_reader :se

  def initialize(se)
    @se = se
  end

  def average_item_price
    set = set_of_item_prices
    sum = sum_array(set_of_item_prices)
    sum / set.count
  end

  def average_items_per_merchant
    ((@se.items.all.count.to_f) / (@se.merchants.all.count.to_f)).round(2)
  end

  def standard_deviation(values)
    average = values.reduce(:+)/values.length.to_f
    average_average = values.reduce(0) do |val, num|
      val + ((num - average) ** 2)
    end
    Math.sqrt(average_average / (values.length - 1)).round(2)
  end

  def average_items_per_merchant_standard_deviation
    set = set_of_merchant_items
    standard_deviation(set)
  end

  def set_of_item_prices
    set = []
    @se.items.all.map do |item|
      set << item.unit_price_to_dollars
    end
    set
  end

  def set_of_merchant_items
    set = []
    @se.merchants.all.map do |merchant|
      set << merchant.items.count
    end
    set
  end

  def merchants_with_high_item_count
    standard_deviation = (average_items_per_merchant_standard_deviation)
    mean = average_items_per_merchant
    @se.merchants.all.find_all do |merchant|
      (merchant.items.count - mean) > standard_deviation
    end
  end

  def average_item_price_for_merchant(merch_id)
    merchant = @se.merchants.find_by_id(merch_id)
    num_of_items = merchant.items.count
    if num_of_items != 0
      sum_of_prices = merchant.items.inject(0) do |sum, item|
        sum += item.unit_price_to_dollars
      end
      result = sum_of_prices/num_of_items
    else
      return nil
    end
    result.round(2)
  end

  def all_merchant_ids
    @se.merchants.all.map do |merchant|
      merchant.id
    end
  end

  def average_average_price_per_merchant
    total_averages = []
    all_merchant_ids.each do |merch_id|
      if average_item_price_for_merchant(merch_id) != nil
        total_averages << average_item_price_for_merchant(merch_id)
      end
    end
    sum = sum_array(total_averages)
    (sum / total_averages.count).round(2)
  end

  def sum_array(array)
    array.inject(0) do |sum, num|
      sum + num
    end
  end

  def average_item_price_standard_deviation
    set = set_of_item_prices
    standard_deviation(set)
  end

  def golden_items
    @se.items.all.find_all do |item|
      item.unit_price_to_dollars >
      (average_item_price +
      (average_item_price_standard_deviation * 2)).round(2)
    end
  end

  def average_invoices_per_merchant
    ((@se.invoices.all.count.to_f) / (@se.merchants.all.count.to_f)).round(2)
  end

  def set_of_merchant_invoices
    set = []
    @se.merchants.all.map do |merchant|
      set << merchant.invoices.count
    end
    set
  end

  def average_invoices_per_merchant_standard_deviation
    set = set_of_merchant_invoices
    standard_deviation(set)
  end

  def top_merchants_by_invoice_count
    standard_deviation = (average_invoices_per_merchant_standard_deviation * 2)
    mean = average_invoices_per_merchant
    @se.merchants.all.find_all do |merchant|
      (merchant.invoices.count - mean) > standard_deviation
    end
  end

  def bottom_merchants_by_invoice_count
    standard_deviation = (average_invoices_per_merchant_standard_deviation * 2)
    mean = average_invoices_per_merchant
    @se.merchants.all.find_all do |merchant|
      (mean - merchant.invoices.count) > standard_deviation
    end
  end

  def average_invoice_count
    set = set_of_merchant_invoices
    total_merchant_count = @se.merchants.all.count
    set.count / total_merchant_count
  end

  def turn_date_to_month(date)

  end

  def turn_date_to_day(date)
    date = Date.parse(date)
    date.strftime("%A")
  end

  def get_invoices_per_day
    @se.invoices.all.reduce(Hash.new(0)) do |days, invoice|
      invoice_day = invoice.created_at.strftime("%A")
      days[invoice_day] += 1
      days
    end
  end

  def top_days_by_invoice_count
    mean = average_sales_per_day
    days = @day_count.find_all do |day, num|
      (num - mean) > average_sales_per_day_standard_deviation
    end
    days.find do |item|
      item
    end
  end

  def invoice_dates
    @se.invoices.all.map do |invoice|
      invoice.created_at.strftime("%A")
    end
  end

  def average_sales_per_day
    @day_count =
    invoice_dates.reduce(Hash.new(0)) do |days, num|
      days[num] += 1; days
    end
    @day_count.values.reduce(:+)/ 7
  end

  def average_sales_per_day_standard_deviation
    mean = average_sales_per_day
    sum = @day_count.values.reduce(0){|sum, num| sum + (num - mean)**2}
    Math.sqrt(sum / 6).round(2)
  end

  def calculate_invoice_percentage
    status = @se.invoices.all.map do |invoice|
      invoice.status
    end
    status = status.reduce(Hash.new(0)) do |status, num|
      status[num] += 1; status
    end
    sum = status.values.inject(:+)
    status.each_with_object(Hash.new(0)) do |(stat, num), hash|
      hash[stat] = num * 100.0 / sum
    end
  end

  def invoice_status(status)
    calculate_invoice_percentage[status].round(2)
  end

  def merchants_with_only_one_item
    @se.merchants.all.find_all do |merchant|
      merchant.items.count == 1
    end
  end

  def item_date
    @se.items.all.map do |item|
      item.created_at.strftime("%A")
    end
  end


  def total_revenue_by_date(date)
    invoices_by_date = []
    @se.invoices.all.each do |invoice|
      if invoice.created_at.strftime("%x") == date.strftime("%x")
        invoices_by_date << invoice
      end
    end
    invoices_by_date.inject(0) do |sum, invoice|
      sum += invoice.total
    end
  end


  def top_revenue_earners(num = 20)
    invoices = {}
    @se.merchants.all.map do |merchant|
      invoices[merchant] = merchant.revenue_for_merchant
    end
    sorted_invoices = invoices.sort_by do |merchant, total_revenue|
      total_revenue.to_f
    end
    sorted_invoices.reverse!
    merchants = sorted_invoices[0..(num-1)].map do |array|
      array[0]
    end
  end

  def merchants_ranked_by_revenue
    top_revenue_earners(@se.merchants.all.count)
  end

  def merchants_with_pending_invoices
    @se.merchants.all.find_all do |merchant|
      merchant.has_pending_invoices?
    end
  end

  def merchants_with_only_one_item_registered_in_month(month)
    merchants_with_only_one_item.find_all do |merchant|
      merchant.created_at.strftime('%B') == month
    end
  end

  def revenue_by_merchant(id)
    merchant = @se.merchants.find_by_id(id)
    merchant.revenue_for_merchant
  end

  def most_sold_item_for_merchant(merch_id)
    most_sold_item = Hash.new(0)
    merchant = @se.merchants.find_by_id(merch_id)

    merchant.succesful_invoices.map do |invoice|
      invoice.invoice_items.map do |invoice_item|
        most_sold_item[invoice_item.item_id] += invoice_item.quantity
      end
    end
    pass_most_sold_item(most_sold_item)
  end

  def best_item_for_merchant(merch_id)
    best_item = Hash.new(0)
    merchant = @se.merchants.find_by_id(merch_id)

    merchant.succesful_invoices.map do |invoice|
      invoice.invoice_items.map do |invoice_item|
        best_item[invoice_item.item_id] += invoice_item.unit_price*invoice_item.quantity
      end
    end
    find_best_item(best_item)
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

  def pass_most_sold_item(hash)
    most_sold_item_hash = hash.sort_by do |high_group|
      high_group[1]
    end
    best_items = most_sold_item_hash[-1]
    items = most_sold_item_hash.find_all do |item|
      item[1] == best_items[1]
    end
    get_most_sold_items(items)
  end

end
