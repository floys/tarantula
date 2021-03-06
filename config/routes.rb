Tarantula::Application.routes do
  root :to => "home#index"

  resource :archive, :only => [:destroy, :create],
    :path => '/projects/:project_id/:resources/archive',
    :controller => 'archives'

  resources :password_resets

  resources :projects do
    member do
      get :priorities
      delete :deleted
      get :products
    end

    collection do
      get :deleted
    end

    resources :users do
      resources :executions
      resource :test_area
      resource :test_object
      resources :report_data
    end

    resources :test_sets do
      resources :cases do
        collection do
          get :not_in_set
        end
      end
    end
    resources :attachments
    resources :cases
    resources :executions
    resources :requirements
    resources :tags
    resources :tasks
    resources :test_objects do
      resources :attachments
    end
    resources :test_areas

    resources :bug_trackers do
      member do
        get :products
      end
    end

    resources :bugs
  end

  resources :requirements do
    resources :cases, :only => [:index]
    resources :attachments
  end

  resources :test_sets do
    resources :cases do
      collection do
        get :not_in_set
      end
    end
  end

  resources :cases do
    member do
      get :change_history
    end
    resources :attachments
    resources :tasks
    resources :requirements, :only => [:index]
  end

  resources :case_executions do
    resources :attachments
  end

  resources :executions do
    resources :case_executions
  end

  resources :test_objects, :only => [:show] do
    resources :attachments
  end

  resources :users do
    member do
      put :selected_project
      get :permissions
      get :available_groups
    end
    collection do
      get :deleted
    end

    resources :projects do
      member do
        get :group
      end
      collection do
        get :deleted
      end
    end
    resources :executions
    resources :tasks
  end

  resources :bug_trackers do
    member do
      get :products
    end
  end

  resources :customer_configs
  match 'restart', :to => 'customer_configs#restart'

  resource :report, :controller => 'report' do
    member do
      get :dashboard
      get :test_result_status
      get :results_by_test_object
      get :case_execution_list
      get :test_efficiency
      get :status
      get :requirement_coverage
      get :bug_trend
      get :workload
    end
  end

  resource :home, :controller => 'home' do
    member do
      get :login
      post :login
      get :logout
      get :index
    end
  end

  resource :import, :controller => 'import' do
    member do
      get :doors
      post :doors
    end
  end

        resources :automation_tools

  resources :backups, :only => [:new, :create]
  resources :csv_exports, :only => [:new, :create]
  resources :csv_imports, :only => [:new, :create]
        match '/api/test', :controller => 'api', :action => 'test', :via => :get
        match '/api/create_testcase', :controller => 'api', :action => 'create_testcase', :via => :post
        match '/api/update_testcase_execution', :controller => 'api', :action => 'update_testcase_execution', :via => :post
        match '/api/unblock_testcase_execution', :controller => 'api', :action => 'unblock_testcase_execution', :via => :post
        match '/api/block_testcase_execution', :controller => 'api', :action => 'block_testcase_execution', :via => :post
        match '/api/get_scenarios', :controller => 'api', :action => 'get_scenarios', :via => :post
        match '/api/update_testcase_step', :controller => 'api', :action => 'update_testcase_step', :via => :post
        match '/api/update_testcase_duration', :controller => 'api', :action => 'update_testcase_duration', :via => :post
        match '/automation/execute', :controller => 'automation', :action => 'execute', :via => :get
        match '/automation/get_sentences', :controller => 'automation', :action => 'get_sentences', :via => :get
        match "/case_executions/automated/:id", :controller => 'case_executions', :action => 'automated', :via => :get
        match "/export/items", :controller => 'export', :action => 'export_items', :via => :get
end
