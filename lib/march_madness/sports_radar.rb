module MarchMadness
  class SportsRadar
    def initialize
      @config = Config.new('config.yml', 'sports_radar')
    end

    def todays_games
      today = Time.current.in_time_zone('Eastern Time (US & Canada)')
      date_format = "#{today.year}/#{today.month}/#{today.day}"
      Response.new(
        request("ncaamb/trial/v7/en/games/#{date_format}/schedule.json")
      )
    end

    def seasonal_statistics(team_id)
      sleep(1.1) # trial api limits
      year = '2019'
      season = 'REG' # Conference Tournament (CT), Regular Season (REG), or Postseason (PST).
      Response.new(
        request("ncaamb/trial/v7/en/seasons/#{year}/#{season}/teams/#{team_id}/statistics.json")
      )
    end

    def game_summary(game_id)
      sleep(1.1) # trial api limits
      Response.new(
        request("ncaamb/trial/v7/en/games/#{game_id}/summary.json")
      )
    end

    private

    def request(path, overrides = {})
      client.get({
        path: URI.encode(path),
        query: { api_key: @config.api_key }
      }.merge(overrides))
    end

    def client
      @client ||= Client.new(@config)
    end
  end
end
