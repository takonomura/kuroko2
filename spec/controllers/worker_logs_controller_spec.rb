require 'rails_helper'

describe Kuroko2::WorkerLogsController do
  routes { Kuroko2::Engine.routes }

  before { sign_in }

  let!(:logs) { create_list(:worker_log, 3) }

  describe '#index' do
    subject! { get :index }

    it do
      expect(response).to have_http_status(:ok)
      expect(response).to render_template('index')

      expect(assigns(:logs)).to match_array logs
    end

    context 'with valid hostname' do
      subject! { get :index, params: { hostname: 'rspec' } }

      it do
        expect(assigns(:logs)).to match_array logs
      end
    end

    context 'with unknown hostname' do
      subject! { get :index, params: { hostname: 'unknown' } }

      it do
        expect(assigns(:logs)).to be_empty
      end
    end
  end

  describe '#timeline' do
    subject! { get :timeline }

    it do
      expect(response).to have_http_status(:ok)
      expect(response).to render_template('timeline')
    end
  end

  describe '#dataset' do
    subject! { get :dataset, xhr: true }

    it do
      expect(response).to have_http_status(:ok)

      expect(assigns(:logs)).to match_array logs
      expect(assigns(:end_at)).not_to be_nil
      expect(assigns(:start_at)).to eq assigns(:end_at) - 1.hour
    end

    context 'with valid hostname' do
      subject! { get :dataset, xhr: true, params: { hostname: 'rspec' } }

      it do
        expect(assigns(:logs)).to match_array logs
      end
    end

    context 'with unknown hostname' do
      subject! { get :dataset, xhr: true, params: { hostname: 'unknown' } }

      it do
        expect(assigns(:logs)).to be_empty
      end
    end

    context 'with period' do
      subject! { get :dataset, xhr: true, params: { period: period }}

      context '30 minutes' do
        let(:period) { '30m' }
        it do
          expect(assigns(:logs)).to match_array logs
          expect(assigns(:start_at)).to eq assigns(:end_at) - 30.minutes
        end
      end
      context '1 hour' do
        let(:period) { '1h' }
        it do
          expect(assigns(:logs)).to match_array logs
          expect(assigns(:start_at)).to eq assigns(:end_at) - 1.hour
        end
      end

      context '1 day' do
        let(:period) { '1d' }
        it do
          expect(assigns(:logs)).to match_array logs
          expect(assigns(:start_at)).to eq assigns(:end_at) - 1.day
        end
      end

      context '1 week' do
        let(:period) { '1w' }
        it do
          expect(assigns(:logs)).to match_array logs
          expect(assigns(:start_at)).to eq assigns(:end_at) - 1.week
        end
      end
    end

    context 'with end_at' do
      let(:end_at) { Time.current + 5.minute }
      subject! { get :dataset, xhr: true, params: { end_at: end_at } }

      it do
        expect(assigns(:logs)).to match_array logs
        expect(assigns(:end_at).strftime("%d-%m-%Y %H:%M:%S")).to eq end_at.strftime("%d-%m-%Y %H:%M:%S")
      end
    end

    context 'with start_at' do
      let(:start_at) { 1.hour.ago(Time.current) }
      subject! { get :dataset, xhr: true, params: { start_at: start_at } }

      it do
        expect(assigns(:logs)).to match_array logs
        expect(assigns(:start_at).strftime("%d-%m-%Y %H:%M:%S")).to eq start_at.strftime("%d-%m-%Y %H:%M:%S")
      end
    end
  end
end
