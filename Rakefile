#!/usr/bin/env rake
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'csv'
require 'excon'
require 'pry'
require 'yaml'
require 'active_support/all'

MINUTES_PLAYED = 17.0
THREE_POINT_AVERAGE = 0.4
TWO_POINT_AVERAGE = 0.5
FOUL_AVERAGE = 0.7

task default: %w[calc paste]
task :paste do
  `pbpaste > team.csv`
end

task :calc do
  data = CSV.parse(File.read('team.csv'), headers: true)
  top_players = data.select { |row| row['MP'].to_f >= MINUTES_PLAYED }
  shooters_2 = top_players.select { |row| row['FG%'].to_f >= TWO_POINT_AVERAGE || row['2P%'].to_f >= TWO_POINT_AVERAGE }
  shooters_3 = top_players.select { |row| row['3P%'].to_f >= THREE_POINT_AVERAGE }
  shooters_foul = top_players.select { |row| row['FT%'].to_f >= FOUL_AVERAGE }

  result = ((((top_players.count / 5.0) * 100).to_i +
  ((shooters_2.count / 5.0) * 100).to_i +
  ((shooters_3.count / 5.0) * 100).to_i +
  ((shooters_foul.count / 5.0) * 100).to_i) / 400.0) * 100


  puts "Score #{result.round}%"
  puts "Top players: #{top_players.count}"
  puts "2 point shooters: #{shooters_2.count}"
  puts "3 point shooters: #{shooters_3.count}"
  puts "foul shooters: #{shooters_foul.count}"
end

require './lib/march_madness/client'
require './lib/march_madness/config'
require './lib/march_madness/response'
require './lib/march_madness/sports_radar'

# task :games do
#   index = 0
#   MarchMadness::SportsRadar.new.todays_games.each do |game|
#     index += 1
#     tags = []
#     tags << '[NEUTRAL]' if game['neutral_site']
#     channel = game['broadcast']
#     tags << "[#{channel['network']}]" if channel.present?
#     puts "#{game['away']['name']} - #{game['away']['id']}"
#     puts "#{game['home']['name']} - #{game['home']['id']}"
#     puts "Game #{index} - #{game['scheduled'].to_time.strftime("%l:%M%p")} - #{tags.join(' ')} " + ('*' * 30)
#   end
# end

def average(value)
  ('%.3f' % value)[1..-1]
end

def injury_report(team)
  puts "#{team['market']} #{team['name']}"
  print 'Any injuries? [y/n]'
  response = $stdin.gets.chomp
  system('clear')
  players = top_players(team)
  if response.downcase == 'y'
    players.reject! do |player|
      puts "#{team['market']} #{team['name']}"
      print "#{player['full_name']} [y/n]"
      response = $stdin.gets.chomp
      system('clear')
      response.downcase == 'y'
    end
  end
  players
end

def top_players(team)
  team['players'].select { |player| player['average']['minutes'].to_f >= MINUTES_PLAYED }
end

def todays_games
  @todays_games ||= gateway.todays_games['games']
end

def gateway
  @gateway ||= MarchMadness::SportsRadar.new
end

def generate_report(players)
  shooters_2 = players.select { |player| player['total']['field_goals_pct'] >= TWO_POINT_AVERAGE || player['total']['two_points_pct'] >= TWO_POINT_AVERAGE }
  shooters_3 = players.select { |player| player['total']['three_points_pct'].to_f >= THREE_POINT_AVERAGE }
  shooters_foul = players.select { |player| player['total']['free_throws_pct'].to_f >= FOUL_AVERAGE }
  result = ((((players.count / 5.0) * 100).to_i +
    ((shooters_2.count / 5.0) * 100).to_i +
    ((shooters_3.count / 5.0) * 100).to_i +
    ((shooters_foul.count / 5.0) * 100).to_i) / 400.0) * 100

  puts "Score #{result.round}%"
  puts "Top players: #{players.count}"
  puts "2 point shooters: #{shooters_2.count}"
  puts "3 point shooters: #{shooters_3.count}"
  puts "foul shooters: #{shooters_foul.count}"
end

task :games do
  system('clear')
  todays_games.each_with_index do |game, index|
    puts game['away']['name']
    puts game['home']['name']
    print "Game #{index + 1}/#{todays_games.count} @ #{game['scheduled'].to_time.strftime("%l:%M%p")} [y/n]"
    response = $stdin.gets.chomp
    system('clear')
    if response.downcase == 'y'
      teams = %w[away home].map do |side|
        team = gateway.seasonal_statistics(game[side]['id'])
        {
          name: "#{team['market']} #{team['name']}",
          players: injury_report(team)
        }
      end

      teams.each do |team|
        puts team[:name]
        generate_report(team[:players])
        puts '*' * 30
      end

      print 'Press any key to continue'
      $stdin.gets.chomp
      system('clear')
    end
  end
end

task :test do
  team_id = '7d797407-623e-476d-b299-46de4275414d'
  gateway = MarchMadness::SportsRadar.new
  team = gateway.seasonal_statistics(team_id)
  binding.pry


end