module MerchantAnalysis

  def best_item_for_merchant(merch_id)
    best_item = Hash.new(0)
    merchant = @se.merchants.find_by_id(merch_id)
    iterate_through_invoices_for_best_item(merchant, best_item)
    find_best_item(best_item)
  end

  def most_sold_item_for_merchant(merch_id)
    most_sold_item = Hash.new(0)
    merchant = @se.merchants.find_by_id(merch_id)
    iterate_through_successful_invoices(merchant, most_sold_item)
    pass_most_sold_item(most_sold_item)
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

  def merchants_ranked_by_revenue
    top_revenue_earners(@se.merchants.all.count)
  end

  def merchants_with_pending_invoices
    @se.merchants.all.find_all do |merchant|
      merchant.has_pending_invoices?
    end
  end

  def merchants_with_only_one_item
    @se.merchants.all.find_all do |merchant|
      merchant.items.count == 1
    end
  end

  def bottom_merchants_by_invoice_count
    standard_deviation = (average_invoices_per_merchant_standard_deviation * 2)
    mean = average_invoices_per_merchant
    find_merchants_below_standard_deviation(mean, standard_deviation)
  end

  def find_merchants_below_standard_deviation(mean, standard_deviation)
    @se.merchants.all.find_all do |merchant|
      (mean - merchant.invoices.count) > standard_deviation
    end
  end

  def top_merchants_by_invoice_count
    standard_deviation = (average_invoices_per_merchant_standard_deviation * 2)
    mean = average_invoices_per_merchant
    find_merchants_above_standard_deviation(mean, standard_deviation)
  end

  def set_of_merchant_invoices
    set = []
    @se.merchants.all.map do |merchant|
      set << merchant.invoices.count
    end
    set
  end

  def merchants_with_high_item_count
    standard_deviation = (average_items_per_merchant_standard_deviation)
    mean = average_items_per_merchant
    find_all_merchants_above_standard_deviation(mean, standard_deviation)
  end

  def average_item_price_for_merchant(merch_id)
    merchant = @se.merchants.find_by_id(merch_id)
    num_of_items = merchant.items.count
    return nil if num_of_items == 0
    (sum_of_prices(merchant)/num_of_items).round(2)
  end

  def all_merchant_ids
    @se.merchants.all.map do |merchant|
      merchant.id
    end
  end

  def set_of_merchant_items
    set = []
    @se.merchants.all.map do |merchant|
      set << merchant.items.count
    end
    set
  end

end
