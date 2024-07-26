Rails.application.routes.draw do
  root "tops#index"
  # ユーザーに関してnewとcreateのみ許可する
  resources :users, only: %i[new create]
end