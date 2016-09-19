class TransactionController < ApplicationController
  def initialize
    @listener = HouseListener.new
    @count = 0
  end

  def home
    @listener.compute_transactions
    all= Transaction.all
    info ="#{all.length} items ------\\n\n"
    render :text =>info+show(all)
  end

  private 
  def show(txs)
    txs.map{|i| [i.trx_date,i.district,i.total_area, i.rcount, i.resident_area].join("  \t\t  ")}.join("  \n  --  \\n ||||||||||||||||||| ")
  end

end
