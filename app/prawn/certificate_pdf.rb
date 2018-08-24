class CertificatePdf < Prawn::Document
  def initialize(winner:)
    super(top_margin: 70)
    @winner = winner
    congratulation
  end

  def congratulation
    text "#{@winner[:login]} ##{@winner[:place]}",
         size: 30,
         style: :bold
  end
end