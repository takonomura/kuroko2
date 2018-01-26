class Kuroko2::WorkerLogsController < Kuroko2::ApplicationController
  def index
    @logs = Kuroko2::WorkerLog.ordered.includes(:job_definition, :job_instance)

    hostname = params[:hostname]
    @logs = @logs.where(hostname: hostname) if hostname.present?

    @logs = @logs.page(params[:page])
  end
end
