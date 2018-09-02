Rails.application.routes.draw do
  root 'contributors_competition#search'
  get 'results', to: 'contributors_competition#show'
  get 'download_certificate',
      to: 'contributors_competition#download_certificate'
  get 'download_all_certificates',
      to: 'contributors_competition#download_all_certificates'
end
