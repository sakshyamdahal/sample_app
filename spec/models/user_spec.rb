require 'spec_helper'

describe User do
  
  before { @user = User.new(name: "example user", email: "user@example.com",
  							password: "foobar", password_confirmation: "foobar") }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }

  it { should_not be_admin }
  it { should be_valid }


  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin) # flips admin attribute from false to true
    end

    it { should be_admin }
  end # with admin attribute

  describe "when name is not present" do
  	before { @user.name = " " }
  	it { should_not be_valid }
  end

  describe "when email is not present" do
  	before { @user.email = " " }
  	it { should_not be_valid }
  end


  describe "when name is too long" do
  	before { @user.name = "a" * 51 }
  	it { should_not be_valid }
  end


  describe "when email format is invalid" do
  	it "should be valid" do
  		addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
  		addresses.each do |invalid_address|
  			@user.email = invalid_address
  			expect(@user).not_to be_valid
  		end
  	end
  end

  describe "when email format is valid" do
  	it "should be valid" do
  		addresses = %w[user@foo.COM A_US-ER@f.b.org first.lst@foo.jp a+b@baz.cn]
  		addresses.each do |valid_address|
  			@user.email = valid_address
  			expect(@user).to be_valid
  		end
  	end
  end

  describe "when email address is already taken" do
  	before do
  		user_with_same_email = @user.dup
  		user_with_same_email.email = @user.email.upcase
  		user_with_same_email.save
  	end

  	it { should_not be_valid }
  end


  # a test for email downcasing
  describe "email address with mixed case" do
  	let(:mixed_case_email) { "Foo@EXamPLE.CoM" }

  	it "should be saved all lower-case" do
  		@user.email = mixed_case_email
  		@user.save
  		expect(@user.reload.email).to eq mixed_case_email.downcase
  	end
  end

  describe "when password is not present" do
  	before do
  		@user = User.new(name: "Example", email: "user@example.com",
  						password: " ", password_confirmation: " ")
  	end
  	it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
  	before { @user.password_confirmation = "mismatch" }
  	it { should_not be_valid }
  end


  describe "with a password that's too short" do
  		before { @user.password = @user.password_confirmation = "a" * 5 }
  		it { should be_invalid }
  	end


  # for password match and mismatch
  describe "return value of authenticate method" do
  	before { @user.save }
  	let(:found_user) { User.find_by(email: @user.email) }

  	describe "with valid password" do
  		it { should eq found_user.authenticate(@user.password) }
  	end

  	describe "with invalid password" do
  		let (:user_for_invalid_password) { found_user.authenticate("invalid") }

  		it { should_not eq user_for_invalid_password }
  		specify { expect(user_for_invalid_password).to be_false }
  	end
  end


  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end


  describe "micropost association" do

    before { @user.save }
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
    end


    it "should destroy associated micropost" do
      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        expect(Micropost.where(id: micropost.id)).to be_empty
      end

      # expect do
      #   Micropost.find(micropost)
      # end.to raise_error(ActiveRecord::RecordNotFound)
  
    end

    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
    end
  end
end
