# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do
	before { @user = User.new(name: "Example User", email: "user@example.com",
								password: "foobar", password_confirmation: "foobar") }

	subject { @user	}

	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:authenticate) }

	it { should be_valid }

	describe "when name is not present" do
		before { @user.name = "" } 
		it { should_not be_valid }
	end

	describe "when name is too long" do
		before { @user.name = "a" * 51 }
		it {should_not be_valid}
	end

	describe "when email is not present" do
		before { @user.email = "" }
		it { should_not be_valid }
	end

	describe "when email format is invalid" do
    	it "should be invalid" do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo.
			             foo@bar_baz.com foo@bar+baz.com]
			addresses.each do |invalid_address|
				@user.email = invalid_address
				@user.should_not be_valid
			end      
    	end
	end

	describe "when email format is valid" do
		it "should be valid" do
		  addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
		  addresses.each do |valid_address|
		    @user.email = valid_address
		    @user.should be_valid
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

	describe "when password is not present" do
		before { @user.password = @user.password_confirmation = " " }
		it {should_not be_valid}
	end

	describe "when password doesn't match confirmation" do
		before { @user.password_confirmation = "mismatch" }
		it { should_not be_valid }
	end

	describe "when password confirmation is nil" do
		before { @user.password_confirmation = nil }
		it { should_not be_valid }
	end

	describe "with a password that is too short" do
		before { @user.password = @user.password_confirmation = "a" * 5 } # how does this enforce passwords > 6?
		it { should be_invalid }
	end
	
	describe "return value of authenticate method" do
		before { @user.save }
		let(:found_user) { User.find_by_email(@user.email)}

		# The following 2 describe blocks cover the case where
		# @user and found_user should be the same (passwords match) and different (passwords mismatched)
		# The use double equals (==) to test for object equivalence

		describe "with valid password" do
			it { should  ==  found_user.authenticate(@user.password) }
		end

		# Using let a second time and also use the specify method. 
		# This is just a synonym for it and can be used when writing it would sound unnatural. 
		# In this case, it sounds good to say “it [i.e., the user] should not equal wrong user,” 
		# but it sounds strange to say “user: user with invalid password should be false”; 
		# saying “specify: user with invalid password should be false” sounds better.

		describe "with invalid password" do
			let(:user_for_invalid_password) { found_user.authenticate("invalid") }
			it { should_not ==  user_for_invalid_password }
			specify { user_for_invalid_password.should be_false }
		end

		# Let
		# RSpec’s let method provides a convenient way to create local variables inside tests. 
		# The syntax might look a little strange, but its effect is similar to variable assignment. 
		# The argument of let is a symbol, and it takes a block whose return value is assigned to 
		# a local variable with the symbol’s name. In other words, 
		# let(: found_user) { User.find_by_email(@user.email) } 
		# creates a found_user variable whose value is equal to the result of find_by_email. 
		# We can then use this variable in any of the before or it blocks throughout the rest of the test. 
		# One advantage of let is that it memoizes its value, which means 
		# that it remembers the value from one invocation to the next. 
		# (Note that memoize is a technical term; in particular, it’s not a misspelling of “memorize.”) 
		# In the present case, because let memoizes the found_user variable, 
		# the find_by_email method will only be called once whenever the User model specs are run.



	end


end
