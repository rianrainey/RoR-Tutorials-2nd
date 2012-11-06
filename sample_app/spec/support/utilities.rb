def full_title(page_title)
	base_title = "Ruby on Rails Tutorial Sample App"
	if page_title.empty?
		base_title
	else
		"#{base_title} | #{page_title}"
	end
end

describe "full_title" do
	it "should include the page title" do
	  full_title("foo").should =~ /foo/
	end
	it "should include the base title" do
	  full_title("foo").should =~ /^Ruby on Rails Tutorial Sample App/
	end
	it "should not include a bar for the home page" do
	  full_title("").should_not =~ /\|/
	end
end