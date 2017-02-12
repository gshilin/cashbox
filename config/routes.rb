Rails.application.routes.draw do
  get '/', to: 'cashdesks#index'
  resources :cashdesks do
    resources :shifts
  end
  resources :incomes
  resources :pelecards, only: [] do
    collection do
      post 'good_url'
      post 'error_url'
      post 'cancel_url'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :admin do
    get '/', to: 'homes#index'
    resources :cashdesks do
      member do
        get 'duplicate'
      end
    end
    resources :incomes, only: [:index, :show]
    resources :icount_flags, only: [:index, :new]
  end
end
