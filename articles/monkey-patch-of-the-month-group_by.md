A while back, I talked about [new additions to ActiveSupport](/3-times-activesupport-3). And now, I have a confession to make: I like monkey patches! At least, as long as they're short and self-explanatory.

I got a few of them lying around, so I am going to post one every month. I also welcome your favorite monkey patch, which you can [email me](mailto:monkey@iain.nl).

So, the first one: **group_by**. This method groups arrays of objects by the result of the block provided and puts the result into a hash.
<pre class="ir_black"><font color="#96cbfe">class</font>&nbsp;<font color="#ffffb6">Array</font>
&nbsp;&nbsp;<font color="#7c7c7c"># Turns an array into a hash, using the results of the block as keys for the</font>
&nbsp;&nbsp;<font color="#7c7c7c"># hash.</font>
&nbsp;&nbsp;<font color="#7c7c7c">#</font>
&nbsp;&nbsp;<font color="#7c7c7c">#&nbsp;&nbsp; [1, 2, 3, 4].group_by(&amp;:odd?)</font>
&nbsp;&nbsp;<font color="#7c7c7c">#&nbsp;&nbsp; # =&gt; {true=&gt;[1, 3], false=&gt;[2, 4]}</font>
&nbsp;&nbsp;<font color="#7c7c7c">#</font>
&nbsp;&nbsp;<font color="#7c7c7c">#&nbsp;&nbsp; [&quot;One&quot;, &quot;Two&quot;, &quot;three&quot;].group_by {|i| i[0,1].upcase }</font>
&nbsp;&nbsp;<font color="#7c7c7c">#&nbsp;&nbsp; # =&gt; {&quot;T&quot;=&gt;[&quot;Two&quot;, &quot;three&quot;], &quot;O&quot;=&gt;[&quot;One&quot;]}</font>
&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">group_by</font>
&nbsp;&nbsp;&nbsp;&nbsp;hash = <font color="#ffffb6">Hash</font>.new { |<font color="#c6c5fe">hash</font>, <font color="#c6c5fe">key</font>|&nbsp;hash[key] = []&nbsp;}
&nbsp;&nbsp;&nbsp;&nbsp;each { |<font color="#c6c5fe">item</font>|&nbsp;hash[<font color="#96cbfe">yield</font>(item)] &lt;&lt; item }
&nbsp;&nbsp;&nbsp;&nbsp;hash
&nbsp;&nbsp;<font color="#96cbfe">end</font>
<font color="#96cbfe">end</font></pre>

No piece of code is complete without tests, so this is it:

<pre class="ir_black"><font color="#96cbfe">class</font>&nbsp;<font color="#ffffb6">ArrayExtGroupingTests</font>&nbsp;&lt; <font color="#ffffb6">Test</font>::<font color="#ffffb6">Unit</font>::<font color="#ffffb6">TestCase</font>

&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">test_group_by</font>
&nbsp;&nbsp;&nbsp;&nbsp;assert_equal {<font color="#99cc99">true</font>=&gt;[<font color="#ff73fd">1</font>, <font color="#ff73fd">3</font>], <font color="#99cc99">false</font>=&gt;[<font color="#ff73fd">2</font>, <font color="#ff73fd">4</font>]}, [<font color="#ff73fd">1</font>, <font color="#ff73fd">2</font>, <font color="#ff73fd">3</font>, <font color="#ff73fd">4</font>].group_by(&amp;<font color="#99cc99">:odd?</font>)
&nbsp;&nbsp;&nbsp;&nbsp;assert_equal {<font color="#336633">&quot;</font><font color="#a8ff60">T</font><font color="#336633">&quot;</font>=&gt;[<font color="#336633">&quot;</font><font color="#a8ff60">Two</font><font color="#336633">&quot;</font>, <font color="#336633">&quot;</font><font color="#a8ff60">three</font><font color="#336633">&quot;</font>], <font color="#336633">&quot;</font><font color="#a8ff60">O</font><font color="#336633">&quot;</font>=&gt;[<font color="#336633">&quot;</font><font color="#a8ff60">One</font><font color="#336633">&quot;</font>]}, [<font color="#336633">&quot;</font><font color="#a8ff60">One</font><font color="#336633">&quot;</font>, <font color="#336633">&quot;</font><font color="#a8ff60">Two</font><font color="#336633">&quot;</font>, <font color="#336633">&quot;</font><font color="#a8ff60">three</font><font color="#336633">&quot;</font>].group_by {|<font color="#c6c5fe">i</font>|&nbsp;i[<font color="#ff73fd">0</font>,<font color="#ff73fd">1</font>].upcase }
&nbsp;&nbsp;<font color="#96cbfe">end</font>

<font color="#96cbfe">end</font></pre>

### Update

Silly me, this one is [already in Ruby itself](http://apidock.com/ruby/Enumerable/group_by). Anyway, this is how it works under the cover...
