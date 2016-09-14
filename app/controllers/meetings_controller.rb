# TO ADAPT TO NESTED FORM
class MeetingsController < ApplicationController
  require 'icalendar'

  def index
    @meetings = current_user.meetings.to_come
  end

  def create
    @meeting = Meeting.new(meeting_params)
    @attendees_params.each {|user_id| @meeting.attendees.build(user_id: user_id)}
    @meeting.state = 'pending'
    deduce_hours
    @meeting.save
  end

  def update
    # TO DO create notif
    @meeting = Meeting.find(params[:id])
    @meeting.start_time == "#{meeting_params[:date]} #{meeting_params[:time]}".to_datetime ? state = 'confirmed' : state = 'pending'
    deduce_hours
    @meeting.state = state
    @meeting.save
  end

  # def ics_export
  #   @timetables = Timetable.where(user: current_user, festival_id: params[:festival])
  #   respond_to do |format|
  #     format.html
  #     format.ics do
  #       cal = Icalendar::Calendar.new
  #       filename = "Your festival calendar"
  #       @timetables.each do |timetable|
  #         timetable.events.each do |event|
  #           performance = Icalendar::Event.new
  #           performance.dtstart = event.concert.start_time
  #           performance.dtend = event.concert.end_time
  #           performance.summary = "#{event.timetable.festival.name} : #{event.concert.artist.name}"
  #           performance.location = event.concert.stage
  #           cal.add_event(performance)
  #         end
  #       end
  #       cal.publish
  #       render :text =>  cal.to_ical
  #       # send_data cal.to_ical, type: 'text/calendar', disposition: 'attachment', filename: filename
  #     end
  #   end
  # end

  private

  def meeting_params
    meeting_params = params.require(:meeting).permit(:date, :time, :duration, :project_id, :object,
                                    :live, attendee_ids: []
                                   )
    @attendees_params = meeting_params[:attendee_ids].collect {|x|  x == '' ? current_user.id : x}
    meeting_params.delete(:attendee_ids)
    return meeting_params
  end

  def deduce_hours
    return nil if meeting_params[:date].empty? || meeting_params[:time].empty?
    duration = meeting_params[:duration] || 30
    @meeting.date = meeting_params[:date]
    @meeting.time = meeting_params[:time]
    @meeting.start_time = "#{@meeting.date} #{@meeting.time}".to_datetime
    @meeting.end_time = @meeting.start_time + duration.to_i.minutes
    @ref_date = @meeting.date
    @ref_time = @meeting.time
  end
end


