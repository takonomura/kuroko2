json.start @start_at.strftime('%Y-%m-%d %H:%M:%S')
json.end   @end_at.strftime('%Y-%m-%d %H:%M:%S')
json.data do
  json.array! @logs do |log|
    json.id log.id
    json.content "<a href='#{job_definition_job_instance_path(log.job_definition, log.job_instance)}'>##{log.job_definition.id} #{h(log.job_definition.name)}</a>"
    json.start log.created_at.strftime('%Y-%m-%d %H:%M:%S')
    json.end (log.finished_at || Time.current).try!(:strftime, '%Y-%m-%d %H:%M:%S')
  end
end
