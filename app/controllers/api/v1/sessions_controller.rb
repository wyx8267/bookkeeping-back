require "jwt"

class Api::V1::SessionsController < ApplicationController
  def create
    # if Rails.env.test?
    #   return render status: :unauthorized if params[:code] != "123456"
    # else
    #   canSignin = ValidationCode.exists? email: params[:email], code: params[:code], used_at: nil
    #   return render status: :unauthorized unless canSignin
    # end

    # user = User.find_or_create_by email: params[:email]
    # render status: :ok, json: { jwt: user.generate_jwt }

    session = Session.new params.permit :email, :code
    if session.valid?
      user = User.find_or_create_by email: session.email
      render json: { jwt: user.generate_jwt }
    else
      render json: { errors: session.errors }, status: :unprocessable_entity
    end
  end
end
