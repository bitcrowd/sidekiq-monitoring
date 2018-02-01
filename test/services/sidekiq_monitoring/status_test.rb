require 'test_helper'

module SidekiqMonitoring
  class StatusTest < ActiveSupport::TestCase
    include ActiveJob::TestHelper

    setup do
      Timecop.freeze(Date.new(2018, 1, 22))
    end

    teardown do
      Timecop.return
    end

    test 'writes timestamp to redis and schedules job' do
      assert_enqueued_with(job: RefreshStatusJob) do
        connection = Minitest::Mock.new
        connection.expect(:set, true, ['monitoring:timestamp:whenever_ran', '2018-01-22 00:00:00'])
        SidekiqMonitoring.stub(:redis, connection) do
          Status.refresh
        end
      end
    end
  end
end
