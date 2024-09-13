Rails.application.routes.draw do
  root "tops#index"

  # 規約関係
  get '/terms_of_service', to: 'tops#terms_of_service'
  get '/privacy_policy', to: 'tops#privacy_policy'

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

  # クイズ、解答の表示
  resources :quizzes, only: %i[new]
  get 'answer', to: 'quizzes#show'

  # プロフィール
  resource :mypage, only: %i[show edit update]

end
