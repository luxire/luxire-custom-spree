class HealthCheckController < ApplicationController
  def status
   render text: "I am Up....", status: 200
  end
end
