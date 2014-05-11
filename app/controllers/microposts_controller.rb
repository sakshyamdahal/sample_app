class MicropostsController < ApplicationController
	before_action :signed_in_user, only: [:create, :destroy]
	before_action :correct_user, only: :destroy

	def create
		@micropost = current_user.microposts.build(micropost_params)
		if @micropost.save
			flash[:success] = "Micropost created!"
			redirect_to root_url
		else
			@feed_items = []
			render 'static_pages/home'
		end
	end

	def destroy
		@micropost.destroy
		redirect_to root_url
	end

	private

		def micropost_params
			params.require(:micropost).permit(:content)
		end

		def correct_user
			# its always better to find by association
			# find_by doesn't raise an exception if there is no micropost
			# but find does
			@micropost = current_user.microposts.find_by(id: params[:id])
			redirect_to root_url if @micropost.nil?

		# 	@micropost = current_user.microposts.find(params[:id])
		# rescue
		# 	redirect_to root_url
		# end
		end
end
