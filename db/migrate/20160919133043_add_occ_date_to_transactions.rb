class AddOccDateToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :occ_date, :date
  end
end
