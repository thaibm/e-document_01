class GroupMembersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  load_resource :organization
  load_resource :team

  def create
    @group_member = current_user.group_members.build group_member_params
    if @group_member.save
      case params[:group_members][:group_type]
      when "organization"
        member = @organization.group_members.find_by user_id: current_user.id
      when "team"
        member = @team.group_members.find_by user_id: current_user.id
      end
      respond_to do |format|
        format.html do
          render partial: "shared/leave",
            locals: {member: member}
        end
      end
    end
  end

  def update
    if @team.present?
      update_team_member
    elsif @organization.present?
      update_organization_member
    end
  end

  def destroy
    if @group_member.destroy
      object = eval "@#{params[:group_members][:group_type]}"
      respond_to do |format|
        format.html do
          render partial: "shared/join",
            locals: {object: object}
        end
      end
    end
  end

  private

  def group_member_params
    params.require(:group_members).permit :group_id, :group_type
  end

  def update_team_member
    case @group_member.confirm
    when true
      @group_member.role = GroupMember.roles[:admin]
      @group_member.save
    when false
      @group_member.confirm = true
      if @group_member.save
        flash[:success] = t "team.admin.add"
      else
        flash[:danger] = t "team.admin.add_fail"
      end
    end
    respond_to do |format|
      format.json do
        render json: {status: status}
      end
    end
  end

  def update_organization_member
    @group_member.confirm = true
    if @group_member.save
      flash[:success] = t "team.admin.add"
      status = t "organizations.update.confirm"
    else
      flash[:danger] = t "team.admin.add_fail"
      status = t "organizations.update.cannot_confirm"
    end
    respond_to do |format|
      format.json do
        render json: {status: status}
      end
    end
  end
end
