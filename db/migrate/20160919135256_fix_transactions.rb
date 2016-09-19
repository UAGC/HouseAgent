class FixTransactions < ActiveRecord::Migration[5.0]
  def change
    change_table  :transactions do |t|
      t.rename :occ_date, :trx_date
  end
  end
end
