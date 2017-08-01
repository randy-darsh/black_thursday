
class Merchant

  attr_reader :id,
              :name,
              :created_at

  def initialize(merch_data, merch_repo)
    @id         = merch_data[:id].to_i
    @name       = merch_data[:name]
    @merch_repo = merch_repo
    @created_at = Time.parse(merch_data[:created_at].to_s)
  end

  def items
    @merch_repo.sales_engine.items.find_all_by_merchant_id(@id)
  end

  def invoices
    @merch_repo.sales_engine.invoices.find_all_by_merchant_id(@id)
  end

  def customers
    invoices = @merch_repo.sales_engine.invoices.find_all_by_merchant_id(@id)
    customers = invoices.map do |invoice|
      @merch_repo.sales_engine.customers.find_by_id(invoice.customer_id)
    end
    customers.uniq
  end

  def succesful_invoices
    invoices.find_all do |invoice|
      invoice.is_paid_in_full? == true
    end
  end

  def has_pending_invoices?
    invoices.any? do |invoice|
      !invoice.is_paid_in_full?
    end
  end

  def revenue_for_merchant
    succesful_invoices.inject(0) do |sum, invoice|
      sum += invoice.total
    end
  end

  def one_invoice_per_month?(month)
    invoices_in_month = invoices.find_all do |invoice|
      invoice.created_at.strftime("%B") == month
    end

    if invoices_in_month.count == 1
      return true
    else
      false
    end
  end

  # transactions_per_invoice = invoices.map do |invoice|
  #   invoice.transactions
  # end
  #
  # transactions_per_invoice.map! do |transaction_per_invoice|
  #   transaction_per_invoice.each do |transaction|
  #     transaction_per_invoice.delete(transaction) if transaction.result == "success"
  #   end
  # end
  #
  # pending = transactions.any? do |transaction|
  #   transaction.result != "success"
  # end
  #
  # if pending == true
  #   return true
  # else
  #   false
  # end



end
