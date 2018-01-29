class Kuroko2::WorkerLogsController < Kuroko2::ApplicationController
  def index
    logs = Kuroko2::WorkerLog.ordered.includes(:job_definition, :job_instance)

    hostname = params[:hostname]
    logs = logs.where(hostname: hostname) if hostname.present?

    @logs = logs.page(params[:page])
  end

  def timeline
  end

  def dataset
    logs = Kuroko2::WorkerLog.ordered.includes(:job_definition, :job_instance)

    hostname = params[:hostname]
    logs = logs.where(hostname: hostname) if hostname.present?

    set_period
    @logs = logs.where('created_at < ?', @end_at).where('finished_at > ? OR finished_at IS NULL', @start_at)
  end

  private

  def set_period
    @end_at = begin params[:end_at].to_datetime rescue Time.current end

    @start_at = begin params[:start_at].to_datetime rescue
      case params[:period]
      when /\A(\d+)m\z/
        $1.to_i.minutes.ago(@end_at)
      when /\A(\d+)h\z/
        $1.to_i.hours.ago(@end_at)
      when /\A(\d+)d\z/
        $1.to_i.days.ago(@end_at)
      when /\A(\d+)w\z/
        $1.to_i.weeks.ago(@end_at)
      else
        1.hour.ago(@end_at)
      end
    end
  end
end
