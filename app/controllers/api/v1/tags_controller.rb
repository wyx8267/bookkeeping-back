class Api::V1::TagsController < ApplicationController
  def index
    current_user = User.find request.env["current_user_id"]
    return render status: 401 if current_user.nil?
    tags = Tag.where(user_id: current_user.id).page(params[:page])
    tags = tags.where(kind: params[:kind]) unless params[:kind].nil?
    render json: { resources: tags, pager: {
      page: params[:page] || 1,
      per_page: Tag.default_per_page,
      count: tags.count,
    } }
  end

  def create
    current_user = User.find request.env["current_user_id"]
    return render status: 401 if current_user.nil?

    tag = Tag.new params.permit(:name, :sign, :kind)
    tag.user = current_user
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
    ActiveRecord::Base.transaction do
      begin
        Item.where("tag_ids && ARRAY[?]::bigint[]", [tag.id])
          .update!(deleted_at: Time.now)
        tag.save!
      rescue
        return head 422
      end
      head 200
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
