class CreateWorkerLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :worker_logs do |t|
      t.string :hostname, limit: 180, null: false
      t.integer :worker_id, limit: 1, null: false
      t.string :queue, limit: 180, null: false
      t.integer :job_definition_id, null: false
      t.integer :job_instance_id, null: false
      t.text :shell, null: false
      t.datetime :finished_at

      t.timestamps
    end

    add_index "worker_logs", ["hostname", "created_at"], using: :btree
  end
end
