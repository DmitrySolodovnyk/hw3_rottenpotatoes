# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    
    Movie.create!(:title=> movie['title'], :rating=> movie['rating'], :release_date=>  movie['release_date']  )
  end
#    print Movie.all
#    print "Endofmovies\n"

#  assert false, "Unimplmemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  values=page.find('#movies').all('td').map {|element|
        element.text
  }
  assert values.find_index(e1) < values.find_index(e2), "Wrong order"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  
  rating_list.split(/[\', ]/).select { |rating_el| !rating_el.empty? && !rating_el.eql?("and") }.each{ |rating|
       step %Q{I #{uncheck}check "ratings_#{rating}"}
  }
  
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
end

Then /^I should( not)? see the following ratings: (.*)/ do |shouldnotsee,rating_list|
 # pending # express the regexp above with the code you wish you had
 # print page.html

  rating_list.split(/[\', ]/).select { |rating_el| !rating_el.empty? && !rating_el.eql?("and") }.each{ |rating|
 
      begin
        found=page.find('#movies').find('td',:text => rating)
        result= found.text
        raise StandardError, 'Error' unless found.text.eql? rating
#        print "found: #{rating} #{result}\n"
        assert shouldnotsee.nil? , "Filter error: #{rating} should#{shouldnotsee} be shown."
      rescue
        assert (not shouldnotsee.nil?), "Filter error: #{rating} should#{shouldnotsee} be shown."
 #       print "not found: #{rating}\n"
      end

#      assert see.nil? & !found.empty? , "Filter error: #{rating} should #{see} be shown."
  }
end

Then /^I should see (\d+) results$/ do |count|
    found=page.find('#movies').all('tr')
    assert found.length.eql?( count.to_i + 1 ), "Filter error: #{count} records should be shown."
end


