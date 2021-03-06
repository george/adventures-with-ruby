A few weeks ago I talked about Domain Driven Design in Ruby at the local Ruby user group: [Rotterdam.rb](http://rotterdam-rb.org/). It had a great turnup (even though the weather prevented some from coming) and there was a good discussion going on. Thank you for that! Follow [@rotterdamrb](http://twitter.com/rotterdamrb) to hear about future meetups with free beer and pizza, sponsored by [Finalist IT Group](http://finalist.nl/)!

It was a long talk, so I couldn't cover all the topics I wanted to cover. I talked about ubiquitous language, bounded contexts, core and support domains, and showed some ways to do this in Ruby, using modules. Basically, I concentrated on techniques to organize [essential complexity](http://en.wikipedia.org/wiki/Essential_complexity), while keeping an eye on practical usage with Ruby and Rails.

When you talk about [Domain Driven Design](http://www.amazon.com/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215), you hardly cannot do that without mentioning the three types of objects that Eric Evans discusses in his book. It's Entity objects, Value objects and Service objects. Still I managed to do just that. Time to fix it; here is what I failed to mention.

### Entities

Entity objects are objects that represent something in the real world and can be referenced as such. Translated into Rails terms these would be instances of (most of) your models. You can reference a post instance by getting it via its id from the database.

These objects are prime candidates for using plugins like [friendly_id](http://norman.github.com/friendly_id/), making the fact that these objects have a real identity in real life clearer. This is because you can now reference them by name, instead of some database id. To use friendly_id with Rails 3, point your gemfile to the ['edge' branch on github](https://github.com/norman/friendly_id/tree/edge).

### Value Objects

Objects that don't have any real identity are called "Value objects". Any object that is a value object has no real identity, nor is it important to know its identity.

Addresses are a good example. The value of the address (e.g. street, house number, city, country) is important. But it's less obvious to store this in a database and reference it by an id. This id would be purely superficial and have no meaning in the domain you are designing.

A pure Ruby way to do this with Structs, which I have mentioned before on this blog. If you're using a document based database, like MongoDB, these would obviously be embedded documents. With ActiveRecord you can use the [`composed_of`-method](http://apidock.com/rails/ActiveRecord/Aggregations/ClassMethods/composed_of). Allow me to demonstrate that:

<pre class="ir_black"><font color="#7c7c7c"># Attributes of Person include:</font>
<font color="#7c7c7c"># </font>
<font color="#7c7c7c"># * first_name&nbsp;&nbsp;string</font>
<font color="#7c7c7c"># * name_infix&nbsp;&nbsp;string</font>
<font color="#7c7c7c"># * last_name&nbsp;&nbsp; string</font>
<font color="#7c7c7c"># * male&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;boolean</font>
<font color="#7c7c7c">#</font>
<font color="#96cbfe">class</font>&nbsp;<font color="#ffffb6">Person</font>&nbsp;&lt; <font color="#ffffb6">ActiveRecord</font>::<font color="#ffffb6">Base</font>
&nbsp;&nbsp;composed_of <font color="#99cc99">:name</font>,&nbsp;&nbsp; <font color="#99cc99">:mapping</font>&nbsp;=&gt; <font color="#ffffb6">Name</font>.members
&nbsp;&nbsp;composed_of <font color="#99cc99">:gender</font>, <font color="#99cc99">:mapping</font>&nbsp;=&gt; <font color="#ffffb6">Gender</font>.members
<font color="#96cbfe">end</font></pre>

<pre class="ir_black"><font color="#96cbfe">class</font>&nbsp;<font color="#ffffb6">Name</font>&nbsp;&lt; <font color="#ffffb6">Struct</font>.new(<font color="#99cc99">:first_name</font>, <font color="#99cc99">:name_infix</font>, <font color="#99cc99">:last_name</font>, <font color="#99cc99">:gender</font>)

&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">to_s</font>
&nbsp;&nbsp;&nbsp;&nbsp;[&nbsp;first_name, name_infix, last_name ].select(&amp;<font color="#99cc99">:present?</font>).join(<font color="#336633">'</font><font color="#a8ff60">&nbsp;</font><font color="#336633">'</font>)
&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">first_name</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">super</font>.presence || title
&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">title</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#ffffb6">I18n</font>.t(gender.key, <font color="#99cc99">:scope</font>&nbsp;=&gt; <font color="#99cc99">:titles</font>)
&nbsp;&nbsp;<font color="#96cbfe">end</font>

<font color="#96cbfe">end</font></pre>

<pre class="ir_black"><font color="#96cbfe">class</font>&nbsp;<font color="#ffffb6">Gender</font>&nbsp;&lt; <font color="#ffffb6">Struct</font>.new(<font color="#99cc99">:male</font>)

&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">to_s</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#ffffb6">I18n</font>.t(key, <font color="#99cc99">:scope</font>&nbsp;=&gt; <font color="#99cc99">:genders</font>)
&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">key</font>
&nbsp;&nbsp;&nbsp;&nbsp;male ? <font color="#99cc99">:male</font>&nbsp;: <font color="#99cc99">:female</font>
&nbsp;&nbsp;<font color="#96cbfe">end</font>

<font color="#96cbfe">end</font></pre>

By defining `to_s` on these structs you can output their gender or name in views without doing anything special:

<pre class="ir_black"><font color="#e18964">%</font><font color="#6699cc">dl</font><font color="#00a0a0">[</font><font color="#c6c5fe">@person</font><font color="#00a0a0">]</font>
&nbsp;&nbsp;<font color="#e18964">%</font><font color="#6699cc">dt</font><font color="#e18964">=</font>&nbsp;<font color="#ffffb6">Person</font>.human_attribute_name(<font color="#99cc99">:name</font>)
&nbsp;&nbsp;<font color="#e18964">%</font><font color="#6699cc">dd</font><font color="#e18964">=</font>&nbsp;<font color="#c6c5fe">@person</font>.name
&nbsp;&nbsp;
&nbsp;&nbsp;<font color="#e18964">%</font><font color="#6699cc">dt</font><font color="#e18964">=</font>&nbsp;<font color="#ffffb6">Person</font>.human_attribute_name(<font color="#99cc99">:gender</font>)
&nbsp;&nbsp;<font color="#e18964">%</font><font color="#6699cc">dd</font><font color="#e18964">=</font>&nbsp;<font color="#c6c5fe">@person</font>.gender</pre>

In this example, `Person` is actually an aggregate of the entity `Person` and two value objects, called `Name` and `Gender`. Although all attributes are flattened out in your persistence layer (in this case, your database table); they do have a deeper **struct**ure in your code. And it's easier to test too!

### Services

Things that aren't really a 'thing' in the domain you're designing are usually services. They are not really part of any entity or value object, but do something with them.

In Rails, these would be [observers](http://guides.rubyonrails.org/active_record_validations_callbacks.html#observers) or plain Ruby objects lying around. Maybe it's time to call them what they are and place them in `app/services`.

Every Rails developer knows the pattern "Fat Model, Skinny Controller". This is a pattern to remember that you shouldn't put model logic in your controller but in your model. But this pattern is often taken too far. There are people that give the `params`-object, or worse, the entire controller-instance, to the model and do their shit there. This is not right. Use a service for that.

Pagination and searching are good candidates for a service. But this blog post is on the long side, so I'll save an example implementation of that for another time. No post is complete without a promise to a follow-up that never comes, right?

### Conclusion

It's the same as I said during my talk: Rails helps you by keeping accidental complexity at a minimum. You can use the techniques described in Domain Driven Design to organize essential complexity and make your application more maintainable. Just be careful not to over-engineer it, that would defeat the purpose. Always be critical of your own code and continue to ask yourself the same question: *"Does this make my code better?"*

