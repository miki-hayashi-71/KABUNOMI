Rails.application.routes.draw do
  root "tops#index"

  ## ユーザー登録関係
  resources :users, only: %i[new create]


  ## ログイン機能関係
  # RESTfulルートで生成したものを、ユーザーが認識しやすいようにカスタムルートで再設定
  # RESTfulルート
  resources :sessions, only: %i[new create destroy]

  # カスタムルート
  get 'login', to: 'user_sessions#new'
  post 'login', to: "user_sessions#create"
  delete 'logout', to: 'user_sessions#destroy'


  ## 地点登録、地図表示関係
  resources :routes, only: %i[new create show]

end
