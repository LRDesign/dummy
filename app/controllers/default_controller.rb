class DefaultController < ApplicationController
  def index
    @data = Foobar.all.to_a
  end
end
