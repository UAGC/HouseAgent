class Transaction < ApplicationRecord
  # Returns this - tx, tx starts with "stx_"
  def separate(tx)
    return 'no same district' unless tx.district == district
    return 'no same date' unless tx.trx_date == trx_date
    return 'no same type' unless tx.trx_type.match(trx_type)
    return 'no area increased' if tx.total_area == total_area
    dta = total_area - tx.total_area
    dra = resident_area - tx.resident_area
    drc = rcount - tx.rcount
    type = (dta * dra * drc < 0 ? '_ERROR_' : '') + trx_type
    Transaction.new(district: district, total_area: dta, rcount: drc, resident_area: dra, trx_date: trx_date, trx_type: type)
  end
end
