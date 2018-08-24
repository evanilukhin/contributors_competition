# frozen_string_literal: true

module ContributorsCompetition
  module GithubApi
    class Test
      def self.get_contributors(repository:)
        case repository
        when 'rep/three_contributors'
          three_contributors
        end
      end

      private

      def three_contributors
        [{ login: 'ivan1', contributions: 3 },
         { login: 'ivan2', contributions: 3 },
         { login: 'ivan3', contributions: 3 }]
      end
    end
  end
end
