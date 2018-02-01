require 'test_helper'

module SidekiqMonitoring
  class RefreshStatusJobTest < ActiveJob::TestCase
    setup do
      Timecop.freeze(Date.new(2018, 1, 22))
    end

    teardown do
      Timecop.return
    end

    test 'job sets timestamp in redis' do
      fakeredis = Redis.new
      assert_nil fakeredis.get('monitoring:timestamp:sidekiq_performed')

      Sidekiq.stub(:redis, {}, fakeredis) do
        RefreshStatusJob.perform_now
      end

      assert_equal '2018-01-22 00:00:00', fakeredis.get('monitoring:timestamp:sidekiq_performed')
    end
  end
end
