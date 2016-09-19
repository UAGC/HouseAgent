class Transaction < ApplicationRecord
  # result = this - tx
  def diff(tx)
    return unless tx.district == @district && @trx_date == tx.trx_date && tx.trx_type==@trx_type
    t_area=@total_area - tx.total_area
    r_area=@resident_area - tx.resident_area
    rc=@rcount-tx.rcount
    m=t_area * r_area * rcount
    return if m==0
    type=( m <0 ? '_ERROR_' : '')+@trx_type
    Transaction.new(district: @district, total_area: t_area, rcount: rc, resident_area: r_area, trx_date: @trx_date, trx_type: type)
  end
end
