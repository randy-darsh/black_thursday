module MathModule
  def average_item_price
    set = set_of_item_prices
    sum = sum_array(set_of_item_prices)
    sum / set.count
  end

  def average_items_per_merchant
    ((@se.items.all.count.to_f) / (@se.merchants.all.count.to_f)).round(2)
  end

  def average_average(values, average)
    values.reduce(0) do |val, num|
      val + ((num - average) ** 2)
    end
  end

  def standard_deviation(values)
    average = values.reduce(:+)/values.length.to_f
    Math.sqrt(average_average(values,average) / (values.length - 1)).round(2)
  end

  def average_items_per_merchant_standard_deviation
    set = set_of_merchant_items
    standard_deviation(set)
  end

  def find_all_merchants_above_standard_deviation(mean, standard_deviation)
    @se.merchants.all.find_all do |merchant|
      (merchant.items.count - mean) > standard_deviation
    end
  end

  def sum_of_prices(merchant)
    merchant.items.inject(0) do |sum, item|
      sum + item.unit_price_to_dollars
    end
  end

  def average_average_price_per_merchant
    sum = sum_array(total_averages)
    (sum / total_averages.count).round(2)
  end

  def sum_array(array)
    array.inject(0) do |sum, num|
      sum + num
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
    count = @day_count.values.reduce(0) { |sum, num| sum + (num - mean)**2}
    Math.sqrt(count / 6).round(2)
  end

  def calculate_invoice_percentage
    status = create_status
    status_hash = create_status_hash(status)
    sum = status_hash.values.inject(:+)
    status_hash.each_with_object(Hash.new(0)) do |(stat, num), hash|
      hash[stat] = num * 100.0 / sum
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

  def average_invoices_per_merchant_standard_deviation
    standard_deviation(set_of_merchant_invoices)
  end

  def find_merchants_above_standard_deviation(mean, standard_deviation)
    @se.merchants.all.find_all do |merchant|
      (merchant.invoices.count - mean) > standard_deviation
    end
  end

end
