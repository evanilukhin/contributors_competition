# frozen_string_literal: true

module ContributorsCompetition
  module GithubApi
    # Provide github api
    class Production
      class << self

        # return ordered array of contributors
        # return nil for other cases
        def get_contributors(repository:)
          response = RestClient.get prepare_url(repository)
          JSON.parse(response.body)
        rescue RestClient::ExceptionWithResponse => _e
          nil # Handling response with code not in [200, 207, 301, 302, 303, 307]
        end

        private

        # request return ordered(from the best contributor) list of contributors
        def prepare_url(repository)
          "https://api.github.com/repos/#{repository}/contributors"
        end
      end
    end
  end
end
