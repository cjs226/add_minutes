#!/usr/bin/env ruby

def expected_arguments
  puts "ERROR: expecting timestamp ([H]H:MM {AM|PM}) and (added minutes)"
  puts "For example: 9:13 AM 200"
  exit 1
end

if ARGV.length < 2
  expected_arguments
end

def add_minutes(old_time,added_minutes,debug)

  puts "Current timestamp: #{ARGV[0]}" if debug
  puts "Added minutes: #{ARGV[1]}" if debug

  # We'll use minutes as our common denominator

  # Calculate the number of minutes of the hour of the timestamp
  begin
    old_hour = old_time.split(':')[0]
    old_hour = Integer("#{old_hour}")
    # Account for 12AM as we want to treat that as 00
    if old_hour == 12 and old_period.upcase == 'AM'
      ttl_minutes = 0
    else
      ttl_minutes = old_hour * 60
    end
  rescue
    puts "ERROR: timestamp hour and/or period appears to be invalid"
    expected_arguments
    exit 1
  end

  # If the period is 'PM', add in the minutes from the 'AM' period, unless it's
  # 12PM
  old_period = old_time.split(' ')[1].upcase
  if old_period == 'PM'
    if old_hour < 12
      ttl_minutes = ttl_minutes + 720
    elsif old_hour > 12
      puts "ERROR: timestamp hour and period combination appears to be invalid"
      expected_arguments
    end
  elsif old_period != 'AM'
    puts "ERROR: timestamp period appears to be invalid"
    expected_arguments
  end
  puts "Total minutes from hours: #{ttl_minutes}" if debug

  # Add in the minutes of the timestamp
  begin
    old_minute = old_time.split(':')[1].split(' ')[0]
    old_minute = Integer("#{old_minute}")
    ttl_minutes = ttl_minutes + old_minute
  rescue
    puts "ERROR: timestamp minute appears to be invalid"
    expected_arguments
  end
  puts "Total minutes from hours and minutes: #{ttl_minutes}" if debug

  # Add in the minutes from the added minutes
  begin
    added_minutes = Integer("#{added_minutes}")
    ttl_minutes = ttl_minutes + added_minutes
  rescue
    puts "ERROR: added_minutes appears to be invalid"
    expected_arguments
  end
  puts "Total minutes from hours, minutes and added_minutes: #{ttl_minutes}" if debug

  # Using our total minutes calcuated above, determine the number of hours
  # and remaining minutes
  time_divided = ttl_minutes.divmod(60)
  ttl_hours = time_divided[0]
  new_minute = time_divided[1]
  puts "Total hours: #{ttl_hours} and remaining minutes: #{new_minute}" if debug

  # Determine the new hour, in 24hr format
  # If ttl_hours is greater than 24, divide 'em by 24 and the remainder will be
  # our new 'hour'
  new_hour = ttl_hours > 24 ? ttl_hours.divmod(24)[1] : ttl_hours

  # Determine the new period, and if necessary convert new_hour to 12hr format
  if new_hour <= 11
    # Hour format is fine, assign the period
    new_period = 'AM'
  elsif new_hour == 12
    # Hour format is fine, assign the period
    new_period = 'PM'
  elsif new_hour <= 23
    # Convert the hour to 12hr format and assign the period
    new_hour = new_hour - 12
    new_period = 'PM'
  elsif new_hour == 24
    # Convert the hour to 12hr format and assign the period
    new_hour = 12
    new_period = 'AM'
  else
    puts "ERROR: Unable to determine new hour and/or period"
    exit 1
  end

  # Pad 'new_minute' if the value is a single number
  new_minute = new_minute.to_s.rjust(2, "0")

  puts "#{new_hour}:#{new_minute} #{new_period}"
end

debug = ARGV[2] == 'debug' ? true : false

add_minutes ARGV[0], ARGV[1], debug
