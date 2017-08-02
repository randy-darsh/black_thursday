module InvoiceAnalysis
  def average_invoice_count
    set = set_of_merchant_invoices
    total_merchant_count = @se.merchants.all.count
    set.count / total_merchant_count
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
    days = find_days(mean)
    days.select.with_index do |item, index|
     index.even?
    end
  end

  def invoice_dates
    @se.invoices.all.map do |invoice|
      invoice.created_at.strftime("%A")
    end
  end

  def invoice_status(status)
    calculate_invoice_percentage[status].round(2)
  end

  def invoices_by_date(date)
    invoices_by_date = []
    @se.invoices.all.each do |invoice|
      if invoice.created_at.strftime("%x") == date.strftime("%x")
        invoices_by_date << invoice
      end
    end
    invoices_by_date
  end

  def sorted_invoices(invoices)
    invoices.sort_by do |merchant, total_revenue|
      total_revenue.to_f
    end.reverse!
  end

  def iterate_through_successful_invoices(merchant, most_sold_item)
    merchant.succesful_invoices.map do |invoice|
      add_to_most_sold_item_hash(invoice, most_sold_item)
    end
  end

  def iterate_through_invoices_for_best_item(merchant, best_item)
    merchant.succesful_invoices.map do |invoice|
      add_to_best_item_hash(invoice, best_item)
    end
  end

  def create_invoices_hash
    invoices = {}
    @se.merchants.all.map do |merchant|
      invoices[merchant] = merchant.revenue_for_merchant
    end
    invoices
  end
end
