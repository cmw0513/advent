class Helper
  def find_guard(events, index)
    previous_event = events[index - 1]
    return previous_event[:guard] if previous_event[:guard] > 0
    find_guard(events, index - 1)
  end
end

require "date"

events = File.read("example.txt").split("\n").sort

parsed_events = events.map do |event|
  datetime = event[0...18]
  guard = event.scan(/Guard #(\d+)/).flatten.join.to_i
  action = event[19..-1]

  {datetime: DateTime.parse(datetime), guard: guard, action: action}
end

guard_sleep_totals = {}

parsed_events.each_with_index do |event, index|
  next if event[:guard] > 0 || event[:action].include?("falls asleep")
  guard = Helper.new.find_guard(parsed_events, index)
  previous_event = parsed_events[index - 1]
  sleep_time = event[:datetime] - previous_event[:datetime]
  p event
  (previous_event[:datetime].strftime("%M").to_i..event[:datetime].strftime("%M").to_i).each do |min|
    p min
  end
  if guard_sleep_totals[guard] = guard_sleep_totals.dig(guard, :total) ? sleep_time : guard_sleep_totals[guard][:total] + sleep_time

end

p sleepiest_guard_id = guard_sleep_totals.max_by{|k, v| v[:total]}.first



