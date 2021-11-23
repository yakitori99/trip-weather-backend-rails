class DatetimesController < ApplicationController
  # today-1 ~ +7のdatetimeをstrにしたデータを返す
  def get_datetimes
    time_now = Time.zone.now
    datetimes = []
    for i in -1..7
      datetimes.push((time_now + i.days).strftime("%Y/%m/%d %H:%M:%S"))
    end
    render json: datetimes
  end

end
