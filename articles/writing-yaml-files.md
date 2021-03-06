A short one for today: How do I write [YAML](http://en.wikipedia.org/wiki/YAML) files?

Well, to get the prettiest results, I do something like this:

<pre class="ir_black"><font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">write</font>(filename, hash)
&nbsp;&nbsp;<font color="#ffffb6">File</font>.open(filename, <font color="#336633">&quot;</font><font color="#a8ff60">w</font><font color="#336633">&quot;</font>) <font color="#6699cc">do</font>&nbsp;|<font color="#c6c5fe">f</font>|
&nbsp;&nbsp;&nbsp;&nbsp;f.write(yaml(hash))
&nbsp;&nbsp;<font color="#6699cc">end</font>
<font color="#96cbfe">end</font>

<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">yaml</font>(hash)
&nbsp;&nbsp;method = hash.respond_to?(<font color="#99cc99">:ya2yaml</font>) ? <font color="#99cc99">:ya2yaml</font>&nbsp;: <font color="#99cc99">:to_yaml</font>
&nbsp;&nbsp;string = hash.deep_stringify_keys.send(method)
&nbsp;&nbsp;string.gsub(<font color="#336633">&quot;</font><font color="#a8ff60">!ruby/symbol </font><font color="#336633">&quot;</font>, <font color="#336633">&quot;</font><font color="#a8ff60">:</font><font color="#336633">&quot;</font>).sub(<font color="#336633">&quot;</font><font color="#a8ff60">---</font><font color="#336633">&quot;</font>,<font color="#336633">&quot;&quot;</font>).split(<font color="#336633">&quot;</font><font color="#e18964">\n</font><font color="#336633">&quot;</font>).map(&amp;<font color="#99cc99">:rstrip</font>).join(<font color="#336633">&quot;</font><font color="#e18964">\n</font><font color="#336633">&quot;</font>).strip
<font color="#96cbfe">end</font></pre>

I use the gem [ya2yaml](http://rubyforge.org/projects/ya2yaml/) to create YAML, because the default Hash#to_yaml doesn't work well with UTF-8. If you have it installed and loaded, it uses that.

Then I turn all keys into strings with the method `deep_stringify_keys`, so the keys don't get formatted like the symbols they are. I remove some random junk and strip whitespace.

To add the `deep_stringify_keys`, open the Hash class:

<pre class="ir_black">
<font color="#96cbfe">class</font>&nbsp;<font color="#ffffb6">Hash</font>
&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">deep_stringify_keys</font>
&nbsp;&nbsp;&nbsp;&nbsp;new_hash = {}
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#99cc99">self</font>.each <font color="#6699cc">do</font>&nbsp;|<font color="#c6c5fe">key</font>, <font color="#c6c5fe">value</font>|
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;new_hash.merge!(key.to_s =&gt; (value.is_a?(<font color="#ffffb6">Hash</font>) ? value.deep_stringify_keys : value)))
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#6699cc">end</font>
&nbsp;&nbsp;<font color="#96cbfe">end</font>
<font color="#96cbfe">end</font></pre>

Here are the specs for this:

<pre class="ir_black">
describe <font color="#336633">&quot;</font><font color="#a8ff60">Writing YAML files</font><font color="#336633">&quot;</font>&nbsp;<font color="#6699cc">do</font>

&nbsp;&nbsp;before <font color="#99cc99">:all</font>&nbsp;<font color="#6699cc">do</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">@it</font>&nbsp;= <font color="#ffffb6">YAMLWriter</font>.new
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">@hash</font>&nbsp;= { <font color="#99cc99">:foo</font>&nbsp;=&gt; { <font color="#99cc99">:bar</font>&nbsp;=&gt; <font color="#99cc99">:baz</font>&nbsp;} }
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">@filename</font>&nbsp;= <font color="#ffffb6">File</font>.join(<font color="#ffffb6">File</font>.dirname(<font color="#99cc99">__FILE__</font>), <font color="#336633">&quot;</font><font color="#a8ff60">/test.yml</font><font color="#336633">&quot;</font>)
&nbsp;&nbsp;<font color="#6699cc">end</font>

&nbsp;&nbsp;it <font color="#336633">&quot;</font><font color="#a8ff60">should write a translation hash to a specified file</font><font color="#336633">&quot;</font>&nbsp;<font color="#6699cc">do</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">@it</font>.should_receive(<font color="#99cc99">:yaml</font>).with(<font color="#c6c5fe">@hash</font>).and_return(<font color="#336633">&quot;</font><font color="#a8ff60">result</font><font color="#336633">&quot;</font>)
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">@it</font>.write(<font color="#c6c5fe">@filename</font>, <font color="#c6c5fe">@hash</font>)
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#ffffb6">File</font>.open(<font color="#c6c5fe">@filename</font>, <font color="#336633">&quot;</font><font color="#a8ff60">r</font><font color="#336633">&quot;</font>) { |<font color="#c6c5fe">line</font>|&nbsp;line.gets.should == <font color="#336633">&quot;</font><font color="#a8ff60">result</font><font color="#336633">&quot;</font>&nbsp;}
&nbsp;&nbsp;<font color="#6699cc">end</font>

&nbsp;&nbsp;it <font color="#336633">&quot;</font><font color="#a8ff60">should convert a hash to a writable string</font><font color="#336633">&quot;</font>&nbsp;<font color="#6699cc">do</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">@it</font>.yaml(<font color="#c6c5fe">@hash</font>).should == <font color="#336633">&quot;</font><font color="#a8ff60">foo:</font><font color="#e18964">\n</font><font color="#a8ff60">&nbsp;&nbsp;bar: :baz</font><font color="#336633">&quot;</font>
&nbsp;&nbsp;<font color="#6699cc">end</font>
<font color="#6699cc">end</font></pre>


