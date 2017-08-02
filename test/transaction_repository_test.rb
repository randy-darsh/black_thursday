require 'simplecov'
SimpleCov.start
require_relative '../lib/transaction_repository'
require 'minitest/autorun'
require 'minitest/emoji'
require_relative '../lib/sales_engine'
require 'csv'
require 'pry'
require 'bigdecimal'

class TransactionRepositoryTest < Minitest::Test
  def setup
    @se = SalesEngine.from_csv({
              :items => "./data/items.csv",
              :merchants => "./data/merchants.csv",
              :invoice_items => "./data/invoice_items.csv",
              :invoices => "./data/invoices.csv",
              :transactions => "./data/transactions.csv",
              :customers => "./data/customers.csv"
            })
    @tr = @se.transactions
  end

  def test_it_exists
    assert_instance_of TransactionRepository, @tr
  end

  def test_all_returns_array_of_all_transactions
    assert_instance_of Array, @tr.all
    assert_equal 4985, @tr.all.count
  end

  def find_by_id
    assert_instance_of Transaction, @tr.find_by_id(6)
  end

  def test_find_all_by_invoice_id
    assert_instance_of Array, @tr.find_all_by_invoice_id(2179)
    assert_equal 2, @tr.find_all_by_invoice_id(2179).count
    assert_equal 1, @tr.find_all_by_invoice_id(2179).first.id
  end

  def test_find_all_by_credit_card_number
    assert_instance_of Array, @tr.find_all_by_credit_card_number(4177816490204479)
    assert_equal 1, @tr.find_all_by_credit_card_number(4177816490204479).count
    assert_equal 2, @tr.find_all_by_credit_card_number(4177816490204479).first.id
  end

  def test_find_all_by_result
    assert_instance_of Array, @tr.find_all_by_result("success")
    assert_equal 4158, @tr.find_all_by_result("success").count
    assert_equal 1, @tr.find_all_by_result("success").first.id
  end

  def test_find_all_unsuccessful_transactions
    assert_instance_of Transaction, find_all_unsuccessful_transaction[0]
    assert_equal 32, @tr.find_all_unsuccessful_transaction.count
  end

end
