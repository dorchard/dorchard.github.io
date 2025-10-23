---
layout: blog-post
title: "The Koch Snowflake"
date: "2009-02-18"
categories: [general]
excerpt: "This post has been imported from my old blog. I mentioned a couple of weeks ago I was going to write a post about a certain fractal. Now I have finally gotten round to writing something it has come at a very appropriate time as Britain has seen an unusual..."
wordpress_url: https://dorchard.wordpress.com/2009/02/18/the-koch-snowflake/
---

This post has been imported from my old blog.

I mentioned a couple of weeks ago I was going to write a post about a certain fractal. Now I have finally gotten round to writing something it has come at a very appropriate time as Britain has seen an unusual amount of snow recently. Sadly all of that snow has melted now. I am going to briefly introduce the [Koch Snowflake](http://en.wikipedia.org/wiki/Koch_snowflake) (also known as the Koch Island, or Koch Star) which is a [fractal](http://en.wikipedia.org/wiki/Fractal) with a very simple construction. I will first informally describe a geometrical construction of the fractal and will then show some of its properties, particularly the property that the fractal has an infinite length enclosing a finite area.  
  
**Construction**  
The base case of the construction is an equilateral triangle. For each successive iteration the construction proceeds as follows: 

  * Divide each edge of the polygon (say of length _a_) into three equal segments of length _a/3_.
  * Replace the middle segment with an equilateral triangle of side _a/3._
  * Remove the base edge of the new equilateral triangle to form a continuous curve with other line segments.

Thus each edge is transformed as such: 

![](http://dorchard.co.uk/tmp/koch/geometric-construction.png)

  
The first 5 iterations look like: 

![](http://dorchard.co.uk/tmp/koch/5-iterations-small.png)

  
**Properties**  
Two properties of this fractal may seem paradoxical at first but are easily shown. I will show the derivations here for the interested without skipping too many steps. For an infinite number of iterations the perimeter of the fractal (the length of all the edges) tends to infinity whilst the area enclosed remains finite.  
  
**Infinite Perimeter**  
First consider the number of edges for an infinite number of iterations. Initially the number of edges is 3, each iteration transforms a single edge into 4 edges (see above), thus the series of the edge count is: 3, 12, 48, .... The general form is:   


![](http://dorchard.co.uk/tmp/koch/equation1.png)

  
Starting from an edge length of _a_ each iteration divides the edge length by 3. The following defines the edge length for iteration _n_ and from this calculates the perimeter for iteration _n_. The limit as _n_ tends to infinity is found, showing that the perimeter is infinite.   


![](http://dorchard.co.uk/tmp/koch/equation2.png)

  
Thus it is easy to see that the perimeter length is infinite through standard results on limits.   
  
**Finite Area**  
The area calculation is a little bit more involved. The result can be seen on [Mathworld](http://mathworld.wolfram.com/KochSnowflake.html) or [Wikipedia](http://en.wikipedia.org/wiki/Koch_snowflake) but a full derivation isn't given, so I show my derivation here for the interested.  
  
The area of the n-th iteration of the Koch snowflake is the area of the base triangle + the area of the new, smaller, triangles added to each edge. From the above length calculations and construction we know that each iteration of the construction divides the length of the edges by three. First consider the relationship between the area of a triangle of edge length _a_ and a triangle of edge length _a/3_  


![](http://dorchard.co.uk/tmp/koch/triangle-scale-1.png) |  ![](http://dorchard.co.uk/tmp/koch/triangle-scale-third.png)  
---|---  
![](http://dorchard.co.uk/tmp/koch/area-equation1.png) |  ![](http://dorchard.co.uk/tmp/koch/area-equation2.png)  
  
Unsurprisingly we see that dividing the edge length by 3 divides the area by 9. At each iteration we add new equilateral triangles to each edge, a ninth of the area of the previous iteration's triangles. We formulate this as a summation of base case _A0_ plus the next _n-1_ iterations where the triangle area at each stage is _A0_ divided by _3 2n_ or _9 n_ (successive divisions of the area by 9). The number of edges is defined by the previous iterations number of edges _3 * 4 n-1_, thus at the _n_ -th iteration we need to add this number of triangles to the snowflake. 

![](http://dorchard.co.uk/tmp/koch/equation3.png)

  
Thus the area is finite at _8/5_ times the area of the base equilateral triangle.   
  
**Summary**  
So the Koch snowflake construction has been introduced and it has been shown relatively easily that the area of a Koch snowflake tends to a finite limit of _8/5_ times the base case area (5) and that the length of perimeter tends to infinity (4). Next time I will probably talk a bit about the _fractal dimension_ of the Koch snowflake and also show an interesting problem that uses the Koch snowflake.  
  
As a last note, following on from the blog post I made about the Python turtle library, a turtle program of the Koch snowflake for Python can be [downloaded here](http://dorchard.co.uk/tmp/koch/koch.py).  
  

