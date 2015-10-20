module Api::V1
  class GroupsController < ApiController

    before_action :set_group

    def show
      ap @group
      respond_with @group
    end

    private

      def set_group
        #@group = Group.find_by(id: params[:id])
        @group = Group.first
      end

  end
end
