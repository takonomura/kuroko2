class Kuroko2::WorkerLog < Kuroko2::ApplicationRecord
  include Kuroko2::TableNameCustomizable

  belongs_to :job_definition
  belongs_to :job_instance

  scope :ordered, -> { order(created_at: :desc) }
end
