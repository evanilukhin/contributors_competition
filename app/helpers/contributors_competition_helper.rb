# frozen_string_literal: true

module ContributorsCompetitionHelper
  def link_to_download_certificate(repository:, place:)
    link_to('download pdf',
            download_certificate_path(params: { repository: repository, place: place }))
  end

  def link_to_download_all_certificates(repository:)
    link_to('download all',
            download_all_certificates_path(params: { repository: repository }))
  end
end
