# frozen_string_literal: true

require 'zip'

class ContributorsCompetitionController < ActionController::Base
  before_action :fetch_repository, except: :search
  before_action :prepare_winner_data, only: :download_certificate
  before_action :prepare_winners_data, only: %i[show download_all_certificates]

  def search; end

  def show
    nil_redirector(@winners) do
      @winners
    end
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
      redirect_back(fallback_location: results_path,
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
    @repository = params.fetch(:repository)
  end

  def prepare_winner_data
    place = params.fetch(:place)&.to_i
    @winner =
      if @repository.present? && place.present?
        top = top_contributors(repository: @repository)
        contributor = top.present? ? top[place] : nil
        if contributor
          certificate_data(
            contributor: contributor,
            place: place
          )
        end
      end
  end

  def certificate_data(contributor:, place:)
    {
      login: contributor['login'],
      contributions: contributor['contributions'],
      place: place,
      repository: @repository
    }
  end

  def prepare_winners_data
    @winners =
      if @repository.present?
        top_contributors = top_contributors(repository: @repository)
        top_contributors&.each_with_index&.map do |contributor, index|
          certificate_data(contributor: contributor, place: index)
        end
      end
  end

  def generate_pdf(winner:)
    CertificatePdf.new(winner: winner)
  end

  def top_contributors(repository:)
    GithubClient.get_contributors(repository: repository)&.first(3)
  end
end
