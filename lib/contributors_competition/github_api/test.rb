# frozen_string_literal: true

module ContributorsCompetition
  module GithubApi
    class Test
      def self.get_contributors(repository:)
        case repository
        when 'rep/three_contributors'
          three_contributors
        when 'rep/one_contributor'
          three_contributors
        when 'not_existed/repository'
          nil
        end
      end

      private

      def one_contributor
        [{ login: 'ivan1', contributions: 3 }]
      end

      def three_contributors
        [{ login: 'ivan1', contributions: 4 },
         { login: 'ivan2', contributions: 3 },
         { login: 'ivan3', contributions: 2 }]
      end
    end
  end
end
