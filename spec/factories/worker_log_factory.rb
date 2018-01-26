FactoryGirl.define do
  factory :worker_log, class: Kuroko2::WorkerLog do
    hostname 'rspec'
    worker_id 1
    queue '@default'

    job_definition { create(:job_definition) }
    job_instance { create(:job_instance, job_definition: job_definition) }

    shell 'echo $NAME'

    finished_at { Time.current }
  end
end
