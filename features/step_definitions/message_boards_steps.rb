Дадено 'че съм студент' do
  backdoor_login Factory(:user)
end

Дадено 'че съществува тема "$title"' do |title|
  Factory(:topic, :title => title)
end

Дадено 'че имам тема "$topic"' do |title|
  Factory(:topic, :user => @current_user, :title => title)
end

Дадено 'че съм отговорил на "$title" с "$reply"' do |title, reply|
  topic = Topic.find_by_title!(title)
  Factory(:reply, :user => @current_user, :topic => topic, :body => reply)
end

Дадено 'че съществува тема "$title" със съдържание:' do |title, body|
  Factory(:topic, :title => title, :body => body)
end

Дадено 'че студент "$name" е публикувал тема "$topic"' do |name, topic|
  user = Factory(:user, :full_name => name)
  Factory(:topic, :title => topic, :user => user)
end

Когато 'започна да редактирам темата' do
  within 'ol.topic li:first' do
    click_link 'Редактирай'
  end
end

Когато 'започна да редактирам отговорът "$reply"' do |reply|
  within "li:contains('#{reply}')" do
    click_link 'Редактирай'
  end
end

То 'трябва да няма "$code" в кода на документа' do |code|
  body.should_not include(code)
end
