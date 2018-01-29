old_logs = Kuroko2::WorkerLog.where('finished_at < ?', 3.months.ago)

count = old_logs.count

Kuroko2::WorkerLog.transaction do
  old_logs.destroy_all
end

puts "Destroyed #{count} worker logs"
