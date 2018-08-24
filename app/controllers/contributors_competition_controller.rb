# frozen_string_literal: true

require 'zip'

class ContributorsCompetitionController < ActionController::Base
  before_action :fetch_repository, only: :show
  before_action :prepare_certificate_data, only: :download_certificate
  before_action :prepare_certificates_data, only: :download_all_certificates

  def show
    nil_redirector(@repository) { @winners = winners(repository: @repository) }
  end

  def download_certificate
    nil_redirector(@winner) do
      respond_to do |format|
        format.html do
          pdf = generate_pdf(winner: @winner)
          send_data pdf.render, type: 'application/pdf', disposition: 'inline'
        end
      end
    end
  end

  def download_all_certificates
    nil_redirector(@winners) do
      respond_to do |format|
        format.html do
          archive = create_archive(winners: @winners)
          send_data archive.sysread, filename: 'certificates.zip', type: 'application/zip'
        end
      end
    end
  end

  private

  def nil_redirector(variable)
    if variable
      yield
    else
      redirect_back(fallback_location: root_path,
                    flash: { error: 'Something went wrong' })
    end
  end

  def create_archive(winners:)
    zipped_prints =
      ::Zip::OutputStream.write_buffer do |zos|
        winners.each do |winner|
          zos.put_next_entry("#{winner[:login]}.pdf")
          zos.write generate_pdf(winner: winner).render
        end
      end
    zipped_prints.rewind
    zipped_prints
  end

  def fetch_repository
    @repository = params.fetch(:repo, '')
  end

  # Yes, I'm understand that this two functions are very similar.
  # Certificates must be rendered from data cached on the server,
  # not from params.
  def prepare_certificate_data
    @winner =
      params.permit(winner: %i[login contributions place]).to_h[:winner]
  end

  def prepare_certificates_data
    @winners =
      params.permit(winners: %i[login contributions place]).to_h[:winners]
  end

  def generate_pdf(winner:)
    CertificatePdf.new(winner: winner)
  end

  def top_contributors(repository:)
    GithubClient.get_contributors(repository: repository)&.first(3)
  end

  def winners(repository:)
    if (contributors = top_contributors(repository: repository))
      contributors.each_with_index.map do |contributor, index|
        {
          login: contributor['login'],
          contributions: contributor['contributions'],
          place: index + 1
        }
      end
    end
  end
end
