class TransactionController < ApplicationController
  before_action { @today=(Time.now.utc+60*60*8).to_date.to_s }

  def stx
    @all=Transaction.where(trx_type: 'stx_new')+
        Transaction.where(trx_type: 'stx_second')+
        Transaction.where(trx_type: 'stx_city_new')+
        Transaction.where(trx_type: 'stx_city_second')+
        Transaction.where(trx_type: 'stx_city_all')
    @txs=@all.sort_by(&:trx_date).reverse!
  end

  def chart
    @all= Transaction.where(trx_type: 'stx_city_new')+
        Transaction.where(trx_type: 'stx_city_second')+
        Transaction.where(trx_type: 'stx_city_all')
    @all= @all.sort_by(&:trx_date).reverse[0..21]
    @labels=@all.map(&:trx_date).uniq.sort.map(&:to_s)
    @rsecond=@all.select { |tx| tx.trx_type == 'stx_city_second' }.sort_by(&:trx_date).map(&:rcount)
    @rnew=@all.select { |tx| tx.trx_type == 'stx_city_new' }.sort_by(&:trx_date).map(&:rcount)
  end

  def news
    @txs=Transaction.where(trx_date: @today, trx_type: 'new')+
        Transaction.where(trx_date: @today, trx_type: 'second')
  end

end
