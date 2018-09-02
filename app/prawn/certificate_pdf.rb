# frozen_string_literal: true

class CertificatePdf < Prawn::Document
  def initialize(winner:)
    super(top_margin: 70)
    @winner = winner
    congratulation
  end

  def congratulation
    text "Contributors Competition\n", size: 30, style: :bold, align: :center
    formatted_text [
      {
        text: "contributor ##{@winner[:place] + 1} of the repository #{@winner[:repository]}\n",
        size: 20,
        style: :bold,
        align: :center
      },
      {
        text: "#{@winner[:login]} made #{@winner[:contributions]} contributions",
        size: 25,
        style: :italic,
        align: :center
      }
    ], valign: :center, leading: 6
  end
end
