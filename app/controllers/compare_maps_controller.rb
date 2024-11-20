class CompareMapsController < ApplicationController
  skip_before_action :require_login, only: %i[new]

  def new; end

end
