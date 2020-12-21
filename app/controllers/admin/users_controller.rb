class Admin::UsersController < ApplicationController
  before_action :admin_user

  def index
    @users = User.all
  end

  def destroy
    # テストユーザーが削除できるのはサンプルユーザーのみ
    unless params[:id].to_i.between?(2, 8)
      flash[:notice] = "サンプルユーザー以外は削除できません"
      redirect_to admin_users_path and return
    end
    user = User.find(params[:id])
    user.destroy
    flash[:notice] = "ユーザー「#{user.name}」を削除しました"
    redirect_to admin_users_path
  end

  private

  def admin_user
    return unless current_user.admin == false

    flash[:notice] = "管理者権限がありません"
    redirect_to root_path
  end
end
