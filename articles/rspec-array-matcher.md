If you're testing arrays a lot, like ActiveRecord's (named) scopes, you should know the following RSpec matcher: `=~`. It doesn't care about sorting and it gives you all the output you need when the spec fails. Here is an example:

<pre class="ir_black">
describe <span class="rubyStringDelimiter">&quot;</span><span class="String">array matching</span><span class="rubyStringDelimiter">&quot;</span> <span class="rubyControl">do</span>

  it <span class="rubyStringDelimiter">&quot;</span><span class="String">should pass</span><span class="rubyStringDelimiter">&quot;</span> <span class="rubyControl">do</span>
    [ <span class="Number">1</span>, <span class="Number">2</span>, <span class="Number">3</span> ].should =~ [ <span class="Number">2</span>, <span class="Number">3</span>, <span class="Number">1</span> ]
  <span class="rubyControl">end</span>

  it <span class="rubyStringDelimiter">&quot;</span><span class="String">should fail</span><span class="rubyStringDelimiter">&quot;</span> <span class="rubyControl">do</span>
    [ <span class="Number">1</span>, <span class="Number">2</span>, <span class="Number">3</span> ].should =~ [ <span class="Number">4</span>, <span class="Number">2</span>, <span class="Number">3</span> ]
  <span class="rubyControl">end</span>

<span class="rubyControl">end</span>
</pre>

<figure class="ir_black"><img src="/rspec-array-matcher-result.png" alt="" title="rspec array matcher result" width="392" height="229"></figure>

Note: There is no inverse (should_not) version of this matcher.
