require 'pry'

# num_teams = 2
# middle_bets = 5
# bottom_bets = 4
# max_occurrences = 2
# middle_occurrences = 1
# bottom_occurrences = 1

num_teams = 2
middle_bets = 5
bottom_bets = 3
max_occurrences = 3
middle_occurrences = 2
bottom_occurrences = 1

# num_teams = 4
# middle_bets = 4
# bottom_bets = 3
# max_occurrences = 2
# middle_occurrences = 1
# bottom_occurrences = 1

picks = %i[
villanova
lsu
illinois
mississippi_state
kentucky
baylor

]

top_picks = picks[0..1]
middle_picks = picks[2..3]
bottom_picks = picks[4..5]

pick_occurrences = (top_picks.count * max_occurrences) +
                   (middle_picks.count * middle_occurrences) +
                   (bottom_picks.count * bottom_occurrences)

puts "Max bets: #{(pick_occurrences / num_teams).to_i}"

# @return [Array<Symbol>]
def select_matches(parlay, picks)
  parlay.select do |team|
    picks.include? team
  end
end

# @param [Array<Symbol>] parlay
# @param [Array<Array<Symbol>>] bets
# @return [Array<Integer>]
def count_occurrences(parlay, bets)
  parlay.map do |team|
    bets.count { |bet| bet.include? team }
  end
end

record = {
  middles: 0,
  bottoms: 0,
  bets: []
}

picks.combination(num_teams).to_a.shuffle.each do |parlay|
  middle_matches = select_matches(parlay, middle_picks)
  bottom_matches = select_matches(parlay, bottom_picks)

  # Filter out parlays
  next if (record[:middles] + middle_matches.count) > middle_bets
  next if (record[:bottoms] + bottom_matches.count) > bottom_bets

  #next if record[:bets].count > total_bets
  next if count_occurrences(middle_matches, record[:bets]).any? { |count| count >= middle_occurrences }
  next if count_occurrences(bottom_matches, record[:bets]).any? { |count| count >= bottom_occurrences }
  next if count_occurrences(parlay, record[:bets]).any? { |count| count >= max_occurrences }

  # Select this parlay
  record[:middles] += middle_matches.count
  record[:bottoms] += bottom_matches.count
  record[:bets] << parlay
end

pp record[:bets]
