class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  after_action :unify_errors
  before_action :set_page

  def set_page
    @page = params[:page] ? Integer(params[:page]) : 1
    @per = params[:per] ? Integer(params[:per]) : 20
  end

  protected

    def unify_errors
      if response.status > 399
        body = JSON.parse(response.body)
        if body['errors']
          body['errors'] = create_error_array(body['errors']) unless body['errors'].is_a?(Array)
        else
          body['errors'] = create_error_array(body)
        end
        response.body = body.to_json
      end
    rescue JSON::ParserError
    end

    def create_error_array(error_hash)
      [].tap do |errs|
        error_hash.each do |field, errors|
          errors.each{|e| errs << "#{field} #{e}" unless field == 'full_messages'}
        end
      end
    end
end
