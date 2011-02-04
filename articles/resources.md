Just a simple little advice for all <a href="http://apidock.com/rails/ActionController/Resources/resources" target="_blank">RESTful</a> programmers out there. It's really simple, and cleans up your code quite a bit. A lot of Rails applications have two roles: an admin and non admin. Your code can get pretty ugly when implementing extra features for the admin.<!--more--> I'm guessing everybody does this from time to time:

<pre lang="rails">- if current_user.admin?
  %p= link_to(@project, :method => :delete)
-# or this:
%p= link_to(@project, :method => :delete) if current_user.admin?</pre>

It's no problem when you're doing this only once or twice, but as the project moves on, your views get swamped, and your controllers too! My suggestion is splitting it into multiple controllers, one for each role, like this:
<pre lang="rails">ActionController::Routing::Routes.draw do |map|
  map.resources :projects
  map.resource :admin do |a|
    a.resources :projects, :controller => 'admin_projects'
  end
end</pre>

This will generate these paths (amongst all usual others):

<pre lang="rails">
      project GET /projects/:id       { :action=>"show", :controller=>"projects"}
admin_project GET /admin/projects/:id { :action=>"show", :controller=>"admin_projects"}
</pre>

This way controllers and views stay clean and uncluttered. It has a cluttered <tt>rake routes</tt> as trade off though, but that's just a minor problem if you ask me. The admin controller can be used as administrator dashboard. If you have another solution, I'd love to hear it!