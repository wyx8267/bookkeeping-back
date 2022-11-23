class Api::V1::TagsController < ApplicationController
  def index
    current_user_id = request.env["current_user_id"]
    return render status: 401 if current_user_id.nil?
    tags = Tag.where({ user_id: current_user_id }).page(params[:page])
    render json: { resources: tags, pager: {
      page: params[:page] || 1,
      per_page: Tag.default_per_page,
      count: Tag.count,
    } }
  end

  def create
    current_user_id = request.env["current_user_id"]
    return render status: 401 if current_user_id.nil?

    tag = Tag.new name: params[:name], sign: params[:sign], user_id: current_user_id
    if tag.save
      render json: { resource: tag }, status: :ok
    else
      render json: { errors: tag.errors }, status: :unprocessable_entity
    end
  end

  def update
    current_user_id = request.env["current_user_id"]
    return render status: 401 if current_user_id.nil?

    tag = Tag.find params[:id]
    tag.update params.permit(:name, :sign)
    if tag.errors.empty?
      render json: { resource: tag }, status: :ok
    else
      render json: { errors: tag.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    current_user_id = request.env["current_user_id"]
    return render status: 401 if current_user_id.nil?

    tag = Tag.find params[:id]
    return head :forbidden unless tag.user_id == current_user_id
    tag.deleted_at = Time.now
    if tag.save
      head 200
    else
      render json: { errors: tag.errors }, status: :unprocessable_entity
    end
  end

  def show
    current_user_id = request.env["current_user_id"]
    return render status: 401 if current_user_id.nil?

    tag = Tag.find params[:id]
    return head :forbidden unless tag.user_id == current_user_id
    render json: { resource: tag }
  end
end
