require 'rails_helper'

describe 'Shows worker logs', type: :feature do
  before { sign_in }

  let!(:worker) { create(:worker, hostname: 'rspec') }
  let(:job_definition) { create(:job_definition) }
  let!(:logs) { create_list(:worker_log, 3, job_definition: job_definition) }

  it 'shows list of worker logs' do
    visit kuroko2.workers_path

    expect(page).to have_content('Kuroko Workers')
    expect(page).to have_content('rspec')

    click_on 'rspec'

    expect(page).to have_content('Worker Logs')
    expect(page).to have_selector('#worker-logs table tbody tr', count: 3)
    expect(page).to have_content('rspec')
    expect(page).to have_content(job_definition.name)
  end

  it 'shows timeline of worker logs' do
    visit kuroko2.worker_logs_path(hostname: 'rspec')

    expect(page).to have_content('Worker Logs')
    expect(page).to have_content('Show Timeline')

    click_on 'Show Timeline'

    expect(page).to have_content('Worker Logs Timeline')
    expect(page).to have_content(job_definition.name)
  end
end
