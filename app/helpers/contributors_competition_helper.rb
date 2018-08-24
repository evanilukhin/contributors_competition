# frozen_string_literal: true

module ContributorsCompetitionHelper
  def link_to_download_certificate(winner)
    link_to('download pdf',
            download_certificate_path(params: { winner: winner }))
  end

  def link_to_download_all_certificates(winners)
    link_to('download all',
            download_all_certificates_path(params: { winners: winners }))
  end
end
