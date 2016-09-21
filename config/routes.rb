Rails.application.routes.draw do

  get 'transaction/stx'

  get 'transaction/chart'

  get 'transaction/news'

  resources :hellos
  get 'transaction/home'
  get 'transaction/index'
  get 'transaction/graph'
  root 'transaction#stx'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
