class TransactionController < ApplicationController
  def initialize
    @listener = HouseListener.new
  end

  def home
  all= Transaction.all
  info ="#{all.length} items \n\n"
  render :text =>info+all.to_json
  end

  def update
    @listener.compute_transactions
    render :text => 'UPDATED'
  end
end
